package midas.passes.fame

import firrtl.RenameMap
import firrtl.annotations._


case class FAMEChannelConnectionAnnotation(
  globalName: String,
  channelInfo: FAMEChannelInfo,
  clock: Option[ReferenceTarget],
  sources: Option[Seq[ReferenceTarget]],
  sinks: Option[Seq[ReferenceTarget]]) extends Annotation with HasSerializationHints {
  def update(renames: RenameMap): Seq[Annotation] = {
    val renamer = RTRenamer.exact(renames)
    Seq(FAMEChannelConnectionAnnotation(globalName, channelInfo.update(renames), clock.map(renamer), sources.map(_.map(renamer)), sinks.map(_.map(renamer))))
  }
  def typeHints: Seq[Class[_]] = Seq(channelInfo.getClass)
  override def getTargets: Seq[ReferenceTarget] = clock ++: (sources.toSeq.flatten ++ sinks.toSeq.flatten)
}


/**
 * Describes the type of the channel (Wire, Forward/Reverse
 * Decoupled)
 */
sealed trait FAMEChannelInfo {
  def update(renames: RenameMap): FAMEChannelInfo = this
}


/**
 * Indicates that a channel connection is a pipe with <latency> register stages
 * Setting latency = 0 models a wire
 *
 * TODO: How to handle registers that are reset? Add an Option[RT]?
 */
case class PipeChannel(val latency: Int) extends FAMEChannelInfo
