// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import coverage.midas.{CoverageScanChainPass, RemoveStatementNames}
import firrtl.annotations.{CircuitTarget, ModuleTarget}
import firrtl.options._
import firrtl.stage.RunFirrtlTransformAnnotation

final class CoverageShellOptions extends RegisteredLibrary {
  override def name = "Coverage"

  override def options = Seq(
    new ShellOption[Unit](
      longOption = "line-coverage",
      toAnnotationSeq = _ => LineCoverage.annotations ++ Common,
      helpText = "enable line coverage instrumentation"
    ),
    new ShellOption[Unit](
      longOption = "fsm-coverage",
      toAnnotationSeq = _ => FsmCoverage.annotations ++ Common,
      helpText = "enable finite state machine coverage instrumentation"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage",
      toAnnotationSeq = _ => ToggleCoverage.all ++ Common,
      helpText = "enable toggle coverage instrumentation for all signals"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-ports",
      toAnnotationSeq = _ => ToggleCoverage.ports ++ Common,
      helpText = "enable toggle coverage instrumentation for all I/O ports"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-registers",
      toAnnotationSeq = _ => ToggleCoverage.registers ++ Common,
      helpText = "enable toggle coverage instrumentation for all registers"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-memories",
      toAnnotationSeq = _ => ToggleCoverage.memories ++ Common,
      helpText = "enable toggle coverage instrumentation for all memory ports"
    ),
    new ShellOption[Unit](
      longOption = "toggle-coverage-wires",
      toAnnotationSeq = _ => ToggleCoverage.wires ++ Common,
      helpText = "enable toggle coverage instrumentation for all wires"
    ),
    new ShellOption[String](
      longOption = "do-not-cover",
      toAnnotationSeq = a => Seq(DoNotCoverAnnotation(parseModuleTarget(a))),
      helpText = "select module which should not be instrumented with coverage",
      helpValueName = Some("<circuit:module>")
    ),
    new ShellOption[Unit](
      longOption = "emit-cover-info",
      toAnnotationSeq = _ => Seq(RunFirrtlTransformAnnotation(Dependency(CoverageInfoEmitter))),
      helpText = "write coverage information to a .cover.json file"
    ),
    new ShellOption[Unit](
      longOption = "cover-scan-chain",
      toAnnotationSeq = _ => Seq(RunFirrtlTransformAnnotation(Dependency(CoverageScanChainPass))),
      helpText = "replace all cover statements with hardware counters and a scan chain"
    ),
    new ShellOption[Unit](
      longOption = "remove-statement-names",
      toAnnotationSeq = _ => Seq(RunFirrtlTransformAnnotation(Dependency(RemoveStatementNames))),
      helpText = "ensures that the output can be parsed by a firrt 1.4 compiler which does not support named statements"
    ),
  )

  private def parseModuleTarget(a: String): ModuleTarget = {
    val parts = a.trim.split(':').toSeq
    parts match {
      case Seq(circuit, module) => CircuitTarget(circuit.trim).module(module.trim)
      case _ => throw new RuntimeException(s"Expected format: <circuit:module>, not: $a")
    }
  }

  private val Common = Seq(RunFirrtlTransformAnnotation(Dependency(CoverageStatisticsPass)))
}
