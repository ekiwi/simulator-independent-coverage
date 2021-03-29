package coverage

import chisel3.experimental.EnumAnnotations.{EnumComponentAnnotation, EnumDefAnnotation}
import chiseltest.coverage.ModuleInstancesPass
import coverage.midas.Builder
import firrtl.annotations.{Annotation, CircuitTarget, ModuleTarget}
import firrtl._
import firrtl.options.Dependency
import firrtl.passes.{ExpandWhens, ExpandWhensAndCheck}
import firrtl.stage.{Forms, RunFirrtlTransformAnnotation}
import firrtl.stage.TransformManager.TransformDependency
import firrtl.transforms.DedupModules

import scala.collection.mutable

object FsmCoverage {
  def annotations: AnnotationSeq = Seq(
    RunFirrtlTransformAnnotation(Dependency(FsmCoveragePass)),
    RunFirrtlTransformAnnotation(Dependency(ModuleInstancesPass))
  )
}

object FsmCoveragePass extends Transform with DependencyAPIMigration {
  val Prefix = "f"

  override def prerequisites: Seq[TransformDependency] = Forms.LowForm
  override def invalidates(a: Transform): Boolean = false

  override protected def execute(state: CircuitState): CircuitState = {
    val enums = state.annotations.collect { case a: EnumDefAnnotation => a.typeName -> a }.toMap
    val components = state.annotations.collect { case a : EnumComponentAnnotation => a }

    // if there are no enums, we won't be able to find any FSMs
    if(enums.isEmpty) return state

    val newAnnos = mutable.ListBuffer[Annotation]()
    val c = CircuitTarget(state.circuit.main)
    val circuit = state.circuit.mapModule(onModule(_, c, newAnnos, enums, components))
    val annos = newAnnos.toList ++ state.annotations
    CircuitState(circuit, annos)
  }

  private case class ModuleCtx(
    annos:     mutable.ListBuffer[Annotation],
    namespace: Namespace,
    m:         ModuleTarget,
    enums:     Map[String, EnumDefAnnotation],
    components: Seq[EnumComponentAnnotation])

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: mutable.ListBuffer[Annotation], enums: Map[String, EnumDefAnnotation], components: Seq[EnumComponentAnnotation]): ir.DefModule =
    m match {
      case e:   ir.ExtModule => e
      case mod: ir.Module =>
        val localComponents = components.filter(_.target.toTarget.moduleOpt.contains(mod.name))
        if(localComponents.isEmpty) { mod } else {
          val namespace = Namespace(mod)
          namespace.newName(Prefix)
          val ctx = ModuleCtx(annos, namespace, c.module(mod.name), enums, localComponents)
          ???
        }
    }
}