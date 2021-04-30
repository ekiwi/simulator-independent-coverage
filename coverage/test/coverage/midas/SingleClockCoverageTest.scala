package coverage.midas

import coverage._
import coverage.passes.{ClockAnalysisExamples, LeanTransformSpec}
import firrtl.annotations.CircuitTarget
import firrtl.options.Dependency

class SingleClockCoverageTest extends LeanTransformSpec(Seq(Dependency(LineCoveragePass))) {
  behavior of "LineCoverage"

  it should "instrument a single clock FireSim design" ignore {
    val m = CircuitTarget("FireSim").module("FireSim")
    val state = compile(ClockAnalysisExamples.firesimRocketSingleClock)

    println(state.circuit.serialize)
  }
}
