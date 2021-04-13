package midas.widgets

import firrtl.annotations._

/**
 * Defines a generated clock as a rational multiple of some reference clock. The generated
 * clock has a frequency (multiplier / divisor) times that of reference.
 *
 * @param name An identifier for the associated clock domain
 *
 * @param multiplier See class comment.
 *
 * @param divisor See class comment.
 */
case class RationalClock(name: String, multiplier: Int, divisor: Int) {
  def simplify: RationalClock = {
    val gcd = BigInt(multiplier).gcd(BigInt(divisor)).intValue
    RationalClock(name, multiplier / gcd, divisor / gcd)
  }

  def equalFrequency(that: RationalClock): Boolean =
    this.simplify.multiplier == that.simplify.multiplier &&
      this.simplify.divisor == that.simplify.divisor
}

sealed trait ClockBridgeConsts {
  val clockChannelName = "clocks"
}

/**
 * A custom bridge annotation for the Clock Bridge. Unique so that we can
 * trivially match against it in bridge extraction.
 *
 * @param target The target-side module for the CB
 *
 * @param clocks The associated clock information for each output clock
 *
 */

case class ClockBridgeAnnotation(val target: ModuleTarget, clocks: Seq[RationalClock])
  extends SingleTargetAnnotation[ModuleTarget] with ClockBridgeConsts {
  val channelNames = Seq(clockChannelName)
  def duplicate(n: ModuleTarget) = this.copy(target)
}