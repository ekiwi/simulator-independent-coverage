// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import coverage.midas.Builder
import coverage.passes.ModuleTreeScanner.analyzeTree
import firrtl._
import firrtl.analyses.InstanceKeyGraph
import firrtl.analyses.InstanceKeyGraph.InstanceKey
import firrtl.annotations.{CircuitTarget, ModuleTarget, ReferenceTarget, SingleTargetAnnotation}
import firrtl.options.Dependency

import scala.collection.mutable

case class ResetAnnotation(target: ReferenceTarget, source: String, inverted: Boolean, isAsync: Boolean) extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}
case class ClockAnnotation(target: ReferenceTarget, source: String, inverted: Boolean) extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}
case class ClockSourceAnnotation(target: ReferenceTarget, sinkCount: Int) extends SingleTargetAnnotation[ReferenceTarget] {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}
case class ResetSourceAnnotation(target: ReferenceTarget, sinkCount: Int) extends SingleTargetAnnotation[ReferenceTarget] {
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

  import ModuleTreeScanner.{ModuleInfo, Tree, Sink}

  private def mergeInfo(iGraph: InstanceKeyGraph, local: Map[String, ModuleInfo]): ModuleInfo = {
    // compute global results
    val moduleOrderBottomUp = iGraph.moduleOrder.reverseIterator
    val childInstances = iGraph.getChildInstances.toMap
    val merged = mutable.HashMap[String, ModuleInfo]()

    moduleOrderBottomUp.foreach {
      case m: ir.Module =>
        val info = mergeWithSubmodules(local(m.name), merged, childInstances(m.name))
        merged(m.name) = info
      case e: ir.ExtModule => local(e.name)
    }

    merged(iGraph.top.module)
  }

  private def mergeWithSubmodules(local: ModuleInfo, getMerged: String => ModuleInfo, instances: Seq[InstanceKey]): ModuleInfo = {
    val submoduleInfo = instances.map { case InstanceKey(name, module) =>  name -> getMerged(module) }
    // resolve all new tree connections
    ModuleInfo(resolveTrees(local, submoduleInfo))
  }

  private def resolveTrees(local: ModuleInfo, submoduleInfo: Seq[(String, ModuleInfo)]): Seq[Tree] = {
    // we consider local connections and any connections from our submodule
    val trees = local.trees ++ submoduleInfo.flatMap{ case (n, i) => i.trees.map(addPrefix(n, _)) }

    // if the source a submodule port, then we have an "internal" tree, otherwise we consider it external
    val (intSrc, extSrc) = trees.partition(t => t.source.count(_ == '.') == 1)

    // TODO: deal with ext modules
    // val isSink = trees.flatMap(_.leaves.map(_.name)).toSet
    // val (intSrc, extSrc) = trees.partition(t => isSink(t.source))

    // create an index for internal sources to allow us to trace connections
    val intTrees = intSrc.groupBy(_.source) // since it is a clock/reset TREE, a single source can have multiple sinks

    // the connections that start at an "external" port are our starting points
    var todo = extSrc

    // collect all connections that start at an external source
    val done = mutable.ArrayBuffer[Tree]()

    // this is a fixed point computation, since connections could "snake" through submodules
    while(todo.nonEmpty) {
      todo = todo.flatMap { tree =>
        val (didExpand, expandedTree) = expandTree(tree, intTrees)
        if(didExpand) {
          Some(expandedTree)
        } else {
          done.append(expandedTree)
          None
        }
      }
    }

    done
  }

  private def expandTree(tree: Tree, sources: Map[String, Seq[Tree]]): (Boolean, Tree) = {
    // expand leaves when possible
    val leavesAndInternal = tree.leaves.map { case s @ Sink(name, inverted, _) =>
      sources.get(name) match {
        case Some(value) =>
          // if there is an expansion, the leaf becomes and inner node
          val leaves = value.flatMap(v => connectSinks(tree.source, v.leaves, inverted))
          val internal = s +: value.flatMap(v => connectSinks(tree.source, v.leaves, inverted))
          (leaves, internal)
        case None =>
          // if there is no expansion, the leaf stays a leaf
          (List(s), List())
      }
    }

    val leaves = leavesAndInternal.flatMap(_._1)
    val newInternal = leavesAndInternal.flatMap(_._2)
    val didExpand = newInternal.nonEmpty

    (didExpand, tree.copy(leaves = leaves, internal = tree.internal ++ newInternal))
  }

  private def connectSinks(source: String, sinks: Seq[Sink], inverted: Boolean): Seq[Sink] =
    sinks.filterNot(_.name == source).map(s => s.copy(inverted = s.inverted ^ inverted))

  private def addPrefix(name: String, t: Tree): Tree = {
    val leaves = t.leaves.map(s => s.copy(name = name + "." + s.name))
    val internal = t.internal.map(s => s.copy(name = name + "." + s.name))
    Tree(name + "." + t.source, leaves, internal=internal)
  }

  private def makeAnnos(iGraph: InstanceKeyGraph, merged: ModuleInfo): AnnotationSeq = {
    val top = CircuitTarget(iGraph.top.module).module(iGraph.top.module)

    // analyze trees and annotate sources
    val sourceAnnos = merged.trees.flatMap { t =>
      val info = analyzeTree(t)
      assert(!t.source.contains('.'), s"TODO: deal with ext module sources")
      val target = top.ref(t.source)

      if(info.clockSinks > 0) {
        assert(!(info.resetSinks > 0), s"Tree starting at ${t.source} is used both as a reset and a clock!")
        Some(ClockSourceAnnotation(target, info.clockSinks))
      } else if(info.resetSinks > 0) {
        Some(ResetSourceAnnotation(target, info.resetSinks))
      } else { None }
    }


    println("Trees:")
    merged.trees.foreach { t =>
      val info = analyzeTree(t)
      println(t.source)
      println(info)
    }

    sourceAnnos
  }

}

private object ModuleTreeScanner {
  private case class Con(lhs: String, rhs: String, inverted: Boolean, info: ir.Info)

  def scan(m: ir.DefModule): ModuleInfo = m match {
    case e: ir.ExtModule =>
      val outPorts = e.ports.filter(_.direction == ir.Output).filter(p => couldBeResetOrClock(p.tpe))
      val outputs = outPorts.map(p => Tree(p.name, List(Sink(p.name, false, List(PortSink(p))))))
      ModuleInfo(outputs)
    case mod: ir.Module =>
      val scan = new ModuleTreeScanner()
      scan.onModule(mod)
      analyzeResults(scan)
  }

  private def analyzeResults(m: ModuleTreeScanner): ModuleInfo = {
    // our analysis goes backwards, from output, clock or reset use to the source
    val cons = m.connections.map(c => c.lhs -> c).toMap
    val isInput = m.inputs.toSet

    // determine the source of all sinks and merge them together by source
    val sourceToSink = m.sinks.toSeq.map { case (name, infos) =>
      val (src, inverted) = findSource(cons, name)
      src -> Sink(name, inverted, infos)
    }
    val trees = sourceToSink.groupBy(_._1).map { case (source, sinks) =>
      val (leaves, internal) = sinks.map(_._2).partition(s => isInput(s.name))
      Tree(source, leaves, internal)
    }

    // filter out any trees that do not originate at an input
    // TODO: make sure that these trees to not connect to a clock or reset
    val inputTrees = trees.toSeq.filter(t => isInput(t.source))

    ModuleInfo(inputTrees)
  }

  private def findSource(cons: Map[String, Con], name: String): (String, Boolean) = cons.get(name) match {
    case Some(value) =>
      val (name, inv) = findSource(cons, value.rhs)
      (name, inv ^ value.inverted)
    case None => (name, false)
  }

  sealed trait SinkInfo { def info: ir.Info ; def isReset: Boolean = false ; def isClock: Boolean = false ; def isPort: Boolean = false}
  case class MemClockSink(m: ir.DefMemory, port: String) extends SinkInfo {
    override def isClock = true
    override def info = m.info
  }
  case class RegClockSink(r: ir.DefRegister) extends SinkInfo {
    override def isClock = true
    override def info = r.info
  }
  case class StmtClockSink(s: ir.Statement with ir.HasInfo) extends SinkInfo {
    override def isClock = true
    override def info = s.info
  }
  case class RegResetSink(r: ir.DefRegister) extends SinkInfo {
    override def isReset = true
    override def info = r.info
  }
  case class RegNextSink(r: ir.DefRegister) extends SinkInfo { override def info = r.info }
  case class PortSink(p: ir.Port) extends SinkInfo { override def info = p.info ; override def isPort = true}
  case class InstSink(i: ir.DefInstance, port: String) extends SinkInfo { override def info = i.info ; override def isPort = true}
  case class Sink(name: String, inverted: Boolean, infos: Seq[SinkInfo])
  case class Tree(source: String, leaves: Seq[Sink], internal: Seq[Sink] = List())
  case class ModuleInfo(trees: Seq[Tree])

  case class TreeInfo(resetSinks: Int, clockSinks: Int, portSinks: Int)
  def analyzeTree(tree: Tree): TreeInfo = {
    var resetSinks = 0
    var clockSinks = 0
    var portSinks = 0
    (tree.leaves ++ tree.internal).foreach { s =>
      s.infos.foreach { i =>
        if(i.isReset) resetSinks += 1
        if(i.isClock) clockSinks += 1
        if(i.isPort) portSinks += 1
      }
    }
    TreeInfo(resetSinks, clockSinks, portSinks)
  }

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
  private val sinks = mutable.HashMap[String, List[SinkInfo]]()
  private val inputs = mutable.ArrayBuffer[String]()
  private val regs = mutable.HashMap[String, ir.DefRegister]()
  private val mems = mutable.HashMap[String, ir.DefMemory]()
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

  private def addSinkInfo(name: String, i: SinkInfo): Unit = {
    sinks(name) = i +: sinks.getOrElse(name, List())
  }

  /** called for module outputs and submodule inputs */
  private def addOutput(ref: ir.RefLikeExpression, info: SinkInfo): Unit = {
    if(!couldBeResetOrClock(ref.tpe)) return
    addSinkInfo(ref.serialize, info)
  }

  private def onPort(p: ir.Port): Unit = p.direction match {
    case ir.Input => addInput(ir.Reference(p))
    case ir.Output => addOutput(ir.Reference(p), PortSink(p))
  }

  private def onInstance(i: ir.DefInstance): Unit = {
    val ports = i.tpe.asInstanceOf[ir.BundleType].fields
    val ref = ir.Reference(i)
    // for fields, Default means Output, Flip means Input
    ports.foreach {
      // we treat the outputs of the submodule as inputs to our module
      case ir.Field(name, ir.Default, tpe) => addInput(ir.SubField(ref, name, tpe))
      case ir.Field(name, ir.Flip, tpe) => addOutput(ir.SubField(ref, name, tpe), InstSink(i, name))
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
      case RegKind =>
        addSinkInfo(loc.serialize, RegNextSink(regs(loc.serialize)))
      case PortKind => onConnectSignal(loc.serialize, c.expr, c.info)
      case InstanceKind => onConnectSignal(loc.serialize, c.expr, c.info)
      case MemKind if loc.serialize.endsWith(".clk") =>
        loc match {
          case ir.SubField(ir.SubField(ir.Reference(name, _, _, _), port, _, _), "clk", _, _) =>
            useClock(c.expr, MemClockSink(mems(name), port))
        }
      case WireKind => onConnectSignal(loc.serialize, c.expr, c.info)
      case _ => case other => throw new RuntimeException(s"Unexpected connect of kind: ${other} (${c.serialize})")
    }
  }

  private def onStmt(s: ir.Statement): Unit = s match {
    case i : ir.DefInstance => onInstance(i)
    case r: ir.DefRegister =>
      if(couldBeResetOrClock(r.tpe)) { regs(r.name) = r }
      useClock(r.clock, RegClockSink(r))
      useReset(r.reset, r)
    case ir.DefNode(info, name, value) =>
      // we ignore any connects that cannot involve resets or clocks because of the type
      if(couldBeResetOrClock(value.tpe)) { onConnectSignal(name, value, info) }
    case c @ ir.Connect(_, lhs, _) =>
      // we ignore any connects that cannot involve resets or clocks because of the type
      if(couldBeResetOrClock(lhs.tpe)) { onConnect(c) }
    case ir.Block(stmts) => stmts.foreach(onStmt)
    case p : ir.Print => useClock(p.clk, StmtClockSink(p))
    case s : ir.Stop => useClock(s.clk, StmtClockSink(s))
    case v : ir.Verification => useClock(v.clk, StmtClockSink(v))
    case _ : ir.DefWire => // nothing to do
    case m: ir.DefMemory => mems(m.name) = m
    case _ : ir.IsInvalid =>
    case ir.EmptyStmt =>
    case other => throw new RuntimeException(s"Unexpected statement type: ${other.serialize}")
  }

  /** called when a clock is used for a register or memory */
  private def useClock(e: ir.Expression, info: SinkInfo): Unit = {
    analyzeClockOrReset(e) match {
      case Some((name, false)) => addSinkInfo(name, info)
      case Some((_, true)) => throw new NotImplementedError("TODO: deal with inversions")
      case None =>
    }
  }

  /** called when a reset is used for a register */
  private def useReset(e: ir.Expression, r: ir.DefRegister): Unit = {
    analyzeClockOrReset(e) match {
      case Some((name, false)) => addSinkInfo(name, RegResetSink(r))
      case Some((_, true)) => throw new NotImplementedError("TODO: deal with inversions")
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
