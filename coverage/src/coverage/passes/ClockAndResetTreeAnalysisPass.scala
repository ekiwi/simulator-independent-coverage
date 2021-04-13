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
  override def prerequisites = Seq(Dependency[passes.ExpandWhensAndCheck], Dependency(passes.LowerTypes))
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


private object ModuleTreeScanner {
  private case class Con(lhs: String, rhs: String, inverted: Boolean, info: ir.Info)

  private def analyzeResults(m: ModuleTreeScanner): ModuleTreeInfo = {
    // our analysis goes backwards, from output, clock or reset use to the source
    val cons = m.connections.map(c => c.lhs -> c).toMap
    val isInput = m.inputs.toSet
    val isReg = m.inputs.toSet

    // resets
    println("Reset Paths:")
    val resets = m.usedAsReset.toSeq.sorted.map { r =>
      val path = findPath(cons, r)
      if(path.size > 1) { println("PATH") }
      if(r != "reset") { println("UNUSUAL") }
      println(path)
    }


    println("Resets")
    println(m.usedAsReset.toSeq.sorted.mkString(", "))
    println("Clocks")
    println(m.usedAsClock.toSeq.sorted.mkString(", "))
    println("Outputs")
    println(m.usedAsOutput.toSeq.sorted.mkString(", "))

    println()
    println()

    // TODO: summarize analysis and return result
    ModuleTreeInfo()
  }

  private def findPath(cons: Map[String, Con], name: String): Seq[(String, Boolean)] = cons.get(name) match {
    case Some(value) =>
      val prefix = findPath(cons, value.rhs)
      (name, prefix.head._2 ^ value.inverted) +: prefix
    case None => List((name, false))
  }


  private case class SignalInfo(name: String, source: String, inverted: Boolean)

  private def couldBeResetOrClock(tpe: ir.Type): Boolean = tpe match {
    case ir.ClockType => true
    case ir.ResetType => true
    case ir.AsyncResetType => true
    case ir.UIntType(ir.IntWidth(w)) if w == 1 => true
    case ir.SIntType(ir.IntWidth(w)) if w == 1 => true
    case _ => false
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
}

/** Analyses all potential potential clock/reset signals in the module
 *  - the goal here is to deal with some casts
 *  - we treat SyncReset, Reset, UInt<1> and SInt<1> as potential reset signals
 *  - we treat Clock, UInt<1> and SInt<1> as potential clock signals
 *  - the only operation that we allow on reset/clock signals is inversion (not(...))
 *    this will turn a posedge clock into a negedge clock and a high-active reset into
 *    a low-active reset
 */
private class ModuleTreeScanner {
  import ModuleTreeScanner._

  // we keep track of the usage and connections of signals that could be reset or clocks
  private val usedAsClock = mutable.HashSet[String]()
  private val usedAsReset = mutable.HashSet[String]()
  private val usedAsOutput = mutable.HashSet[String]()
  private val inputs = mutable.ArrayBuffer[String]()
  private val regs = mutable.ArrayBuffer[String]()
  private val connections = mutable.ArrayBuffer[Con]()


  def onModule(m: ir.Module): ModuleTreeInfo = {
    m.ports.foreach(onPort)
    onStmt(m.body)
    println("=================")
    println(s"= ${m.name}")
    println("=================")
    analyzeResults(this)
  }

  /** called for module inputs and submodule outputs */
  private def addInput(ref: ir.RefLikeExpression): Unit = {
    if(!couldBeResetOrClock(ref.tpe)) return
    inputs.append(ref.serialize)
  }

  /** called for module outputs and submodule inputs */
  private def addOutput(ref: ir.RefLikeExpression): Unit = {
    if(!couldBeResetOrClock(ref.tpe)) return
    usedAsOutput.add(ref.serialize)
  }

  private def onPort(p: ir.Port): Unit = p.direction match {
    case ir.Input => addInput(ir.Reference(p))
    case ir.Output => addOutput(ir.Reference(p))
  }

  private def onInstance(i: ir.DefInstance): Unit = {
    val ports = i.tpe.asInstanceOf[ir.BundleType].fields
    val ref = ir.Reference(i)
    // for fields, Default means Output, Flip means Input
    ports.foreach {
      // we treat the outputs of the submodule as inputs to our module
      case ir.Field(name, ir.Default, tpe) => addInput(ir.SubField(ref, name, tpe))
      case ir.Field(name, ir.Flip, tpe) => addOutput(ir.SubField(ref, name, tpe))
    }
  }

  private def onConnectSignal(lhs: String, rhs: ir.Expression, info: ir.Info): Unit = {
    analyzeClockOrReset(rhs) match {
      case Some((name, inv)) => connections.append(Con(lhs, name, inv, info))
      case None =>
    }
  }

  private def onConnect(c: ir.Connect): Unit = {
    val loc = c.loc.asInstanceOf[ir.RefLikeExpression]
    Builder.getKind(loc) match {
      case RegKind => // we ignore registers
      case PortKind => onConnectSignal(loc.serialize, c.expr, c.info)
      case InstanceKind => onConnectSignal(loc.serialize, c.expr, c.info)
      case MemKind if loc.serialize.endsWith(".clk") => useClock(c.expr)
      case WireKind => onConnectSignal(loc.serialize, c.expr, c.info)
      case _ => case other => throw new RuntimeException(s"Unexpected connect of kind: ${other} (${c.serialize})")
    }
  }

  private def onStmt(s: ir.Statement): Unit = s match {
    case i : ir.DefInstance => onInstance(i)
    case r: ir.DefRegister =>
      if(couldBeResetOrClock(r.tpe)) { regs.append(r.name) }
      useClock(r.clock)
      useReset(r.reset)
    case ir.DefNode(info, name, value) =>
      // we ignore any connects that cannot involve resets or clocks because of the type
      if(couldBeResetOrClock(value.tpe)) { onConnectSignal(name, value, info) }
    case c @ ir.Connect(_, lhs, _) =>
      // we ignore any connects that cannot involve resets or clocks because of the type
      if(couldBeResetOrClock(lhs.tpe)) { onConnect(c) }
    case ir.Block(stmts) => stmts.foreach(onStmt)
    case p : ir.Print => useClock(p.clk)
    case s : ir.Stop => useClock(s.clk)
    case v : ir.Verification => useClock(v.clk)
    case _ : ir.DefWire => // nothing to do
    case _: ir.DefMemory =>
    case _ : ir.IsInvalid =>
    case ir.EmptyStmt =>
    case other => throw new RuntimeException(s"Unexpected statement type: ${other.serialize}")
  }

  /** called when a clock is used for a register or memory */
  private def useClock(e: ir.Expression): Unit = {
    analyzeClockOrReset(e) match {
      case Some((name, _)) => usedAsClock.add(name)
      case None =>
    }
  }

  /** called when a reset is used for a register */
  private def useReset(e: ir.Expression): Unit = {
    analyzeClockOrReset(e) match {
      case Some((name, _)) => usedAsReset.add(name)
      case None =>
    }
  }

  /** analyzes the expression as a (potential) clock signal */
  private def analyzeClockOrReset(e: ir.Expression): Option[(String, Boolean)] = e match {
    case ref: ir.RefLikeExpression => Some((ref.serialize, false))
    case _ : ir.Mux => None // for now we do not analyze muxes
    case ir.DoPrim(op, Seq(arg), _, _) =>
      op match {
        case PrimOps.Not => analyzeClockOrReset(arg).map{ case (n, inv) => n -> !inv }
        case PrimOps.AsAsyncReset => analyzeClockOrReset(arg)
        case PrimOps.AsClock => analyzeClockOrReset(arg)
        case PrimOps.AsUInt => analyzeClockOrReset(arg)
        case PrimOps.AsSInt => analyzeClockOrReset(arg)
        case _ => None
      }
    // TODO: can we always safely ignore that a clock or reset signal might be invalid?
    case ir.ValidIf(_, value, _) => analyzeClockOrReset(value)
    case _ => None
  }
}
