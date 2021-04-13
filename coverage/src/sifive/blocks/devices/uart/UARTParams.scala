package sifive.blocks.devices.uart

case class UARTParams(
  address: BigInt,
  dataBits: Int = 8,
  stopBits: Int = 2,
  divisorBits: Int = 16,
  oversample: Int = 4,
  nSamples: Int = 3,
  nTxEntries: Int = 8,
  nRxEntries: Int = 8,
  includeFourWire: Boolean = false,
  includeParity: Boolean = false,
  includeIndependentParity: Boolean = false, // Tx and Rx have opposite parity modes
  initBaudRate: BigInt = BigInt(115200),
)