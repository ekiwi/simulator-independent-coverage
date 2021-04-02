// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import firrtl._
import firrtl.analyses.InstanceKeyGraph.InstanceKey
import firrtl.ir.{Input, Output}
import firrtl.options.Dependency
import firrtl.stage.Forms
import firrtl.transforms.{ConstantPropagation, DeadCodeElimination, EnsureNamedStatements}

import scala.collection.mutable

/** Analyses the Clock and Reset Domains of all Registers and Memories in the Circuit.
  * TODO: is a synchronous reset a real reset?
  * */
object ClockAndResetAnalysisPass extends Transform with DependencyAPIMigration {
  // we don't want to deal with non-ground types since clocks or resets could be part of a bundle
  // TODO: can we run this analysis on high form?
  //       the line coverage instrumentation pass needs to run before ExpandWhens and would benefit from this analysis
  //       Potential fix: use undefined clock in line coverage pass, add fix-up pass to add correct clock
  override def prerequisites = Forms.LowForm ++ Seq(Dependency(EnsureNamedStatements))

  // we do not change the circuit, only annotate the results, or throw errors
  override def invalidates(a: Transform) = false

  // constant prop could remove false paths and DCE could remove unused signals
  override def optionalPrerequisites = Seq(Dependency[DeadCodeElimination], Dependency[ConstantPropagation])


  override def execute(state: CircuitState): CircuitState = {
    //val modInfos = state.circuit.modules.par.map(scanModule) // parallel version
    val modInfos = state.circuit.modules.map(scanModule)
    state
  }

  private def scanModule(m: ir.DefModule): ModuleInfo = m match {
    case e: ir.ExtModule =>
      throw new RuntimeException(s"TODO: deal with extmodules")
    case mod: ir.Module =>
      // println(mod.serialize)
      new ModuleScanner().onModule(mod)

  }
}

private case class Clock(name: String, inverted: Boolean = false) {
  override def toString = if(inverted) { "@negedge " + name } else { "@posedge " + name }
}
private case class Reset(name: String, inverted: Boolean = false) {
  override def toString = if(inverted) { "not(" + name + ")" } else { name }
}
private case class Domain(clock: Clock, reset: Option[Reset]) {
  override def toString = reset match {
    case Some(r) => s"$clock, $r"
    case None => clock.toString
  }
}

private case class ModuleInfo(
  states: List[StateInfo],
  statements: List[StateInfo],
  outputs: List[OutputInfo],
  instances: List[InstanceKey]
)
private case class OutputInfo(name: String, node: ir.FirrtlNode, driver: DriverInfo)
private case class StateInfo(name: String, node: ir.FirrtlNode, domain: Domain, driver: DriverInfo)
private case class DriverInfo(domains: List[Domain], dependencies: List[String])

/** A Module Scanner essentially performs two types of analyses in parallel:
  * - A (combinatorial) connectivity check, similar to what we would do to check for combinatorial loops
  *   - inputs are: module inputs, registers (RHS), submodule/memory outputs
  *   - outputs are: module outputs, registers (LHS), submodule/memory inputs
  * - An analysis of potential clock/reset signals
  *   - the goal here is to deal with some casts
  *   - we treat SyncReset, Reset, UInt<1> and SInt<1> as potential reset signals
  *   - we treat Clock, UInt<1> and SInt<1> as potential clock signals
  *   - the only operation that we allow on reset/clock signals is inversion (not(...))
  *     this will turn a posedge clock into a negedge clock and a high-active reset into
  *     a low-active reset
  */
private class ModuleScanner {
  private case class ClockCandidate(src: ir.RefLikeExpression, inverted: Boolean = false, usedAsClock: Boolean = false) {
    def toDomain: Clock = Clock(src.serialize, inverted=inverted)
    def flip: ClockCandidate = copy(inverted = !inverted)
    def used: Boolean = usedAsClock
  }
  private case class ResetCandidate(src: ir.RefLikeExpression, inverted: Boolean = false, usedAsAsyncReset: Boolean = false, usedAsSyncReset: Boolean = false) {
    def toDomain: Reset = Reset(src.serialize, inverted=inverted)
    def flip: ResetCandidate = copy(inverted = !inverted)
    def used: Boolean = usedAsAsyncReset || usedAsSyncReset
  }

  /** Track potential clocks. */
  private val clocks = mutable.HashMap[String, ClockCandidate]()
  /** Track potential resets. */
  private val resets = mutable.HashMap[String, ResetCandidate]()
  /** Track the dependencies of all signals on our inputs */
  private val dependsOn = mutable.HashMap[String, Set[String]]()
  /** Registers/Memories/Statements have separate dependency tracking since the dependency not combinatorial */
  private val stateDeps = mutable.HashMap[String, Set[String]]()


  /** Every Input is assigned to a fake domain. */
  private val inputs = mutable.ArrayBuffer[String]()
  private val outputs = mutable.ArrayBuffer[String]()

  private val memories = mutable.HashMap[String, ir.DefMemory]()
  private val stateDomains = mutable.HashMap[String, Domain]()

  /** Clocked statement that cannot be referenced: print, stop, assert, assume and cover */
  private val statementDomains = mutable.HashMap[String, Domain]()
  private val statementDeps = mutable.HashMap[String, Set[String]]()

  /** Track instances for eventual merging. */
  private val instances = mutable.ListBuffer[InstanceKey]()

  def onModule(m: ir.Module): ModuleInfo = {
    m.ports.foreach(onPort)
    onStmt(m.body)

    // create the module info


    println("=================")
    println(s"= ${m.name}")
    println("=================")

    println("Register/Memory/Statement Domains")
    (stateDomains ++ stateDomains).foreach { case (r, dom) =>
      println(s"$r: $dom")
    }
    println()


    println("Output Dependencies")
    val isInput = inputs.toSet
    outputs.foreach { out =>
      val deps = dependsOn(out)
      val inputs = deps.filter(isInput(_))
      val domains = deps.flatMap(stateDomains.get)
      println(s"$out: " + inputs.mkString(", ") + " " + domains.mkString(", "))
    }

    println()
    println()

    // TODO: summarize analysis and return result
    ModuleInfo(List(), List(), List(), List())
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

  /** called for module inputs and submodule outputs */
  private def addInput(ref: ir.RefLikeExpression): Unit = {
    val tpe = ref.tpe.asInstanceOf[ir.GroundType]
    val key = ref.serialize
    if(couldBeReset(tpe)) resets(key) = ResetCandidate(ref)
    if(couldBeClock(tpe)) clocks(key) = ClockCandidate(ref)
    inputs.append(key)
  }

  /** called for module outputs and submodule inputs */
  private def addOutput(ref: ir.RefLikeExpression): Unit = {
    outputs.append(ref.serialize)
  }

  private def onPort(p: ir.Port): Unit = p.direction match {
    case Input => addInput(ir.Reference(p))
    case Output => addOutput(ir.Reference(p))
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

  private def onReg(r: ir.DefRegister): Unit = {
    assert(!stateDomains.contains(r.name))
    val clock = useClock(r.clock, s"of register ${r.serialize}")
    // try to see if we have an async reset
    val reset = r.reset match {
      case Utils.False() => None
      case other => Some(useReset(other, s"of register ${r.serialize}"))
    }
    stateDomains(r.name) = Domain(clock, reset)
  }

  private def onRegNext(name: String, next: ir.Expression): Unit = {
    // compute dependencies for register next
    stateDeps(name) = getDependencies(next)

    // check to see if there is a synchronous reset
    val domains = stateDomains(name)
    val hasAsyncReset = domains.reset.isDefined
    if(!hasAsyncReset) { next match {
      // at this point in the compiler, synchronous reset have been transformed into muxes
      // TODO: maybe use some information from prior passes to figure out resets in a more reliable manner
      case ir.Mux(rst, _, _, _) =>
        stateDomains(name) = domains.copy(reset = Some(useReset(rst, s"of register ${name}")))
      case _ => // ignore
    }}
  }

  private def onConnectSignal(name: String, rhs: ir.Expression): Unit = {
    // track dependencies
    dependsOn(name) = getDependencies(rhs)
    // analyze reset/clock if applicable
    val tpe = rhs.tpe.asInstanceOf[ir.GroundType]
    if(couldBeClock(tpe)) analyzeClock(rhs) match { case Some(i) => clocks(name) = i case _ => }
    if(couldBeReset(tpe)) analyzeReset(rhs) match { case Some(i) => resets(name) = i case _ => }
  }

  private def onConnectOutput(ref: ir.RefLikeExpression, rhs: ir.Expression): Unit = {
    // TODO: do always just do the same as when we are connecting a signal?
    onConnectSignal(ref.serialize, rhs)
  }

  private def onConnectMem(name: String, port: String, field: String, rhs: ir.Expression): Unit = field match {
    case "clk" =>
      val key = name + "." + port
      val clock = useClock(rhs, s"of memory ${name}")
      assert(!stateDomains.contains(key))
      stateDomains(key) = Domain(clock, None)
    case _ =>
      val key = name + "." + port
      val deps = getDependencies(rhs)
      // reading memory inputs is forbidden, so we do not add the dependencies to the global [[dependsOn]] map
      val oldDeps = stateDeps.getOrElse(key, Set())
      stateDeps(key) = oldDeps | deps
  }

  private def onConnect(c: ir.Connect): Unit = c.loc match {
    case ir.Reference(name, _, RegKind, _) => onRegNext(name, c.expr)
    case ref @ ir.Reference(_, _, PortKind, _) => onConnectOutput(ref, c.expr)
    case ir.Reference(name, _, _, _) => onConnectSignal(name, c.expr)
    // connecting to a submodule output
    case ref@ir.SubField(ir.Reference(_, _, _, _), _, _, _) => onConnectOutput(ref, c.expr)
    // connecting to a memory port
    case ir.SubField(ir.SubField(ir.Reference(name, _, _, _), port, _, _), field, _, _) =>
      onConnectMem(name, port, field, c.expr)
    case other => throw new RuntimeException(s"Unexpected connect: ${other.serialize}")
  }

  private def onSideEffectingStatement(name: String, clock: ir.Expression, en: ir.Expression, args: Seq[ir.Expression]): Unit = {
    statementDeps(name) = (en +: args).map(getDependencies).reduce(_ | _)
    val clk = useClock(clock, s"of statement ${name}")
    stateDomains(name) = Domain(clk, None)
  }

  private def onStmt(s: ir.Statement): Unit = s match {
    case i : ir.DefInstance => onInstance(i)
    case mem: ir.DefMemory => memories(mem.name) = mem
    case reg: ir.DefRegister => onReg(reg)
    case _ : ir.DefWire => // nothing to do
    case ir.DefNode(_, name, value) => onConnectSignal(name, value)
    case c: ir.Connect => onConnect(c)
    case ir.IsInvalid(_, ref) => dependsOn(ref.serialize) = Set()
    case ir.Block(stmts) => stmts.foreach(onStmt)
    case p : ir.Print => onSideEffectingStatement(p.name, p.clk, p.en, p.args)
    case s : ir.Stop => onSideEffectingStatement(s.name, s.clk, s.en, Seq())
    case v : ir.Verification => onSideEffectingStatement(v.name, v.clk, v.en, Seq(v.pred))
    case other => throw new RuntimeException(s"Unexpected statement type: ${other.serialize}")
  }

  /** called when a clock is used for a register or memory */
  private def useClock(e: ir.Expression, ctx: => String): Clock = {
    val clockName = e.serialize // TODO: deal with non reference expressions!
    assert(clocks.contains(clockName), s"Could not find clock $ctx!")
    // we mark the clock as used:
    val clock = clocks(clockName).copy(usedAsClock = true)
    clocks(clockName) = clock
    clock.toDomain
  }

  /** called when a reset is used for a register */
  private def useReset(e: ir.Expression, ctx: => String): Reset = {
    val resetName = e.serialize // TODO: deal with non reference expressions!
    assert(resets.contains(resetName), s"Could not find (async) reset $ctx!")
    val reset = resets(resetName).copy(usedAsAsyncReset = true)
    resets(resetName) = reset
    reset.toDomain
  }

  /** returns a set of inputs/registers that the expression depends */
  private def getDependencies(e: ir.Expression): Set[String] = e match {
    case ref: ir.RefLikeExpression =>
      val name = ref.serialize
      dependsOn.getOrElse(name, Set(name))
    case ir.Mux(cond, tval, fval, _) =>
      Seq(cond, tval, fval).map(getDependencies).reduce(_ | _)
    case ir.ValidIf(cond, value, _) =>
      Seq(cond,value).map(getDependencies).reduce(_ | _)
    case ir.DoPrim(_, args, _, _) =>
      args.map(getDependencies).reduce(_ | _)
    case _ => Set()
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
