package midas.passes.fame

import firrtl.RenameMap
import firrtl.annotations._

object RTRenamer {
  // TODO: determine order for multiple renames, or just check of == 1 rename?
  def exact(renames: RenameMap): (ReferenceTarget => ReferenceTarget) = {
    { rt =>
      val renameMatches = renames.get(rt).getOrElse(Seq(rt)).collect({ case rt: ReferenceTarget => rt })
      assert(renameMatches.length == 1, s"renameMatches is not 1. renameMatches length is ${renameMatches.length}")
      renameMatches.head
    }
  }

  def apply(renames: RenameMap): (ReferenceTarget => Seq[ReferenceTarget]) = {
    { rt => renames.get(rt).getOrElse(Seq(rt)).collect({ case rt: ReferenceTarget => rt }) }
  }
}

