package fuzzing.harness

import chiseltest.simulator.SimulatorContext
import firrtl.annotations.NoTargetAnnotation
import fuzzing.TopmoduleInfo

trait FuzzHarness {
  def start(input: java.io.InputStream, sim: SimulatorContext): Unit
  // returns true when done
  def step(sim: SimulatorContext): Boolean
}

trait FuzzHarnessAnnotation extends NoTargetAnnotation {
  def makeHarness(info: TopmoduleInfo): FuzzHarness
}
