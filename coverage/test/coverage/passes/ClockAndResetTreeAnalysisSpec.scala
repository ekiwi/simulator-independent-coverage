// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import firrtl.options.Dependency

class ClockAndResetTreeAnalysisSpec extends LeanTransformSpec(Seq(Dependency(ClockAndResetTreeAnalysisPass))) {
  behavior.of("ClockAndResetTreeAnalysis")
  import ClockAndResetAnalysisExamples._

  it should "analyze a circuit with a single clock" in {
    compile(inverter)
  }

  it should "analyze a circuit with a single clock and reset" in {
    compile(inverterWithReset)
  }

  it should "analyze the iCache" in {
    compile(iCache)
  }

  it should "analyze Rocket Core" ignore {
    compile(rocket)
  }

  it should "analyze the AsyncQueueSink" ignore {
    compile(asyncQueueSink)
  }

  it should "analyze Rocket Chip generated for Firesim" ignore {
    compile(firesimRocket)
  }
}
