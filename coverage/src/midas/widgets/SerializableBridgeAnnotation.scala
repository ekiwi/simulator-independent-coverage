// See LICENSE for license details.

package midas.widgets

import chisel3._
import firrtl.annotations.SingleTargetAnnotation
import firrtl.annotations.{ReferenceTarget, ModuleTarget, HasSerializationHints}


// just enough code copied from firesim to be able to load
// SerializableBridgeAnnotation emitted by firesim libraries


/**
 * A serializable form of BridgeAnnotation emitted by Chisel Modules that extend Bridge
 *
 * @param target  The module representing an Bridge. Typically a black box
 *
 * @param channelNames  See BridgeAnnotation. A list of channelNames used
 *  to find associated FCCAs for this bridge
 *
 * @param widgetClass  The full class name of the BridgeModule generator
 *
 * @param widgetConstructorKey A optional, serializable object which will be passed
 *   to the constructor of the BridgeModule. Consult https://github.com/json4s/json4s#serialization to
 *   better understand what can and cannot be serialized.
 *
 *   To provide additional typeHints to the serilization/deserialization
 *   protocol mix in HasSerializationHints into your ConstructorKey's class and return
 *   additional pertinent classes
 */

case class SerializableBridgeAnnotation[T <: AnyRef](
  target: ModuleTarget,
  channelNames: Seq[String],
  widgetClass: String,
  widgetConstructorKey: Option[T])
  extends SingleTargetAnnotation[ModuleTarget] with HasSerializationHints {

  def typeHints = widgetConstructorKey match {
    // If the key has extra type hints too, grab them as well
    case Some(key: HasSerializationHints) => key.getClass +: key.typeHints
    case Some(key) => Seq(key.getClass)
    case None => Seq()
  }
  def duplicate(n: ModuleTarget) = this.copy(target)
}