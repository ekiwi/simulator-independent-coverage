// SPDX-License-Identifier: Apache-2.0

package coverage

import firrtl.options._

final class CoverageShellOptions extends RegisteredLibrary {
  override def name = "Coverage"

  override def options = Seq(
    new ShellOption[Unit](
      longOption = "line-coverage",
      toAnnotationSeq = _ => LineCoverage.annotations,
      helpText = "enable line coverage instrumentation"
  ))
}
