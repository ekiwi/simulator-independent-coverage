// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import firrtl.options.Dependency
import firrtl.annotations._

class ClockAndResetTreeSpec extends LeanTransformSpec(Seq(Dependency(ClockAndResetTreeAnalysisPass))) {
  behavior.of("ClockAndResetTreeAnalysis")
  import ClockDomainAnalysisExamples._
  import ClockAndResetTreeExamples._

  it should "analyze a circuit with a single clock" in {
    val m = CircuitTarget("Inverter").module("Inverter")
    val state = compile(inverter)

    // there is exactly one register connected to the clock
    assert(state.annotations.contains(ClockSourceAnnotation(m.ref("clock"), 1)))
    assert(state.annotations.contains(ClockAnnotation(m.ref("clock"), source = "clock")))
  }

  it should "analyze a clock divider" in {
    val c = CircuitTarget("ClockDiv")
    val m = c.module("ClockDiv")
    val state = compile(clockDiv)

    // there are two source: 1) the clock input 2) the divided clock
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 2)
    ))
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.instOf("divider", "Divider").ref("cReg"), 1)
    ))

    // sinks
    assert(state.annotations.contains(
      ClockAnnotation(m.ref("clock"), "clock")
    ))
    // instance port and module ports get a separate annotation
    assert(state.annotations.contains(
      ClockAnnotation(m.instOf("divider", "Divider").ref("clockIn"), "clock")
    ))
    assert(state.annotations.contains(
      ClockAnnotation(c.module("Divider").ref("clockIn"), "clock")
    ))
    assert(state.annotations.contains(
      ClockAnnotation(m.instOf("divider", "Divider").ref("clockOut"), "divider.cReg")
    ))
    assert(state.annotations.contains(
      ClockAnnotation(c.module("Divider").ref("clockOut"), "divider.cReg")
    ))

  }

  it should "analyze an inlined clock divider" in {
    val m = CircuitTarget("InternalClockDiv").module("InternalClockDiv")
    val state = compile(internalClockDiv)

    // there are two source: 1) the clock input 2) the divided clock
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clock"), 2)
    ))
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("cReg"), 1)
    ))
  }

  it should "analyze a clock going through multiple modules (sideways)" in {
    val m = CircuitTarget("PassThrough").module("PassThrough")
    val state = compile(passThroughSideways)

    val clocks = state.annotations.collect{ case a: ClockSourceAnnotation => a }
    assert(clocks == List(ClockSourceAnnotation(m.ref("clock"), 1)))
  }

  it should "analyze a clock going through multiple modules (vertical)" in {
    val m = CircuitTarget("PassThrough").module("PassThrough")
    val state = compile(passThroughVertical)

    val clocks = state.annotations.collect{ case a: ClockSourceAnnotation => a }
    assert(clocks == List(ClockSourceAnnotation(m.ref("clock"), 1)))
  }

  it should "analyze a clock going through multiple modules (vertical) w/ internal reg" in {
    val m = CircuitTarget("PassThrough").module("PassThrough")
    val state = compile(passThroughVerticalReg)

    val clocks = state.annotations.collect{ case a: ClockSourceAnnotation => a }
    assert(clocks == List(ClockSourceAnnotation(m.ref("clock"), 2)))
  }

  it should "analyze inverted clock signals" in {
    val m = CircuitTarget("InvertedClock").module("InvertedClock")
    val state = compile(invertedClock)

    val clocks = state.annotations.collect{ case a: ClockSourceAnnotation => a }
    assert(clocks == List(ClockSourceAnnotation(m.ref("clock"), 8)))
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

  it should "analyze a circuit with a different number of clock per instance" in {
    val c = CircuitTarget("SameModuleDifferentNumberOfClocks")
    val m = c.module("SameModuleDifferentNumberOfClocks")
    val state = compile(sameModuleDifferentNumberOfClocks)

    // we have two clock and one reset
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clockA"), 3)
    ))
    assert(state.annotations.contains(
      ClockSourceAnnotation(m.ref("clockB"), 1)
    ))
    assert(state.annotations.contains(
      ResetSourceAnnotation(m.ref("reset"), 2)
    ))

    // the "clock" input of the "Child" module is always connected to clockA
    assert(state.annotations.contains(
      ClockAnnotation(c.module("Child").ref("clock"), "clockA")
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

  it should "analyze Rocket Chip generated for Firesim" in {
    val m = CircuitTarget("FireSim").module("FireSim")
    val state = compile(firesimRocket)

    val clocks = state.annotations.collect{ case a: ClockSourceAnnotation => a }
    val resets = state.annotations.collect{ case a: ResetSourceAnnotation => a }

    // there are two clock sources, both originating from the RationalClockBridge
    val clockBridge = m.instOf("RationalClockBridge", "RationalClockBridge")
    assert(clocks.contains(ClockSourceAnnotation(clockBridge.ref("clocks_0"), 6088)))
    assert(clocks.contains(ClockSourceAnnotation(clockBridge.ref("clocks_1"), 467)))
    assert(clocks.size == 2)

    // there are multiple reset in the design, many coming from the ClockGroupResetSynchronizer and AsyncQueues
    val peekPokeBridge = m.instOf("peekPokeBridge", "PeekPokeBridge")
    assert(resets.contains(ResetSourceAnnotation(peekPokeBridge.ref("reset"), 30)))
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

  val internalClockDiv =
    """circuit InternalClockDiv:
      |  module Divider:
      |    input clockIn : Clock
      |    output clockOut : Clock
      |    reg cReg : UInt<1>, clockIn
      |    cReg <= not(cReg)
      |    clockOut <= asClock(cReg)
      |  module InternalClockDiv:
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
      |    reg cReg : UInt<1>, clock
      |    cReg <= not(cReg)
      |    reg out1Reg : UInt<8>, asClock(cReg)
      |    out1Reg <= in
      |    out1 <= out1Reg
      |""".stripMargin

  val passThroughSideways =
    """circuit PassThrough:
      |  module Pass:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    out <= in
      |  module PassThrough:
      |    input reset : AsyncReset   ; unused reset input as chisel would generate
      |    input clock : Clock
      |    input in : UInt<8>
      |    output out0 : UInt<8>
      |
      |    inst p0 of Pass
      |    inst p1 of Pass
      |    inst p2 of Pass
      |    inst p3 of Pass
      |    inst p4 of Pass
      |    inst p5 of Pass
      |    inst p6 of Pass
      |    inst p7 of Pass
      |    inst p8 of Pass
      |    inst p9 of Pass
      |    p0.in <= asUInt(clock)
      |    p1.in <= p0.out
      |    p2.in <= p1.out
      |    p3.in <= p2.out
      |    p4.in <= p3.out
      |    p5.in <= p4.out
      |    p6.in <= p5.out
      |    p7.in <= p6.out
      |    p8.in <= p7.out
      |    p9.in <= p8.out
      |    node clk = asClock(p9.out)
      |
      |    reg out0Reg : UInt<8>, clk
      |    out0Reg <= in
      |    out0 <= out0Reg
      |""".stripMargin

  val passThroughVertical =
    """circuit PassThrough:
      |  module Pass0:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    out <= in
      |  module Pass1:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass0
      |    p.in <= in
      |    out <= p.out
      |  module Pass2:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass1
      |    p.in <= in
      |    out <= p.out
      |  module Pass3:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass2
      |    p.in <= in
      |    out <= p.out
      |  module Pass4:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass3
      |    p.in <= in
      |    out <= p.out
      |  module Pass5:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass4
      |    p.in <= in
      |    out <= p.out
      |  module PassThrough:
      |    input reset : AsyncReset   ; unused reset input as chisel would generate
      |    input clock : Clock
      |    input in : UInt<8>
      |    output out0 : UInt<8>
      |
      |    inst p of Pass5
      |    p.in <= asUInt(clock)
      |    node clk = asClock(p.out)
      |
      |    reg out0Reg : UInt<8>, clk
      |    out0Reg <= in
      |    out0 <= out0Reg
      |""".stripMargin

  val passThroughVerticalReg =
    """circuit PassThrough:
      |  module Pass0:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    out <= in
      |    reg r: UInt<1>, asClock(in)
      |    r <= not(r)
      |  module Pass1:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass0
      |    p.in <= in
      |    out <= p.out
      |  module Pass2:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass1
      |    p.in <= in
      |    out <= p.out
      |  module Pass3:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass2
      |    p.in <= in
      |    out <= p.out
      |  module Pass4:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass3
      |    p.in <= in
      |    out <= p.out
      |  module Pass5:
      |    input in : UInt<1>
      |    output out : UInt<1>
      |    inst p of Pass4
      |    p.in <= in
      |    out <= p.out
      |  module PassThrough:
      |    input reset : AsyncReset   ; unused reset input as chisel would generate
      |    input clock : Clock
      |    input in : UInt<8>
      |    output out0 : UInt<8>
      |
      |    inst p of Pass5
      |    p.in <= asUInt(clock)
      |    node clk = asClock(p.out)
      |
      |    reg out0Reg : UInt<8>, clk
      |    out0Reg <= in
      |    out0 <= out0Reg
      |""".stripMargin

  val invertedClock =
    """circuit InvertedClock:
      |  module InvertedClock:
      |    input reset : AsyncReset   ; unused reset input as chisel would generate
      |    input clock : Clock
      |    input in : UInt<8>
      |    output out0 : UInt<8>
      |
      |    wire clock2 : UInt<1>
      |    wire clock3 : Clock
      |    node clock0 = asUInt(clock)
      |    node clock1 = not(clock0)
      |    clock3 <= asClock(clock2)
      |    clock2 <= clock1
      |
      |    ; @posedge clock
      |    reg r0 : UInt<8>, clock
      |    r0 <= in
      |    ; @negedge clock
      |    ; TODO: support inversion at the register
      |    ;reg r1 : UInt<8>, asClock(not(asUInt(clock)))
      |    reg r1 : UInt<8>, clock
      |    r1 <= in
      |    ; @posedge clock
      |    reg r2 : UInt<8>, asClock(not(asUInt(asClock(not(asUInt(clock))))))
      |    r2 <= in
      |    ; @posedge clock
      |    reg r3 : UInt<8>, asClock(not(not(asUInt(clock))))
      |    r3 <= in
      |    ; @posedge clock
      |    reg r4 : UInt<8>, asClock(clock0)
      |    r4 <= in
      |    ; @negedge clock
      |    reg r5 : UInt<8>, asClock(clock1)
      |    r5 <= in
      |    ; @negedge clock
      |    reg r6 : UInt<8>, asClock(clock2)
      |    r6 <= in
      |    ; @negedge clock
      |    reg r7 : UInt<8>, asClock(clock3)
      |    r7 <= in
      |
      |    out0 <= xor(r0, xor(r1, xor(r2, xor(r3, xor(r4, xor(r5, xor(r6, r7)))))))
      |""".stripMargin

}