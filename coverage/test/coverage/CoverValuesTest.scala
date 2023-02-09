package coverage

import chisel3._
import chisel3.experimental.{ChiselAnnotation, annotate}
import coverage.tests.CompilerTest
import firrtl.annotations.Annotation
import firrtl.transforms.DontTouchAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import treadle.TreadleTester

import scala.collection.mutable

object coverValues {
  private val CounterResolution = 32
  private val MaxCount = (BigInt(1) << CounterResolution) - 1
  def apply(signal: UInt, name: String): Unit = {
    val bits = signal.getWidth
    val entries = BigInt(1) << bits
    val counter = SyncReadMem(entries, UInt(CounterResolution.W), SyncReadMem.WriteFirst)
    // name counter and mark it as don't touch in order to be able to access it through the simulator
    counter.suggestName(name)
    annotate(new ChiselAnnotation {
      override def toFirrtl: Annotation = DontTouchAnnotation(counter.toTarget)
    })
    // it takes one cycle to read the current count
    val prev_count = counter.read(signal)
    val prev_signal = RegNext(signal)
    // we update the counter after the read cycle
    val prev_count_plus_one = Mux(prev_count === MaxCount.U, prev_count, prev_count + 1.U)
    // we need to only start recording 1 cycle after reset
    val reset = Module.reset.asBool
    val delayedReset = RegNext(reset)
    when(!reset && !delayedReset) {
      counter.write(prev_signal, prev_count_plus_one)
    }


  }
}


class CoverValuesMockUp(signalBits: Int) extends Module {
  val signal = IO(Input(UInt(signalBits.W)))
  coverValues(signal, "cnt")
}


class CoverValuesTest extends AnyFlatSpec with CompilerTest {
  behavior of "cover-values"

  it should "count how often a signal is covered" in {
    val SignalBits = 4

    // we need to use treadle in order to be able to read out memories
    val (src , r) = compile(new CoverValuesMockUp(SignalBits), target = "low")
    // println(src)
    val dut = TreadleTester(r :+ treadle.WriteVcdAnnotation)

    // generate some signal value
    val rnd = new scala.util.Random(0)
    val values = (0 until 100).map(_ => BigInt(4, rnd))

    // reset circuit
    dut.poke("reset", 1)
    dut.step(1)
    dut.poke("reset", 0)

    // apply values
    values.foreach { value =>
      dut.poke("signal", value)
      dut.step()
    }
    dut.step() // update counts
    dut.finish // finish simulation, save VCD

    // calculate expected counts
    val counts = mutable.HashMap[BigInt, Int]()
    values.foreach{ ii => counts(ii) = counts.getOrElse(ii, 0) + 1 }
    val expectedCounts = (0 until (1 << SignalBits)).map(ii => counts.getOrElse(ii, 0))

    // get back counts from mem
    val hwCounts = (0 until (1 << SignalBits)).map(ii => dut.peekMemory("cnt", ii).toInt)
    assert(hwCounts == expectedCounts)
  }

}
