// SPDX-License-Identifier: Apache-2.0

package coverage

import firrtl.annotations.{CircuitTarget, ModuleTarget}
import firrtl.options._

final class CoverageShellOptions extends RegisteredLibrary {
  override def name = "Coverage"

  override def options = Seq(
    new ShellOption[Unit](
      longOption = "line-coverage",
      toAnnotationSeq = _ => LineCoverage.annotations,
      helpText = "enable line coverage instrumentation"
    ),
    new ShellOption[Unit](
      longOption = "fsm-coverage",
      toAnnotationSeq = _ => FsmCoverage.annotations,
      helpText = "enable finite state machine coverage instrumentation"
    ),
    new ShellOption[String](
      longOption = "do-not-cover",
      toAnnotationSeq = a => Seq(DoNotCoverAnnotation(parseModuleTarget(a))),
      helpText = "select module which should not be instrumented with coverage",
      helpValueName = Some("<circuit:module>")
    ),
  )

  private def parseModuleTarget(a: String): ModuleTarget = {
    val parts = a.trim.split(':').toSeq
    parts match {
      case Seq(circuit, module) => CircuitTarget(circuit.trim).module(module.trim)
      case _ => throw new RuntimeException(s"Expected format: <circuit:module>, not: $a")
    }
  }
}
