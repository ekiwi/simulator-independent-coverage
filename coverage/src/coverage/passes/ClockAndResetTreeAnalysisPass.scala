// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import coverage.midas.Builder
import firrtl._
import firrtl.analyses.InstanceKeyGraph
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
    // analyze each module in isolation
    val local = state.circuit.modules.map(m => m.name -> ModuleTreeScanner.scan(m)).toMap

    // combine local information into a global list of clocks and resets
    val iGraph = InstanceKeyGraph(state.circuit)
    val merged = mergeInfo(iGraph, local)
    val annos = makeAnnos(iGraph, merged)

    state.copy(annotations = annos ++ state.annotations)
  }

  import ModuleTreeScanner.{ModuleInfo, ConnectionInfo, SignalInfo, SignalGroup}

  private def mergeInfo(iGraph: InstanceKeyGraph, local: Map[String, ModuleInfo]): ModuleInfo = {
    // compute global results
    val moduleOrderBottomUp = iGraph.moduleOrder.reverseIterator
    val childInstances = iGraph.getChildInstances.toMap
    val merged = mutable.HashMap[String, ModuleInfo]()

    moduleOrderBottomUp.foreach {
      case m: ir.Module =>
        val info = mergeWithSubmodules(m, local(m.name), merged, childInstances(m.name))
        merged(m.name) = info
      case e: ir.ExtModule =>
        val outputs = local(e.name).connections
        ModuleInfo(Seq(), Seq(), outputs)
    }

    merged(iGraph.top.module)
  }

  private type SignalGroups = Seq[SignalGroup]

  private def mergeWithSubmodules(m: ir.Module, local: ModuleInfo, getMerged: String => ModuleInfo, instances: Seq[InstanceKey]): ModuleInfo = {
    val submoduleInfo = instances.map { case InstanceKey(name, module) =>  name -> getMerged(module) }

    // we first resolve all connections
    val allCons = resolveConnections(local.connections, submoduleInfo)

    // filter out the connections that are relevant to the outside world
    val connections = allCons.filterNot(c => isInstancePort(c.source) || isInstancePort(c.sink))

    // resolve all our clock and reset signals
    val sinkToSource = allCons.map(c => c.sink -> c).toMap // every sink should be unique!
    val subClocks = submoduleInfo.map{ case (n, i) => n -> i.clocks }
    val clocks = resolveSignals(local.clocks, subClocks, sinkToSource)
    val subResets = submoduleInfo.map{ case (n, i) => n -> i.resets }
    val resets = resolveSignals(local.resets, subResets, sinkToSource)

    // package it all up
    ModuleInfo(clocks, resets, connections)
  }

  private def resolveSignals(local: Seq[SignalGroup], submodules: Seq[(String, SignalGroups)],
    sinkToSource: Map[String, ConnectionInfo]): SignalGroups = {
    // prefix sub-module signals
    val prefixed = submodules.flatMap { case (name, groups) => addPrefix(name, groups) }

    // resolve all signal groups
    val resolved = (local ++ prefixed).map { case g @ SignalGroup(source, signals) =>
      sinkToSource.get(source) match {
        case Some(con) =>
          val newSignals = signals.map(s => s.copy(inverted = s.inverted ^ con.inverted))
          SignalGroup(con.source, newSignals)
        case None => g
      }
    }

    // merge all groups that now draw from the same source
    resolved.groupBy(_.source).toSeq.sortBy(_._1).map { case (source, groups) =>
      SignalGroup(source, groups.flatMap(_.signals))
    }
  }

  private def resolveConnections(local: Seq[ConnectionInfo], submoduleInfo: Seq[(String, ModuleInfo)]): Seq[ConnectionInfo] = {
    // we consider local connections and any connections from our submodule
    val connections = local ++ submoduleInfo.flatMap{ case (n, i) => i.connections.map(addPrefix(n, _)) }

    // if the source is also a sink, then we have an "internal" connections, otherwise we consider it external
    val isSink = connections.map(_.sink).toSet
    val (intSrc, extSrc) = connections.partition(c => isSink(c.source))

    // create an index for internal sources to allow us to trace connections
    val intCons = intSrc.groupBy(_.source) // since it is a clock/reset TREE, a single source can have multiple sinks

    // the connections that start at an "external" port are our starting points
    var todo = extSrc

    // collect all connections that start at an external source
    val done = mutable.ArrayBuffer[ConnectionInfo]()

    // this is a fixed point computation, since connections could "snake" through submodules
    while(todo.nonEmpty) {
      todo = todo.flatMap { con =>
        // remember this connection
        done.append(con)
        // connect everything starting at the sink and add it to our todo list
        intCons.getOrElse(con.sink, List()).map(connectSource(_, con))
      }
    }

    done
  }

  private def connectSource(con: ConnectionInfo, source: ConnectionInfo): ConnectionInfo = {
    require(con.source == source.sink)
    val inverted = source.inverted ^ con.inverted
    val usedAsReset = source.usedAsReset || con.usedAsReset
    val usedAsClock = source.usedAsClock || con.usedAsClock
    ConnectionInfo(con.sink, source.source, inverted, usedAsReset=usedAsReset, usedAsClock=usedAsClock)
  }

  private def isInstancePort(name: String): Boolean = name.contains('.')
  private def addPrefix(name: String, groups: SignalGroups): SignalGroups = {
    groups.map { case SignalGroup(source, signals) =>
      SignalGroup(name + "." + source, signals.map(s => s.copy(name = name + "." + s.name)))
    }
  }
  private def addPrefix(name: String, o: ConnectionInfo): ConnectionInfo =
    o.copy(sink = name + "." + o.sink, source = name + "." + o.source)

  private def makeAnnos(iGraph: InstanceKeyGraph, merged: ModuleInfo): AnnotationSeq = {
    println("Clocks:")
    merged.clocks.foreach(println)
    println("Resets:")
    merged.clocks.foreach(println)
    Seq()
  }

}

private object ModuleTreeScanner {
  private case class Con(lhs: String, rhs: String, inverted: Boolean, info: ir.Info)

  def scan(m: ir.DefModule): ModuleInfo = m match {
    case e: ir.ExtModule =>
      val outPorts = e.ports.filter(_.direction == ir.Output).filter(p => couldBeResetOrClock(p.tpe))
      val outputs = outPorts.map(p => ConnectionInfo(p.name, p.name, false, false, false))
      ModuleInfo(List(), List(), outputs)
    case mod: ir.Module =>
      val scan = new ModuleTreeScanner()
      scan.onModule(mod)
      analyzeResults(scan)
  }

  private def analyzeResults(m: ModuleTreeScanner): ModuleInfo = {
    // our analysis goes backwards, from output, clock or reset use to the source
    val cons = m.connections.map(c => c.lhs -> c).toMap
    val isInput = m.inputs.toSet
    val isReg = m.regs.toSet

    // find all signals that are definitely reset or clock signals (since they are used as such)
    val resets = analyzeSignals(m.usedAsReset.toSeq, cons, isInput, isReg, "reset")
    val clocks = analyzeSignals(m.usedAsClock.toSeq, cons, isInput, isReg, "clock")

    // check to see if any outputs are also resets or clocks or derived from an input
    val connections = m.usedAsOutput.toSeq.sorted.flatMap { sink =>
      val path = findPath(cons, sink)
      val (src, _) = path.last
      // we are only interested in outputs that directly depend on an input
      if(!isInput(src)) { None } else {
        val usedAsReset = path.map(_._1).exists(resets.contains)
        val usedAsClock = path.map(_._1).exists(clocks.contains)
        assert(!(usedAsReset && usedAsClock), f"Found signal that is both used as a reset and a clock: $path")
        Some(ConnectionInfo(sink, src, path.head._2, usedAsReset=usedAsReset, usedAsClock=usedAsClock))
      }
    }

    ModuleInfo(groupSignals(resets), groupSignals(clocks), connections)
  }

  private def groupSignals(signals: Map[String, SignalSourceInfo]): Seq[SignalGroup] = {
    signals.values.groupBy(_.source).toSeq.sortBy(_._1).map { case (source, sigs) =>
      SignalGroup(source, sigs.toSeq.sortBy(_.name).map(s => SignalInfo(s.name, s.inverted)))
    }
  }

  private def findPath(cons: Map[String, Con], name: String): Seq[(String, Boolean)] = cons.get(name) match {
    case Some(value) =>
      val prefix = findPath(cons, value.rhs)
      (name, prefix.head._2 ^ value.inverted) +: prefix
    case None => List((name, false))
  }

  private def analyzeSignals(names: Seq[String], cons: Map[String, Con], isInput: String => Boolean,
    isReg: String => Boolean, kind: String): Map[String, SignalSourceInfo] = {
    names.sorted.flatMap { s =>
      val path = findPath(cons, s)
      val src = path.last
      assert(!src._2, f"Sources should never be inverted! $src")
      assert(!isReg(src._1), f"Registered ${kind}s are not currently supported: $path")
      assert(isInput(src._1), f"Found $kind that is not derived from an input. How can that happen? $path")
      path.map{ case (name, inverted) => name -> SignalSourceInfo(name, src._1, inverted) }
    }.toMap
  }

  private case class SignalSourceInfo(name: String, source: String, inverted: Boolean)
  case class SignalInfo(name: String, inverted: Boolean)
  case class SignalGroup(source: String, signals: Seq[SignalInfo])
  case class ConnectionInfo(sink: String, source: String, inverted: Boolean, usedAsReset: Boolean, usedAsClock: Boolean)
  case class ModuleInfo(resets: Seq[SignalGroup], clocks: Seq[SignalGroup], connections: Seq[ConnectionInfo])

  private def couldBeResetOrClock(tpe: ir.Type): Boolean = tpe match {
    case ir.ClockType => true
    case ir.ResetType => true
    case ir.AsyncResetType => true
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
 *  - we also try our best to filter out no-ops, like a bits(..., 0, 0) extraction
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


  def onModule(m: ir.Module): Unit = {
    m.ports.foreach(onPort)
    onStmt(m.body)
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
      case ir.Field(_, other, _) => throw new RuntimeException(s"Unexpected field direction: $other")
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
    case ir.DoPrim(op, Seq(arg), consts, _) =>
      op match {
        case PrimOps.Not => analyzeClockOrReset(arg).map{ case (n, inv) => n -> !inv }
        case PrimOps.AsAsyncReset => analyzeClockOrReset(arg)
        case PrimOps.AsClock => analyzeClockOrReset(arg)
        case PrimOps.AsUInt => analyzeClockOrReset(arg)
        case PrimOps.AsSInt => analyzeClockOrReset(arg)
        case PrimOps.Bits if consts == List(BigInt(0), BigInt(0)) => analyzeClockOrReset(arg)
        case _ => None
      }
    // TODO: can we always safely ignore that a clock or reset signal might be invalid?
    case ir.ValidIf(_, value, _) => analyzeClockOrReset(value)
    case _ => None
  }
}
