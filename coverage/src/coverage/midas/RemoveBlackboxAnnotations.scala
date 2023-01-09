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
      case _: BlackBoxResourceFileNameAnno => true
      // the LogLevelAnnotation is als wreaking havoc with our Firesim setup!
      case _: LogLevelAnnotation => true
      case _ => false
    }
    state.copy(annotations=annos)
  }
}
