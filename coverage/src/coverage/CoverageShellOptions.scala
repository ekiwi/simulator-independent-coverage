// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

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
    new ShellOption[Unit](
      longOption = "toggle-coverage",
      toAnnotationSeq = _ => ToggleCoverage.all,
      helpText = "enable toggle coverage instrumentation for all signals"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-ports",
      toAnnotationSeq = _ => ToggleCoverage.ports,
      helpText = "enable toggle coverage instrumentation for all I/O ports"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-registers",
      toAnnotationSeq = _ => ToggleCoverage.registers,
      helpText = "enable toggle coverage instrumentation for all registers"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-memories",
      toAnnotationSeq = _ => ToggleCoverage.memories,
      helpText = "enable toggle coverage instrumentation for all memory ports"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-wires",
      toAnnotationSeq = _ => ToggleCoverage.wires,
      helpText = "enable toggle coverage instrumentation for all wires"
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
