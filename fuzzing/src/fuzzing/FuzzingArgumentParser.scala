package fuzzing

import chiseltest.WriteVcdAnnotation
import coverage.DoNotCoverAnnotation
import firrtl.AnnotationSeq
import firrtl.annotations.{CircuitTarget, NoTargetAnnotation}
import firrtl.options.{Dependency, DuplicateHandling, ExceptOnError, ShellOption}
import firrtl.stage.{FirrtlFileAnnotation, RunFirrtlTransformAnnotation}
import fuzzing.harness.{FuzzHarness, RFuzzHarness}
import scopt.OptionParser

case class Harness(name: String, makeHarness: TopmoduleInfo => FuzzHarness) extends NoTargetAnnotation
case class FeedbackCap(cap: Int) extends NoTargetAnnotation
case class Folder(str: String) extends NoTargetAnnotation
case class MuxToggleOpAnnotation(fullToggle: Boolean) extends NoTargetAnnotation
case object DoAnalysis extends NoTargetAnnotation

//Note: Currently doesn't extend native argument parser, may be useful later.
class FuzzingArgumentParser extends OptionParser[AnnotationSeq]("fuzzer") with DuplicateHandling with ExceptOnError {

  private val argumentOptions = Seq(
    new ShellOption[String](
      longOption = "FIRRTL",
      toAnnotationSeq = input => Seq(FirrtlFileAnnotation(input)),
      helpText = "",
      helpValueName = Some("<str>")
    ),
    new ShellOption[String](
      longOption = "Harness",
      toAnnotationSeq = input => {
        val makeHarness = input match {
          case "rfuzz"  => new RFuzzHarness(_)
          case other    => throw new NotImplementedError(s"Unknown harness $other")
        }
        Seq(Harness(input, makeHarness))
      },
      helpText = "",
      helpValueName = Some("<str>")
    ),
    new ShellOption[Unit](
      longOption = "Directed",
      toAnnotationSeq = _ =>
        Seq(
          DoNotCoverAnnotation(CircuitTarget("TLI2C").module("TLMonitor_72")),
          DoNotCoverAnnotation(CircuitTarget("TLI2C").module("DummyPlusArgReader_75")),
          DoNotCoverAnnotation(CircuitTarget("TLSPI").module("TLMonitor_66")),
          DoNotCoverAnnotation(CircuitTarget("TLSPI").module("SPIFIFO_1")),
          DoNotCoverAnnotation(CircuitTarget("TLSPI").module("SPIMedia_1")),
          DoNotCoverAnnotation(CircuitTarget("TLSPI").module("DummyPlusArgReader_69")),
//                                  DoNotCoverAnnotation(CircuitTarget("TLSPI").module("Queue_18")),
//                                  DoNotCoverAnnotation(CircuitTarget("TLSPI").module("Queue_19")),
          DoNotCoverAnnotation(CircuitTarget("TLSPI").module("SPIPhysical_1"))
        ),
      helpText = ""
    ),
    new ShellOption[Unit](
      longOption = "VCD",
      toAnnotationSeq = _ => Seq(WriteVcdAnnotation),
      helpText = ""
    ),
    new ShellOption[Int](
      longOption = "Feedback",
      toAnnotationSeq = input => Seq(FeedbackCap(input)),
      helpText = "",
      helpValueName = Some("<i>")
    ),
    new ShellOption[String](
      longOption = "Folder",
      toAnnotationSeq = input => Seq(Folder(input)),
      helpText = "",
      helpValueName = Some("<str>")
    ),
    new ShellOption[Unit](
      longOption = "mux-toggle-coverage",
      toAnnotationSeq = _ =>
        Seq(
          RunFirrtlTransformAnnotation(Dependency(pass.MuxToggleCoverage)),
          MuxToggleOpAnnotation(fullToggle = false)
        ),
      helpText = "enable mux toggle coverage instrumentation"
    ),
    new ShellOption[Unit](
      longOption = "full-mux-toggle-coverage",
      toAnnotationSeq = _ =>
        Seq(
          RunFirrtlTransformAnnotation(Dependency(pass.MuxToggleCoverage)),
          MuxToggleOpAnnotation(fullToggle = true)
        ),
      helpText = "enable line coverage instrumentation"
    ),
    new ShellOption[Unit](
      longOption = "line-coverage",
      toAnnotationSeq = _ =>
        Seq(
          RunFirrtlTransformAnnotation(Dependency(coverage.LineCoveragePass))
        ),
      helpText = "enable line coverage instrumentation"
    ),
    new ShellOption[Unit](
      longOption = "analysis",
      toAnnotationSeq = _ => Seq(DoAnalysis),
      helpText = "perform coverage analysis instead of starting a fuzz server"
    )
  )

  argumentOptions.foreach(_.addOption(this))
  this.help("help").text("prints this usage text")
}
