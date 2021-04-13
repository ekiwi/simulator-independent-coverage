// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import coverage.midas.Builder
import firrtl._
import firrtl.analyses.InstanceKeyGraph.InstanceKey
import firrtl.annotations.{ReferenceTarget, SingleTargetAnnotation}
import firrtl.options.Dependency

import scala.collection.mutable

case class ResetAnnotation(target: ReferenceTarget, source: String, inverted: Boolean, isAsync: Boolean) extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}
case class ClockAnnotation(target: ReferenceTarget, source: String, inverted: Boolean) extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}

/** Finds all clocks and reset signals in the design and annotates them with a global name. */
object ClockAndResetTreeAnalysisPass extends Transform with DependencyAPIMigration {
  // we want every wire to only have a single assignment
  override def prerequisites = Seq(Dependency[passes.ExpandWhensAndCheck], Dependency(passes.ExpandConnects))
  // we want to be able to identify resets (including synchronous resets)
  override def optionalPrerequisiteOf = Seq(Dependency(firrtl.transforms.RemoveReset))
  // we do not change the circuit, only annotate the results
  override def invalidates(a: Transform) = false

  override def execute(state: CircuitState): CircuitState = {
    val modInfos = state.circuit.modules.map(scanModule)
    state
  }

  private def scanModule(m: ir.DefModule): ModuleTreeInfo = m match {
    case e: ir.ExtModule =>
      logger.warn(s"TODO: deal with exmodules like ${e.name}")
      ModuleTreeInfo()
    case mod: ir.Module =>
      // println(mod.serialize)
      new ModuleTreeScanner().onModule(mod)
  }
}

private case class ModuleTreeInfo()


/** Analyses all potential potential clock/reset signals in the module
 *  - the goal here is to deal with some casts
 *  - we treat SyncReset, Reset, UInt<1> and SInt<1> as potential reset signals
 *  - we treat Clock, UInt<1> and SInt<1> as potential clock signals
 *  - the only operation that we allow on reset/clock signals is inversion (not(...))
 *    this will turn a posedge clock into a negedge clock and a high-active reset into
 *    a low-active reset
 */
private class ModuleTreeScanner {
  private case class ClockCandidate(src: ir.RefLikeExpression, inverted: Boolean = false, usedAsClock: Boolean = false) {
    def toDomain: Clock = Clock(src.serialize, inverted=inverted)
    def flip: ClockCandidate = copy(inverted = !inverted)
    def used: Boolean = usedAsClock
    override def toString = {
      val edge = if(inverted) "@negedge" else "@posedge"
      edge + " " + src.serialize + " : " + src.tpe.serialize + (if(used) " (used)" else "")
    }
  }
  private case class ResetCandidate(src: ir.RefLikeExpression, inverted: Boolean = false, usedAsAsyncReset: Boolean = false, usedAsSyncReset: Boolean = false) {
    def toDomain: Reset = Reset(src.serialize, inverted=inverted)
    def flip: ResetCandidate = copy(inverted = !inverted)
    def used: Boolean = usedAsAsyncReset || usedAsSyncReset
    override def toString = {
      val sync = if(usedAsSyncReset) "sync" else "async"
      sync + " " + src.serialize + " : " + src.tpe.serialize + (if(used) " (used)" else "")
    }
  }

  /** Track potential clocks. */
  private val clocks = mutable.HashMap[String, ClockCandidate]()
  /** Track potential resets. */
  private val resets = mutable.HashMap[String, ResetCandidate]()

  /** Every Input is assigned to a fake domain. */
  private val inputs = mutable.ArrayBuffer[String]()
  private val outputs = mutable.ArrayBuffer[String]()

  private val memories = mutable.HashMap[String, ir.DefMemory]()


  /** Track instances for eventual merging. */
  private val instances = mutable.ListBuffer[InstanceKey]()

  def onModule(m: ir.Module): ModuleTreeInfo = {
    m.ports.foreach(onPort)
    onStmt(m.body)

    // create the module info


    println("=================")
    println(s"= ${m.name}")
    println("=================")

    println("Clocks")
    clocks.foreach { case (key, value) =>
      println(s"$key: $value")
    }
    println("Resets")
    resets.foreach { case (key, value) =>
      println(s"$key: $value")
    }

    println()
    println()

    // TODO: summarize analysis and return result
    ModuleTreeInfo()
  }

  /** decide based on the type only if this signal could be used as a reset (neither sound nor complete!) */
  private def couldBeReset(tpe: ir.GroundType): Boolean = tpe match {
    case ir.ResetType => true
    case ir.AsyncResetType => true
    case ir.UIntType(ir.IntWidth(w)) if w == 1 => true
    case ir.SIntType(ir.IntWidth(w)) if w == 1 => true
    case _ => false
  }

  /** decide based on the type only if this signal could be used as a clock (neither sound nor complete!) */
  private def couldBeClock(tpe: ir.GroundType): Boolean = tpe match {
    case ir.ClockType => true
    case ir.UIntType(ir.IntWidth(w)) if w == 1 => true
    case ir.SIntType(ir.IntWidth(w)) if w == 1 => true
    case _ => false
  }

  private def couldBeResetOrClock(tpe: ir.Type): Boolean = tpe match {
    case ir.ClockType => true
    case ir.ResetType => true
    case ir.AsyncResetType => true
    case ir.UIntType(ir.IntWidth(w)) if w == 1 => true
    case ir.SIntType(ir.IntWidth(w)) if w == 1 => true
    case _ => false
  }

  /** called for module inputs and submodule outputs */
  private def addInput(ref: ir.RefLikeExpression): Unit = {
    if(!couldBeResetOrClock(ref.tpe)) return
    val tpe = ref.tpe.asInstanceOf[ir.GroundType]
    val key = ref.serialize
    if(couldBeReset(tpe)) resets(key) = ResetCandidate(ref)
    if(couldBeClock(tpe)) clocks(key) = ClockCandidate(ref)
    inputs.append(key)
  }

  /** called for module outputs and submodule inputs */
  private def addOutput(ref: ir.RefLikeExpression): Unit = {
    if(!couldBeResetOrClock(ref.tpe)) return
    outputs.append(ref.serialize)
  }

  private def onPort(p: ir.Port): Unit = p.direction match {
    case ir.Input => addInput(ir.Reference(p))
    case ir.Output => addOutput(ir.Reference(p))
  }

  private def onInstance(i: ir.DefInstance): Unit = {
    instances.prepend(InstanceKey(i.name, i.module))
    val ports = i.tpe.asInstanceOf[ir.BundleType].fields
    val ref = ir.Reference(i)
    // for fields, Default means Output, Flip means Input
    ports.foreach {
      // we treat the outputs of the submodule as inputs to our module
      case ir.Field(name, ir.Default, tpe) => addInput(ir.SubField(ref, name, tpe))
      case ir.Field(name, ir.Flip, tpe) => addOutput(ir.SubField(ref, name, tpe))
    }
  }


  private def onConnectSignal(name: String, rhs: ir.Expression): Unit = {
    // analyze reset/clock if applicable
    val tpe = rhs.tpe.asInstanceOf[ir.GroundType]
    if(couldBeClock(tpe)) analyzeClock(rhs) match { case Some(i) => clocks(name) = i case _ => }
    if(couldBeReset(tpe)) analyzeReset(rhs) match { case Some(i) => resets(name) = i case _ => }
  }

  private def onConnectOutput(ref: ir.RefLikeExpression, rhs: ir.Expression): Unit = {
    // TODO: do always just do the same as when we are connecting a signal?
    onConnectSignal(ref.serialize, rhs)
  }


  private def onConnect(c: ir.Connect): Unit = {
    val loc = c.loc.asInstanceOf[ir.RefLikeExpression]
    Builder.getKind(loc) match {
      case RegKind => // we ignore registers
      case PortKind => onConnectOutput(loc, c.expr)
      case InstanceKind => onConnectOutput(loc, c.expr)
      case MemKind if loc.serialize.endsWith(".clk") =>
        useClock(c.expr, s"of memory ${loc.serialize}")
      case WireKind | NodeKind => onConnectSignal(loc.serialize, c.expr)
      case _ => case other => throw new RuntimeException(s"Unexpected connect of kind: ${other} (${c.serialize})")
    }
  }

  private def onStmt(s: ir.Statement): Unit = s match {
    case i : ir.DefInstance => onInstance(i)
    case mem: ir.DefMemory => memories(mem.name) = mem
    case r: ir.DefRegister =>
      useClock(r.clock, s"of register ${r.serialize}")
      useReset(r.reset, s"of register ${r.serialize}")
    case _ : ir.DefWire => // nothing to do
    case ir.DefNode(_, name, value) =>
      // we ignore any connects that cannot involve resets or clocks because of the type
      if(couldBeResetOrClock(value.tpe)) { onConnectSignal(name, value) }
    case c @ ir.Connect(_, lhs, _) =>
      // we ignore any connects that cannot involve resets or clocks because of the type
      if(couldBeResetOrClock(lhs.tpe)) { onConnect(c) }
    case ir.IsInvalid(_, ref) =>
    case ir.Block(stmts) => stmts.foreach(onStmt)
    case p : ir.Print => useClock(p.clk, s"of statement ${p.name}")
    case s : ir.Stop => useClock(s.clk, s"of statement ${s.name}")
    case v : ir.Verification => useClock(v.clk, s"of statement ${v.name}")
    case ir.EmptyStmt =>
    case other => throw new RuntimeException(s"Unexpected statement type: ${other.serialize}")
  }

  /** called when a clock is used for a register or memory */
  private def useClock(e: ir.Expression, ctx: => String): Unit = {
    val clockName = e.serialize // TODO: deal with non reference expressions!
    assert(clocks.contains(clockName), s"Could not find clock $ctx!")
    // we mark the clock as used:
    val clock = clocks(clockName).copy(usedAsClock = true)
    clocks(clockName) = clock
  }

  /** called when a reset is used for a register */
  private def useReset(e: ir.Expression, ctx: => String): Unit = e match {
    case Utils.False() =>
    case _ =>
      val resetName = e.serialize // TODO: deal with non reference expressions!
      assert(resets.contains(resetName), s"Could not find (async) reset $ctx!")
      val reset = resets(resetName).copy(usedAsAsyncReset = true)
      resets(resetName) = reset
  }

  /** analyzes the expression as a (potential) clock signal */
  private def analyzeClock(e: ir.Expression): Option[ClockCandidate] = e match {
    case ref: ir.RefLikeExpression => clocks.get(ref.serialize)
    case _ : ir.Mux => None // for now we do not analyze muxes
    case ir.DoPrim(op, Seq(arg), _, _) =>
      op match {
        case PrimOps.Not => analyzeClock(arg).map(_.flip)
        case PrimOps.AsAsyncReset => None // async resets shouldn't be clocks
        case PrimOps.AsClock => analyzeClock(arg)
        case PrimOps.AsUInt => analyzeClock(arg)
        case PrimOps.AsSInt => analyzeClock(arg)
        case _ => None
      }
    // TODO: can we always safely ignore that a clock signal might be invalid?
    case ir.ValidIf(_, value, _) => analyzeClock(value)
    case _ => None
  }

  /** analyzes the expression as a (potential) reset signal */
  private def analyzeReset(e: ir.Expression): Option[ResetCandidate] = e match {
    case ref: ir.RefLikeExpression => resets.get(ref.serialize)
    case _ : ir.Mux => None // for now we do not analyze muxes
    case ir.DoPrim(op, Seq(arg), _, _) =>
      op match {
        case PrimOps.Not => analyzeReset(arg).map(_.flip)
        case PrimOps.AsAsyncReset => analyzeReset(arg)
        case PrimOps.AsClock => None // clocks resets shouldn't be resets
        case PrimOps.AsUInt => analyzeReset(arg)
        case PrimOps.AsSInt => analyzeReset(arg)
        case _ => None
      }
    // TODO: can we always safely ignore that a reset signal might be invalid?
    case ir.ValidIf(_, value, _) => analyzeReset(value)
    case _ => None
  }
}
