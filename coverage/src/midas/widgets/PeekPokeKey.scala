package midas.widgets

import midas.widgets.SerializationUtils.SerializableField

case class PeekPokeKey(
  peeks: Seq[SerializableField],
  pokes: Seq[SerializableField],
  maxChannelDecoupling: Int = 2)