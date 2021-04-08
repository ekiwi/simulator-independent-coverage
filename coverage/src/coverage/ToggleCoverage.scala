// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chiseltest.coverage.{CoverageInfo, ModuleInstancesPass}
import coverage.midas.Builder
import coverage.passes.{AliasAnalysis, KeepClockAndResetPass}
import firrtl.annotations.{Annotation, CircuitTarget, MakePresetRegAnnotation, ModuleTarget, NoTargetAnnotation, PresetRegAnnotation, ReferenceTarget, SingleTargetAnnotation}
import firrtl._
import firrtl.analyses.InstanceKeyGraph
import firrtl.options.Dependency
import firrtl.stage.{Forms, RunFirrtlTransformAnnotation}
import firrtl.stage.TransformManager.TransformDependency
import firrtl.transforms.PropagatePresetAnnotations

import scala.collection.mutable

object ToggleCoverage {
  def annotations: AnnotationSeq = Seq(
    RunFirrtlTransformAnnotation(Dependency(ToggleCoveragePass)),
    RunFirrtlTransformAnnotation(Dependency(ModuleInstancesPass))
  )
}

case class ToggleCoverageOptions(
  instrumentPorts: Boolean = true,
  instrumentRegisters: Boolean = true,
  instrumentMemories: Boolean = true,
  instrumentSignals: Boolean = true,
  maxWidth: Int = 200,
  resetAware: Boolean = false, // reset awareness ensures that toggles during reset are ignored
) extends NoTargetAnnotation

object AllEmitters {
  def apply(): Seq[TransformDependency] = Seq(
    Dependency[VerilogEmitter],
    Dependency[SystemVerilogEmitter],
    Dependency[MinimumVerilogEmitter]
  )
}

case class ToggleCoverageAnnotation(target: ReferenceTarget, signals: List[ReferenceTarget], bit: Int)
  extends SingleTargetAnnotation[ReferenceTarget]
    with CoverageInfo {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}

object ToggleCoveragePass extends Transform with DependencyAPIMigration {
  val Prefix = "t"

  // we want to run after optimization in order to minimize the number of signals that are left over to instrument
  override def prerequisites: Seq[TransformDependency] = Forms.LowFormOptimized ++ Seq(Dependency(KeepClockAndResetPass))
  // we add our own registers with presets
  override def optionalPrerequisites = Seq(Dependency[PropagatePresetAnnotations])
  // we want to run before the actual Verilog is emitted
  override def optionalPrerequisiteOf = AllEmitters()
  override def invalidates(a: Transform): Boolean = false

  override protected def execute(state: CircuitState): CircuitState = {
    // collect options and modules to ignore
    val opts = state.annotations.collect { case a: ToggleCoverageOptions => a }
    require(opts.size < 2, s"Multiple options: $opts")
    val opt = opts.headOption.getOrElse(ToggleCoverageOptions())
    val ignoreMods = Coverage.collectModulesToIgnore(state)

    // collect global alias information
    val iGraph = InstanceKeyGraph(state.circuit)
    val aliases = AliasAnalysis.findAliases(state.circuit, iGraph)

    // we first instrument each module in isolation
    val newAnnos = new Annos()
    val c = CircuitTarget(state.circuit.main)
    val ms = state.circuit.modules.map(m => onModule(m, c, newAnnos, ignoreMods, opt, aliases(m.name)))
    val circuit = state.circuit.copy(modules = ms.map(_._1))

    // as a second step we add information to our annotations for signals that cross module boundaries
    val portAliases = ms.map { case (m,a,_) => m.name -> a }.toMap
    resolvePortAliases(c, newAnnos, portAliases, iGraph)

    val annos = newAnnos ++ ms.flatMap(_._3).toList ++ state.annotations
    CircuitState(circuit, annos)
  }

  private def resolvePortAliases(c: CircuitTarget, annos: Annos, iAliases: Map[String, PortAliases], iGraph: InstanceKeyGraph): Unit = {
    val signalToAnnoIds: Map[String, Seq[Int]] =
      annos.zipWithIndex.flatMap{ case (a, i) => a.signals.map(s => s.toString() -> i) }.groupBy(_._1).mapValues(_.map(_._2))

    // make alias table mutable, so that we can propagate aliase up the hierarchy
    val aliases = mutable.HashMap[String, PortAliases]() ++ iAliases

    // go through modules top to bottom
    val moduleOrderBottomUp = iGraph.moduleOrder.reverseIterator
    val childInstances = iGraph.getChildInstances.toMap

    moduleOrderBottomUp.foreach { m =>
      val mTarget = c.module(m.name)
      val localSignalToPort = aliases(m.name).flatMap{ case (port, signals) => signals.map(_.toString() -> port) }.toMap
      // look at all instances in this module and check to see if any of them have declared part aliases
      childInstances(m.name).foreach { child =>
        val as = aliases.getOrElse(child.module, List())
        as.foreach { case (port, signals) =>
          val portKey = mTarget.ref(child.name).field(port).toString()
          signalToAnnoIds.get(portKey) match {
            case Some(annoIds) =>
              annoIds.foreach { aId =>
                val old = annos(aId)
                annos(aId) = old.copy(signals = old.signals ++ signals)
              }
            case None =>
              // if there are no annotations for this signal, we know that the signal is actually sampled
              // even further up the hierarchy
              val localPort = localSignalToPort(portKey)
              val prev = aliases.getOrElse(m.name, List())
              aliases(m.name) =  (localPort, signals) +: prev
          }
        }
      }
    }
  }

  private type Annos = mutable.ArrayBuffer[ToggleCoverageAnnotation]
  private case class ModuleCtx(
    annos:     Annos,
    namespace: Namespace,
    m:         ModuleTarget,
    en:        ir.Reference,
    clk:       ir.Expression)

  // map from port name to signals associated with that port
  private type PortAliases = Seq[(String, Seq[ReferenceTarget])]

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: Annos, ignore: Set[String],
    opt: ToggleCoverageOptions, aliases: AliasAnalysis.Aliases): (ir.DefModule, PortAliases, Option[Annotation]) =
    m match {
      case mod: ir.Module if !ignore(mod.name) =>
        // first we check to see which signals we want to cover
        val isTop = mod.name == c.name
        val allSignals = collectSignals(mod)
        val signals = filterSignals(allSignals, opt)

        if(signals.isEmpty) { (mod, List(), None) } else {
          val namespace = Namespace(mod)
          namespace.newName(Prefix)
          // create a module wide signal that indicates whether the toggle coverage is active
          val en = ir.Reference(namespace.newName("enToggle"), Utils.BoolType, RegKind, UnknownFlow)
          val ctx = ModuleCtx(annos, namespace, c.module(mod.name), en, Builder.findClock(mod))
          val (coverStmts, portAliases) = coverSignals(signals, aliases, ctx, isTop)
          if(coverStmts.nonEmpty) {
            // create actual hardware to generate enable signal
            val (enStmt, enAnno) = buildCoverEnable(ctx, opt.resetAware)
            val body = ir.Block(mod.body, enStmt, ir.Block(coverStmts))
            (mod.copy(body = body), portAliases, Some(enAnno))
          } else { (mod, portAliases, None) }
        }
      case other => (other, List(), None)
    }

  private type Signals = Seq[Signal]
  case class Signal(ref: ir.RefLikeExpression, info: ir.Info) {
    def name: String = ref.serialize
  }

  private def filterSignals(signals: Signals, opt: ToggleCoverageOptions): Signals = signals.filter { sig =>
    val tpeCheck = sig.ref.tpe match {
      case ir.UIntType(ir.IntWidth(w)) => w <= opt.maxWidth
      case ir.SIntType(ir.IntWidth(w)) => w <= opt.maxWidth
      // we don't want to instrument clocks or asynchronous signals
      case _ => false
    }
    val kindCheck = getKind(sig.ref) match {
      case MemKind => opt.instrumentMemories
      case RegKind => opt.instrumentRegisters
      case WireKind => opt.instrumentSignals
      case NodeKind => opt.instrumentSignals
      case PortKind => opt.instrumentPorts
      case InstanceKind => opt.instrumentPorts
      case other => throw new NotImplementedError(s"Unexpected signal kind: $other")
    }
    tpeCheck && kindCheck
  }
  private def getKind(ref: ir.RefLikeExpression): firrtl.Kind = ref match {
    case ir.Reference(_, _, kind, _) => kind
    case ir.SubField(expr, _, _, _) => getKind(expr.asInstanceOf[ir.RefLikeExpression])
    case ir.SubIndex(expr, _, _, _) => getKind(expr.asInstanceOf[ir.RefLikeExpression])
    case ir.SubAccess(expr, _, _, _) => getKind(expr.asInstanceOf[ir.RefLikeExpression])
  }

  private def collectSignals(m: ir.Module): Signals = {
    m.ports.map(p => Signal(ir.Reference(p), p.info)) ++ collectSignals(m.body)
  }
  private def collectSignals(s: ir.Statement): Signals = s match {
    case n @ ir.DefNode(_, name, expr) if !isTemp(name) => List(Signal(ir.Reference(n), n.info))
    case w @ ir.DefWire(_, name, _) if !isTemp(name) => List(Signal(ir.Reference(w), w.info))
    case r : ir.DefRegister => List(Signal(ir.Reference(r), r.info))
    case m : ir.DefMemory => memRefs(m)
    case i: ir.DefInstance => instRefs(i)
    case ir.Block(stmts) => stmts.flatMap(collectSignals)
    case ir.Conditionally(_, _, conseq, alt) => List(conseq, alt).flatMap(collectSignals)
    case _: ir.DefInstance => List() // we ignore instances since their ports will be covered inside of them
    case _ => List()
  }
  private def isTemp(name: String): Boolean = name.startsWith("_")
  private def instRefs(i: ir.DefInstance): Signals = {
    val iRef = ir.Reference(i)
    getFields(iRef.tpe).map { case ir.Field(name, flip, tpe) =>
      val portRef = ir.SubField(iRef, name, tpe, Utils.to_flow(Utils.to_dir(flip)))
      Signal(portRef, i.info)
    }
  }
  private def memRefs(m: ir.DefMemory): Signals = {
    val memRef = ir.Reference(m)
    getFields(memRef.tpe).flatMap { case ir.Field(name, flip, tpe) =>
      val portRef = ir.SubField(memRef, name, tpe, Utils.to_flow(Utils.to_dir(flip)))
      getFields(tpe).map { case ir.Field(name, flip, tpe) =>
        val fieldRef = ir.SubField(portRef, name, tpe, Utils.to_flow(Utils.to_dir(flip)))
        Signal(fieldRef, m.info)
      }
    }
  }
  private def getFields(t: ir.Type): Seq[ir.Field] = t.asInstanceOf[ir.BundleType].fields

  private def buildCoverEnable(ctx: ModuleCtx, resetAware: Boolean): (ir.Statement, Annotation) = {
    assert(!resetAware, "TODO: reset aware")

    // we add a simple register in order to disable toggle coverage in the first cycle
    val ref = ctx.en
    val reg = ir.DefRegister(ir.NoInfo, ref.name, Utils.BoolType, ctx.clk, Utils.False(), Utils.False())
    val next = ir.Connect(ir.NoInfo, ref, Utils.True())
    val presetAnno = MakePresetRegAnnotation(ctx.m.ref(reg.name))

    (ir.Block(reg, next), presetAnno)
  }

  private def coverSignals(signals: Signals, aliases: AliasAnalysis.Aliases, ctx: ModuleCtx, isTop: Boolean):
  (Seq[ir.Statement], PortAliases) = {
    // first we group the signals using the alias information
    val signalsByName = signals.map(s => s.name -> s).toMap
    val aliased = mutable.HashSet[String]()
    val signalGroups: Seq[Signals] = aliases.flatMap { g =>
      val signalsInGroup = g.filter(n => signalsByName.contains(n))
      if(signalsInGroup.size > 1) {
        signalsInGroup.foreach(aliased.add)
        val signals: Signals = signalsInGroup.map(signalsByName(_))
        Some(signals)
      } else { None }
    }
    val nonAliasedSignals = signals.filterNot(s => aliased(s.name)).map(s => List(s))

    val groups = signalGroups ++ nonAliasedSignals
    val portAliases = mutable.ListBuffer[(String, Seq[ReferenceTarget])]()
    val stmts = groups.flatMap { g =>
      // see if this group includes a port
      val ports = g.filter(s => getKind(s.ref) == PortKind)
      val hasPort = ports.nonEmpty

      // if we cover ports, then we might ignore this group as it will get covered in the module above ours
      val skipPort = hasPort && !isTop
      if(!skipPort) {
        // cover one of the signals in the group
        val (stmt, names) = addCover(g.head, ctx)
        // add annotations for all
        addAnno(g, names, ctx)
        Some(stmt)
      } else {
        // We remember the signals that alias with the port so that they can be added to the annotation
        // in a module further up the hierarchy.
        val signalTargets = g.map(s => refToTarget(ctx.m, s.ref)).toList
        portAliases.prepend(ports.head.name-> signalTargets)
        None
      }
    }

    (stmts, portAliases.toList)
  }

  private def addAnno(signals: Signals, names: Seq[String], ctx: ModuleCtx): Unit = {
    names.zipWithIndex.foreach { case (coverName, bit) =>
      val sigs = signals.map(s => refToTarget(ctx.m, s.ref)).toList
      val anno = ToggleCoverageAnnotation(ctx.m.ref(coverName), sigs, bit)
      ctx.annos.prepend(anno)
    }
  }

  private def refToTarget(m: ModuleTarget, ref: ir.RefLikeExpression): ReferenceTarget = ref match {
    case ir.Reference(name, _, _, _) => m.ref(name)
    case ir.SubField(ir.Reference(name, _, _, _), field, _, _) => m.ref(name).field(field)
    case ir.SubField(ir.SubField(ir.Reference(name, _, _, _), field1, _, _), field2, _, _) => m.ref(name).field(field1).field(field2)
    case other => throw new NotImplementedError(s"Unsupported reference: $other")
  }

  private def addCover(signal: Signal, ctx: ModuleCtx): (ir.Statement, Seq[String]) = {
    val (prevStmt, prevRef) = buildPrevReg(signal, ctx)

    // TODO: do we want to distinguish the type of toggle?
    val width = Builder.getWidth(signal.ref.tpe).toInt
    val didToggleName = makeName(signal.ref, ctx.namespace, "_t")
    val didToggleNode = ir.DefNode(signal.info, didToggleName,
      ir.DoPrim(firrtl.PrimOps.Xor, List(signal.ref, prevRef), List(), ir.UIntType(ir.IntWidth(width))))
    val didToggle = ir.Reference(didToggleNode)

    val covers = (0 until width).map { ii =>
      val name = ctx.namespace.newName(Prefix)
      val pred = ir.DoPrim(firrtl.PrimOps.Bits, List(didToggle), List(ii, ii), Utils.BoolType)
      val cover = ir.Verification(ir.Formal.Cover, signal.info, ctx.clk, pred, ctx.en, ir.StringLit(""), name)
      (name, cover)
    }

    val stmts = prevStmt ++ Seq(didToggleNode) ++ covers.map(_._2)
    (ir.Block(stmts), covers.map(_._1))
  }

  private def buildPrevReg(signal: Signal, ctx: ModuleCtx): (Seq[ir.Statement], ir.Reference) = {
    // build a register to hold the previous value
    val prevName = makeName(signal.ref, ctx.namespace, "_p")
    val prevRef = ir.Reference(prevName, signal.ref.tpe, RegKind, UnknownFlow)
    val prevReg = ir.DefRegister(signal.info, prevName, signal.ref.tpe,
      clock=ctx.clk, reset = Utils.False(), init = prevRef)
    val next = ir.Connect(signal.info, prevRef, signal.ref)
    (List(prevReg, next), prevRef)
  }

  private def makeName(ref: ir.RefLikeExpression, namespace: Namespace, suffix: String): String = {
    namespace.newName(ref.serialize.replace('.', '_') + suffix)
  }
}