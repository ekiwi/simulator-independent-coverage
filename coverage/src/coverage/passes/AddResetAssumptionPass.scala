// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes


import coverage.midas.Builder
import firrtl._
import firrtl.annotations._
import firrtl.options.Dependency
import firrtl.transforms._

import scala.collection.mutable

/** adds an assumption to the toplevel module that all resets are active in the first cycle */
object AddResetAssumptionPass extends Transform with DependencyAPIMigration {
  // run on lowered firrtl
  override def prerequisites = Seq(
    Dependency(firrtl.passes.ExpandWhens), Dependency(firrtl.passes.LowerTypes),
    Dependency(firrtl.transforms.RemoveReset))
  override def invalidates(a: Transform) = false
  // since we generate PresetRegAnnotations, we need to run after preset propagation
  override def optionalPrerequisites = Seq(Dependency[PropagatePresetAnnotations])

  override def execute(state: CircuitState): CircuitState = {
    val annos = mutable.ListBuffer[Annotation]()
    val modules = state.circuit.modules.map {
      case mod: ir.Module if mod.name == state.circuit.main => onMain(mod, annos)
      case other => other
    }

    state.copy(circuit = state.circuit.copy(modules = modules), annotations = annos.toList ++: state.annotations)
  }

  private def onMain(m: ir.Module, annos: mutable.ListBuffer[Annotation]): ir.Module = {
    val resets = Builder.findResets(m)
    val clock = Builder.findClock(m ,logger)
    if(resets.isEmpty || clock.isEmpty) return m

    // create a register to know when we are in the "init" cycle
    val namespace = Namespace(m)
    val reg = ir.DefRegister(ir.NoInfo, namespace.newName("isInitCycle"),
      Utils.BoolType, clock.get, reset = Utils.False(), init = Utils.True())
    val regRef = ir.Reference(reg)
    val next = ir.Connect(ir.NoInfo, regRef, Utils.False())
    annos.append(MakePresetRegAnnotation(CircuitTarget(m.name).module(m.name).ref(reg.name)))

    // assume that isInitCycle => reset
    val resetAssumptions = resets.map { r =>
      ir.Verification(ir.Formal.Assume, ir.NoInfo, clock.get, r, regRef, ir.StringLit(""), namespace.newName(r.serialize + "_active"))
    }

    val body = ir.Block(Seq(m.body, reg, next) ++ resetAssumptions)

    m.copy(body = body)
  }
}
