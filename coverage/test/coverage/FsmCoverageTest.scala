package coverage

import coverage.circuits.FifoRegister
import org.scalatest.flatspec.AnyFlatSpec

class FsmCoverageTest extends AnyFlatSpec {
  behavior of "FsmCoverage"

}

class FsmCoverageInstrumentationTest extends AnyFlatSpec with CompilerTest {
  behavior of "FsmCoverage Instrumentation"

  it should "recognize the FSM" in {
    val (result, rAnnos) = compile(new FifoRegister(8), "high")

    println()
  }

}