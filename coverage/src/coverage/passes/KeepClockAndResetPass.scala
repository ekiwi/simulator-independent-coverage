// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import coverage.midas.Builder
import firrtl._
import firrtl.annotations.CircuitTarget
import firrtl.options.Dependency
import firrtl.stage.Forms
import firrtl.transforms._

/** Marks all `clock` and `reset` signals as DontTouch so that they are not removed by
 *  Dead Code Elimination. This makes adding coverage that relies on those pins being
 *  available easier.
 */
object KeepClockAndResetPass extends Transform with DependencyAPIMigration {
  // try to run early
  override def prerequisites = Forms.Checks
  override def invalidates(a: Transform) = false
  // need to run before DCE
  override def optionalPrerequisiteOf = Seq(Dependency[DeadCodeElimination])


  override def execute(state: CircuitState): CircuitState = {
    val c = CircuitTarget(state.circuit.main)
    val annos = state.circuit.modules.flatMap(onModule(_, c))
    state.copy(annotations = annos ++ state.annotations)
  }

  private def onModule(m: ir.DefModule, c: CircuitTarget): List[DontTouchAnnotation] = m match {
    case mod: ir.Module =>
      val clock = Builder.findClocks(mod)
      // TODO: re-enable this for resets!
      //val reset = Builder.findResets(mod)
      val mRef = c.module(mod.name)
      (clock).map(e => DontTouchAnnotation(Builder.refToTarget(mRef, e))).toList
    case _ => List()
  }
}
