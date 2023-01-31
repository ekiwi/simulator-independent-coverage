// Copyright 2021-2023 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package midas.coverage

import coverage.{Builder, Coverage}
import firrtl._
import firrtl.analyses.InstanceKeyGraph.InstanceKey
import firrtl.annotations._
import firrtl.options.Dependency
import firrtl.passes.ResolveFlows
import firrtl.passes.wiring.WiringTransform
import firrtl.stage.Forms
import firrtl.stage.TransformManager.TransformDependency
import firrtl.transforms.{EnsureNamedStatements, PropagatePresetAnnotations}
import midas.passes.fame.{FAMEChannelConnectionAnnotation, PipeChannel}
import midas.widgets.BridgeIOAnnotation

import scala.collection.mutable

case class CoverageScanChainOptions(counterWidth: Int = 32) extends NoTargetAnnotation {
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
    val opts = state.annotations.collect { case a: CoverageScanChainOptions => a }.distinct
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
    val chainAnno = createChainAnnotation(main, infos, opt)
    val bridgeKey = CoverageBridgeKey(opt.counterWidth, chainAnno.covers)
    val bridgeAnnos = createBridgeAnnos(main.name, prefixes(main.name), bridgeKey)

    // extract modules
    val modules = modulesAndInfoAndAnnos.map(_._1)
    val circuit = state.circuit.copy(modules = modules)

    CircuitState(circuit, chainAnno +: annos ++: bridgeAnnos ++: state.annotations)
  }

  private def createBridgeAnnos(mainName: String, mainPrefix: String, key: CoverageBridgeKey): AnnotationSeq = {
    val mainTarget = CircuitTarget(mainName).module(mainName)

    // TODO: this is a hack! We do not actually know what clock to use ...
    val clockRef = mainTarget.ref("harnessClock")
    val pipeChannel = PipeChannel(1)

    // `en` toplevel input
    val enName = mainPrefix + "_en"
    val enChannel = FAMEChannelConnectionAnnotation(
      globalName = enName,
      channelInfo = pipeChannel,
      clock = Some(clockRef),
      sinks = Some(Seq(mainTarget.ref(enName))),
      sources = None
    )
    // `out` toplevel output
    val outName = mainPrefix + "_out"
    val outChannel = FAMEChannelConnectionAnnotation(
      globalName = outName,
      channelInfo = pipeChannel,
      clock = Some(clockRef),
      sinks = None,
      sources = Some(List(mainTarget.ref(outName)))
    )

    // bridge annotation
    val bridgeAnno = BridgeIOAnnotation(
      target = mainTarget.ref(mainPrefix), // this is not a real port!
      widgetClass = BridgeWidgetClass,
      widgetConstructorKey = key,
      channelNames = Seq(enChannel.globalName, outChannel.globalName)
    )

    Seq(enChannel, outChannel, bridgeAnno)
  }

  private def createChainAnnotation(
    main:  ModuleTarget,
    infos: Seq[ModuleInfo],
    opt:   CoverageScanChainOptions
  ): CoverageScanChainInfo = {
    val ii = infos.map(i => i.name -> i).toMap

    val mainInfo = ii(main.module)
    val covers = getCovers(main.module, "", ii)

    CoverageScanChainInfo(main, mainInfo.prefix, opt.counterWidth, covers)
  }

  private def getCovers(name: String, prefix: String, ii: Map[String, ModuleInfo]): List[String] = ii.get(name) match {
    case None => List()
    case Some(info) =>
      info.covers.map(prefix + _) ++ info.instances.flatMap(i => getCovers(i.module, prefix + i.name + ".", ii))
  }

  private val BridgeWidgetClass = "coverage.midas.CoverageBridgeModule"

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
      val ctx = ModuleCtx(new Covers(), new Instances(), prefixes, opt.counterWidth)
      val namespace = Namespace(mod)

      // we first find and remove all cover statements and change the port definition of submodules
      val removedCovers = findCoversAndModifyInstancePorts(mod.body, ctx)
      val scanChainPorts = getScanChainPorts(prefixes(mod.name), opt.counterWidth, isTop)
      val portRefs = scanChainPorts.map(ir.Reference(_))

      // in the toplevel module we do not have a `in` port, but a constant zero node instead
      val (ports, zeroStmt) = if(isTop) {
        val zeroValue = Utils.getGroundZero(ir.UIntType(ir.IntWidth(opt.counterWidth)))
        val zero = ir.DefNode(ir.NoInfo, namespace.newName("scan_chain_in_zero"), zeroValue)
        val refs = Seq(portRefs.head, ir.Reference(zero).copy(flow = SourceFlow), portRefs.last)
        (refs, Some(zero))
      } else { (portRefs, None) }

      // connect the scan chain
      ports match {
        case Seq(enPort, inPort, outPort) =>
          val stmts = mutable.ArrayBuffer[ir.Statement]()
          val annos = mutable.ArrayBuffer[Annotation]()
          val counterCtx = CounterCtx(c.module(mod.name), enPort, stmts, annos, namespace)

          // now we generate counters for all cover points we removed
          val counterOut =
            ctx.covers.foldLeft[ir.Expression](inPort)((prev, cover) => generateCounter(counterCtx, cover, prev))

          // we add the sub module to the end of the chain
          val instanceCtx = InstanceCtx(prefixes, enPort, stmts)
          val instanceOut = ctx.instances.foldLeft[ir.Expression](counterOut)((prev, inst) =>
            connectInstance(instanceCtx, inst, prev)
          )

          // finally we connect the outPort to the end of the chain
          stmts.append(ir.Connect(ir.NoInfo, outPort, instanceOut))

          // we then add the counters and connection statements to the end of the module
          val body = ir.Block(zeroStmt ++: removedCovers +: stmts.toSeq)
          // add ports
          val ports = mod.ports ++ scanChainPorts

          // build the module info
          val covers = ctx.covers.map(_.name).toList
          val instances = ctx.instances.map(i => InstanceKey(i.name, i.module)).toList
          val prefix = prefixes(mod.name)
          val info = ModuleInfo(mod.name, prefix, covers, instances)

          (mod.copy(ports = ports, body = body), Some(info), annos.toSeq)
      }
  }

  private case class CounterCtx(m: ModuleTarget, en: ir.Expression, stmts: mutable.ArrayBuffer[ir.Statement], annos: mutable.ArrayBuffer[Annotation], namespace: Namespace)

  private def generateCounter(ctx: CounterCtx, cover: ir.Verification, prev: ir.Expression): ir.Expression = {
    assert(cover.op == ir.Formal.Cover)
    val info = cover.info

    // we replace the cover statement with a register of the same name (the name is now available!)
    val init = Utils.getGroundZero(prev.tpe.asInstanceOf[ir.UIntType])
    // counter register
    val reg = ir.DefRegister(info, cover.name, prev.tpe, cover.clk, Utils.False(), init)
    ctx.stmts.append(reg)
    val regRef = ir.Reference(reg).copy(flow = SourceFlow)

    // create a node for the cover condition
    val coveredNode = ir.DefNode(info, ctx.namespace.newName(s"${cover.name}_cond"), Utils.and(cover.en, cover.pred))
    ctx.stmts.append(coveredNode)
    // we increment the counter when condition is true
    val covered = ir.Reference(coveredNode).copy(flow=SourceFlow)
    // create conditional increment node
    val incNode = ir.DefNode(info, ctx.namespace.newName(s"${cover.name}_inc"), Builder.add(regRef, covered))
    ctx.stmts.append(incNode)
    val inc = ir.Reference(incNode).copy(flow=SourceFlow)

    // we need to check for overflow
    val willOverflow = Builder.reduceAnd(regRef)
    // we increment the counter when it is not being reset and the chain is not enabled
    val update = Utils.mux(ctx.en, prev, Utils.mux(willOverflow, regRef, inc))

    // register update
    val con = ir.Connect(info, regRef.copy(flow = SinkFlow), update)
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

  private def getScanChainPorts(prefix: String, width: BigInt, isTop: Boolean = false): Seq[ir.Port] = {
    val allPorts =  PortSuffixes.zip(Seq(BigInt(1), width, width)).zip(Seq(true, true, false))
    // the toplevel module does not have an in port
    val ports = if(isTop) allPorts.filterNot(_._1._1 == "in") else allPorts
    ports.map { case ((suffix, w), isInput) =>
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
