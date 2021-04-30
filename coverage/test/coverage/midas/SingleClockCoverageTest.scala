package coverage.midas

import coverage._
import coverage.passes.{ClockAnalysisExamples, LeanTransformSpec}
import firrtl.annotations.CircuitTarget
import firrtl.options.Dependency
import logger.{LogLevel, LogLevelAnnotation, Logger}

class SingleClockCoverageTest extends LeanTransformSpec(Seq(Dependency(LineCoveragePass), Dependency(CoverageStatisticsPass))) {
  behavior of "LineCoverage"

  it should "instrument a single clock FireSim design" in {
    val m = CircuitTarget("FireSim").module("FireSim")
    val ll = LogLevel.Warn
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock)
    }
  }
}
