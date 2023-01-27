package fuzzing

import chiseltest._
import chiseltest.simulator.SimulatorContext
import firrtl.{AnnotationSeq, LowFirrtlEmitter}
import firrtl.options.{Dependency, TargetDirAnnotation}
import firrtl.stage.{FirrtlCircuitAnnotation, FirrtlStage, RunFirrtlTransformAnnotation}
import fuzzing.afl.AFLProxy
import logger.LogLevel
import logger.LogLevelAnnotation

object FuzzLab {

  def main(args: Array[String]): Unit = {
    val parser = new FuzzingArgumentParser
    val argAnnos = parser.parse(args, Seq()).get

    //Parse args
    val harness =
      argAnnos.collectFirst { case h: Harness => h }.getOrElse(throw new RuntimeException("No harness specified!"))
    val feedbackCap = argAnnos.collectFirst { case FeedbackCap(i) => i }.getOrElse(0)
    val outputFolder = argAnnos.collectFirst { case Folder(i) => i }.getOrElse("")

    val (dut, info) = compile("test_run_dir/" + harness.name + "_with_afl", argAnnos)
    val target = new FuzzTarget(dut, info, harness.makeHarness)

    if (argAnnos.contains(DoAnalysis)) {
      CoverageAnalysis.run(target, os.pwd / os.RelPath(outputFolder), feedbackCap)
    } else {
      println("\nReady to fuzz! Waiting for someone to open the fifos!")
      val (a2jPipe, j2aPipe, inputFile) = (os.pwd / "a2j", os.pwd / "j2a", os.pwd / "input")
      AFLProxy.fuzz(target, feedbackCap, outputFolder, a2jPipe, j2aPipe, inputFile)
    }
  }

  val DefaultAnnotations = Seq(
    RunFirrtlTransformAnnotation(Dependency(pass.MetaResetPass)),
    RunFirrtlTransformAnnotation(Dependency(pass.RemovePrintfPass)),
    RunFirrtlTransformAnnotation(Dependency(pass.AssertSignalPass))
    // debugging output
    // LogLevelAnnotation(LogLevel.Info),
  )

  def compile(targetDir: String, annos: AnnotationSeq = Seq.empty): (SimulatorContext, TopmoduleInfo) = {
    println("Loading and instrumenting FIRRTL...")
    val state = loadFirrtl(targetDir, annos)
    val info = TopmoduleInfo(state.circuit)
    val dut = TreadleBackendAnnotation.getSimulator.createContext(state)
    //val dut = VerilatorBackendAnnotation.getSimulator.createContext(state)
    (dut, info)
  }

  private lazy val firrtlStage = new FirrtlStage
  private def loadFirrtl(targetDir: String, annos: AnnotationSeq): firrtl.CircuitState = {
    // we need to compile the firrtl file to low firrtl + add mux toggle coverage and meta reset
    val allAnnos = DefaultAnnotations ++ Seq(TargetDirAnnotation(targetDir)) ++ annos
    val r = firrtlStage.execute(Array("-E", "low-opt"), allAnnos)
    val circuit = r.collectFirst { case FirrtlCircuitAnnotation(c) => c }.get
    firrtl.CircuitState(circuit, r)
  }
}
