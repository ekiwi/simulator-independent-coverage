// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import coverage.passes.RemoveKeepClockAndResetAnnotations
import firrtl.annotations.NoTargetAnnotation
import firrtl._
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import firrtl.stage.TransformManager.TransformDependency

import scala.collection.mutable

object ToggleCoverage {
  def passes: Seq[TransformDependency] = Seq(Dependency(ToggleCoveragePass), Dependency(ModuleInstancesPass),
    Dependency(RemoveKeepClockAndResetAnnotations))
  // TODO: re-enable MemoryToggleCoverage (currently broken b/c we are not allowed to read input ports!)
  def all: AnnotationSeq = Seq(PortToggleCoverage, RegisterToggleCoverage, WireToggleCoverage) ++ passAnnos
  def ports: AnnotationSeq = Seq(PortToggleCoverage) ++ passAnnos
  def registers: AnnotationSeq = Seq(RegisterToggleCoverage) ++ passAnnos
  def memories: AnnotationSeq = Seq(MemoryToggleCoverage) ++ passAnnos
  def wires: AnnotationSeq = Seq(WireToggleCoverage) ++ passAnnos
  private def passAnnos = passes.map(p => RunFirrtlTransformAnnotation(p))

  def processCoverage(annos: AnnotationSeq): ToggleCoverageData = {
    val cov = Coverage.collectTestCoverage(annos).toMap
    val moduleToInst = Coverage.collectModuleInstances(annos).groupBy(_._2).map{ case (k,v) => k -> v.map(_._1) }
    val infos = annos.collect { case a: ToggleCoverageAnnotation => a }



    ???
  }
}

//                                         instance, module,       signal,      bit, count
case class ToggleCoverageData(inst: Seq[((String, String), Seq[(String, Seq[(Int, Long)])])])

/** enables coverage of all I/O ports in the design */
case object PortToggleCoverage extends NoTargetAnnotation
/** enables coverage of all register signals in the design */
case object RegisterToggleCoverage extends NoTargetAnnotation
/** enables coverage of all memory port signals in the design */
case object MemoryToggleCoverage extends NoTargetAnnotation
/** enables coverage of all wires in the design */
case object WireToggleCoverage extends NoTargetAnnotation