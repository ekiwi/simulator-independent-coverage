// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes


import firrtl._
import firrtl.annotations.{Annotation, CircuitTarget, MakePresetRegAnnotation, ModuleTarget}
import firrtl.options.Dependency
import firrtl.transforms._

import scala.collection.mutable
import scala.util.Random

/** Initializes every register with a (random at compile time) value.
 *  This can be useful when doing formal cover trace generation because
 *  it prevents the solver from choosing specific register initialization
 *  value to achieve coverage instead of choosing proper inputs.
 *
 * */
object RandomStateInit extends Transform with DependencyAPIMigration {
  // run on lowered firrtl
  override def prerequisites = Seq(Dependency(passes.ExpandWhens), Dependency(passes.LowerTypes), Dependency(transforms.RemoveReset))
  override def invalidates(a: Transform) = false
  // since we generate PresetRegAnnotations, we need to run after preset propagation
  override def optionalPrerequisites = Seq(Dependency[PropagatePresetAnnotations])

  override def execute(state: CircuitState): CircuitState = {
    val c = CircuitTarget(state.circuit.main)
    val modsAndAnnos = state.circuit.modules.map(onModule(_, c))
    val annos = modsAndAnnos.flatMap(_._2) ++ state.annotations
    val circuit = state.circuit.copy(modules = modsAndAnnos.map(_._1))
    state.copy(circuit = circuit, annotations = annos)
  }

  private def onModule(m: ir.DefModule, c: CircuitTarget): (ir.DefModule, Seq[Annotation]) = m match {
    case mod: ir.Module =>
      val rand = new Random(mod.name.hashCode)
      val annos = mutable.ListBuffer[Annotation]()
      val m = c.module(mod.name)
      val newMod = mod.mapStmt(onStmt(_, annos, m, rand))
      (newMod, annos.toList)
    case other => (other, List())
  }

  private def bitsToSigned(unsigned: BigInt, width: Int): BigInt = {
    val isNeg = ((unsigned >> (width - 1)) & 1) == 1
    if(isNeg) {
      val mask = (BigInt(1) << width) - 1
      -1 * (((~unsigned) & mask) + 1)
    } else { unsigned }
  }

  private def onStmt(s: ir.Statement, annos: mutable.ListBuffer[Annotation], m: ModuleTarget, rand: Random): ir.Statement = s match {
    case r: ir.DefRegister =>
      if(r.reset == Utils.False()) {
        val bits = firrtl.bitWidth(r.tpe).toInt

        val init = r.tpe match {
          case _ : ir.SIntType =>
            val initValue = bitsToSigned(BigInt(bits, rand), bits)
            ir.SIntLiteral(initValue, ir.IntWidth(bits))
          case _ => ir.UIntLiteral(BigInt(bits, rand), ir.IntWidth(bits))
        }
        annos.append(MakePresetRegAnnotation(m.ref(r.name)))
        r.copy(init = init)
      } else {
        logger.warn(s"[${m.module}] Cannot initialize register ${r.name} with reset: ${r.reset.serialize}")
        r
      }
    case mem: ir.DefMemory =>
      logger.warn(s"[${m.module}] TODO: add support for memory initialization of ${mem.name}")
      mem
    case other => other.mapStmt(onStmt(_, annos, m, rand))
  }
}
