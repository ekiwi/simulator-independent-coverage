// SPDX-License-Identifier: Apache-2.0

package coverage.passes

import firrtl.FileUtils
import firrtl.options.Dependency

class ClockAndResetAnalysisSpec extends LeanTransformSpec(Seq(Dependency(ClockAndResetAnalysisPass))) {
  behavior.of("ClockAndResetAnalysis")
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


object ClockAndResetAnalysisExamples {
  /* Original Chisel:
  class Inverter extends Module {
    val io = IO(new Bundle {
      val in = Input(Bool())
      val out = Output(Bool())
    })
    io.out := RegNext(~io.in)
  }
  */
  val inverter =
    """circuit Inverter :
      |  module Inverter :
      |    input clock : Clock
      |    input reset : UInt<1>
      |    output io : { flip in : UInt<1>, out : UInt<1>}
      |
      |    node _T = not(io.in) @[main.scala 12:21]
      |    reg REG : UInt<1>, clock with :
      |      reset => (UInt<1>("h0"), REG) @[main.scala 12:20]
      |    REG <= _T @[main.scala 12:20]
      |    io.out <= REG @[main.scala 12:10]
      |""".stripMargin

  /*
  class InverterWithReset extends Module {
    val io = IO(new Bundle {
      val in = Input(Bool())
      val out = Output(Bool())
    })
    val inverted = RegInit(false.B)
    inverted := ~io.in
    io.out := inverted
  }
  */
  val inverterWithReset =
  """circuit InverterWithReset :
    |  module InverterWithReset :
    |    input clock : Clock
    |    input reset : UInt<1>
    |    output io : { flip in : UInt<1>, out : UInt<1>}
    |
    |    reg inverted : UInt<1>, clock with :
    |      reset => (reset, UInt<1>("h0")) @[main.scala 11:25]
    |    node _T = not(io.in) @[main.scala 12:15]
    |    inverted <= _T @[main.scala 12:12]
    |    io.out <= inverted @[main.scala 13:10]
    |
    |""".stripMargin

  def asyncQueueSink: String = FileUtils.getTextResource("/AsyncQueueSink.fir")
  def iCache: String = FileUtils.getTextResource("/regress/ICache.fir")
  def rocket: String = FileUtils.getTextResource("/regress/RocketCore.fir")
  def firesimRocket: String = FileUtils.getTextResource("/FireSimRocketConfig.fir")
}