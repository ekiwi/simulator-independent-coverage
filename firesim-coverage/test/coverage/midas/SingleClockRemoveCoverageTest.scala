// Copyright 2021-2023 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>
package coverage.midas

import coverage.{CoverageStatisticsPass, FindCoversToRemovePass, LineCoveragePass, LoadCoverageAnnotation, RemoveCoverAnnotation, RemoveCoverPointsPass}
import coverage.tests.{ClockAnalysisExamples, LeanTransformSpec}
import firrtl.options.Dependency
import firrtl.transforms.NoCircuitDedupAnnotation
import logger.{LogLevel, LogLevelAnnotation, Logger}

class SingleClockRemoveCoverageTest extends LeanTransformSpec(Seq(Dependency(LineCoveragePass), Dependency(CoverageStatisticsPass), Dependency(RemoveCoverPointsPass), Dependency(FindCoversToRemovePass), Dependency(CoverageScanChainPass))) {
  behavior of "LineCoverage with reduced cover points"

  it should "remove already covered cover points from a a single clock FireSim design" in {
    val ll = LogLevel.Warn
    val loadCov = LoadCoverageAnnotation("test/resources/chipyard.merged.cover.json")
    // needed in order to be compatible with the firesim build
    val noDedup = NoCircuitDedupAnnotation
    val state = Logger.makeScope(Seq(LogLevelAnnotation(ll))) {
      compile(ClockAnalysisExamples.firesimRocketSingleClock, noDedup +: loadCov +: ClockAnalysisExamples.firesimRocketSingleClockEnumOnlyAnnos)
    }

    val removed = state.annotations.collectFirst{ case RemoveCoverAnnotation(removed) => removed }.get
    assert(removed.length == 1999)

    val lines = state.circuit.serialize.split('\n').map(_.trim)
    val coverCount = lines.count(_.contains("cover("))
    assert(coverCount == 3691 - removed.length)
  }
}