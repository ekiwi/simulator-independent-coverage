package midas.passes.fame

import firrtl.RenameMap
import firrtl.annotations._
import midas.widgets.RationalClock


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

  def getBridgeModule(): String = sources.getOrElse(sinks.get).head.module

  def moveFromBridge(portName: String): FAMEChannelConnectionAnnotation = {
    def updateRT(rT: ReferenceTarget): ReferenceTarget = ModuleTarget(rT.circuit, rT.circuit).ref(portName).field(rT.ref)

    require(sources == None || sinks == None, "Bridge-connected channels cannot loopback")
    val rTs = sources.getOrElse(sinks.get) ++ clock ++ (channelInfo match {
      case i: DecoupledForwardChannel => Seq(i.readySink.getOrElse(i.readySource.get))
      case other => Seq()
    })

    val localRenames = RenameMap(Map((rTs.map(rT => rT -> Seq(updateRT(rT)))):_*))
    copy(globalName = s"${portName}_${globalName}").update(localRenames).head.asInstanceOf[this.type]
  }

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

/**
 * Indicates that a channel connection is the reverse (ready) half of
 * a decoupled target connection. Since the forward half incorporates
 * references to the ready signals, this channel contains no signal
 * references.
 */
case object DecoupledReverseChannel extends FAMEChannelInfo

/**
 * Indicates that a channel connection carries target clocks
 */
case class TargetClockChannel(clockInfo: Seq[RationalClock])  extends FAMEChannelInfo

/**
 * Indicates that a channel connection is the forward (valid) half of
 * a decoupled target connection.
 *
 * @param readySink  sink port component of the corresponding reverse channel
 *
 * @param validSource  valid port component from this channel's sources
 *
 * @param readySource  source port component of the corresponding reverse channel
 *
 * @param validSink  valid port component from this channel's sinks
 *
 * @note  (readySink, validSource) are on one model, (readySource, validSink) on the other
 */
case class DecoupledForwardChannel(
  readySink: Option[ReferenceTarget],
  validSource: Option[ReferenceTarget],
  readySource: Option[ReferenceTarget],
  validSink: Option[ReferenceTarget]) extends FAMEChannelInfo {
  override def update(renames: RenameMap): DecoupledForwardChannel = {
    val renamer = RTRenamer.exact(renames)
    DecoupledForwardChannel(
      readySink.map(renamer),
      validSource.map(renamer),
      readySource.map(renamer),
      validSink.map(renamer))
  }
}

// Helper factory methods for generating bridge annotations that have only sinks or sources
object DecoupledForwardChannel {
  def sink(valid: ReferenceTarget, ready: ReferenceTarget) =
    DecoupledForwardChannel(None, None, Some(ready), Some(valid))

  def source(valid: ReferenceTarget, ready: ReferenceTarget) =
    DecoupledForwardChannel(Some(ready), Some(valid), None, None)
}