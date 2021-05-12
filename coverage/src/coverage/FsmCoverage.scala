// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chisel3.experimental.EnumAnnotations.{EnumComponentAnnotation, EnumDefAnnotation}
import firrtl.annotations.{Annotation, CircuitTarget, ComponentName, ModuleTarget, Named, ReferenceTarget, SingleTargetAnnotation}
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

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm ++ Seq(Dependency(FsmInfoPass))
  override def invalidates(a: Transform): Boolean = false


  override def execute(state: CircuitState): CircuitState = {
    // collect FSMs in modules that are not ignored
    val ignoreMods = Coverage.collectModulesToIgnore(state)
    val infos = state.annotations.collect{ case a: FsmInfoAnnotation if !ignoreMods(a.target.module) => a }

    // if there are no FSMs there is nothing to do
    if(infos.isEmpty) return state


    val circuit = state.circuit.mapModule(onModule(_, infos))

    state.copy(circuit = circuit)
  }

  private def onModule(m: ir.DefModule, infos: Seq[FsmInfoAnnotation]): ir.DefModule = m match {
    case mod: ir.Module =>
      val fsms = infos.filter(_.target.module == mod.name)
      if(fsms.isEmpty) { mod } else {

        fsms.foreach(onFsm)
       // TODO: instrument!

        mod
      }
    case other => other
  }

  private def onFsm(fsm: FsmInfoAnnotation): Unit = {
    println(s"[${fsm.target.module}.${fsm.target.name}] Found FSM")
    if(fsm.start.nonEmpty) { println(s"Start: ${fsm.start}") }
    println("Transitions:")
    fsm.transitions.foreach(t => println(s"${t._1} -> ${t._2}"))

  }
}

case class FsmInfoAnnotation(target: ReferenceTarget, states: Seq[(String, BigInt)], transitions: Seq[(String, String)], start: String) extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target=n)
}

/** Annotates FSMs in the design with information about all available states and transitions. */
object FsmInfoPass extends Transform with DependencyAPIMigration {
  val Prefix = "f"

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm
  override def invalidates(a: Transform): Boolean = false

  override protected def execute(state: CircuitState): CircuitState = {
    val enums = state.annotations.collect { case a: EnumDefAnnotation => a.typeName -> a }.toMap
    val components = state.annotations.collect { case a : EnumComponentAnnotation => a }

    // if there are no enums, we won't be able to find any FSMs
    if(enums.isEmpty) return state

    val c = CircuitTarget(state.circuit.main)
    val infos = state.circuit.modules.flatMap(onModule(_, c, enums, components))

    state.copy(annotations = infos ++: state.annotations)
  }

  private def onModule(m: ir.DefModule, c: CircuitTarget, enums: Map[String, EnumDefAnnotation], components: Seq[EnumComponentAnnotation]): List[Annotation] = m match {
    case mod: ir.Module =>
      val localComponents = components
        .filter(c => toReferenceTarget(c.target).module == mod.name)
        .map(c => toReferenceTarget(c.target).ref -> c).toMap
      if (localComponents.isEmpty) {
        List()
      } else {
        val enumRegs = new ModuleScanner(localComponents).run(mod)
        enumRegs.map { case EnumReg(enumTypeName, regDef, next) =>
          analyzeFSM(c.module(mod.name), regDef, next, enums(enumTypeName).definition)
        }.toList
      }
    case other => List()
  }

  private def analyzeFSM(module: ModuleTarget, regDef: ir.DefRegister, nextExpr: ir.Expression, states: Map[String, BigInt]): FsmInfoAnnotation = {
    val (resetState, next) = destructReset(nextExpr)
    // println(s"Next: ${next.serialize}")
    val intToState = states.toSeq.map{ case (k,v) => v -> k }.toMap
    val transitions = destructMux(next).flatMap { case (guard, nx) =>
      val from = guardStates(guard, regDef.name, intToState).getOrElse(states.keySet)
      val to = nextStates(nx, regDef.name, intToState, from)
      from.flatMap(f => to.map(t => f -> t))
    }.sortBy(_._1)

    FsmInfoAnnotation(module.ref(regDef.name),
      states = states.toSeq.sorted,
      transitions = transitions,
      start = resetState.map(intToState).getOrElse("")
    )
  }

  // tries to extract the reset value
  private def destructReset(e: ir.Expression): (Option[BigInt], ir.Expression) = e match {
    case ir.Mux(ir.Reference("reset", _, _, _), rval: ir.UIntLiteral, oval, _) => (Some(rval.value), oval)
    case ir.Mux(ir.DoPrim(PrimOps.Not, Seq(ir.Reference("reset", _, _, _)), _, _), oval, rval: ir.UIntLiteral, _) => (Some(rval.value), oval)
    case _ => (None, e)
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
  private def guardStates(e: ir.Expression, name: String, states: Map[BigInt, String]): Option[Set[String]] = e match {
    case ir.DoPrim(PrimOps.Eq, Seq(r: ir.Reference, c: ir.UIntLiteral), _, _) if r.name == name =>
      Some(Set(states(c.value)))
    case ir.DoPrim(PrimOps.Eq, Seq(c: ir.UIntLiteral, r: ir.Reference), _, _) if r.name == name =>
      Some(Set(states(c.value)))
    case ir.DoPrim(PrimOps.Neq, Seq(r: ir.Reference, c: ir.UIntLiteral), _, _) if r.name == name =>
      Some(states.values.toSet -- Set(states(c.value)))
    case ir.DoPrim(PrimOps.Neq, Seq(c: ir.UIntLiteral, r: ir.Reference), _, _) if r.name == name =>
      Some(states.values.toSet -- Set(states(c.value)))
    case ir.DoPrim(PrimOps.Or, Seq(a, b), _, _) =>
      val aStates = guardStates(a, name, states)
      val bStates = guardStates(b, name, states)
      (aStates, bStates) match {
        case (None, None) => None
        case (None, a) => a
        case (a, None) => a
        case (Some(a), Some(b)) => Some(a | b)
      }
    case ir.DoPrim(PrimOps.And, Seq(a, b), _, _) =>
      val aStates = guardStates(a, name, states)
      val bStates = guardStates(b, name, states)
      (aStates, bStates) match {
        case (None, None) => None
        case (None, a) => a
        case (a, None) => a
        case (Some(a), Some(b)) => Some(a & b)
      }
    case ir.DoPrim(PrimOps.Not, Seq(a), _, _) =>
      val aStates = guardStates(a, name, states)
      aStates match {
        case Some(s) => Some(states.values.toSet -- s)
        case None => None
      }
    case other =>
      val symbols = findSymbols(other)
      if(symbols.contains(name)) {
        logger.warn("[FSM] over-approximating the states")
        Some(states.values.toSet)
      } else { None } // no states
  }

  private def findSymbols(e: ir.Expression): Seq[String] = e match {
    case r: ir.Reference => Seq(r.name)
    case ir.SubField(expr, _, _, _) => findSymbols(expr)
    case ir.SubIndex(expr, _, _, _) => findSymbols(expr)
    case ir.SubAccess(expr, index, _, _) => Seq(expr, index).flatMap(findSymbols)
    case ir.DoPrim(_, args, _, _) => args.flatMap(findSymbols)
    case ir.Mux(cond, tval, fval, _) => Seq(cond, tval, fval).flatMap(findSymbols)
    case ir.ValidIf(cond, value, _) => Seq(cond, value).flatMap(findSymbols)
    case _ => Seq()
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