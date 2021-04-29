// SPDX-License-Identifier: Apache-2.0

package coverage.passes

import firrtl.options.Dependency

class ClockDomainAnalysisSpec extends LeanTransformSpec(Seq(Dependency(ClockDomainAnalysisPass))) {
  behavior.of("ClockDomainAnalysis")
  import ClockAnalysisExamples._

  it should "analyze a circuit with a single clock" in {
    compile(inverter)
  }

  it should "analyze a circuit with a single clock and reset" in {
    compile(inverterWithReset)
  }

  it should "analyze the iCache" in {
    compile(iCache)
  }

  it should "analyze Rocket Core" in {
    compile(rocket)
  }

  it should "analyze the AsyncQueueSink" in {
    compile(asyncQueueSink)
  }

  it should "analyze Rocket Chip generated for Firesim" in {
    compile(firesimRocket)
  }
}