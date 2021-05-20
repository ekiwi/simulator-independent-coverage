// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chisel3.experimental.EnumAnnotations.{EnumComponentAnnotation, EnumDefAnnotation}
import chiseltest.coverage.CoverageInfo
import coverage.midas.Builder
import coverage.passes.{RegisterResetAnnotation, RegisterResetAnnotationPass}
import firrtl.annotations.{Annotation, CircuitTarget, ComponentName, ModuleTarget, MultiTargetAnnotation, Named, NoTargetAnnotation, ReferenceTarget, SingleTargetAnnotation, Target}
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

  def processCoverage(annos: AnnotationSeq): Seq[FsmCoverageData] = {
    val fsms = annos.collect{ case a : FsmCoverageAnnotation => a }
    val cov = Coverage.collectTestCoverage(annos).toMap
    val moduleToInst = Coverage.moduleToInstances(annos)

    fsms.flatMap { fsm =>
      val top = fsm.stateReg.circuit + "."
      moduleToInst(fsm.stateReg.module).map { inst =>
        val states = fsm.states
          .map(s => s._1 -> cov(Coverage.path(inst, s._2.ref)))
          .toList.sortBy(_._1)
        val transitions = fsm.transitions
          .map(t => t._1 -> cov(Coverage.path(inst, t._2.ref)))
          .toList.sortBy(_._1)
        FsmCoverageData(top + Coverage.path(inst, fsm.stateReg.ref), states, transitions)
      }
    }
  }
}

case class FsmCoverageData(name: String, states: List[(String, Long)], transitions: List[((String, String), Long)])


case class FsmCoverageAnnotation(
  stateReg: ReferenceTarget,
  states: Seq[(String, ReferenceTarget)],
  transitions: Seq[((String, String), ReferenceTarget)]) extends MultiTargetAnnotation with CoverageInfo {
  override def targets = Seq(Seq(stateReg)) ++ states.map(s => Seq(s._2)) ++ transitions.map(t => Seq(t._2))

  override def duplicate(n: Seq[Seq[Target]]) = {
    assert(n.length == 1 + states.length + transitions.length)
    n.foreach(e => assert(e.length == 1, "Cover points and state registers should not be split up!"))
    val targets = n.map(_.head.asInstanceOf[ReferenceTarget])
    val r = copy(stateReg = targets.head,
      states = states.map(_._1).zip(targets.slice(1, states.length + 1)),
      transitions = transitions.map(_._1).zip(targets.drop(1 + states.length)),
    )
    r
  }
}

case object SkipFsmCoverageAnnotation extends NoTargetAnnotation

object FsmCoveragePass extends Transform with DependencyAPIMigration {
  val Prefix = "f"

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm ++ Seq(Dependency(FsmInfoPass), Dependency(RegisterResetAnnotationPass))
  override def invalidates(a: Transform): Boolean = false

  override def execute(state: CircuitState): CircuitState = {
    if(state.annotations.contains(SkipFsmCoverageAnnotation)) {
      logger.info("[FsmCoverage] skipping due to SkipFsmCoverage annotation")
      return state
    }

    // collect FSMs in modules that are not ignored
    val ignoreMods = Coverage.collectModulesToIgnore(state)
    val infos = state.annotations.collect{ case a: FsmInfoAnnotation if !ignoreMods(a.target.module) => a }

    // if there are no FSMs there is nothing to do
    if(infos.isEmpty) return state

    // instrument FSMs
    val registerResets = state.annotations.collect { case a: RegisterResetAnnotation => a }
    val newAnnos = mutable.ListBuffer[Annotation]()
    val c = CircuitTarget(state.circuit.main)
    val circuit = state.circuit.mapModule(onModule(_, c, newAnnos, infos, registerResets))
    state.copy(circuit = circuit, annotations = newAnnos.toList ++ state.annotations)
  }

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: mutable.ListBuffer[Annotation],
    infos: Seq[FsmInfoAnnotation], resets: Seq[RegisterResetAnnotation]): ir.DefModule = m match {
    case mod: ir.Module =>
      val fsms = infos.filter(_.target.module == mod.name)
      if(fsms.isEmpty) { mod } else {
        val isFsm = fsms.map(_.target.ref).toSet
        val fsmRegs = findFsmRegs(mod.body, isFsm)
        val stmts = new mutable.ListBuffer[ir.Statement]()
        val ctx = ModuleCtx(c.module(mod.name), stmts, Namespace(mod))
        val toReset = RegisterResetAnnotationPass.findResetsInModule(ctx.m, resets)
        val fsmAnnos = fsms.map { f => onFsm(f, fsmRegs.find(_.name == f.target.ref).get, ctx, toReset.get) }
        annos ++= fsmAnnos
        val newBody = ir.Block(mod.body +: stmts.toList)

        mod.copy(body = newBody)
      }
    case other => other
  }

  private case class ModuleCtx(m: ModuleTarget, stmts: mutable.ListBuffer[ir.Statement], namespace: Namespace)

  private def onFsm(fsm: FsmInfoAnnotation, reg: ir.DefRegister, ctx: ModuleCtx, toReset: String => Option[String]): Annotation = {
    val info = reg.info
    val clock = reg.clock
    val reset = toReset(reg.name).map(ir.Reference(_, Utils.BoolType, NodeKind, SourceFlow)).getOrElse(Utils.False())
    val notReset = Utils.not(reset)
    val regRef = ir.Reference(reg)
    val regWidth = firrtl.bitWidth(reg.tpe)
    def inState(s: BigInt): ir.Expression = Utils.eq(regRef, ir.UIntLiteral(s, ir.IntWidth(regWidth)))

    // cover state when FSM is _not_ in reset
    val states = fsm.states.map { case (id, stateName) =>
      val name = ctx.namespace.newName(reg.name + "_" + stateName)
      ctx.stmts.append(ir.Verification(ir.Formal.Cover, info, clock, inState(id), notReset, ir.StringLit(""), name))
      stateName -> ctx.m.ref(name)
    }

    // create a register to hold the previous state
    val prevState = Builder.makeRegister(ctx.stmts, info, ctx.namespace.newName(reg.name + "_prev"), reg.tpe, clock, regRef)
    def inPrevState(s: BigInt): ir.Expression = Utils.eq(prevState, ir.UIntLiteral(s, ir.IntWidth(regWidth)))

    // create a register to track if the previous state is valid
    val prevValid = Builder.makeRegister(ctx.stmts, info, ctx.namespace.newName(reg.name + "_prev_valid"), Utils.BoolType, clock, notReset)

    // create a transition valid signal
    val transitionValid = ir.Reference(ctx.namespace.newName(reg.name + "_t_valid"), Utils.BoolType, NodeKind)
    ctx.stmts.append(ir.DefNode(info, transitionValid.name, Utils.and(notReset, prevValid)))

    val idToName = fsm.states.toMap
    val transitions = fsm.transitions.map { case (from, to) =>
      val (fromName, toName) = (idToName(from), idToName(to))
      val name = ctx.namespace.newName(reg.name + "_" + fromName + "_to_" + toName)
      ctx.stmts.append(ir.Verification(ir.Formal.Cover, info, clock, Utils.and(inPrevState(from), inState(to)),
        transitionValid, ir.StringLit(""), name))
      (fromName, toName) -> ctx.m.ref(name)
    }

    FsmCoverageAnnotation(ctx.m.ref(reg.name), states, transitions)
  }

  private def printFsmInfo(fsm: FsmInfoAnnotation): Unit = {
    val toName = fsm.states.toMap
    println(s"[${fsm.target.module}.${fsm.target.name}] Found FSM")
    if (fsm.start.nonEmpty) {
      println(s"Start: ${toName(fsm.start.get)}")
    }
    println("Transitions:")
    fsm.transitions.foreach(t => println(s"${toName(t._1)} -> ${toName(t._2)}"))
  }

  private def findFsmRegs(s: ir.Statement, isFsm: String => Boolean): Seq[ir.DefRegister] = s match {
    case r : ir.DefRegister if isFsm(r.name) => List(r)
    case ir.Block(stmts) => stmts.flatMap(findFsmRegs(_, isFsm))
    case _ : ir.Conditionally => throw new RuntimeException("Unexpected when statement! Expected LoFirrtl.")
    case _ => List()
  }
}

case class FsmInfoAnnotation(target: ReferenceTarget, states: Seq[(BigInt, String)], transitions: Seq[(BigInt, BigInt)], start: Option[BigInt])
  extends SingleTargetAnnotation[ReferenceTarget] {
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
    val allStates = states.values.toSet
    val transitions = destructMux(next).flatMap { case (guard, nx) =>
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
        // logger.warn("[FSM] over-approximating the states")
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
  }
}

/** searches for state machine registers */
private class ModuleScanner(localComponents: Map[String, EnumComponentAnnotation]) {
  private val regDefs = mutable.HashMap[String, ir.DefRegister]()
  private val connects = mutable.HashMap[String, ir.Expression]()

  def run(mod: ir.Module): Seq[EnumReg] = {
    mod.foreachStmt(onStmt)
    regDefs.keys.toSeq.map { key =>
      val (next, _) = inlineComb(connects(key), key)
      EnumReg(localComponents(key).enumTypeName, regDefs(key), next)
    }
  }

  /** resolves references to nodes (all wires should have been removed at this point)
   *  Ignores any subexpressions that do not actually contain references to the state register.
   * */
  private def inlineComb(e: ir.Expression, stateReg: String): (ir.Expression, Boolean) = e match {
    case r: ir.Reference if r.kind == firrtl.NodeKind =>
      val (e, shouldInline) = inlineComb(connects(r.name), stateReg)
      if(shouldInline) { (e, true) } else { (r, false) }
    case r: ir.Reference if r.name == stateReg => (r, true)
    // registers are always plain references, so any RefLikeExpression that gets here is not a state register
    case r: ir.RefLikeExpression => (r, false)
    case p : ir.DoPrim =>
      val c = p.args.map(inlineComb(_, stateReg))
      val shouldInline = c.exists(_._2)
      if(shouldInline) { (p.copy(args = c.map(_._1)), true) } else { (p, false) }
    case m @ ir.Mux(cond, tval, fval, tpe) =>
      val c = Seq(cond, tval, fval).map(inlineComb(_, stateReg))
      val shouldInline = c.exists(_._2)
      if(shouldInline) {
        (ir.Mux(c(0)._1, c(1)._1, c(2)._1, tpe), true)
      } else { (m, false) }
    case v@ ir.ValidIf(cond, value, tpe) =>
      val c = Seq(cond, value).map(inlineComb(_, stateReg))
      val shouldInline = c.exists(_._2)
      if(shouldInline) {
        (ir.ValidIf(c(0)._1, c(1)._1, tpe), true)
      } else { (v, false) }
    case l: ir.Literal => (l, false)
    case other => throw new RuntimeException(s"Unexpected expression $other")
  }
  private def onStmt(s: ir.Statement): Unit = s match {
    case r: ir.DefRegister if localComponents.contains(r.name) => regDefs(r.name) = r
    case ir.Connect(_, loc, expr) => connects(loc.serialize) = expr
    case ir.DefNode(_, name, expr) => connects(name) = expr
    case other => other.foreachStmt(onStmt)
  }
}
private case class EnumReg(enumTypeName: String, regDef: ir.DefRegister, next: ir.Expression)