// See LICENSE for license details.

package midas.targetutils


import firrtl.RenameMap
import firrtl.annotations._
import firrtl.transforms.DontTouchAllTargets


case class FirrtlFpgaDebugAnnotation(target: ComponentName) extends
  SingleTargetAnnotation[ComponentName] with DontTouchAllTargets {
  def duplicate(n: ComponentName) = this.copy(target = n)
}

private[midas] class ReferenceTargetRenamer(renames: RenameMap) {
  // TODO: determine order for multiple renames, or just check of == 1 rename?
  def exactRename(rt: ReferenceTarget): ReferenceTarget = {
    val renameMatches = renames.get(rt).getOrElse(Seq(rt)).collect({ case rt: ReferenceTarget => rt })
    assert(renameMatches.length == 1,
      s"${rt} should be renamed exactly once. Suggested renames: ${renameMatches}")
    renameMatches.head
  }

  def apply(rt: ReferenceTarget): Seq[ReferenceTarget] = {
    renames.get(rt).getOrElse(Seq(rt)).collect({ case rt: ReferenceTarget => rt })
  }
}

private [midas] case class SynthPrintfAnnotation(
  args: Seq[Seq[ReferenceTarget]], // These aren't currently used; here for future proofing
  mod: ModuleTarget,
  format: String,
  name: Option[String]) extends firrtl.annotations.Annotation {

  def update(renames: RenameMap): Seq[firrtl.annotations.Annotation] = {
    val renamer = new ReferenceTargetRenamer(renames)
    val renamedArgs = args.map(_.flatMap(renamer(_)))
    val renamedMod = renames.get(mod).getOrElse(Seq(mod)).collect({ case mt: ModuleTarget => mt })
    assert(renamedMod.size == 1) // To implement: handle module duplication or deletion
    Seq(this.copy(args = renamedArgs, mod = renamedMod.head ))
  }
}


/**
 * A mixed-in ancestor trait for all FAME annotations, useful for type-casing.
 */
trait FAMEAnnotation {
  this: Annotation =>
}


case class FirrtlFAMEModelAnnotation(
  target: InstanceTarget) extends SingleTargetAnnotation[InstanceTarget] with FAMEAnnotation {
  def targets = Seq(target)
  def duplicate(n: InstanceTarget) = this.copy(n)
}

/**
 * This specifies that the module should be automatically multi-threaded (FIRRTL annotation).
 */
case class FirrtlEnableModelMultiThreadingAnnotation(
  target: InstanceTarget) extends SingleTargetAnnotation[InstanceTarget] with FAMEAnnotation {
  def targets = Seq(target)
  def duplicate(n: InstanceTarget) = this.copy(n)
}

case class FirrtlMemModelAnnotation(target: ReferenceTarget) extends
  SingleTargetAnnotation[ReferenceTarget] {
  def duplicate(rt: ReferenceTarget) = this.copy(target = rt)
}

case class ExcludeInstanceAssertsAnnotation(target: (String, String)) extends
  firrtl.annotations.NoTargetAnnotation {
  def duplicate(n: (String, String)) = this.copy(target = n)
}

/**
 * AutoCounter annotations. Do not emit the FIRRTL annotations unless you are
 * writing a target transformation, use the Chisel-side [[PerfCounter]] object
 * instead.
 *
 */
case class AutoCounterFirrtlAnnotation(
  target: ReferenceTarget,
  clock: ReferenceTarget,
  reset: ReferenceTarget,
  label: String,
  message: String,
  coverGenerated: Boolean = false)
  extends firrtl.annotations.Annotation with DontTouchAllTargets {
  def update(renames: RenameMap): Seq[firrtl.annotations.Annotation] = {
    val renamer = new ReferenceTargetRenamer(renames)
    val renamedTarget = renamer.exactRename(target)
    val renamedClock  = renamer.exactRename(clock)
    val renamedReset  = renamer.exactRename(reset)
    Seq(this.copy(target = renamedTarget, clock = renamedClock, reset = renamedReset))
  }
  // The AutoCounter tranform will reject this annotation if it's not enclosed
  def shouldBeIncluded(modList: Seq[String]): Boolean = !coverGenerated || modList.contains(target.module)
  def enclosingModule(): String = target.module
  def enclosingModuleTarget(): ModuleTarget = ModuleTarget(target.circuit, enclosingModule)
}

case class AutoCounterCoverModuleFirrtlAnnotation(target: ModuleTarget) extends
  SingleTargetAnnotation[ModuleTarget] with FAMEAnnotation {
  def duplicate(n: ModuleTarget) = this.copy(target = n)
}


// Need serialization utils to be upstreamed to FIRRTL before i can use these.
//sealed trait TriggerSourceType
//case object Credit extends TriggerSourceType
//case object Debit extends TriggerSourceType

case class TriggerSourceAnnotation(
  target: ReferenceTarget,
  clock: ReferenceTarget,
  reset: Option[ReferenceTarget],
  sourceType: Boolean) extends Annotation with FAMEAnnotation with DontTouchAllTargets {
  def update(renames: RenameMap): Seq[firrtl.annotations.Annotation] = {
    val renamer = new ReferenceTargetRenamer(renames)
    val renamedTarget = renamer.exactRename(target)
    val renamedClock  = renamer.exactRename(clock)
    val renamedReset  = reset map renamer.exactRename
    Seq(this.copy(target = renamedTarget, clock = renamedClock, reset = renamedReset))
  }
  def enclosingModuleTarget(): ModuleTarget = ModuleTarget(target.circuit, target.module)
  def enclosingModule(): String = target.module
}


case class TriggerSinkAnnotation(
  target: ReferenceTarget,
  clock: ReferenceTarget) extends Annotation with FAMEAnnotation with DontTouchAllTargets {
  def update(renames: RenameMap): Seq[firrtl.annotations.Annotation] = {
    val renamer = new ReferenceTargetRenamer(renames)
    val renamedTarget = renamer.exactRename(target)
    val renamedClock  = renamer.exactRename(clock)
    Seq(this.copy(target = renamedTarget, clock = renamedClock))
  }
  def enclosingModuleTarget(): ModuleTarget = ModuleTarget(target.circuit, target.module)
}