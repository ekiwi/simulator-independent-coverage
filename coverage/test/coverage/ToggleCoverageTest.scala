// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chisel3._
import chiseltest.ChiselScalatestTester
import coverage.circuits.Test1Module
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import org.scalatest.flatspec.AnyFlatSpec


class ToggleCoverageTest extends AnyFlatSpec with ChiselScalatestTester {
}

class ToggleTestModule extends Module {
  val in = IO(Input(UInt(8.W)))
  val out0 = IO(Output(UInt(8.W)))
  val out1 = IO(Output(UInt(8.W)))

  val c0 = Module(new ToggleTestChild)
  c0.in := in
  out0 := c0.out0
  out1 := c0.out1
}

class ToggleTestChild extends Module {
  val in = IO(Input(UInt(8.W)))
  val out0 = IO(Output(UInt(8.W)))
  val out1 = IO(Output(UInt(8.W)))
  out0 := in
  out1 := RegNext(in)
}

class ToggleCoverageInstrumentationTest extends AnyFlatSpec with CompilerTest {
  behavior of "ToggleCoverage"

  override protected def annos = Seq(RunFirrtlTransformAnnotation(Dependency(ToggleCoveragePass)))

  it should "add cover statements" in {
    val (result, rAnnos) = compile(new Test1Module(), "sverilog")
    println(result)
    val l = result.split('\n').map(_.trim)
  }

  it should "only create one counter when there are obvious aliases" in {
    val (result, rAnnos) = compile(new ToggleTestModule(), "low")
    val l = result.split('\n').map(_.trim)

    val annos = rAnnos.collect{ case a: ToggleCoverageAnnotation => a }

    // we expect the covered signals to be the following
    val expected = List(
      "ToggleTestChild.REG", "ToggleTestChild.in",
      "ToggleTestChild.out0", "ToggleTestChild.out1",
      "ToggleTestChild.reset",
      "ToggleTestModule.in", "ToggleTestModule.out0",
      "ToggleTestModule.out1", "ToggleTestModule.reset"
    )
    val coverNames = annos.map(a => s"${a.module}.${a.signal}").distinct.sorted
    assert(coverNames == expected)


    // Check how many how many cover statements there are
    val covers = l.filter(_.startsWith("cover("))
    val coverCount = covers.length

    // We expect there to be fewer actual cover statement than signals covered.
    // The following signals alias:
    // - ToggleTestChild.REG -> ToggleTestChild.out1 -> ToggleTestModule.out1
    // - ToggleTestModule.in -> ToggleTestChild.in -> ToggleTestChild.out0 -> ToggleTestModule.out0
    // - ToggleTestModule.reset -> ToggleTestChild.reset

    val expectedCoverBits = 8 + 8 + 1
    assert(coverCount == expectedCoverBits, "\n" + covers.mkString("\n"))
  }
}