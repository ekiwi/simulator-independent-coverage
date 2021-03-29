/*
 * Copyright: 2014, Technical University of Denmark, DTU Compute
 * Author: Martin Schoeberl (martin@jopdesign.com)
 * License: Simplified BSD License
 *
 * Play with FIFO buffers.
 *
 * This code is a copy from the chisel-examples repo for easier
 * inclusion in the Chisel book.
 *
 * Modified by Kevin Laeufer.
 *
 */

package coverage.circuits

import chisel3._
import chisel3.experimental.ChiselEnum

class WriterIO(size: Int) extends Bundle {
  val write = Input(Bool())
  val full = Output(Bool())
  val din = Input(UInt(size.W))
}
//- end

//- start bubble_fifo_reader_io
class ReaderIO(size: Int) extends Bundle {
  val read = Input(Bool())
  val empty = Output(Bool())
  val dout = Output(UInt(size.W))
}
//- end

object State extends ChiselEnum {
  val Empty, Full = Value
}

/**
 * A single register (=stage) to build the FIFO.
 */
//- start bubble_fifo_register
class FifoRegister(size: Int) extends Module {
  val io = IO(new Bundle {
    val enq = new WriterIO(size)
    val deq = new ReaderIO(size)
  })

  val stateReg = RegInit(State.Empty)
  val dataReg = RegInit(0.U(size.W))

  when(stateReg === State.Empty) {
    when(io.enq.write) {
      stateReg := State.Full
      dataReg := io.enq.din
    }
  }.elsewhen(stateReg === State.Full) {
    when(io.deq.read) {
      stateReg := State.Empty
      dataReg := 0.U // just to better see empty slots in the waveform
    }
  }.otherwise {
    // There should not be an otherwise state
  }

  io.enq.full := (stateReg === State.Full)
  io.deq.empty := (stateReg === State.Empty)
  io.deq.dout := dataReg
}