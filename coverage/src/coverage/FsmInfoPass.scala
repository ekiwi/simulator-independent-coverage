// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chisel3.experimental.EnumAnnotations.{EnumComponentAnnotation, EnumDefAnnotation}
import firrtl.annotations._
import firrtl._
import firrtl.stage.Forms
import firrtl.stage.TransformManager.TransformDependency

import scala.collection.mutable

case class FsmInfoAnnotation(target: ReferenceTarget, states: Seq[(BigInt, String)], transitions: Seq[(BigInt, BigInt)], start: Option[BigInt])
  extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target=n)
}

/** Annotates FSMs in the design with information about all available states and transitions. */
object FsmInfoPass extends Transform with DependencyAPIMigration {
  val Prefix = "f"

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm
  override def invalidates(a: Transform): Boolean = false

  private val debug: Boolean = true

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
        if(debug) println(mod.serialize)
        // extract net info from module
        val regNames = localComponents.keySet
        val netData = new ModuleNetAnalyzer(regNames).run(mod)
        localComponents.map { case (name, anno) =>
          analyzeFSM(c.module(mod.name), ???, ???, enums(anno.enumTypeName).definition)
        }.toList
      }
    case other => List()
  }

  private def analyzeFSM(module: ModuleTarget, regDef: ir.DefRegister, nextExpr: ir.Expression, states: Map[String, BigInt]): FsmInfoAnnotation = {
    if(debug) println(s"Analyzing FSM in $module")
    val (resetState, next) = destructReset(nextExpr)
    // if(debug) println(s"Next: ${next.serialize}")
    val allStates = states.values.toSet
    val destructedMux = destructMux(next)
    if(debug) {
      println(s"Next:\n${next.serialize}")
      println(s"Destructed:")
      destructedMux.foreach { case (guard, nx) =>
        println(s"When ${guard.serialize} ==> ${nx.serialize}")
      }
    }
    val transitions = destructedMux.flatMap { case (guard, nx) =>
      val from = guardStates(guard, regDef.name, allStates).getOrElse(allStates)
      val to = nextStates(nx, regDef.name, allStates, from)
      from.flatMap(f => to.map(t => f -> t))
    }.sortBy(_._1)

    FsmInfoAnnotation(module.ref(regDef.name),
      states = states.toSeq.sorted.map{ case (n, i) => i -> n },
      transitions = transitions,
      start = resetState
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
  private def nextStates(e: ir.Expression, name: String, allStates: Set[BigInt], guards: Set[BigInt]): Set[BigInt] = e match {
    case c: ir.UIntLiteral => Set(c.value)
    case r: ir.Reference if r.name == name => guards
    case _ => allStates
  }
  private def guardStates(e: ir.Expression, name: String, allStates: Set[BigInt]): Option[Set[BigInt]] = e match {
    case ir.DoPrim(PrimOps.Eq, Seq(r: ir.Reference, c: ir.UIntLiteral), _, _) if r.name == name =>
      Some(Set(c.value))
    case ir.DoPrim(PrimOps.Eq, Seq(c: ir.UIntLiteral, r: ir.Reference), _, _) if r.name == name =>
      Some(Set(c.value))
    case ir.DoPrim(PrimOps.Neq, Seq(r: ir.Reference, c: ir.UIntLiteral), _, _) if r.name == name =>
      Some(allStates -- Set(c.value))
    case ir.DoPrim(PrimOps.Neq, Seq(c: ir.UIntLiteral, r: ir.Reference), _, _) if r.name == name =>
      Some(allStates -- Set(c.value))
    case ir.DoPrim(PrimOps.Or, Seq(a, b), _, _) =>
      val aStates = guardStates(a, name, allStates)
      val bStates = guardStates(b, name, allStates)
      combineOr(aStates, bStates)
    case ir.DoPrim(PrimOps.And, Seq(a, b), _, _) =>
      val aStates = guardStates(a, name, allStates)
      val bStates = guardStates(b, name, allStates)
      combineAnd(aStates, bStates)
    case ir.DoPrim(PrimOps.Not, Seq(a), _, _) =>
      val aStates = guardStates(a, name, allStates)
      aStates match {
        case Some(s) => Some(allStates -- s)
        case None => None
      }
    // try to analyze the following pattern
    // orr(cat(cat(eq(release_state, UInt(9)), eq(release_state, UInt(6))), eq(release_state, UInt(1))))
    case ir.DoPrim(PrimOps.Orr, Seq(s @ ir.DoPrim(PrimOps.Cat, _, _, _)), _, tpe) =>
      val bits = getCatBits(s)
      bits.foreach { b =>
        assert(firrtl.bitWidth(b.tpe) == 1, s"Cannot deal with concatenated value ${b.serialize}")
      }

      val sts = bits.map(guardStates(_, name, allStates))
      if(sts.length == 1) {
        sts.head
      } else {
        sts.reduce(combineOr)
      }
    case other =>
      val symbols = findSymbols(other)
      if(symbols.contains(name)) {
        // throw new RuntimeException(s"failed to analyze:\n" + other.serialize)
        logger.warn("[FSM] over-approximating the states")
        Some(allStates)
      } else { None } // no states
  }

  private def combineOr(aStates: Option[Set[BigInt]], bStates: Option[Set[BigInt]]): Option[Set[BigInt]] = {
    (aStates, bStates) match {
      case (None, None) => None
      case (None, a) => a
      case (a, None) => a
      case (Some(a), Some(b)) => Some(a | b)
    }
  }

  private def combineAnd(aStates: Option[Set[BigInt]], bStates: Option[Set[BigInt]]): Option[Set[BigInt]] = {
    (aStates, bStates) match {
      case (None, None) => None
      case (None, a) => a
      case (a, None) => a
      case (Some(a), Some(b)) => Some(a & b)
    }
  }

  private def getCatBits(e: ir.Expression): List[ir.Expression] = e match {
    case ir.DoPrim(PrimOps.Cat, Seq(msb, lsb), _, _) =>
      getCatBits(msb) ++ getCatBits(lsb)
    case other => List(other)
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
    case other => throw new NotImplementedError(s"Unexpected $other")
  }
}



/** Contains the right-hand-side expression and transitive register dependency for a single node or register next expression. */
private case class ConnectionInfo(expr: ir.Expression, registerDependencies: Set[String])
/** Contains information about all nodes and register next connections in the circuit */
private case class ModuleNetData(con: Map[String, ConnectionInfo])
private class ModuleNetAnalyzer(registers: Set[String]) {
  private val con = mutable.HashMap[String, ConnectionInfo]()
  def run(mod: ir.Module): ModuleNetData = {
    mod.foreachStmt(onStmt)
    ModuleNetData(con.toMap)
  }
  def onStmt(s: ir.Statement): Unit = s match {
    case ir.Connect(_, ir.Reference(name, _, kind, _), expr) if kind == RegKind =>
      // register do not induce any dependencies, since we are only looking at a single cycle!
      con(name) = ConnectionInfo(expr, Set())
    case ir.Connect(_, loc, expr) =>
      con(loc.serialize) = ConnectionInfo(expr, findDeps(expr))
    case ir.DefNode(_, name, expr) =>
      con(name) = ConnectionInfo(expr, findDeps(expr))
    case other => other.foreachStmt(onStmt)
  }
  def findDeps(e: ir.Expression): Set[String] = e match {
    case ir.Reference(name, _, _, _) =>
      if(registers.contains(name)) { Set(name) } else {
        con.get(name).map(_.registerDependencies).getOrElse(Set())
      }
    case _ : ir.UIntLiteral | _ : ir.SIntLiteral => Set()
    case prim : ir.DoPrim => prim.args.map(findDeps).reduce(_ | _)
    case ir.Mux(cond, tval, fval, _) => Seq(cond, tval, fval).map(findDeps).reduce(_ | _)
    case ir.ValidIf(cond, value, _) => Seq(cond, value).map(findDeps).reduce(_ | _)
    case _ : ir.RefLikeExpression => Set() // ref-like but not a reference => cannot be a scalar register
  }
}