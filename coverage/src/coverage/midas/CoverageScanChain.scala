// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.midas

import coverage.{Coverage, LineCoveragePass}
import firrtl._
import firrtl.analyses.InstanceKeyGraph.InstanceKey
import firrtl.annotations._
import firrtl.ir.DefNode
import firrtl.options.Dependency
import firrtl.passes.ResolveFlows
import firrtl.passes.wiring.WiringTransform
import firrtl.stage.Forms
import firrtl.stage.TransformManager.TransformDependency
import firrtl.transforms.{EnsureNamedStatements, PropagatePresetAnnotations}
import midas.passes.fame.{FAMEChannelConnectionAnnotation, FAMEChannelInfo, PipeChannel}
import midas.widgets.SerializableBridgeAnnotation

import scala.collection.mutable

case class CoverageScanChainOptions(counterWidth: Int = 32, addBridge: Boolean = false) extends NoTargetAnnotation {
  require(counterWidth > 0)
}

/** @param target the top-level module
  * @param prefix prefix for the scan chain ports
  * @param width  width of the scan chain data ports
  * @param covers cover points in the scan chain from front (last to be scanned out) to back (first to be scanned out)
  */
case class CoverageScanChainInfo(target: ModuleTarget, prefix: String, width: Int, covers: List[String])
    extends SingleTargetAnnotation[ModuleTarget] {
  override def duplicate(n: ModuleTarget) = copy(target = n)
}

case class CoverageBridgeKey(counterWidth: Int, covers: List[String])

/** Turns cover points into saturating hardware counters and builds a scan chain.
  * Should eventually be moved to midas/firesim.
  */
object CoverageScanChainPass extends Transform with DependencyAPIMigration {

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm ++ Seq(Dependency(EnsureNamedStatements))
  // every automatic coverage pass needs to run before this!
  override def optionalPrerequisites = (Seq(Dependency[PropagatePresetAnnotations]) ++
    // we add our own registers with presets
    Coverage.AllPasses ++
    // we need to run after the wiring transform
    Seq(Dependency[WiringTransform])
    )
  override def invalidates(a: Transform): Boolean = a match {
    case ResolveFlows => true // ir.Reference sets the flow to unknown
    case _            => false
  }

  override protected def execute(state: CircuitState): CircuitState = {
    // determine the counter width
    val opts = state.annotations.collect { case a: CoverageScanChainOptions => a }
    if(opts.isEmpty) {
      logger.info("[CoverageScanChainPass] no options annotation found, skipping...")
      return state
    }
    require(opts.size < 2, s"Multiple options: $opts")
    val opt = opts.head

    // we first calculate an appropriate prefix for the scan chain IO
    val prefixes = state.circuit.modules.flatMap(m => findPrefix(m).map(p => m.name -> p)).toMap

    // now we can create the chains and hook them up
    val c = CircuitTarget(state.circuit.main)
    val modulesAndInfoAndAnnos = state.circuit.modules.map(insertChain(c, _, prefixes, opt))

    // collect/generate all annotations
    val infos = modulesAndInfoAndAnnos.flatMap(_._2)
    val annos = modulesAndInfoAndAnnos.flatMap(_._3)
    val main = c.module(c.name)
    val anno = createChainAnnotation(main, infos, opt)


    // we generate an extmodule for the bridge
    val (bridgeMod, bridgeAnnos) = if(opt.addBridge) {
      genBridgeModule(c, opt.counterWidth, anno.covers)
    } else {
      (None, List())
    }

    val modules = bridgeMod ++: modulesAndInfoAndAnnos.map(_._1)
    val circuit = state.circuit.copy(modules = modules)

    CircuitState(circuit, anno +: bridgeAnnos ++: annos ++: state.annotations)
  }

  private def createChainAnnotation(
    main:  ModuleTarget,
    infos: Seq[ModuleInfo],
    opt:   CoverageScanChainOptions
  ): CoverageScanChainInfo = {
    val ii = infos.map(i => i.name -> i).toMap

    val mainInfo = ii(main.module)
    val covers = getCovers(main.module, main.module + ".", ii)

    CoverageScanChainInfo(main, mainInfo.prefix, opt.counterWidth, covers)
  }

  private def getCovers(name: String, prefix: String, ii: Map[String, ModuleInfo]): List[String] = ii.get(name) match {
    case None => List()
    case Some(info) =>
      info.covers.map(prefix + _) ++ info.instances.flatMap(i => getCovers(i.module, prefix + i.name + ".", ii))
  }

  private val BridgeModuleName = "CoverageBridge"
  private val BridgeEnPort = "cover_en"
  private val BridgeOutPort = "cover_out"
  private val BridgeWidgetClass = "coverage.midas.CoverageBridgeModule"

  private def genBridgeModule(c: CircuitTarget, counterWidth: Int, covers: List[String]): (Option[ir.DefModule], List[Annotation]) = {
    val moduleName = "CoverageBridge"
    val m = c.module(moduleName)
    val key = CoverageBridgeKey(counterWidth, covers)
    val bridgeAnno = SerializableBridgeAnnotation(m, List(BridgeEnPort, BridgeOutPort), BridgeWidgetClass, Some(key))
    val pipeChannel = PipeChannel(1)
    val enChannel = FAMEChannelConnectionAnnotation(BridgeEnPort, pipeChannel, Some(m.ref("clock")),
      sinks= Some(List(m.ref(BridgeEnPort))), sources =None)
    val outChannel = FAMEChannelConnectionAnnotation(BridgeOutPort, pipeChannel, Some(m.ref("clock")),
      sinks=None, sources = Some(List(m.ref(BridgeOutPort))))
    val ports = List(
      ir.Port(ir.NoInfo, "clock", ir.Input, ir.ClockType),
      ir.Port(ir.NoInfo, BridgeEnPort, ir.Output, Utils.BoolType),
      ir.Port(ir.NoInfo, BridgeOutPort, ir.Input, ir.UIntType(ir.IntWidth(counterWidth)))
    )
    val module = ir.ExtModule(ir.NoInfo, name = moduleName, ports=ports, defname=moduleName, params = List())
    (Some(module), List(bridgeAnno, enChannel, outChannel))
  }

  private def genBridgeInstance(stmts: mutable.ArrayBuffer[ir.Statement], namespace: Namespace, counterWidth: Int,
    enRef: ir.Reference, inRef: ir.Reference): ir.RefLikeExpression = {
    val counterTpe = ir.UIntType(ir.IntWidth(counterWidth))
    val tpe = ir.BundleType(List(
      ir.Field("clock", Utils.to_flip(ir.Input), ir.ClockType),
      ir.Field(BridgeEnPort, Utils.to_flip(ir.Output), Utils.BoolType),
      ir.Field(BridgeOutPort, Utils.to_flip(ir.Input), counterTpe)
    ))
    val instName = namespace.newName(BridgeModuleName)
    val inst = ir.DefInstance(ir.NoInfo, instName, BridgeModuleName, tpe)
    val ref = ir.Reference(inst)
    // instantiate
    stmts.append(inst)
    // TODO: this is a hack!
    val clockInput = ir.Reference("harnessClock", ir.ClockType, NodeKind)
    // connect clock and enable signal
    stmts.append(ir.Connect(ir.NoInfo, ir.SubField(ref, "clock", ir.ClockType), clockInput))
    stmts.append(ir.DefNode(ir.NoInfo, enRef.name, ir.SubField(ref, BridgeEnPort, Utils.BoolType)))
    stmts.append(ir.DefNode(ir.NoInfo, inRef.name, ir.UIntLiteral(0, counterTpe.width)))
    // return out ref
    ir.SubField(ref, BridgeOutPort, counterTpe)
  }

  private case class ModuleInfo(name: String, prefix: String, covers: List[String], instances: List[InstanceKey])
  private def insertChain(
    c: CircuitTarget,
    m:        ir.DefModule,
    prefixes: Map[String, String],
    opt:    CoverageScanChainOptions,
  ): (ir.DefModule, Option[ModuleInfo], AnnotationSeq) = m match {
    case e: ir.ExtModule => (e, None, List())
    case mod: ir.Module =>
      val isTop = mod.name == c.name
      val hasBridge = isTop && opt.addBridge
      val ctx = ModuleCtx(new Covers(), new Instances(), prefixes, opt.counterWidth)
      // we first find and remove all cover statements and change the port definition of submodules
      val removedCovers = findCoversAndModifyInstancePorts(mod.body, ctx)
      val scanChainPorts = getScanChainPorts(prefixes(mod.name), opt.counterWidth)
      val portRefs = scanChainPorts.map(ir.Reference(_))
      val refs = if(hasBridge) { portRefs.map(_.copy(kind=NodeKind)) } else { portRefs }
      refs match {
        case Seq(enPort, inPort, outPort) =>
          val stmts = mutable.ArrayBuffer[ir.Statement]()
          val annos = mutable.ArrayBuffer[Annotation]()
          val counterCtx = CounterCtx(c.module(mod.name), enPort, stmts, annos)

          // if we are the toplevel module, we instantiate the bridge
          val bridgeOutRef = if(hasBridge) {
            genBridgeInstance(stmts, Namespace(mod), opt.counterWidth, enPort, inPort)
          } else { ir.Reference("") }

          // now we generate counters for all cover points we removed
          val counterOut =
            ctx.covers.foldLeft[ir.Expression](inPort)((prev, cover) => generateCounter(counterCtx, cover, prev))

          // we add the sub module to the end of the chain
          val instanceCtx = InstanceCtx(prefixes, enPort, stmts)
          val instanceOut = ctx.instances.foldLeft[ir.Expression](counterOut)((prev, inst) =>
            connectInstance(instanceCtx, inst, prev)
          )

          // finally we connect the outPort to the end of the chain
          if(hasBridge) {
            stmts.append(ir.Connect(ir.NoInfo, bridgeOutRef, instanceOut))
          } else {
            stmts.append(ir.Connect(ir.NoInfo, outPort, instanceOut))
          }

          // we then add the counters and connection statements to the end of the module
          val body = ir.Block(removedCovers, ir.Block(stmts.toSeq))
          // add ports
          val ports = mod.ports ++ (if(hasBridge) List() else scanChainPorts)

          // build the module info
          val covers = ctx.covers.map(_.name).toList
          val instances = ctx.instances.map(i => InstanceKey(i.name, i.module)).toList
          val prefix = prefixes(mod.name)
          val info = ModuleInfo(mod.name, prefix, covers, instances)

          (mod.copy(ports = ports, body = body), Some(info), annos.toSeq)
      }
  }

  private case class CounterCtx(m: ModuleTarget, en: ir.Expression, stmts: mutable.ArrayBuffer[ir.Statement], annos: mutable.ArrayBuffer[Annotation])

  private def generateCounter(ctx: CounterCtx, cover: ir.Verification, prev: ir.Expression): ir.Expression = {
    assert(cover.op == ir.Formal.Cover)
    // we replace the cover statement with a register of the same name (the name is now available!)
    val init = Utils.getGroundZero(prev.tpe.asInstanceOf[ir.UIntType])
    val regRef = ir.Reference(cover.name, prev.tpe, RegKind, UnknownFlow)

    // we increment the counter when condition is true
    val covered = Utils.and(cover.en, cover.pred)
    val inc = Builder.add(regRef, covered)
    // we need to check for overflow
    val willOverflow = Builder.reduceAnd(regRef)
    // we increment the counter when it is not being reset and the chain is not enabled
    val update = Utils.mux(ctx.en, prev, Utils.mux(willOverflow, regRef, inc))

    // counter register
    val reg = ir.DefRegister(cover.info, cover.name, prev.tpe, cover.clk, Utils.False(), init)
    ctx.stmts.append(reg)
    val con = ir.Connect(cover.info, ir.Reference(reg), update)
    ctx.stmts.append(con)
    val presetAnno = MakePresetRegAnnotation(ctx.m.ref(reg.name))
    ctx.annos.append(presetAnno)

    // the register might be shifted into the next reg in the chain
    regRef
  }

  private case class InstanceCtx(
    prefixes: Map[String, String],
    en:       ir.Expression,
    stmts:    mutable.ArrayBuffer[ir.Statement])

  private def connectInstance(ctx: InstanceCtx, inst: ir.DefInstance, prev: ir.Expression): ir.Expression = {
    assert(ctx.prefixes.contains(inst.module))
    val width = prev.tpe.asInstanceOf[ir.UIntType].width.asInstanceOf[ir.IntWidth].width
    val portRefs = getScanChainPorts(ctx.prefixes(inst.module), width).map { p =>
      ir.SubField(ir.Reference(inst), p.name, p.tpe, Utils.swap(Utils.to_flow(p.direction)))
    }
    portRefs match {
      case Seq(enPort, inPort, outPort) =>
        // connect the enable to the global enable
        ctx.stmts.append(ir.Connect(inst.info, enPort, ctx.en))
        // connect the in Port to the previous value
        ctx.stmts.append(ir.Connect(inst.info, inPort, prev))
        // return the out Port
        outPort
    }
  }

  private type Covers = mutable.ArrayBuffer[ir.Verification]
  private type Instances = mutable.ArrayBuffer[ir.DefInstance]
  private case class ModuleCtx(covers: Covers, instances: Instances, prefixes: Map[String, String], width: Int)

  private def findCoversAndModifyInstancePorts(s: ir.Statement, ctx: ModuleCtx): ir.Statement = s match {
    case v: ir.Verification if v.op == ir.Formal.Cover =>
      ctx.covers.append(v)
      ir.EmptyStmt
    case i: ir.DefInstance if ctx.prefixes.contains(i.module) =>
      // add scan chain fields to the bundle type
      val ports = getScanChainPorts(ctx.prefixes(i.module), ctx.width)
      val fields = ports.map(p => ir.Field(p.name, Utils.to_flip(p.direction), p.tpe))
      assert(i.tpe.isInstanceOf[ir.BundleType], "Instances should always have a bundle type!")
      val tpe = ir.BundleType(i.tpe.asInstanceOf[ir.BundleType].fields ++ fields)
      val newInstance = i.copy(tpe = tpe)
      ctx.instances.append(newInstance)
      newInstance
    case other => other.mapStmt(findCoversAndModifyInstancePorts(_, ctx))
  }

  private def findPrefix(m: ir.DefModule): Option[String] = m match {
    case _: ir.ExtModule => None // we ignore ext modules since they cannot contain firrtl cover statements
    case m: ir.Module =>
      val namespace = Namespace(m)
      var prefix = DefaultPrefix
      while (!isFreePrefix(namespace, prefix)) {
        prefix = prefix + "_"
      }
      Some(prefix)
  }

  private def isFreePrefix(namespace: Namespace, prefix: String): Boolean = {
    PortSuffixes.map(prefix + "_" + _).forall(n => !namespace.contains(n))
  }

  private def getScanChainPorts(prefix: String, width: BigInt): Seq[ir.Port] = {
    PortSuffixes.zip(Seq(BigInt(1), width, width)).zip(Seq(true, true, false)).map { case ((suffix, w), isInput) =>
      val dir = if (isInput) ir.Input else ir.Output
      ir.Port(ir.NoInfo, prefix + "_" + suffix, dir, ir.UIntType(ir.IntWidth(w)))
    }
  }

  // Scan Chain Ports (for now we assume a single clock):
  // input ${prefix}_en: UInt<1>
  // input ${prefix}_in: UInt<$countWidth>
  // output ${prefix}_out: UInt<$countWidth>
  private val PortSuffixes = Seq("en", "in", "out")
  private val DefaultPrefix = "cover_chain"

}
