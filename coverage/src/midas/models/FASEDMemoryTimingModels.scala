// See LICENSE for license details.
package midas
package models

import firrtl.annotations.HasSerializationHints
import freechips.rocketchip.diplomacy.{AddressSet, IdRange, TransferSizes}
import junctions._

// A serializable summary of the diplomatic edge
case class AXI4EdgeSummary(
  maxReadTransfer: Int,
  maxWriteTransfer: Int,
  idReuse: Option[Int],
  maxFlight: Option[Int],
  address: Seq[AddressSet]
) {
  def targetAddressOffset(): BigInt = address.map(_.base).min
}

case class BaseParams(
  // Pessimistically provisions the functional model. Don't be cheap:
  // underprovisioning will force functional model to assert backpressure on
  // target AW. W or R channels, which may lead to unexpected bandwidth throttling.
  maxReads: Int,
  maxWrites: Int,

  // AREA OPTIMIZATIONS:
  // AXI4 bursts(INCR) can be 256 beats in length -- some
  // area can be saved if the target design only issues smaller requests
  maxReadLength: Int = 256,
  maxReadsPerID: Option[Int] = None,
  maxWriteLength: Int = 256,
  maxWritesPerID: Option[Int] = None,

  // DEBUG FEATURES
  // Check for collisions in pending reads and writes to the host memory system
  // May produce false positives in timing models that reorder requests
  detectAddressCollisions: Boolean = false,

  // HOST INSTRUMENTATION
  stallEventCounters: Boolean = false, // To track causes of target-time stalls
  localHCycleCount: Boolean = false, // Host Cycle Counter
  latencyHistograms: Boolean = false, // Creates a BRAM histogram of various system latencies


  // BASE TIMING-MODEL INSTRUMENTATION
  xactionCounters: Boolean = true, // Numbers of read and write AXI4 xactions
  beatCounters: Boolean = false, // Numbers of read and write beats in AXI4 xactions
  targetCycleCounter: Boolean = false, // Redundant in a full simulator; useful for testing

  // Number of xactions in flight in a given cycle. Bin N contains the range
  // (occupancyHistograms[N-1], occupancyHistograms[N]]
  occupancyHistograms: Seq[Int] = Seq(0, 2, 4, 8),
  addrRangeCounters: BigInt = BigInt(0)
)

abstract class BaseConfig {

}


// Need to wrap up all the parameters in a case class for serialization. The edge and width
// were previously passed in via the target's Parameters object
case class CompleteConfig(
  userProvided: BaseConfig,
  axi4Widths: NastiParameters,
  axi4Edge: Option[AXI4EdgeSummary] = None,
  memoryRegionName: Option[String] = None) extends HasSerializationHints {
  def typeHints(): Seq[Class[_]] = Seq(userProvided.getClass)
}
