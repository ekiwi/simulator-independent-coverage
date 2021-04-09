// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import firrtl._
import firrtl.annotations.{JsonProtocol, NoTargetAnnotation}
import firrtl.options.CustomFileEmission
import firrtl.options.Viewer.view
import firrtl.stage.FirrtlOptions


/** Serializes all relevant coverage annotations. */
object CoverageInfoEmitter extends Transform with DependencyAPIMigration {
  override def prerequisites = Seq()
  override def optionalPrerequisites = Coverage.AllPasses
  override def invalidates(a: Transform) = false

  override def execute(state: CircuitState): CircuitState = {
    val annos = chiseltest.coverage.Coverage.collectCoverageAnnotations(state.annotations)
    if(annos.nonEmpty) {
      val str = JsonProtocol.serialize(annos)
      val out = EmittedCoverageInfo(str, state.circuit.main)
      state.copy(annotations =  out +: state.annotations)
    } else { state }
  }
}

case class EmittedCoverageInfo(str: String, main: String) extends NoTargetAnnotation with CustomFileEmission {
  override protected def baseFileName(annotations: AnnotationSeq): String = {
    view[FirrtlOptions](annotations).outputFileName.getOrElse(main)
  }
  override protected def suffix = Some(".cover.json")
  override def getBytes = str.getBytes
}
