package coverage

import chisel3.experimental.EnumAnnotations.{EnumComponentAnnotation, EnumDefAnnotation}
import chiseltest.coverage.ModuleInstancesPass
import firrtl.annotations.{Annotation, CircuitTarget, ComponentName, ModuleTarget, Named, ReferenceTarget}
import firrtl._
import firrtl.options.Dependency
import firrtl.stage.{Forms, RunFirrtlTransformAnnotation}
import firrtl.stage.TransformManager.TransformDependency

import scala.collection.mutable

object FsmCoverage {
  def annotations: AnnotationSeq = Seq(
    RunFirrtlTransformAnnotation(Dependency(FsmCoveragePass)),
    RunFirrtlTransformAnnotation(Dependency(ModuleInstancesPass))
  )
}

object FsmCoveragePass extends Transform with DependencyAPIMigration {
  val Prefix = "f"

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm
  override def invalidates(a: Transform): Boolean = false

  override protected def execute(state: CircuitState): CircuitState = {
    val enums = state.annotations.collect { case a: EnumDefAnnotation => a.typeName -> a }.toMap
    val components = state.annotations.collect { case a : EnumComponentAnnotation => a }

    // if there are no enums, we won't be able to find any FSMs
    if(enums.isEmpty) return state

    val newAnnos = mutable.ListBuffer[Annotation]()
    val c = CircuitTarget(state.circuit.main)
    val ignoreMods = Coverage.collectModulesToIgnore(state)
    val circuit = state.circuit.mapModule(onModule(_, c, newAnnos, enums, components, ignoreMods))
    val annos = newAnnos.toList ++ state.annotations
    CircuitState(circuit, annos)
  }

  private case class ModuleCtx(
    annos:     mutable.ListBuffer[Annotation],
    namespace: Namespace,
    m:         ModuleTarget,
    enums:     Map[String, EnumDefAnnotation],
    components: Map[String, EnumComponentAnnotation])

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: mutable.ListBuffer[Annotation],
    enums: Map[String, EnumDefAnnotation], components: Seq[EnumComponentAnnotation], ignore: Set[String]): ir.DefModule =
    m match {
      case mod: ir.Module if !ignore(mod.name) =>
        val localComponents = components
          .filter(c => toReferenceTarget(c.target).module == mod.name)
          .map(c => toReferenceTarget(c.target).ref -> c).toMap
        if(localComponents.isEmpty) { mod } else {

          val enumRegs = new ModuleScanner(localComponents).run(mod)
          enumRegs.foreach { case EnumReg(enumTypeName, regDef, next) =>
            analyzeFSM(regDef, next, enums(enumTypeName).definition)
          }

          val namespace = Namespace(mod)
          namespace.newName(Prefix)
          val ctx = ModuleCtx(annos, namespace, c.module(mod.name), enums, localComponents)


          mod
        }
      case other => other
    }


  private def analyzeFSM(regDef: ir.DefRegister, next: ir.Expression, states: Map[String, BigInt]): Unit = {
    println(s"Analyzing register ${regDef.name}")
    val clock = regDef.clock
    println(s"Clock: $clock")
    println(s"Next: ${next.serialize}")
    println("Next States:")
    val intToState = states.toSeq.map{ case (k,v) => v -> k }.toMap
    val transitions = destructMux(next)
    transitions.foreach { case (guard, nx) =>
      val gs = guardStates(guard, regDef.name, intToState)
      println(s"${guard.serialize} : ${gs}")
      println(s" --> ${nx.serialize} : ${nextStates(nx, regDef.name, intToState, gs)}")
    }
  }

  private def destructMux(e: ir.Expression): List[(ir.Expression, ir.Expression)] = e match {
    case ir.Mux(cond, tval, fval, _) =>
      val tru = destructMux(tval)
      val fals = destructMux(fval)
      tru.map{ case (guard, value) => (Utils.and(cond, guard), value) } ++
        fals.map{ case (guard, value) => (Utils.and(Utils.not(cond), guard), value) }
    case other => List((Utils.True(), other))
  }
  private def nextStates(e: ir.Expression, name: String, states: Map[BigInt, String], guards: Set[String]): Set[String] = e match {
    case c: ir.UIntLiteral => Set(states(c.value))
    case r: ir.Reference if r.name == name => guards
    case _ => states.values.toSet
  }
  private def guardStates(e: ir.Expression, name: String, states: Map[BigInt, String]): Set[String] = e match {
    case ir.DoPrim(PrimOps.Eq, Seq(r: ir.Reference, c: ir.UIntLiteral), _, _) if r.name == name =>
      Set(states(c.value))
    case ir.DoPrim(PrimOps.Eq, Seq(c: ir.UIntLiteral, r: ir.Reference), _, _) if r.name == name =>
      Set(states(c.value))
    case ir.DoPrim(PrimOps.Neq, Seq(r: ir.Reference, c: ir.UIntLiteral), _, _) if r.name == name =>
      states.values.toSet -- Set(states(c.value))
    case ir.DoPrim(PrimOps.Neq, Seq(c: ir.UIntLiteral, r: ir.Reference), _, _) if r.name == name =>
      states.values.toSet -- Set(states(c.value))
    case ir.DoPrim(PrimOps.Or, Seq(a, b), _, _) =>
      val aStates = guardStates(a, name, states)
      val bStates = guardStates(b, name, states)
      aStates | bStates
    case ir.DoPrim(PrimOps.And, Seq(a, b), _, _) =>
      val aStates = guardStates(a, name, states)
      val bStates = guardStates(b, name, states)
      aStates & bStates
    case other => states.values.toSet // conservative: any state
  }

  private def toReferenceTarget(n: Named): ReferenceTarget = n match {
    case ComponentName(name, module) => module.toTarget.ref(name)
  }
}

/** searches for state machine registers */
private class ModuleScanner(localComponents: Map[String, EnumComponentAnnotation]) {
  private val regDefs = mutable.HashMap[String, ir.DefRegister]()
  private val connects = mutable.HashMap[String, ir.Expression]()

  def run(mod: ir.Module): Seq[EnumReg] = {
    mod.foreachStmt(onStmt)
    regDefs.keys.toSeq.map { key =>
      val next = inlineComb(connects(key))
      EnumReg(localComponents(key).enumTypeName, regDefs(key), next)
    }
  }

  /** resolves references to nodes (all wires should have been removed at this point) */
  private def inlineComb(e: ir.Expression): ir.Expression = e match {
    case r: ir.Reference if r.kind == firrtl.NodeKind => inlineComb(connects(r.name))
    case other => other.mapExpr(inlineComb)
  }
  private def onStmt(s: ir.Statement): Unit = s match {
    case r: ir.DefRegister if localComponents.contains(r.name) => regDefs(r.name) = r
    case ir.Connect(_, loc, expr) => connects(loc.serialize) = expr
    case ir.DefNode(_, name, expr) => connects(name) = expr
    case other => other.foreachStmt(onStmt)
  }
}
private case class EnumReg(enumTypeName: String, regDef: ir.DefRegister, next: ir.Expression)