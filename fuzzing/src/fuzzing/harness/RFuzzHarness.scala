package fuzzing.harness

import chiseltest.simulator.SimulatorContext
import fuzzing.TopmoduleInfo

import java.io.InputStream

class RFuzzHarness(info: TopmoduleInfo) extends FuzzHarness {
  private var input: Option[InputStream] = None

  override def start(input: InputStream, sim: SimulatorContext): Unit = {
    this.input = Some(input)
  }

  private val inputBits = info.inputs.map(_._2).sum
  private val inputSize = scala.math.ceil(inputBits.toDouble / 8.0).toInt

  private def pop(): Array[Byte] = {
    val in = input.getOrElse(throw new RuntimeException("No input!"))
    val r = in.readNBytes(inputSize)
    if (r.size == inputSize) { r }
    else { Array.emptyByteArray }
  }

  private def applyInputs(sim: SimulatorContext, bytes: Array[Byte]): Unit = {
    var input: BigInt = bytes.zipWithIndex.map { case (b, i) => (0xff & BigInt(b)) << (i * 8) }.reduce(_ | _)
    info.inputs.foreach { case (name, bits) =>
      val mask = (BigInt(1) << bits) - 1
      val value = input & mask
      input = input >> bits
      //println("'" + name + "'", bits.toString, value.toString)
      sim.poke(name, value)
    }
    //println("---")
  }

  override def step(sim: SimulatorContext): Boolean = {
    val inputBytes = pop()
    if (inputBytes.nonEmpty) {
      applyInputs(sim, inputBytes)
    } else {
      input = None
    }
    val done = inputBytes.isEmpty
    done
  }
}
