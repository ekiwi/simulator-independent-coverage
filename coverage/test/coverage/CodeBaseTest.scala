// SPDX-License-Identifier: Apache-2.0

package coverage

import org.scalatest.flatspec.AnyFlatSpec

class CodeBaseTest extends AnyFlatSpec {
  behavior of "CodeBase"

  it should "read in a code base" in {
    val c = new CodeBase(os.pwd / "test")

    // TODO: test warn about duplicates
    //c.warnAboutDuplicates()
    // assert(c.duplicateKeys == List("package.scala"))
    // assert(c.isDuplicate("package.scala"))
    assert(!c.isDuplicate("CodeBaseTest.scala"))

    // get this line
    assert(c.getLine("CodeBaseTest.scala", 19).get.trim == "// get this line")
  }
}