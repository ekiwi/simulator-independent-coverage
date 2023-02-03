package coverage

import coverage.circuits.FifoRegister
import coverage.tests.CompilerTest
import firrtl.AnnotationSeq
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import chisel3._


class FsmCoverageTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "FsmCoverage"


  it should "accurately count the states and transitions" in {
    val r = runTest()

    val data = FsmCoverage.processCoverage(r)
    assert(data.length == 1, "There is exactly one FSM in the design!")

    val fsm = data.head
    assert(fsm.name == "FifoRegister.stateReg")
    assert(fsm.states.map(_._1) == List("Empty", "Full"))
    assert(fsm.transitions.map(_._1) == List("Empty" -> "Empty", "Empty" -> "Full", "Full" -> "Empty", "Full" -> "Full"))

    val totalCycles = 15 // excludes single reset cycle in the beginning
    assert(fsm.states.map(_._2).sum == totalCycles, "We are in exactly one state each cycle!")
    assert(fsm.transitions.map(_._2).sum == totalCycles - 1,
      "We take exactly one transition every cycle besides the first one")

    val t = fsm.transitions.toMap
    assert(t("Empty" -> "Empty") == 6)
    assert(t("Empty" -> "Full") == 4)
    assert(t("Full" -> "Empty") == 3)
    assert(t("Full" -> "Full") == 1)
  }

  private def runTest(): AnnotationSeq = {
    val rand = new scala.util.Random(0)
    val r = test(new FifoRegister(8)).withAnnotations(FsmCoverage.annotations ++ Seq(WriteVcdAnnotation)) { dut =>
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

class FsmCoverageInstrumentationTest extends AnyFlatSpec with CompilerTest {
  behavior of "FsmCoverage Instrumentation"

  override protected def annos = Seq(RunFirrtlTransformAnnotation(Dependency(FsmCoveragePass)))


  it should "add cover statements" in {
    val (result, rAnnos) = compile(new FifoRegister(8), "low")
    // println(result)
    val l = result.split('\n').map(_.trim).map(_.split('@').head.trim)

    // we expect six custom cover points (2 states, 4 transitions)
    assert(l.contains("""cover(clock, eq(stateReg, UInt<1>("h0")), not(reset), "") : stateReg_Empty"""))
    assert(l.contains("""cover(clock, eq(stateReg, UInt<1>("h1")), not(reset), "") : stateReg_Full"""))
    assert(l.contains("""cover(clock, and(eq(stateReg_prev, UInt<1>("h0")), eq(stateReg, UInt<1>("h1"))), stateReg_t_valid, "") : stateReg_Empty_to_Full"""))
    val coverCount = l.count(_.contains("cover("))
    assert(coverCount == 6)

    // we should have 1 coverage annotation for 2 + 4 (cover) + 1 (stateReg) targets
    val a = rAnnos.collect{ case a: FsmCoverageAnnotation => a }
    assert(a.size == 1)
    assert(a.head.targets.length == (2 + 4 + 1))
  }

}

class FsmInfoPassTests extends AnyFlatSpec with CompilerTest {

  override protected def annos = Seq(RunFirrtlTransformAnnotation(Dependency(FsmInfoPass)))

  it should "properly analyze the FIFO register FSM" in {
    val (_, rAnnos) = compile(new FifoRegister(8), "low")
    val info = {
      val infos = rAnnos.collect { case a: FsmInfoAnnotation => a }
      assert(infos.length == 1, "expected exactly one info since there is only one FSM in the design")
      infos.head
    }

    checkInfo(info,
      states = Seq(0 -> "Empty", 1 -> "Full"),
      start = Some("Empty"),
      transitions = Seq(
        "Empty" -> "Empty",
        "Empty" -> "Full",
        "Full" -> "Empty",
        "Full" -> "Full",
      )
    )
  }

  val ResourceDir = os.pwd / "test" / "resources"

  it should "properly analyze the FSMs in RISC-V Mini" in {
    val (_, rAnnos) = compileFile(ResourceDir / "RiscVMiniTileTester.fir", ResourceDir / "RiscVMiniTileTester.fsm.json", "low")
    val infos = rAnnos.collect { case a: FsmInfoAnnotation => a }

    // The Cache has a state machine
    val cacheInfo = infos.find(_.target.toString().contains("Cache")).get
    checkInfo(cacheInfo,
      states = Seq(0 -> "sIdle", 1 -> "sReadCache", 2 -> "sWriteCache", 3 -> "sWriteBack",
        4 -> "sWriteAck", 5 -> "sRefillReady", 6 -> "sRefill"),
      start = Some("sIdle"),
      // transitions from a manual analysis
      transitions = Seq(
        "sIdle" -> "sIdle",       // !io.cpu.req.valid
        "sIdle" -> "sWriteCache", // io.cpu.req.valid && io.cpu.req.bits.mask.orR
        "sIdle" -> "sReadCache",  // io.cpu.req.valid && !io.cpu.req.bits.mask.orR
        // TODO: "sIdle -> sRefill" ??
      )
    )

    val arbiterInfo = infos.find(_.target.toString().contains("MemArbiter")).get


  }

  private def checkInfo(info: FsmInfoAnnotation, states: Seq[(Int, String)], start: Option[String], transitions: Seq[(String, String)]): Unit = {
    // ensure unique state names
    val uniqueNames = states.map(_._2).distinct
    assert(uniqueNames.length == states.length, "We assume unique state names!")

    // check for missing or misnamed states
    val infoStateIndex = info.states.toMap
    states.foreach { case (ii, name) =>
      assert(infoStateIndex.contains(ii), s"State $name ($ii) missing from info annotation!")
      assert(infoStateIndex(ii) == name, s"State #$ii is named ${infoStateIndex(ii)} instead of $name")
    }

    // check for states that were not expected
    assert(states.length == info.states.length, s"More states than expected in info annotation: ${info.states}")

    // check for missing transitions:
    val infoTransitionIndex = info.transitions.map{ case (from, to) => s"${infoStateIndex(from)} -> ${infoStateIndex(to)}" }.toSet
    transitions.foreach { case (from, to) =>
      val name = s"$from -> $to"
      assert(infoTransitionIndex.contains(name), "missing transition")
    }

    // check for unexpected transition
    val expectedTransitionIndex = transitions.map{ case (from, to) => s"$from -> $to" }.toSet
    infoTransitionIndex.toSeq.sorted.foreach { name =>
      assert(expectedTransitionIndex.contains(name), "unexpected transition")
    }
  }
}