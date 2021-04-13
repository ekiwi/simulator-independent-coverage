package testchipip

case class TracedInstructionWidths(iaddr: Int, insn: Int, wdata: Option[Int], cause: Int, tval: Int)