// See LICENSE for license details.

package midas.widgets

import firrtl.annotations._


/**
  * An BridgeAnnotation that references the IO created by BridgeExtraction after it has promoted and removed
  * all modules annotated with BridgeAnnotations.
  *
  * @param target  The IO corresponding to and Bridge's interface
  *
  * @param channelMapping A mapping from the channel names initially emitted by the Chisel Module, to uniquified global ones
  *  to find associated FCCAs for this bridge
  *
  * @param clockInfo Contains information about the domain in which the bridge is instantiated. 
  *  This will always be nonEmpty for bridges instantiated in the input FIRRTL
  *
  * @param widgetClass The BridgeModule's full class name. See BridgeAnnotation
  *
  * @param widgetConstructorKey The BridgeModule's constructor argument.
  *
  */

case class BridgeIOAnnotation(
    target: ReferenceTarget,
    channelMapping: Map[String, String],
    clockInfo: Option[Any] = None,
    widgetClass: String,
    widgetConstructorKey: Option[_ <: AnyRef] = None)
    extends SingleTargetAnnotation[ReferenceTarget] with HasSerializationHints {

  def typeHints() = widgetConstructorKey match {
    // If the key has extra type hints too, grab them as well
    case Some(key: HasSerializationHints) => key.getClass +: key.typeHints
    case Some(key) => Seq(key.getClass)
    case None => Seq()
  }
  def duplicate(n: ReferenceTarget) = this.copy(target)
  def channelNames = channelMapping.values
}

object BridgeIOAnnotation {
  // Useful when a pass emits these annotations directly; (they aren't promoted from BridgeAnnotation)
  def apply(target: ReferenceTarget,
            channelNames: Seq[String],
            widgetClass: String,
            widgetConstructorKey: AnyRef): BridgeIOAnnotation =
   BridgeIOAnnotation(
      target,
      channelNames.map(p => p -> p).toMap,
      widgetClass = widgetClass,
      widgetConstructorKey = Some(widgetConstructorKey))
}
