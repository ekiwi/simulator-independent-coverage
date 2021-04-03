// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chiseltest.coverage.ModuleInstancesPass
import coverage.midas.Builder
import firrtl.annotations.{Annotation, CircuitTarget, ModuleTarget, NoTargetAnnotation, SingleTargetAnnotation}
import firrtl.{AnnotationSeq, CircuitState, DependencyAPIMigration, Namespace, Transform, Utils, ir}
import firrtl.options.Dependency
import firrtl.passes.{ExpandWhens, ExpandWhensAndCheck, MemPortUtils}
import firrtl.stage.{Forms, RunFirrtlTransformAnnotation}
import firrtl.stage.TransformManager.TransformDependency
import firrtl.transforms.DedupModules

import scala.collection.mutable

object ToggleCoverage {
  def annotations: AnnotationSeq = Seq(
    RunFirrtlTransformAnnotation(Dependency(LineCoveragePass)),
    RunFirrtlTransformAnnotation(Dependency(ModuleInstancesPass))
  )
}

case class ToggleCoverageOptions(
  instrumentInputs: Boolean = true,
  instrumentOutputs: Boolean = true,
  instrumentState: Boolean = true,
  instrumentSignals: Boolean = true,
) extends NoTargetAnnotation

object ToggleCoveragePass extends Transform with DependencyAPIMigration {
  val Prefix = "t"

  // we want to run after optimization in order to minimize the number of signals that are left over to instrument
  override def prerequisites: Seq[TransformDependency] = Forms.LowFormOptimized
  override def invalidates(a: Transform): Boolean = false

  override protected def execute(state: CircuitState): CircuitState = {
    val newAnnos = mutable.ListBuffer[Annotation]()
    val c = CircuitTarget(state.circuit.main)
    val ignoreMods = Coverage.collectModulesToIgnore(state)
    val circuit = state.circuit.mapModule(onModule(_, c, newAnnos, ignoreMods))
    val annos = newAnnos.toList ++ state.annotations
    CircuitState(circuit, annos)
  }

  private case class ModuleCtx(
    annos:     mutable.ListBuffer[Annotation],
    namespace: Namespace,
    m:         ModuleTarget,
    clk:       ir.Expression)

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: mutable.ListBuffer[Annotation], ignore: Set[String]): ir.DefModule =
    m match {
      case mod: ir.Module if !ignore(mod.name) =>
        // first we check to see which signals we want to cover
        val signals = collectSignals(mod)

//        val namespace = Namespace(mod)
//        namespace.newName(Prefix)
//        val ctx = ModuleCtx(annos, namespace, c.module(mod.name), Builder.findClock(mod))
//        val bodyInfo = onStmt(mod.body, ctx)
//        val body = addCover(bodyInfo, ctx)
//        mod.copy(body = body)
        mod
      case other => other
    }

  private def collectSignals(m: ir.Module): Seq[ir.RefLikeExpression] = {
    m.ports.map(ir.Reference(_)) ++ collectSignals(m.body)
  }
  private def collectSignals(s: ir.Statement): Seq[ir.RefLikeExpression] = s match {
    case n @ ir.DefNode(_, name, _) if !isTemp(name) => List(ir.Reference(n))
    case w @ ir.DefWire(_, name, _) if !isTemp(name) => List(ir.Reference(w))
    case r : ir.DefRegister => List(ir.Reference(r))
    case m : ir.DefMemory => memRefs(m)
    case ir.Block(stmts) => stmts.flatMap(collectSignals)
    case ir.Conditionally(_, _, conseq, alt) => List(conseq, alt).flatMap(collectSignals)
    case _: ir.DefInstance => List() // we ignore instances since their ports will be covered inside of them
    case _ => List()
  }
  private def isTemp(name: String): Boolean = name.startsWith("_")
  private def memRefs(m: ir.DefMemory): Seq[ir.SubField] = {
    val memRef = ir.Reference(m)
    getFields(memRef.tpe).flatMap { case ir.Field(name, flip, tpe) =>
      val portRef = ir.SubField(memRef, name, tpe, Utils.to_flow(Utils.to_dir(flip)))
      getFields(tpe).map { case ir.Field(name, flip, tpe) =>
        ir.SubField(portRef, name, tpe, Utils.to_flow(Utils.to_dir(flip)))
      }
    }
  }
  private def getFields(t: ir.Type): Seq[ir.Field] = t.asInstanceOf[ir.BundleType].fields

  private def addCover(info: (ir.Statement, Boolean, Seq[ir.Info]), ctx: ModuleCtx): ir.Statement = {
    val (stmt, doCover, infos) = info
    if (!doCover) { stmt }
    else {
      val name = ctx.namespace.newName(Prefix)
      val lines = Coverage.infosToLines(infos)
      ctx.annos.prepend(LineCoverageAnnotation(ctx.m.ref(name), lines))
      val cover =
        ir.Verification(ir.Formal.Cover, ir.NoInfo, ctx.clk, Utils.True(), Utils.True(), ir.StringLit(""), name)
      ir.Block(cover, stmt)
    }
  }
}