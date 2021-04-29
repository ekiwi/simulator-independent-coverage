// SPDX-License-Identifier: Apache-2.0

package coverage.passes

import firrtl.FileUtils
import firrtl.options.Dependency

class ClockDomainAnalysisSpec extends LeanTransformSpec(Seq(Dependency(ClockDomainAnalysisPass))) {
  behavior.of("ClockDomainAnalysis")
  import ClockDomainAnalysisExamples._

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


object ClockDomainAnalysisExamples {
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



  val sameModuleDifferentNumberOfClocks =
    """circuit SameModuleDifferentNumberOfClocks:
      |  module Child:
      |    input clock : Clock
      |    input reset : Reset
      |    input in0: UInt<8>
      |    output out0: UInt<8>
      |    output out1: UInt<8>
      |
      |    ; this signal is just wired through this module, but not actually clocked by it
      |    out0 <= in0
      |
      |    reg counter : UInt<8>, clock with :
      |      reset => (reset, UInt<8>(0))
      |    counter <= add(counter, UInt(1))
      |    ; this signal on the other hand is always under the domain of our clock
      |    out1 <= counter
      |
      |  module SameModuleDifferentNumberOfClocks:
      |    input reset: AsyncReset
      |    input clockA: Clock
      |    input clockB: Clock
      |    input in0: UInt<8>
      |    input in1: UInt<8>
      |    output out0: UInt<8>
      |    output out1: UInt<8>
      |    output out2: UInt<8>
      |    output out3: UInt<8>
      |
      |    ; we have one register for each clock domain
      |    reg r0 : UInt<8>, clockA
      |    r0 <= in0
      |    reg r1 : UInt<8>, clockB
      |    r1 <= in1
      |
      |    ; c0 will only have a single clock
      |    inst c0 of Child
      |    c0.clock <= clockA
      |    c0.reset <= reset
      |    c0.in0 <= r0
      |    out0 <= c0.out0
      |    out1 <= c0.out1
      |
      |    ; c1 is clocked by clockA, however its input is driven by clockB
      |    inst c1 of Child
      |    c1.clock <= clockA
      |    c1.reset <= reset
      |    c1.in0 <= r1
      |    out2 <= c1.out0
      |    out3 <= c1.out1
      |""".stripMargin


  def asyncQueueSink: String = FileUtils.getTextResource("/AsyncQueueSink.fir")
  def iCache: String = FileUtils.getTextResource("/regress/ICache.fir")
  def rocket: String = FileUtils.getTextResource("/regress/RocketCore.fir")
  def firesimRocket: String = FileUtils.getTextResource("/FireSimRocketConfig.fir")
}