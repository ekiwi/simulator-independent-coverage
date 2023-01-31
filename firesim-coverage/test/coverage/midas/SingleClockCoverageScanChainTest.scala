// Copyright 2021-2023 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>
package coverage.midas

import coverage.{CoverageStatisticsPass, LineCoveragePass}
import coverage.tests.{ClockAnalysisExamples, LeanTransformSpec}
import firrtl.annotations.CircuitTarget
import firrtl.options.Dependency
import logger.{LogLevel, LogLevelAnnotation, Logger}
import midas.coverage.{CoverageScanChainInfo, CoverageScanChainOptions, CoverageScanChainPass}

class SingleClockCoverageScanChainTest extends LeanTransformSpec(Seq(Dependency(LineCoveragePass), Dependency(CoverageStatisticsPass), Dependency(CoverageScanChainPass))) {
  behavior of "LineCoverage + CoverageScanChain"

  it should "instrument a single clock FireSim design" in {
    val m = CircuitTarget("FireSim").module("FireSim")
    val ll = LogLevel.Warn
    val opts = CoverageScanChainOptions()
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock, Seq(opts))
    }

    val covers = state.annotations.collect{ case c : CoverageScanChainInfo => c.covers }.head
  }
}

