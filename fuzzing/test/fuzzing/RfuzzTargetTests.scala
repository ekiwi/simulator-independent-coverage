package fuzzing

import firrtl.options.Dependency
import firrtl.stage.{FirrtlFileAnnotation, RunFirrtlTransformAnnotation}
import fuzzing.FuzzLab.compile
import fuzzing.harness.RFuzzHarness
import org.scalatest.flatspec.AnyFlatSpec

import java.io.ByteArrayInputStream

class RfuzzTargetTests extends AnyFlatSpec {
  behavior.of("RfuzzTarget")

  val target = "rfuzz"

  val muxToggleAnnos = Seq(FirrtlFileAnnotation("benchmarks/TLI2C.fir")) ++
    Seq(RunFirrtlTransformAnnotation(Dependency(pass.MuxToggleCoverage)))

  it should "execute a single input" in {
    val (dut, info) = compile("test_run_dir/rfuzz", muxToggleAnnos)

    val fuzzer = new FuzzTarget(dut, info, new RFuzzHarness(_))
    val input = Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0).map(_.toByte)
    val (coverage, _) = fuzzer.run(new ByteArrayInputStream(input), 1)
    println(coverage)
    fuzzer.finish(verbose = false)
  }

}
