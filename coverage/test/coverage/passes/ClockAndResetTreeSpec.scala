// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import firrtl.options.Dependency
import firrtl.annotations._

class ClockAndResetTreeSpec extends LeanTransformSpec(Seq(Dependency(ClockAndResetTreeAnalysisPass))) {
  behavior.of("ClockAndResetTreeAnalysis")
  import ClockAndResetAnalysisExamples._
  import ClockAndResetTreeExamples._

  it should "analyze a circuit with a single clock" in {
    val m = CircuitTarget("Inverter").module("Inverter")
    val state = compile(inverter)

    // there is exactly one register connected to the clock
    assert(state.annotations.contains(ClockSourceAnnotation(m.ref("clock"), 1)))
    // assert(state.annotations.contains(ClockAnnotation(m.ref("clock"), inverted = false, source = "clock")))
  }

  it should "analyze a clock divider" in {
    val m = CircuitTarget("ClockDiv").module("ClockDiv")
    val state = compile(clockDiv)

    // there are two source: 1) the clock input 2) the divided clock
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 2)
    ))
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.instOf("divider", "Divider").ref("cReg"), 1)
    ))

  }

  it should "analyze a circuit with a single clock and reset" in {
    val m = CircuitTarget("InverterWithReset").module("InverterWithReset")
    val state = compile(inverterWithReset)

    // there is a normal Chisel reset and clock source in the toplevel
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 1)
    ))
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("reset"), 1)
    ))
  }

  it should "analyze the iCache" in {
    val m = CircuitTarget("ICache").module("ICache")
    val state = compile(iCache)

    // there is a normal Chisel reset and clock source in the toplevel
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 45)
    ))
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("reset"), 6)
    ))
  }

  it should "analyze Rocket Core" in {
    val m = CircuitTarget("RocketCore").module("RocketCore")
    val state = compile(rocket)

    // there is a normal Chisel reset and clock source in the toplevel
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 316)
    ))
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("reset"), 58)
    ))
  }

  it should "analyze the AsyncQueueSink" in {
    val m = CircuitTarget("AsyncQueueSink").module("AsyncQueueSink")
    val state = compile(asyncQueueSink)

    // there is only a single boring toplevel clock
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 28)
    ))
    // there is also one boring toplevel reset
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("reset"), 18)
    ))

    // however there are multiple derived resets:
    //
    // node _sink_valid_0_reset_T_2 = or(_sink_valid_0_reset_T, _sink_valid_0_reset_T_1) @[AsyncQueue.scala 173:42]
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("_sink_valid_0_reset_T_2"), 3)
    ))
    // node _sink_valid_1_reset_T_2 = or(_sink_valid_1_reset_T, _sink_valid_1_reset_T_1) @[AsyncQueue.scala 174:42]
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("_sink_valid_1_reset_T_2"), 3)
    ))
    // node _source_extend_reset_T_2 = or(_source_extend_reset_T, _source_extend_reset_T_1) @[AsyncQueue.scala 175:42]
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("_source_extend_reset_T_2"), 3)
    ))
  }

  it should "analyze Rocket Chip generated for Firesim" ignore {
    compile(firesimRocket)
  }
}

object ClockAndResetTreeExamples {
  val clockDiv =
    """circuit ClockDiv:
      |  module Divider:
      |    input clockIn : Clock
      |    output clockOut : Clock
      |    reg cReg : UInt<1>, clockIn
      |    cReg <= not(cReg)
      |    clockOut <= asClock(cReg)
      |  module ClockDiv:
      |    input reset : AsyncReset   ; unused reset input as chisel would generate
      |    input clock : Clock
      |    input in : UInt<8>
      |    output out0 : UInt<8>
      |    output out1 : UInt<8>
      |
      |    reg out0Reg : UInt<8>, clock
      |    out0Reg <= in
      |    out0 <= out0Reg
      |
      |    inst divider of Divider
      |    divider.clockIn <= clock
      |    reg out1Reg : UInt<8>, divider.clockOut
      |    out1Reg <= in
      |    out1 <= out1Reg
      |""".stripMargin


}