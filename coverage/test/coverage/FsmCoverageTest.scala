package coverage

import coverage.circuits.FifoRegister
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import org.scalatest.flatspec.AnyFlatSpec

class FsmCoverageTest extends AnyFlatSpec {
  behavior of "FsmCoverage"

}

class FsmCoverageInstrumentationTest extends AnyFlatSpec with CompilerTest {
  behavior of "FsmCoverage Instrumentation"

  override protected def annos = Seq(RunFirrtlTransformAnnotation(Dependency(FsmCoveragePass)))

  it should "recognize the FSM" in {
    val (result, rAnnos) = compile(new FifoRegister(8), "low")

    println()
  }

}