package coverage

import coverage.circuits.FifoRegister
import chiseltest._
import chisel3._
import firrtl.AnnotationSeq
import org.scalatest.flatspec.AnyFlatSpec

class ReadyValidCoverageTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ReadyValidCoverage"


  it should "accurately count the number of times each interface fires" in {
    val r = runTest()

    // TODO: figure out why this test is not working in treadle; probably a treadle bug
    val data = ReadyValidCoverage.processCoverage(r)
    assert(data.length == 2, "There are two read/valid interfaces!")

    assert(data.map(_.name).sorted == Seq("FifoRegister.io.deq", "FifoRegister.io.enq"))
    assert(data.map(_.count) == Seq(4, 4))
  }

  private def runTest(): AnnotationSeq = {
    val rand = new scala.util.Random(0)
    val r = test(new FifoRegister(8)).withAnnotations(ReadyValidCoverage.annotations ++ Seq(WriteVcdAnnotation, VerilatorBackendAnnotation)) { dut =>
      (0 until 4).foreach { _ =>
        // push until full
        while (dut.io.enq.ready.peek().litToBoolean) {
          dut.io.enq.bits.poke(BigInt(8, rand).U)
          val skip = rand.nextBoolean()
          dut.io.enq.valid.poke((!skip).B)
          dut.io.deq.ready.poke(false.B)
          dut.clock.step()
        }

        // pop until empty
        while (dut.io.deq.valid.peek().litToBoolean) {
          dut.io.enq.valid.poke(false.B)
          val skip = rand.nextBoolean()
          dut.io.deq.ready.poke((!skip).B)
          dut.clock.step()
        }
      }
    }
    r.getAnnotationSeq
  }
}