// SPDX-License-Identifier: Apache-2.0

package coverage.midas

import coverage.circuits.Test1Module
import coverage.LineCoveragePass
import coverage.tests.CompilerTest
import firrtl._
import firrtl.options.Dependency
import firrtl.stage.RunFirrtlTransformAnnotation
import midas.coverage.{CoverageScanChainInfo, CoverageScanChainOptions, CoverageScanChainPass}
import org.scalatest.flatspec.AnyFlatSpec

class CoverageScanChainTest extends AnyFlatSpec with CompilerTest {
  behavior of "CoverageScanChain"

  override protected def annos = Seq(
    RunFirrtlTransformAnnotation(Dependency(LineCoveragePass)),
    RunFirrtlTransformAnnotation(Dependency(CoverageScanChainPass))
  )

  it should "insert a scan chain for all coverage statements" in {
    val width = 30
    val widthAnno = CoverageScanChainOptions(width)

    val (result, rAnnos) = compile(new Test1Module(withSubmodules = true), "low", Seq(widthAnno))
    // println(result)
    val l = result.split('\n').map(_.trim)

    val chainInfo = rAnnos.collectFirst { case a: CoverageScanChainInfo => a }.get
    assert(chainInfo.width == width)

    // the cover chain ports will need to use an additional '_' because of the colliding register named `cover_chain_en`
    assert(chainInfo.prefix == "cover_chain_")
    assert(l.contains("input cover_chain__en : UInt<1>"))
    assert(l.contains(s"output cover_chain__out : UInt<$width>"))

    // the submodules do not have a collision
    assert(l.contains("input cover_chain_en : UInt<1>"))
    assert(l.contains(s"input cover_chain_in : UInt<$width>"))
    assert(l.contains(s"output cover_chain_out : UInt<$width>"))

    val expectedCovers = List(
      "l_3", "l_0", "l_1", "l_2", "user_cov",
      "c0.l_0", "c0.user_cov_2",
      "c1.l_0", "c1.user_cov_2",
    )
    assert(chainInfo.covers == expectedCovers)
  }

  it should "initialize the counter registers in the Verilog" in {
    val width = 30
    val widthAnno = CoverageScanChainOptions(width)

    val (result, rAnnos) = compile(new Test1Module(withSubmodules = true), "verilog", Seq(widthAnno))
    // println(result)
    val l = result.split('\n').map(_.trim)

    // the coverage counter should be initialized to zero
    assert(l.contains("reg [29:0] l_3 = 30'h0;"))
  }
}
