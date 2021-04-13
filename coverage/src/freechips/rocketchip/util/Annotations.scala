package freechips.rocketchip.util

import firrtl.annotations._
import freechips.rocketchip.diplomacy.AddressMapEntry
import freechips.rocketchip.regmapper.RegistersSer


/** Record a sram. */
case class SRAMAnnotation(target: Named,
  address_width: Int,
  name: String,
  data_width: Int,
  depth: BigInt,
  description: String,
  write_mask_granularity: Int) extends SingleTargetAnnotation[Named] {
  def duplicate(n: Named) = this.copy(n)
}

/** Record a case class that was used to parameterize this target. */
case class ParamsAnnotation(target: Named, paramsClassName: String, params: Map[String,Any]) extends SingleTargetAnnotation[Named] {
  def duplicate(n: Named) = this.copy(n)
}

/** Record an address map. */
case class AddressMapAnnotation(target: Named, mapping: Seq[AddressMapEntry], label: String) extends SingleTargetAnnotation[Named] {
  def duplicate(n: Named) = this.copy(n)

  def toUVM: String =
    s"// Instance Name: ${target.serialize}\n" +
      mapping.map(_.range.toUVM).mkString("\n")

  def toJSON: String =
    s"""{\n  "${label}":  [\n""" +
      mapping.map(_.range.toJSON).mkString(",\n") +
      "\n  ]\n}"
}

/** Marks this module as a candidate for register retiming */
case class RetimeModuleAnnotation(target: ModuleName) extends SingleTargetAnnotation[ModuleName] {
  def duplicate(n: ModuleName) = this.copy(n)
}

case class RegFieldDescMappingAnnotation(
  target: ModuleName,
  regMappingSer: RegistersSer) extends SingleTargetAnnotation[ModuleName] {
  def duplicate(n: ModuleName): RegFieldDescMappingAnnotation = this.copy(target = n)
}