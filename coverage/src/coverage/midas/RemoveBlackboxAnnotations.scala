package coverage.midas

import firrtl._
import firrtl.options.Dependency
import firrtl.transforms._
import logger.LogLevelAnnotation

/** Removed all firrtl.transforms.BlackBoxResourceAnno annotation (this is required to make our Firesim Flow work). */
object RemoveBlackboxAnnotations extends Transform with DependencyAPIMigration {
  override def prerequisites = Seq()
  override def optionalPrerequisiteOf = Seq(Dependency[BlackBoxSourceHelper])
  override def invalidates(a: Transform) = false

  override def execute(state: CircuitState): CircuitState = {
    val annos = state.annotations.filterNot {
      case _: BlackBoxResourceAnno => true
      case _: BlackBoxResourceFileNameAnno => true
      case _: LogLevelAnnotation => true
      case _ => false
    }
    state.copy(annotations=annos)
  }
}
