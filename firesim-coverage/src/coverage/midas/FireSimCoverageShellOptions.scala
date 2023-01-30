// Copyright 2021-2023 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>
package coverage.midas

import firrtl.options.{Dependency, RegisteredLibrary, ShellOption}
import firrtl.stage.RunFirrtlTransformAnnotation

final class FireSimCoverageShellOptions extends RegisteredLibrary {
  override def name = "FireSimCoverage"

  override def options = Seq(
    new ShellOption[Unit](
      longOption = "cover-scan-chain",
      toAnnotationSeq = _ => Seq(RunFirrtlTransformAnnotation(Dependency(CoverageScanChainPass))),
      helpText = "schedules the cover scan chain pass to run, needs a CoverageScanChainOptions annotation for the pass to have any effect"
    ),
    new ShellOption[String](
      longOption = "cover-scan-chain-width",
      toAnnotationSeq = a => Seq(RunFirrtlTransformAnnotation(Dependency(CoverageScanChainPass)),
        CoverageScanChainOptions(a.toInt)),
      helpText = "replace all cover statements with hardware counters of <WIDTH> and a scan chain"
    ),
    new ShellOption[Unit](
      longOption = "remove-blackbox-annos",
      toAnnotationSeq = _ => Seq(RunFirrtlTransformAnnotation(Dependency(RemoveBlackboxAnnotations))),
      helpText = "removes all Blackbox resource annotations"
    ),
  )
}