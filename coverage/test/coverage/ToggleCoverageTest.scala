// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import chiseltest.ChiselScalatestTester
import coverage.circuits.Test1Module
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import org.scalatest.flatspec.AnyFlatSpec


class ToggleCoverageTest extends AnyFlatSpec with ChiselScalatestTester {
}

class ToggleCoverageInstrumentationTest extends AnyFlatSpec with CompilerTest {
  behavior of "ToggleCoverage"

  override protected def annos = Seq(RunFirrtlTransformAnnotation(Dependency(ToggleCoveragePass)))

  it should "add cover statements" in {
    val (result, rAnnos) = compile(new Test1Module(), "low")
    println(result)
    val l = result.split('\n').map(_.trim)
  }
}