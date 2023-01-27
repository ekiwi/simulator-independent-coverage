package fuzzing

import chiseltest.simulator.SimulatorContext
import fuzzing.harness.FuzzHarness

class FuzzTarget(dut: SimulatorContext, info: TopmoduleInfo, makeHarness: TopmoduleInfo => FuzzHarness) {
  val MetaReset = "metaReset"
  require(info.clocks.size == 1, s"Only designs with a single clock are supported!\n${info.clocks}")
  require(info.inputs.exists(_._1 == MetaReset), s"No meta reset in ${info.inputs}")
  require(info.inputs.exists(_._1 == "reset"))

  private var isValid = true
  private var cycles:       Long = 0
  private var resetCycles:  Long = 0
  private var totalTime:    Long = 0
  private var coverageTime: Long = 0
  private val acceptInvalid = false

  // the harness does not control the reset pins
  private val harnessInfo = info.copy(inputs = info.inputs.filterNot { case (name, _) =>
    name == "reset" || name == MetaReset
  })
  private val harness = makeHarness(harnessInfo)

  private def setInputsToZero(): Unit = {
    info.inputs.foreach { case (n, _) => dut.poke(n, 0) }
  }

  private def metaReset(): Unit = {
    dut.poke(MetaReset, 1)
    step()
    dut.poke(MetaReset, 0)
    resetCycles += 1
  }

  private def reset(): Unit = {
    dut.poke("reset", 1)
    step()
    dut.poke("reset", 0)
    resetCycles += 1
  }

  private def getCoverage(feedbackCap: Int): Seq[Byte] = {
    dut.getCoverage().map(_._2).map(v => scala.math.min(v, feedbackCap).toByte)
  }

  def run(input: java.io.InputStream, feedbackCap: Int): (Seq[Byte], Boolean) = {
    val start = System.nanoTime()
    setInputsToZero()
    metaReset()
    reset()
    isValid = true
    // we only consider coverage _after_ the reset is done!
    dut.resetCoverage()

    harness.start(input, dut)
    var done = harness.step(dut)
    while (!done) {
      step()
      done = harness.step(dut)
    }

    val startCoverage = System.nanoTime()
    var c = getCoverage(feedbackCap)

    if (!isValid && !acceptInvalid) {
      c = Seq.fill[Byte](c.length)(0)
    }

    val end = System.nanoTime()
    totalTime += (end - start)
    coverageTime += (end - startCoverage)
    (c, isValid)
  }

  private def ms(i: Long): Long = i / 1000 / 1000
  def finish(verbose: Boolean = false): Unit = {
    dut.finish()
    if (verbose) {
      println(s"Executed $cycles target cycles (incl. $resetCycles reset cycles).")
      println(s"Total time in simulator: ${ms(totalTime)}ms")
      println(
        s"Total time for getCoverage: ${ms(coverageTime)}ms (${coverageTime.toDouble / totalTime.toDouble * 100.0}%)"
      )
      val MHz = cycles.toDouble * 1000.0 / totalTime.toDouble
      println(s"$MHz MHz")
    }
  }

  private def step(): Unit = {
    val assert_failed = dut.peek("assert_failed") == 1
    if (assert_failed) {
      isValid = false
    }

    dut.step(1)
    cycles += 1
  }
}
