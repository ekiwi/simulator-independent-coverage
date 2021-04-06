// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chiseltest.coverage.ModuleInstancesPass
import coverage.midas.Builder
import coverage.passes.KeepClockAndResetPass
import firrtl.annotations.{Annotation, CircuitTarget, MakePresetRegAnnotation, ModuleTarget, NoTargetAnnotation, PresetRegAnnotation, SingleTargetAnnotation}
import firrtl._
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
  resetAware: Boolean = false, // reset awareness ensures that toggels during reset are ignored
) extends NoTargetAnnotation

object AllEmitters {
  def apply(): Seq[TransformDependency] = Seq(
    Dependency[VerilogEmitter],
    Dependency[SystemVerilogEmitter],
    Dependency[MinimumVerilogEmitter]
  )
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

    // instrument
    val newAnnos = mutable.ListBuffer[Annotation]()
    val c = CircuitTarget(state.circuit.main)
    val circuit = state.circuit.mapModule(onModule(_, c, newAnnos, ignoreMods, opt))
    val annos = newAnnos.toList ++ state.annotations
    CircuitState(circuit, annos)
  }

  private case class ModuleCtx(
    annos:     mutable.ListBuffer[Annotation],
    namespace: Namespace,
    m:         ModuleTarget,
    en:        ir.Expression,
    clk:       ir.Expression)

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: mutable.ListBuffer[Annotation], ignore: Set[String], opt: ToggleCoverageOptions): ir.DefModule =
    m match {
      case mod: ir.Module if !ignore(mod.name) =>
        // first we check to see which signals we want to cover
        val allSignals = collectSignals(mod)
        val signals = filterSignals(allSignals, opt)

        if(signals.isEmpty) { mod } else {
          val namespace = Namespace(mod)
          namespace.newName(Prefix)
          val ctx = ModuleCtx(annos, namespace, c.module(mod.name), Utils.False(), Builder.findClock(mod))
          val (enStmt, en) = buildCoverEnable(ctx, opt.resetAware, Utils.False())
          val ctx2 = ctx.copy(en = en)
          val coverStmts = signals.map(s => addCover(s, ctx2))
          val body = ir.Block(List(mod.body, enStmt) ++ coverStmts)
          mod.copy(body = body)
        }
      case other => other
    }

  private type Signals = Seq[Signal]
  case class Signal(ref: ir.RefLikeExpression, info: ir.Info)

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
      case PortKind => opt.instrumentPorts
      case WireKind => opt.instrumentSignals
      case NodeKind => opt.instrumentSignals
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
    case n @ ir.DefNode(_, name, _) if !isTemp(name) => List(Signal(ir.Reference(n), n.info))
    case w @ ir.DefWire(_, name, _) if !isTemp(name) => List(Signal(ir.Reference(w), w.info))
    case r : ir.DefRegister => List(Signal(ir.Reference(r), r.info))
    case m : ir.DefMemory => memRefs(m)
    case ir.Block(stmts) => stmts.flatMap(collectSignals)
    case ir.Conditionally(_, _, conseq, alt) => List(conseq, alt).flatMap(collectSignals)
    case _: ir.DefInstance => List() // we ignore instances since their ports will be covered inside of them
    case _ => List()
  }
  private def isTemp(name: String): Boolean = name.startsWith("_")
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

  private def buildCoverEnable(ctx: ModuleCtx, resetAware: Boolean, reset: ir.Expression): (ir.Statement, ir.Expression) = {
    assert(!resetAware, "TODO: reset aware")

    // we add a simple register in order to disable toggle coverage in the first cycle
    val name = ctx.namespace.newName("enToggle")
    val reg = ir.DefRegister(ir.NoInfo, name, Utils.BoolType, ctx.clk, reset, Utils.False())
    val ref = ir.Reference(reg)
    val next = ir.Connect(ir.NoInfo, ref, Utils.True())
    val presetAnno = MakePresetRegAnnotation(ctx.m.ref(reg.name))
    ctx.annos.prepend(presetAnno)

    (ir.Block(reg, next), ref)
  }

  private def addCover(signal: Signal, ctx: ModuleCtx): ir.Statement = {
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

    // TODO: create annotation

    val stmts = prevStmt ++ Seq(didToggleNode) ++ covers.map(_._2)
    ir.Block(stmts)
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