// SPDX-License-Identifier: Apache-2.0


package coverage

import circuits.Test1Module
import chiseltest._
import chiseltest.coverage._
import chiseltest.simulator.SimulatorAnnotation
import firrtl.AnnotationSeq
import logger.{LogLevel, LogLevelAnnotation}
import org.scalatest.flatspec.AnyFlatSpec
import chisel3._

/** Ensure that all simulators give the same coverage feedback when run with the same tests.
  * To implement this for a particular simulator, just override the `backend` annotation.
  * */
abstract class SimulatorCoverageTest(name: String, backend: SimulatorAnnotation) extends AnyFlatSpec with ChiselScalatestTester {
  behavior of s"$name Coverage Collection"
  private def noAutoCov: AnnotationSeq = Seq(backend)
  private def allAutoCov: AnnotationSeq = Seq(backend) ++ LineCoverage.annotations
  private def trace: AnnotationSeq = Seq(LogLevelAnnotation(LogLevel.Trace))

  it should "report count for all user cover points (no submodules)" in {
    val r = test(new Test1Module(withSubmodules = false)).withAnnotations(noAutoCov) { dut =>
      dut.clock.step()
    }
    val cov = getCoverage(r)

    // the cover point in the main module are not prefixed
    assert(cov.keys.toList == List("cover_0"))

    // since we executed one step and all inputs are zero by default, we expect the count to be 3
    assert(cov("cover_0") == 2)
  }

  it should "report count for all user cover points (with submodules)" in {
    val r = test(new Test1Module(withSubmodules = true)).withAnnotations(noAutoCov) { dut =>
      dut.clock.step()
    }
    val cov = getCoverage(r)

    // the cover point in the main module are not prefixed, but the one in the child module are
    assert(cov.keys.toList.sorted == List("c0.cover_0", "c1.cover_0", "cover_0"))

    // since we executed one step and all inputs are zero by default, we expect the count to be 3
    assert(cov("cover_0") == 2)
  }

  it should "generate the same coverage as other simulators" in {
    val rand = new scala.util.Random(0)
    val r = test(new Test1Module(withSubmodules = true)).withAnnotations(allAutoCov) { dut =>
      (0 until 1000).foreach { _ =>
        dut.a.poke(BigInt(3, rand).U)
        dut.clock.step()
      }
    }
    val cov = getCoverage(r)
    val expected = Map(
      "cover_0" -> 130, "l_1" -> 248, "l_0" -> 135, "l_3" -> 1002, "l_2" -> 754,
      "c1.l_0" -> 1002, "c0.cover_0" -> 370,
      "c0.l_0" -> 1002, "c1.cover_0" -> 366
    )
    assert(cov == expected)
  }

  it should "allow us to estimate pi" in {
    val rand = new scala.util.Random(0)
    val r = test(new PiEstimator).withAnnotations(noAutoCov) { dut =>
      (0 until 1000).foreach { _ =>
        dut.x.poke(BigInt(8, rand).S)
        dut.y.poke(BigInt(8, rand).S)
        dut.clock.step()
      }
    }

    val cov = getCoverage(r)
    val inCircle = cov("cover_0")
    val inRectangle = cov("cover_1")
    val pi = 4.0 * inCircle.toDouble / inRectangle.toDouble
    val error = math.abs(pi - math.Pi)
    assert(error < 0.0329)
  }

  private def getCoverage(r: TestResult): Map[String, Long] = {
    val coverage = r.getAnnotationSeq.collect { case a: TestCoverage => a.counts }
    assert(coverage.size == 1, "Expecting exactly one coverage map!")
    coverage.head.toMap
  }
}

class TreadleCoverageTest extends SimulatorCoverageTest("Treadle", TreadleBackendAnnotation) {}
class VerilatorCoverageTest extends SimulatorCoverageTest("Verilator", VerilatorBackendAnnotation) {}

private class PiEstimator extends Module {
  val x = IO(Input(SInt(8.W)))
  val y = IO(Input(SInt(8.W)))
  val inCircle = IO(Output(Bool()))
  val inRectangle = IO(Output(Bool()))
  val radius = 100
  inCircle := (x * x + y * y) <= (radius * radius).S
  inRectangle := (x <= radius.S && x >= -radius.S) && (y <= radius.S && y >= -radius.S)
  cover(inCircle)
  cover(inRectangle)
}