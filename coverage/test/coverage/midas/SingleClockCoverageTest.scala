package coverage.midas

import coverage._
import coverage.passes.{ClockAnalysisExamples, LeanTransformSpec}
import firrtl.annotations.CircuitTarget
import firrtl.options.Dependency
import logger.{LogLevel, LogLevelAnnotation, Logger}


class SingleClockCoverageScanChainTest extends LeanTransformSpec(Seq(Dependency(LineCoveragePass), Dependency(CoverageStatisticsPass), Dependency(CoverageScanChainPass))) {
  behavior of "LineCoverage + CoverageScanChain"

  it should "instrument a single clock FireSim design" in {
    val m = CircuitTarget("FireSim").module("FireSim")
    val ll = LogLevel.Info
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock)
    }
  }
}


class SingleClockLineCoverageTest extends LeanTransformSpec(Seq(Dependency(LineCoveragePass), Dependency(CoverageStatisticsPass))) {
  behavior of "LineCoverage for Single Clock Chipyard Design"

  it should "instrument a single clock FireSim design" in {
    val m = CircuitTarget("FireSim").module("FireSim")
    val ll = LogLevel.Warn
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock)
    }
  }
}

class SingleClockToggleCoverageTest extends LeanTransformSpec(Seq(Dependency(ToggleCoveragePass), Dependency(CoverageStatisticsPass))) {
  behavior of "ToggleCoverage for Single Clock Chipyard Design"

  val options = ToggleCoverage.all

  it should "instrument a single clock FireSim design" in {
    // we do not want to instrument the Firesim top, it will actually fail since that module has no clock input
    // and our clock finding heuristic isn't good enough to deal with that :(
    val m = CircuitTarget("FireSim").module("FireSim")
    val skipTop = Seq(DoNotCoverAnnotation(m))
    val ll = LogLevel.Warn
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock, annos = options ++ skipTop)
    }
  }
}


class SingleClockFsmCoverageTest extends LeanTransformSpec(Seq(Dependency(FsmCoveragePass), Dependency(CoverageStatisticsPass))) {
  behavior of "FsmCoverage"

  it should "instrument a single clock FireSim design" in {
    val m = CircuitTarget("FireSim").module("FireSim")
    val ll = LogLevel.Warn
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock, ClockAnalysisExamples.firesimRocketSingleClockAnnos)
    }
  }

  it should "instrument a single clock RiscV Mini design" in {
    val ll = LogLevel.Warn
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.riscvMini, ClockAnalysisExamples.riscvMiniAnnos)
    }
  }
}
