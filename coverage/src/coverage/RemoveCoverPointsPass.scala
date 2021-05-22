// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>
package coverage

import chiseltest.coverage.ModuleInstancesAnnotation
import firrtl._
import firrtl.annotations._
import firrtl.options.Dependency

import scala.collection.mutable


/** specifies a list of cover points (refered to by their hierarchical path name) that can be removed */
case class RemoveCoverAnnotation(remove: List[String]) extends NoTargetAnnotation

/** Removes cover statements that have been covered sufficiently often */
object RemoveCoverPointsPass extends Transform with DependencyAPIMigration {
  // run on lowered firrtl
  override def prerequisites = Seq(
    Dependency(firrtl.passes.ExpandWhens), Dependency(firrtl.passes.LowerTypes),
    Dependency(firrtl.transforms.RemoveReset), Dependency(ModuleInstancesPass))

  override def invalidates(a: Transform) = false

  // we need to run after the cover points are added
  override def optionalPrerequisites = Coverage.AllPasses

  // we want to run before the actual Verilog is emitted
  override def optionalPrerequisiteOf = AllEmitters()

  override def execute(state: CircuitState): CircuitState = {
    val removePaths = state.annotations.collect { case RemoveCoverAnnotation(remove) => remove }.flatten
    if (removePaths.isEmpty) return state

    val instToMod = state.annotations.collectFirst { case ModuleInstancesAnnotation(instanceToModule) => instanceToModule }.get
    val modNames = state.circuit.modules.map(_.name)
    val remove = findStatementsToRemove(modNames, removePaths, instToMod)

    val modules = state.circuit.modules.map {
      case mod: ir.Module if remove(mod.name).nonEmpty => onModule(mod, remove(mod.name))
      case other => other
    }

    // TODO: maybe remove annotations?
    val circuit = state.circuit.copy(modules=modules)
    state.copy(circuit = circuit)
  }

  private def onModule(m: ir.Module, remove: List[String]): ir.DefModule = {
    m.mapStmt(onStmt(_, remove.toSet))
  }

  private def onStmt(s: ir.Statement, remove: String => Boolean): ir.Statement = s match {
    case v @ ir.Verification(ir.Formal.Cover, _, _, _, _, _) if remove(v.name) => ir.EmptyStmt
    case other => other.mapStmt(onStmt(_, remove))
  }

  private def findStatementsToRemove(modules: Seq[String], removePaths: Seq[String], instanceToModule: List[(String, String)]): Map[String, List[String]] = {
    // count in how many instances the cover point is requested to be removed
    val instToMod = instanceToModule.toMap
    val moduleCoverCounts = modules.map(m => m -> mutable.HashMap[String, Int]()).toMap
    removePaths.foreach { path =>
      val parts = path.split('.')
      val name = parts.last
      val instance = parts.dropRight(1).mkString(".")
      val mod = instToMod.getOrElse(instance,
        throw new RuntimeException(s"Unknown instance: $instance!")
      )
      moduleCoverCounts(mod)(name) = moduleCoverCounts(mod).getOrElse(name, 0) + 1
    }

    // for every module, remove the cover points that are requested to be removed in all instances
    modules.map { m =>
      val instanceCount = instanceToModule.count(_._2 == m)
      val remove = moduleCoverCounts(m).toList.filter(_._2 < instanceCount).map(_._1)
      m -> remove
    }.toMap
  }
}