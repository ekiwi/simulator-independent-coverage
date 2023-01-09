package coverage.passes


import firrtl.AnnotationSeq
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import chisel3._
import logger.{LogLevel, LogLevelAnnotation}


class StateInitTestModule extends Module {
  val a = Reg(UInt(5.W))
  val b = Reg(SInt(5.W))
  val c = RegInit(0.U(8.W))
  val m = SyncReadMem(8, UInt(4.W))

  val a_out = IO(Output(chiselTypeOf(a)))
  a_out := a
  val b_out = IO(Output(chiselTypeOf(b)))
  b_out := b
  val c_out = IO(Output(chiselTypeOf(c)))
  c_out := c

  val m_out = IO(Output(UInt(4.W)))
  val m_addr = IO(Input(UInt(3.W)))
  m_out := m.read(m_addr)

  // we want to keep all the registers around
  Seq(a,b,c).foreach(dontTouch(_))
}

class RandomStateInitSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "RandomStateInit"

  it should "randomly initialize registers" in {
    // this only works in Verilator since treadle does not seem to respect the register preset annotations
    // tracking issue: https://github.com/chipsalliance/treadle/issues/329
    val sim = VerilatorBackendAnnotation
    val ll = LogLevelAnnotation(LogLevel.Warn)
    val transform = RunFirrtlTransformAnnotation(Dependency(RandomStateInit))

    test(new StateInitTestModule).withAnnotations(Seq(sim, ll, transform, WriteVcdAnnotation)) { dut =>
      dut.clock.step()
      // c gets reset
      dut.c_out.expect(0.U)
      // all the other registers are randomized (in a deterministic fashion) at compile time
      dut.a_out.expect(11.U)
      dut.b_out.expect((-2).S)
    }
  }
}
