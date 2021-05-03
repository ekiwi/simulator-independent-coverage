package coverage.midas

import coverage.{Coverage, CoverageStatisticsPass, ModuleInstancesPass}
import firrtl._
import firrtl.options.Dependency
import firrtl.transforms.EnsureNamedStatements

/** Removed all names from statements for FIRRTL 1.4 compatibility. */
object RemoveStatementNames extends Transform with DependencyAPIMigration {
  override def prerequisites = Seq()
  override def optionalPrerequisites = Coverage.AllPasses ++ Seq(
    Dependency(CoverageScanChainPass), Dependency(ModuleInstancesPass)
  )
  override def invalidates(a: Transform) = a match {
    case EnsureNamedStatements => true
    case _ => false
  }

  override def execute(state: CircuitState): CircuitState = {
    val circuit = state.circuit.mapModule(onModule)
    state.copy(circuit=circuit)
  }
  private def onModule(m: ir.DefModule): ir.DefModule = m match {
    case e: ir.ExtModule => e
    case mod: ir.Module => mod.mapStmt(onStmt)
  }
  private def onStmt(s: ir.Statement): ir.Statement = s match {
    case s : ir.Print => s.withName("")
    case s : ir.Stop => s.withName("")
    case s : ir.Verification => s.withName("")
    case other => other.mapStmt(onStmt)
  }
}
