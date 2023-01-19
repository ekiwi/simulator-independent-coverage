package coverage.passes

import coverage.tests.{ClockAnalysisExamples, LeanTransformSpec}
import firrtl.annotations.CircuitTarget
import firrtl.options.Dependency
import logger._


class ChangeMainSpec extends LeanTransformSpec(Seq(Dependency(ChangeMainPass))) {
  behavior of "ChangeMainPass"

  it should "change the main of a RISC-V mini design" in {
    val ll = LogLevel.Info
    val tile = CircuitTarget("TileTester").module("Tile")
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.riscvMini,  MakeMainAnnotation(tile) +: ClockAnalysisExamples.riscvMiniAnnos)
    }
  }
}
