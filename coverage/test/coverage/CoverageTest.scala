package coverage

import org.scalatest.flatspec.AnyFlatSpec
import firrtl.ir

class CoverageTest extends AnyFlatSpec{

  "parseFileInfo" should "be robust" in {
    assert(Coverage.parseFileInfo(ir.FileInfo("Atomics.scala 35:16 Atomics.scala 35:16")) ==
      Seq("Atomics.scala" -> 35, "Atomics.scala" -> 35))
  }

}
