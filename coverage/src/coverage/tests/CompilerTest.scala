package coverage.tests

import chisel3.RawModule
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage}
import chiseltest.ChiselScalatestTester
import chiseltest.experimental.sanitizeFileName
import firrtl.options.{InputAnnotationFileAnnotation, TargetDirAnnotation}
import firrtl.stage.{FirrtlFileAnnotation, FirrtlStage}
import firrtl.{AnnotationSeq, EmittedFirrtlCircuitAnnotation, EmittedFirrtlModuleAnnotation, EmittedVerilogCircuitAnnotation, EmittedVerilogModuleAnnotation}
import org.scalatest.TestSuite

import java.io.File

/** Base trait for tests that need to compile a circuit and inspect the resulting firrtl / Verilog */
trait CompilerTest extends ChiselScalatestTester {
  this: TestSuite =>
  protected def annos: AnnotationSeq = Seq()

  protected def compile[M <: RawModule](gen: => M, target: String, a: AnnotationSeq = List(), ll: String = "warn"): (String, AnnotationSeq) = {
    val stage = new ChiselStage
    val r = stage.execute(Array("-E", target, "-ll", ll), ChiselGeneratorAnnotation(() => gen) +: testRunDir +: a ++: annos)
    (extractSource(r), r)
  }

  protected def compileFile(firrtlFile: os.Path, annoFile: os.Path, target: String, a: AnnotationSeq = List(), ll: String = "warn"): (String, AnnotationSeq) = {
    assert(os.exists(firrtlFile), firrtlFile.toString())
    assert(os.exists(annoFile), annoFile.toString())
    val stage = new FirrtlStage
    val fileAnnos = Seq(FirrtlFileAnnotation(firrtlFile.toString()), InputAnnotationFileAnnotation(annoFile.toString()))
    val r = stage.execute(Array("-E", target, "-ll", ll), fileAnnos ++: testRunDir +: a ++: annos)
    (extractSource(r), r)
  }



  private def extractSource(annos: AnnotationSeq): String = {
    val src = annos.collect {
      case EmittedFirrtlCircuitAnnotation(a) => a
      case EmittedFirrtlModuleAnnotation(a) => a
      case EmittedVerilogCircuitAnnotation(a) => a
      case EmittedVerilogModuleAnnotation(a) => a
    }.map(_.value).mkString("")
    src
  }



  private def testRunDir: TargetDirAnnotation = {
    // ensure that test files don't just end up in the root directory
    val testName = sanitizeFileName(scalaTestContext.value.get.name)
    val testRunDir = TargetDirAnnotation("test_run_dir" + File.separator + testName)
    testRunDir
  }
}
