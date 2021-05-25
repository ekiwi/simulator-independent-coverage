circuit NeuromorphicProcessor :
  extmodule ClockBufferBB :
    input I : Clock
    input CE : UInt<1>
    output O : Clock
    defname = ClockBufferBB

  module ClockBufferVerilog :
    input clock : Clock
    input reset : UInt<1>
    input io_I : Clock
    input io_CE : UInt<1>
    output io_O : Clock

    inst bb of ClockBufferBB @[ClockBuffer.scala 46:18]
    io_O <= bb.O @[ClockBuffer.scala 47:6]
    bb.I <= io_I @[ClockBuffer.scala 47:6]
    bb.CE <= io_CE @[ClockBuffer.scala 47:6]

  module TrueDualPortMemory :
    input io_clka : Clock
    input io_ena : UInt<1>
    input io_wea : UInt<1>
    input io_addra : UInt<9>
    input io_dia : UInt<9>
    output io_doa : UInt<9>
    input io_clkb : Clock
    input io_enb : UInt<1>
    input io_web : UInt<1>
    input io_addrb : UInt<9>
    input io_dib : UInt<9>
    output io_dob : UInt<9>

    mem ram : @[TrueDualPortMemory.scala 28:24]
      data-type => UInt<9>
      depth => 512
      read-latency => 1
      write-latency => 1
      reader => io_doa_MPORT
      reader => io_dob_MPORT
      writer => MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _GEN_0 = validif(io_wea, io_addra) @[TrueDualPortMemory.scala 34:20 35:12]
    node _GEN_1 = validif(io_wea, io_clka) @[TrueDualPortMemory.scala 34:20 35:12]
    node _GEN_2 = mux(io_wea, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 34:20 35:12 28:24]
    node _GEN_3 = validif(io_wea, UInt<1>("h1")) @[TrueDualPortMemory.scala 34:20 35:23]
    node _GEN_4 = validif(io_wea, io_dia) @[TrueDualPortMemory.scala 34:20 35:23]
    node _GEN_5 = validif(io_ena, _GEN_0) @[TrueDualPortMemory.scala 33:18]
    node _GEN_6 = validif(io_ena, _GEN_1) @[TrueDualPortMemory.scala 33:18]
    node _GEN_7 = mux(io_ena, _GEN_2, UInt<1>("h0")) @[TrueDualPortMemory.scala 33:18 28:24]
    node _GEN_8 = validif(io_ena, _GEN_3) @[TrueDualPortMemory.scala 33:18]
    node _GEN_9 = validif(io_ena, _GEN_4) @[TrueDualPortMemory.scala 33:18]
    node _GEN_10 = validif(io_ena, io_addra) @[TrueDualPortMemory.scala 33:18 37:20]
    node _GEN_11 = validif(io_ena, io_clka) @[TrueDualPortMemory.scala 33:18 37:20]
    node _GEN_12 = mux(io_ena, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 33:18 37:20 28:24]
    node _GEN_13 = validif(io_ena, ram.io_doa_MPORT.data) @[TrueDualPortMemory.scala 33:18 37:14]
    node _GEN_14 = validif(io_web, io_addrb) @[TrueDualPortMemory.scala 45:20 46:12]
    node _GEN_15 = validif(io_web, io_clkb) @[TrueDualPortMemory.scala 45:20 46:12]
    node _GEN_16 = mux(io_web, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 45:20 46:12 28:24]
    node _GEN_17 = validif(io_web, UInt<1>("h1")) @[TrueDualPortMemory.scala 45:20 46:23]
    node _GEN_18 = validif(io_web, io_dib) @[TrueDualPortMemory.scala 45:20 46:23]
    node _GEN_19 = validif(io_enb, _GEN_14) @[TrueDualPortMemory.scala 44:18]
    node _GEN_20 = validif(io_enb, _GEN_15) @[TrueDualPortMemory.scala 44:18]
    node _GEN_21 = mux(io_enb, _GEN_16, UInt<1>("h0")) @[TrueDualPortMemory.scala 44:18 28:24]
    node _GEN_22 = validif(io_enb, _GEN_17) @[TrueDualPortMemory.scala 44:18]
    node _GEN_23 = validif(io_enb, _GEN_18) @[TrueDualPortMemory.scala 44:18]
    node _GEN_24 = validif(io_enb, io_addrb) @[TrueDualPortMemory.scala 44:18 48:20]
    node _GEN_25 = validif(io_enb, io_clkb) @[TrueDualPortMemory.scala 44:18 48:20]
    node _GEN_26 = mux(io_enb, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 44:18 48:20 28:24]
    node _GEN_27 = validif(io_enb, ram.io_dob_MPORT.data) @[TrueDualPortMemory.scala 44:18 48:14]
    io_doa <= _GEN_13
    io_dob <= _GEN_27
    ram.io_doa_MPORT.addr <= _GEN_10
    ram.io_doa_MPORT.en <= _GEN_12
    ram.io_doa_MPORT.clk <= _GEN_11
    ram.io_dob_MPORT.addr <= _GEN_24
    ram.io_dob_MPORT.en <= _GEN_26
    ram.io_dob_MPORT.clk <= _GEN_25
    ram.MPORT.addr <= _GEN_5
    ram.MPORT.en <= _GEN_7
    ram.MPORT.clk <= _GEN_6
    ram.MPORT.data <= _GEN_9
    ram.MPORT.mask <= _GEN_8
    ram.MPORT_1.addr <= _GEN_19
    ram.MPORT_1.en <= _GEN_21
    ram.MPORT_1.clk <= _GEN_20
    ram.MPORT_1.data <= _GEN_23
    ram.MPORT_1.mask <= _GEN_22

  module TrueDualPortMemory_2 :
    input io_clka : Clock
    input io_ena : UInt<1>
    input io_wea : UInt<1>
    input io_addra : UInt<4>
    input io_dia : UInt<8>
    output io_doa : UInt<8>
    input io_clkb : Clock
    input io_enb : UInt<1>
    input io_web : UInt<1>
    input io_addrb : UInt<4>
    input io_dib : UInt<8>
    output io_dob : UInt<8>

    mem ram : @[TrueDualPortMemory.scala 28:24]
      data-type => UInt<8>
      depth => 16
      read-latency => 1
      write-latency => 1
      reader => io_doa_MPORT
      reader => io_dob_MPORT
      writer => MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _GEN_0 = validif(io_wea, io_addra) @[TrueDualPortMemory.scala 34:20 35:12]
    node _GEN_1 = validif(io_wea, io_clka) @[TrueDualPortMemory.scala 34:20 35:12]
    node _GEN_2 = mux(io_wea, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 34:20 35:12 28:24]
    node _GEN_3 = validif(io_wea, UInt<1>("h1")) @[TrueDualPortMemory.scala 34:20 35:23]
    node _GEN_4 = validif(io_wea, io_dia) @[TrueDualPortMemory.scala 34:20 35:23]
    node _GEN_5 = validif(io_ena, _GEN_0) @[TrueDualPortMemory.scala 33:18]
    node _GEN_6 = validif(io_ena, _GEN_1) @[TrueDualPortMemory.scala 33:18]
    node _GEN_7 = mux(io_ena, _GEN_2, UInt<1>("h0")) @[TrueDualPortMemory.scala 33:18 28:24]
    node _GEN_8 = validif(io_ena, _GEN_3) @[TrueDualPortMemory.scala 33:18]
    node _GEN_9 = validif(io_ena, _GEN_4) @[TrueDualPortMemory.scala 33:18]
    node _GEN_10 = validif(io_ena, io_addra) @[TrueDualPortMemory.scala 33:18 37:20]
    node _GEN_11 = validif(io_ena, io_clka) @[TrueDualPortMemory.scala 33:18 37:20]
    node _GEN_12 = mux(io_ena, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 33:18 37:20 28:24]
    node _GEN_13 = validif(io_ena, ram.io_doa_MPORT.data) @[TrueDualPortMemory.scala 33:18 37:14]
    node _GEN_14 = validif(io_web, io_addrb) @[TrueDualPortMemory.scala 45:20 46:12]
    node _GEN_15 = validif(io_web, io_clkb) @[TrueDualPortMemory.scala 45:20 46:12]
    node _GEN_16 = mux(io_web, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 45:20 46:12 28:24]
    node _GEN_17 = validif(io_web, UInt<1>("h1")) @[TrueDualPortMemory.scala 45:20 46:23]
    node _GEN_18 = validif(io_web, io_dib) @[TrueDualPortMemory.scala 45:20 46:23]
    node _GEN_19 = validif(io_enb, _GEN_14) @[TrueDualPortMemory.scala 44:18]
    node _GEN_20 = validif(io_enb, _GEN_15) @[TrueDualPortMemory.scala 44:18]
    node _GEN_21 = mux(io_enb, _GEN_16, UInt<1>("h0")) @[TrueDualPortMemory.scala 44:18 28:24]
    node _GEN_22 = validif(io_enb, _GEN_17) @[TrueDualPortMemory.scala 44:18]
    node _GEN_23 = validif(io_enb, _GEN_18) @[TrueDualPortMemory.scala 44:18]
    node _GEN_24 = validif(io_enb, io_addrb) @[TrueDualPortMemory.scala 44:18 48:20]
    node _GEN_25 = validif(io_enb, io_clkb) @[TrueDualPortMemory.scala 44:18 48:20]
    node _GEN_26 = mux(io_enb, UInt<1>("h1"), UInt<1>("h0")) @[TrueDualPortMemory.scala 44:18 48:20 28:24]
    node _GEN_27 = validif(io_enb, ram.io_dob_MPORT.data) @[TrueDualPortMemory.scala 44:18 48:14]
    io_doa <= _GEN_13
    io_dob <= _GEN_27
    ram.io_doa_MPORT.addr <= _GEN_10
    ram.io_doa_MPORT.en <= _GEN_12
    ram.io_doa_MPORT.clk <= _GEN_11
    ram.io_dob_MPORT.addr <= _GEN_24
    ram.io_dob_MPORT.en <= _GEN_26
    ram.io_dob_MPORT.clk <= _GEN_25
    ram.MPORT.addr <= _GEN_5
    ram.MPORT.en <= _GEN_7
    ram.MPORT.clk <= _GEN_6
    ram.MPORT.data <= _GEN_9
    ram.MPORT.mask <= _GEN_8
    ram.MPORT_1.addr <= _GEN_19
    ram.MPORT_1.en <= _GEN_21
    ram.MPORT_1.clk <= _GEN_20
    ram.MPORT_1.data <= _GEN_23
    ram.MPORT_1.mask <= _GEN_22

  module WriteControl :
    input io_clkw : Clock
    input io_resetw : UInt<1>
    input io_wr : UInt<1>
    input io_rPtr : UInt<5>
    output io_full : UInt<1>
    output io_wPtr : UInt<5>
    output io_wAddr : UInt<4>

    node _T = asAsyncReset(io_resetw) @[TrueDualPortFIFO.scala 45:42]
    reg wPtr : UInt<5>, io_clkw with :
      reset => (_T, UInt<1>("h0")) @[TrueDualPortFIFO.scala 55:25]
    node _gray1_bVec_T = bits(wPtr, 4, 0) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_1 = xorr(_gray1_bVec_T) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_2 = bits(wPtr, 4, 1) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_3 = xorr(_gray1_bVec_T_2) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_4 = bits(wPtr, 4, 2) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_5 = xorr(_gray1_bVec_T_4) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_6 = bits(wPtr, 4, 3) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_7 = xorr(_gray1_bVec_T_6) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_8 = bits(wPtr, 4, 4) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_9 = xorr(_gray1_bVec_T_8) @[TrueDualPortFIFO.scala 29:60]
    node gray1_bVec_1 = _gray1_bVec_T_3 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_bVec_0 = _gray1_bVec_T_1 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_b1_lo = cat(gray1_bVec_1, gray1_bVec_0) @[TrueDualPortFIFO.scala 30:16]
    node gray1_bVec_4 = _gray1_bVec_T_9 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_bVec_3 = _gray1_bVec_T_7 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_b1_hi_hi = cat(gray1_bVec_4, gray1_bVec_3) @[TrueDualPortFIFO.scala 30:16]
    node gray1_bVec_2 = _gray1_bVec_T_5 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_b1_hi = cat(gray1_b1_hi_hi, gray1_bVec_2) @[TrueDualPortFIFO.scala 30:16]
    node _gray1_b1_T = cat(gray1_b1_hi, gray1_b1_lo) @[TrueDualPortFIFO.scala 30:16]
    node _gray1_b1_T_1 = add(_gray1_b1_T, UInt<1>("h1")) @[TrueDualPortFIFO.scala 30:23]
    node _gray1_b1_T_2 = tail(_gray1_b1_T_1, 1) @[TrueDualPortFIFO.scala 30:23]
    node gray1_b1 = _gray1_b1_T_2 @[TrueDualPortFIFO.scala 28:18 30:8]
    node _gray1_T = bits(gray1_b1, 4, 1) @[TrueDualPortFIFO.scala 31:25]
    node _gray1_T_1 = cat(UInt<1>("h0"), _gray1_T) @[TrueDualPortFIFO.scala 31:20]
    node _gray1_T_2 = xor(gray1_b1, _gray1_T_1) @[TrueDualPortFIFO.scala 31:8]
    node _fullFlag_T = bits(io_rPtr, 4, 4) @[TrueDualPortFIFO.scala 69:27]
    node _fullFlag_T_1 = bits(wPtr, 4, 4) @[TrueDualPortFIFO.scala 69:43]
    node _fullFlag_T_2 = neq(_fullFlag_T, _fullFlag_T_1) @[TrueDualPortFIFO.scala 69:35]
    node _fullFlag_T_3 = bits(io_rPtr, 2, 0) @[TrueDualPortFIFO.scala 69:63]
    node _fullFlag_T_4 = bits(wPtr, 2, 0) @[TrueDualPortFIFO.scala 69:84]
    node _fullFlag_T_5 = eq(_fullFlag_T_3, _fullFlag_T_4) @[TrueDualPortFIFO.scala 69:76]
    node _fullFlag_T_6 = and(_fullFlag_T_2, _fullFlag_T_5) @[TrueDualPortFIFO.scala 69:52]
    node _rAddrMsb_T = bits(io_rPtr, 4, 4) @[TrueDualPortFIFO.scala 68:26]
    node _rAddrMsb_T_1 = bits(io_rPtr, 3, 3) @[TrueDualPortFIFO.scala 68:43]
    node _rAddrMsb_T_2 = xor(_rAddrMsb_T, _rAddrMsb_T_1) @[TrueDualPortFIFO.scala 68:34]
    node rAddrMsb = _rAddrMsb_T_2 @[TrueDualPortFIFO.scala 51:26 68:16]
    node _wAddrMsb_T = bits(wPtr, 4, 4) @[TrueDualPortFIFO.scala 64:23]
    node _wAddrMsb_T_1 = bits(wPtr, 3, 3) @[TrueDualPortFIFO.scala 64:37]
    node _wAddrMsb_T_2 = xor(_wAddrMsb_T, _wAddrMsb_T_1) @[TrueDualPortFIFO.scala 64:31]
    node wAddrMsb = _wAddrMsb_T_2 @[TrueDualPortFIFO.scala 50:26 64:16]
    node _fullFlag_T_7 = eq(rAddrMsb, wAddrMsb) @[TrueDualPortFIFO.scala 69:111]
    node _fullFlag_T_8 = and(_fullFlag_T_6, _fullFlag_T_7) @[TrueDualPortFIFO.scala 69:98]
    node fullFlag = _fullFlag_T_8 @[TrueDualPortFIFO.scala 52:26 69:16]
    node _wPtrNext_T = eq(fullFlag, UInt<1>("h0")) @[TrueDualPortFIFO.scala 61:32]
    node _wPtrNext_T_1 = and(io_wr, _wPtrNext_T) @[TrueDualPortFIFO.scala 61:29]
    node gray1 = _gray1_T_2 @[TrueDualPortFIFO.scala 48:23 58:13]
    node _wPtrNext_T_2 = mux(_wPtrNext_T_1, gray1, wPtr) @[TrueDualPortFIFO.scala 61:22]
    node _wAddr_T = bits(wPtr, 2, 0) @[TrueDualPortFIFO.scala 65:35]
    node _wAddr_T_1 = cat(wAddrMsb, _wAddr_T) @[TrueDualPortFIFO.scala 65:28]
    node wPtrNext = _wPtrNext_T_2 @[TrueDualPortFIFO.scala 47:26 61:16]
    node wAddr = _wAddr_T_1 @[TrueDualPortFIFO.scala 49:23 65:16]
    io_full <= fullFlag @[TrueDualPortFIFO.scala 74:16]
    io_wPtr <= wPtr @[TrueDualPortFIFO.scala 73:16]
    io_wAddr <= wAddr @[TrueDualPortFIFO.scala 72:16]
    wPtr <= wPtrNext @[TrueDualPortFIFO.scala 55:25]

  module ReadControl :
    input io_clkr : Clock
    input io_resetr : UInt<1>
    input io_rd : UInt<1>
    input io_wPtr : UInt<5>
    output io_empty : UInt<1>
    output io_rPtr : UInt<5>
    output io_rAddr : UInt<4>

    node _T = asAsyncReset(io_resetr) @[TrueDualPortFIFO.scala 89:42]
    reg rPtr : UInt<5>, io_clkr with :
      reset => (_T, UInt<1>("h0")) @[TrueDualPortFIFO.scala 99:25]
    node _gray1_bVec_T = bits(rPtr, 4, 0) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_1 = xorr(_gray1_bVec_T) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_2 = bits(rPtr, 4, 1) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_3 = xorr(_gray1_bVec_T_2) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_4 = bits(rPtr, 4, 2) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_5 = xorr(_gray1_bVec_T_4) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_6 = bits(rPtr, 4, 3) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_7 = xorr(_gray1_bVec_T_6) @[TrueDualPortFIFO.scala 29:60]
    node _gray1_bVec_T_8 = bits(rPtr, 4, 4) @[TrueDualPortFIFO.scala 29:47]
    node _gray1_bVec_T_9 = xorr(_gray1_bVec_T_8) @[TrueDualPortFIFO.scala 29:60]
    node gray1_bVec_1 = _gray1_bVec_T_3 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_bVec_0 = _gray1_bVec_T_1 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_b1_lo = cat(gray1_bVec_1, gray1_bVec_0) @[TrueDualPortFIFO.scala 30:16]
    node gray1_bVec_4 = _gray1_bVec_T_9 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_bVec_3 = _gray1_bVec_T_7 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_b1_hi_hi = cat(gray1_bVec_4, gray1_bVec_3) @[TrueDualPortFIFO.scala 30:16]
    node gray1_bVec_2 = _gray1_bVec_T_5 @[TrueDualPortFIFO.scala 29:{23,23}]
    node gray1_b1_hi = cat(gray1_b1_hi_hi, gray1_bVec_2) @[TrueDualPortFIFO.scala 30:16]
    node _gray1_b1_T = cat(gray1_b1_hi, gray1_b1_lo) @[TrueDualPortFIFO.scala 30:16]
    node _gray1_b1_T_1 = add(_gray1_b1_T, UInt<1>("h1")) @[TrueDualPortFIFO.scala 30:23]
    node _gray1_b1_T_2 = tail(_gray1_b1_T_1, 1) @[TrueDualPortFIFO.scala 30:23]
    node gray1_b1 = _gray1_b1_T_2 @[TrueDualPortFIFO.scala 28:18 30:8]
    node _gray1_T = bits(gray1_b1, 4, 1) @[TrueDualPortFIFO.scala 31:25]
    node _gray1_T_1 = cat(UInt<1>("h0"), _gray1_T) @[TrueDualPortFIFO.scala 31:20]
    node _gray1_T_2 = xor(gray1_b1, _gray1_T_1) @[TrueDualPortFIFO.scala 31:8]
    node _emptyFlag_T = bits(io_wPtr, 4, 4) @[TrueDualPortFIFO.scala 113:28]
    node _emptyFlag_T_1 = bits(rPtr, 4, 4) @[TrueDualPortFIFO.scala 113:44]
    node _emptyFlag_T_2 = eq(_emptyFlag_T, _emptyFlag_T_1) @[TrueDualPortFIFO.scala 113:36]
    node _emptyFlag_T_3 = bits(io_wPtr, 2, 0) @[TrueDualPortFIFO.scala 113:64]
    node _emptyFlag_T_4 = bits(rPtr, 2, 0) @[TrueDualPortFIFO.scala 113:85]
    node _emptyFlag_T_5 = eq(_emptyFlag_T_3, _emptyFlag_T_4) @[TrueDualPortFIFO.scala 113:77]
    node _emptyFlag_T_6 = and(_emptyFlag_T_2, _emptyFlag_T_5) @[TrueDualPortFIFO.scala 113:53]
    node _wAddrMsb_T = bits(io_wPtr, 4, 4) @[TrueDualPortFIFO.scala 112:27]
    node _wAddrMsb_T_1 = bits(io_wPtr, 3, 3) @[TrueDualPortFIFO.scala 112:44]
    node _wAddrMsb_T_2 = xor(_wAddrMsb_T, _wAddrMsb_T_1) @[TrueDualPortFIFO.scala 112:35]
    node wAddrMsb = _wAddrMsb_T_2 @[TrueDualPortFIFO.scala 112:17 95:27]
    node _rAddrMsb_T = bits(rPtr, 4, 4) @[TrueDualPortFIFO.scala 108:23]
    node _rAddrMsb_T_1 = bits(rPtr, 3, 3) @[TrueDualPortFIFO.scala 108:37]
    node _rAddrMsb_T_2 = xor(_rAddrMsb_T, _rAddrMsb_T_1) @[TrueDualPortFIFO.scala 108:31]
    node rAddrMsb = _rAddrMsb_T_2 @[TrueDualPortFIFO.scala 108:16 94:27]
    node _emptyFlag_T_7 = eq(wAddrMsb, rAddrMsb) @[TrueDualPortFIFO.scala 113:112]
    node _emptyFlag_T_8 = and(_emptyFlag_T_6, _emptyFlag_T_7) @[TrueDualPortFIFO.scala 113:99]
    node emptyFlag = _emptyFlag_T_8 @[TrueDualPortFIFO.scala 113:17 96:27]
    node _rPtrNext_T = eq(emptyFlag, UInt<1>("h0")) @[TrueDualPortFIFO.scala 105:32]
    node _rPtrNext_T_1 = and(io_rd, _rPtrNext_T) @[TrueDualPortFIFO.scala 105:29]
    node gray1 = _gray1_T_2 @[TrueDualPortFIFO.scala 102:13 92:23]
    node _rPtrNext_T_2 = mux(_rPtrNext_T_1, gray1, rPtr) @[TrueDualPortFIFO.scala 105:22]
    node _rAddr_T = bits(rPtr, 2, 0) @[TrueDualPortFIFO.scala 109:35]
    node _rAddr_T_1 = cat(rAddrMsb, _rAddr_T) @[TrueDualPortFIFO.scala 109:28]
    node rPtrNext = _rPtrNext_T_2 @[TrueDualPortFIFO.scala 105:16 91:26]
    node rAddr = _rAddr_T_1 @[TrueDualPortFIFO.scala 109:16 93:23]
    io_empty <= emptyFlag @[TrueDualPortFIFO.scala 118:16]
    io_rPtr <= rPtr @[TrueDualPortFIFO.scala 117:16]
    io_rAddr <= rAddr @[TrueDualPortFIFO.scala 116:16]
    rPtr <= rPtrNext @[TrueDualPortFIFO.scala 99:25]

  module TrueDualPortFIFO :
    input io_clki : Clock
    input io_we : UInt<1>
    input io_datai : UInt<8>
    output io_full : UInt<1>
    input io_clko : Clock
    input io_en : UInt<1>
    output io_datao : UInt<8>
    output io_empty : UInt<1>
    input io_rst : UInt<1>

    inst ram of TrueDualPortMemory_2 @[TrueDualPortFIFO.scala 123:21]
    inst wctrl of WriteControl @[TrueDualPortFIFO.scala 124:21]
    inst rctrl of ReadControl @[TrueDualPortFIFO.scala 125:21]
    node _ram_io_ena_T = eq(wctrl.io_full, UInt<1>("h0")) @[TrueDualPortFIFO.scala 135:28]
    node _ram_io_ena_T_1 = and(io_we, _ram_io_ena_T) @[TrueDualPortFIFO.scala 135:25]
    node _ram_io_wea_T = eq(wctrl.io_full, UInt<1>("h0")) @[TrueDualPortFIFO.scala 136:28]
    node _ram_io_wea_T_1 = and(io_we, _ram_io_wea_T) @[TrueDualPortFIFO.scala 136:25]
    node _ram_io_enb_T = eq(rctrl.io_empty, UInt<1>("h0")) @[TrueDualPortFIFO.scala 150:28]
    node _ram_io_enb_T_1 = and(io_en, _ram_io_enb_T) @[TrueDualPortFIFO.scala 150:25]
    node wAddr = wctrl.io_wAddr @[TrueDualPortFIFO.scala 126:19 144:9]
    node wPtr = wctrl.io_wPtr @[TrueDualPortFIFO.scala 127:19 143:8]
    node rAddr = rctrl.io_rAddr @[TrueDualPortFIFO.scala 128:19 160:9]
    node rPtr = rctrl.io_rPtr @[TrueDualPortFIFO.scala 129:19 159:8]
    io_full <= wctrl.io_full @[TrueDualPortFIFO.scala 142:11]
    io_datao <= ram.io_dob @[TrueDualPortFIFO.scala 152:16]
    io_empty <= rctrl.io_empty @[TrueDualPortFIFO.scala 158:12]
    ram.io_clka <= io_clki @[TrueDualPortFIFO.scala 132:16]
    ram.io_ena <= _ram_io_ena_T_1 @[TrueDualPortFIFO.scala 135:16]
    ram.io_wea <= _ram_io_wea_T_1 @[TrueDualPortFIFO.scala 136:16]
    ram.io_addra <= wAddr @[TrueDualPortFIFO.scala 133:16]
    ram.io_dia <= io_datai @[TrueDualPortFIFO.scala 134:16]
    ram.io_clkb <= io_clko @[TrueDualPortFIFO.scala 147:16]
    ram.io_enb <= _ram_io_enb_T_1 @[TrueDualPortFIFO.scala 150:16]
    ram.io_web <= UInt<1>("h0") @[TrueDualPortFIFO.scala 151:16]
    ram.io_addrb <= rAddr @[TrueDualPortFIFO.scala 148:16]
    ram.io_dib <= UInt<1>("h0") @[TrueDualPortFIFO.scala 149:16]
    wctrl.io_clkw <= io_clki @[TrueDualPortFIFO.scala 138:17]
    wctrl.io_resetw <= io_rst @[TrueDualPortFIFO.scala 139:19]
    wctrl.io_wr <= io_we @[TrueDualPortFIFO.scala 140:15]
    wctrl.io_rPtr <= rPtr @[TrueDualPortFIFO.scala 141:17]
    rctrl.io_clkr <= io_clko @[TrueDualPortFIFO.scala 154:17]
    rctrl.io_resetr <= io_rst @[TrueDualPortFIFO.scala 155:19]
    rctrl.io_rd <= io_en @[TrueDualPortFIFO.scala 156:15]
    rctrl.io_wPtr <= wPtr @[TrueDualPortFIFO.scala 157:17]

  module Tx :
    input clock : Clock
    input reset : UInt<1>
    output io_tx : UInt<1>
    output io_ready : UInt<1>
    input io_valid : UInt<1>
    input io_data : UInt<8>

    reg clkCnt : UInt<11>, clock with :
      reset => (UInt<1>("h0"), clkCnt) @[UART.scala 17:23]
    reg baudtick : UInt<1>, clock with :
      reset => (UInt<1>("h0"), baudtick) @[UART.scala 18:25]
    reg state : UInt<2>, clock with :
      reset => (UInt<1>("h0"), state) @[UART.scala 19:22]
    reg data : UInt<8>, clock with :
      reset => (UInt<1>("h0"), data) @[UART.scala 20:21]
    reg txBit : UInt<1>, clock with :
      reset => (UInt<1>("h0"), txBit) @[UART.scala 21:22]
    reg bitCnt : UInt<3>, clock with :
      reset => (UInt<1>("h0"), bitCnt) @[UART.scala 22:23]
    reg readyR : UInt<1>, clock with :
      reset => (UInt<1>("h0"), readyR) @[UART.scala 23:23]
    node _T = eq(clkCnt, UInt<10>("h2b6")) @[UART.scala 28:15]
    node _clkCnt_T = add(clkCnt, UInt<1>("h1")) @[UART.scala 32:22]
    node _clkCnt_T_1 = tail(_clkCnt_T, 1) @[UART.scala 32:22]
    node _GEN_0 = mux(_T, UInt<1>("h0"), _clkCnt_T_1) @[UART.scala 28:30 29:12 32:12]
    node _GEN_1 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[UART.scala 28:30 30:14 33:14]
    node _T_1 = eq(UInt<2>("h0"), state) @[Conditional.scala 37:30]
    node _T_2 = and(baudtick, io_valid) @[UART.scala 40:21]
    node _GEN_2 = mux(_T_2, UInt<1>("h0"), txBit) @[UART.scala 40:34 41:15 21:22]
    node _GEN_3 = mux(_T_2, UInt<2>("h1"), state) @[UART.scala 40:34 42:15 19:22]
    node _GEN_4 = mux(_T_2, UInt<1>("h0"), bitCnt) @[UART.scala 40:34 43:16 22:23]
    node _GEN_5 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[UART.scala 36:10 40:34 44:16]
    node _GEN_6 = mux(_T_2, io_data, data) @[UART.scala 40:34 45:14 20:21]
    node _T_3 = eq(UInt<2>("h1"), state) @[Conditional.scala 37:30]
    node _txBit_T = bits(data, 0, 0) @[UART.scala 50:22]
    node _data_T = bits(data, 7, 1) @[UART.scala 51:31]
    node _data_T_1 = cat(UInt<1>("h1"), _data_T) @[UART.scala 51:24]
    node _T_4 = lt(bitCnt, UInt<3>("h7")) @[UART.scala 52:21]
    node _bitCnt_T = add(bitCnt, UInt<1>("h1")) @[UART.scala 53:28]
    node _bitCnt_T_1 = tail(_bitCnt_T, 1) @[UART.scala 53:28]
    node _GEN_7 = mux(_T_4, _bitCnt_T_1, UInt<1>("h0")) @[UART.scala 52:28 53:18 55:18]
    node _GEN_8 = mux(_T_4, state, UInt<2>("h2")) @[UART.scala 19:22 52:28 56:17]
    node _GEN_9 = mux(baudtick, _txBit_T, txBit) @[UART.scala 49:22 50:15 21:22]
    node _GEN_10 = mux(baudtick, _data_T_1, data) @[UART.scala 49:22 51:14 20:21]
    node _GEN_11 = mux(baudtick, _GEN_7, bitCnt) @[UART.scala 49:22 22:23]
    node _GEN_12 = mux(baudtick, _GEN_8, state) @[UART.scala 19:22 49:22]
    node _T_5 = eq(UInt<2>("h2"), state) @[Conditional.scala 37:30]
    node _GEN_13 = mux(baudtick, UInt<1>("h1"), txBit) @[UART.scala 61:22 62:15 21:22]
    node _GEN_14 = mux(baudtick, UInt<2>("h0"), state) @[UART.scala 61:22 63:15 19:22]
    node _GEN_15 = mux(_T_5, _GEN_13, txBit) @[Conditional.scala 39:67 UART.scala 21:22]
    node _GEN_16 = mux(_T_5, _GEN_14, state) @[Conditional.scala 39:67 UART.scala 19:22]
    node _GEN_17 = mux(_T_3, _GEN_9, _GEN_15) @[Conditional.scala 39:67]
    node _GEN_18 = mux(_T_3, _GEN_10, data) @[Conditional.scala 39:67 UART.scala 20:21]
    node _GEN_19 = mux(_T_3, _GEN_11, bitCnt) @[Conditional.scala 39:67 UART.scala 22:23]
    node _GEN_20 = mux(_T_3, _GEN_12, _GEN_16) @[Conditional.scala 39:67]
    node _GEN_21 = mux(_T_1, _GEN_2, _GEN_17) @[Conditional.scala 40:58]
    node _GEN_22 = mux(_T_1, _GEN_3, _GEN_20) @[Conditional.scala 40:58]
    node _GEN_23 = mux(_T_1, _GEN_4, _GEN_19) @[Conditional.scala 40:58]
    node _GEN_24 = mux(_T_1, _GEN_5, UInt<1>("h0")) @[Conditional.scala 40:58 UART.scala 36:10]
    node _GEN_25 = mux(_T_1, _GEN_6, _GEN_18) @[Conditional.scala 40:58]
    io_tx <= txBit @[UART.scala 25:9]
    io_ready <= readyR @[UART.scala 26:12]
    clkCnt <= mux(reset, UInt<11>("h0"), _GEN_0) @[UART.scala 17:{23,23}]
    baudtick <= mux(reset, UInt<1>("h0"), _GEN_1) @[UART.scala 18:{25,25}]
    state <= mux(reset, UInt<2>("h0"), _GEN_22) @[UART.scala 19:{22,22}]
    data <= mux(reset, UInt<8>("h0"), _GEN_25) @[UART.scala 20:{21,21}]
    txBit <= mux(reset, UInt<1>("h1"), _GEN_21) @[UART.scala 21:{22,22}]
    bitCnt <= mux(reset, UInt<3>("h0"), _GEN_23) @[UART.scala 22:{23,23}]
    readyR <= mux(reset, UInt<1>("h0"), _GEN_24) @[UART.scala 23:{23,23}]

  module Rx :
    input clock : Clock
    input reset : UInt<1>
    input io_rx : UInt<1>
    input io_ready : UInt<1>
    output io_valid : UInt<1>
    output io_data : UInt<8>

    reg dataSr : UInt<2>, clock with :
      reset => (UInt<1>("h0"), dataSr) @[UART.scala 80:25]
    reg filter : UInt<2>, clock with :
      reset => (UInt<1>("h0"), filter) @[UART.scala 81:25]
    reg rxBit : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rxBit) @[UART.scala 82:25]
    reg spaceCnt : UInt<4>, clock with :
      reset => (UInt<1>("h0"), spaceCnt) @[UART.scala 83:25]
    reg data : UInt<8>, clock with :
      reset => (UInt<1>("h0"), data) @[UART.scala 84:25]
    reg clkCnt : UInt<6>, clock with :
      reset => (UInt<1>("h0"), clkCnt) @[UART.scala 85:25]
    reg baudTick : UInt<1>, clock with :
      reset => (UInt<1>("h0"), baudTick) @[UART.scala 86:25]
    reg bitTick : UInt<1>, clock with :
      reset => (UInt<1>("h0"), bitTick) @[UART.scala 87:25]
    reg state : UInt<2>, clock with :
      reset => (UInt<1>("h0"), state) @[UART.scala 88:25]
    reg bitCnt : UInt<3>, clock with :
      reset => (UInt<1>("h0"), bitCnt) @[UART.scala 89:25]
    reg validR : UInt<1>, clock with :
      reset => (UInt<1>("h0"), validR) @[UART.scala 90:25]
    node _T = and(validR, io_ready) @[UART.scala 95:15]
    node _GEN_0 = mux(_T, UInt<1>("h0"), validR) @[UART.scala 95:28 96:12 90:25]
    node _T_1 = eq(clkCnt, UInt<6>("h2b")) @[UART.scala 99:15]
    node _clkCnt_T = add(clkCnt, UInt<1>("h1")) @[UART.scala 104:22]
    node _clkCnt_T_1 = tail(_clkCnt_T, 1) @[UART.scala 104:22]
    node _GEN_1 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[UART.scala 100:14 103:14 99:34]
    node _GEN_2 = mux(_T_1, UInt<1>("h0"), _clkCnt_T_1) @[UART.scala 101:12 104:12 99:34]
    node _dataSr_T = bits(dataSr, 0, 0) @[UART.scala 110:21]
    node _dataSr_T_1 = cat(_dataSr_T, io_rx) @[UART.scala 110:25]
    node _T_2 = bits(dataSr, 1, 1) @[UART.scala 112:16]
    node _T_3 = lt(filter, UInt<2>("h3")) @[UART.scala 112:30]
    node _T_4 = and(_T_2, _T_3) @[UART.scala 112:20]
    node _filter_T = add(filter, UInt<1>("h1")) @[UART.scala 113:24]
    node _filter_T_1 = tail(_filter_T, 1) @[UART.scala 113:24]
    node _T_5 = bits(dataSr, 1, 1) @[UART.scala 114:23]
    node _T_6 = eq(_T_5, UInt<1>("h0")) @[UART.scala 114:16]
    node _T_7 = gt(filter, UInt<1>("h0")) @[UART.scala 114:37]
    node _T_8 = and(_T_6, _T_7) @[UART.scala 114:27]
    node _filter_T_2 = sub(filter, UInt<1>("h1")) @[UART.scala 115:24]
    node _filter_T_3 = tail(_filter_T_2, 1) @[UART.scala 115:24]
    node _GEN_3 = mux(_T_8, _filter_T_3, filter) @[UART.scala 114:44 115:14 81:25]
    node _GEN_4 = mux(_T_4, _filter_T_1, _GEN_3) @[UART.scala 112:37 113:14]
    node _T_9 = eq(filter, UInt<2>("h3")) @[UART.scala 118:17]
    node _T_10 = eq(filter, UInt<1>("h0")) @[UART.scala 120:23]
    node _GEN_5 = mux(_T_10, UInt<1>("h0"), rxBit) @[UART.scala 120:32 121:13 82:25]
    node _GEN_6 = mux(_T_9, UInt<1>("h1"), _GEN_5) @[UART.scala 118:26 119:13]
    node _T_11 = eq(spaceCnt, UInt<4>("hf")) @[UART.scala 124:19]
    node _spaceCnt_T = add(spaceCnt, UInt<1>("h1")) @[UART.scala 128:28]
    node _spaceCnt_T_1 = tail(_spaceCnt_T, 1) @[UART.scala 128:28]
    node _GEN_7 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[UART.scala 107:11 124:29 125:15]
    node _GEN_8 = mux(_T_11, UInt<1>("h0"), _spaceCnt_T_1) @[UART.scala 124:29 126:16 128:16]
    node _T_12 = eq(state, UInt<2>("h0")) @[UART.scala 130:16]
    node _GEN_9 = mux(_T_12, UInt<1>("h0"), _GEN_8) @[UART.scala 130:28 131:16]
    node _GEN_10 = mux(baudTick, _dataSr_T_1, dataSr) @[UART.scala 109:18 110:12 80:25]
    node _GEN_11 = mux(baudTick, _GEN_4, filter) @[UART.scala 109:18 81:25]
    node _GEN_12 = mux(baudTick, _GEN_6, rxBit) @[UART.scala 109:18 82:25]
    node _GEN_13 = mux(baudTick, _GEN_7, UInt<1>("h0")) @[UART.scala 107:11 109:18]
    node _GEN_14 = mux(baudTick, _GEN_9, spaceCnt) @[UART.scala 109:18 83:25]
    node _T_13 = eq(UInt<2>("h0"), state) @[Conditional.scala 37:30]
    node _T_14 = eq(rxBit, UInt<1>("h0")) @[UART.scala 137:24]
    node _T_15 = and(baudTick, _T_14) @[UART.scala 137:21]
    node _GEN_15 = mux(_T_15, UInt<2>("h1"), state) @[UART.scala 137:32 138:15 88:25]
    node _T_16 = eq(UInt<2>("h1"), state) @[Conditional.scala 37:30]
    node _data_T = bits(data, 7, 1) @[UART.scala 143:30]
    node _data_T_1 = cat(rxBit, _data_T) @[UART.scala 143:23]
    node _T_17 = lt(bitCnt, UInt<3>("h7")) @[UART.scala 144:21]
    node _bitCnt_T = add(bitCnt, UInt<1>("h1")) @[UART.scala 145:28]
    node _bitCnt_T_1 = tail(_bitCnt_T, 1) @[UART.scala 145:28]
    node _GEN_16 = mux(_T_17, _bitCnt_T_1, UInt<1>("h0")) @[UART.scala 144:27 145:18 147:18]
    node _GEN_17 = mux(_T_17, state, UInt<2>("h2")) @[UART.scala 144:27 148:17 88:25]
    node _GEN_18 = mux(bitTick, _data_T_1, data) @[UART.scala 142:21 143:14 84:25]
    node _GEN_19 = mux(bitTick, _GEN_16, bitCnt) @[UART.scala 142:21 89:25]
    node _GEN_20 = mux(bitTick, _GEN_17, state) @[UART.scala 142:21 88:25]
    node _T_18 = eq(UInt<2>("h2"), state) @[Conditional.scala 37:30]
    node _T_19 = and(bitTick, rxBit) @[UART.scala 153:20]
    node _GEN_21 = mux(_T_19, UInt<2>("h0"), state) @[UART.scala 153:30 154:15 88:25]
    node _GEN_22 = mux(_T_19, UInt<1>("h1"), _GEN_0) @[UART.scala 153:30 155:16]
    node _GEN_23 = mux(_T_18, _GEN_21, state) @[Conditional.scala 39:67 UART.scala 88:25]
    node _GEN_24 = mux(_T_18, _GEN_22, _GEN_0) @[Conditional.scala 39:67]
    node _GEN_25 = mux(_T_16, _GEN_18, data) @[Conditional.scala 39:67 UART.scala 84:25]
    node _GEN_26 = mux(_T_16, _GEN_19, bitCnt) @[Conditional.scala 39:67 UART.scala 89:25]
    node _GEN_27 = mux(_T_16, _GEN_20, _GEN_23) @[Conditional.scala 39:67]
    node _GEN_28 = mux(_T_16, _GEN_0, _GEN_24) @[Conditional.scala 39:67]
    node _GEN_29 = mux(_T_13, _GEN_15, _GEN_27) @[Conditional.scala 40:58]
    node _GEN_30 = mux(_T_13, data, _GEN_25) @[Conditional.scala 40:58 UART.scala 84:25]
    node _GEN_31 = mux(_T_13, bitCnt, _GEN_26) @[Conditional.scala 40:58 UART.scala 89:25]
    node _GEN_32 = mux(_T_13, _GEN_0, _GEN_28) @[Conditional.scala 40:58]
    io_valid <= validR @[UART.scala 93:12]
    io_data <= data @[UART.scala 92:11]
    dataSr <= mux(reset, UInt<2>("h3"), _GEN_10) @[UART.scala 80:{25,25}]
    filter <= mux(reset, UInt<2>("h3"), _GEN_11) @[UART.scala 81:{25,25}]
    rxBit <= mux(reset, UInt<1>("h1"), _GEN_12) @[UART.scala 82:{25,25}]
    spaceCnt <= mux(reset, UInt<4>("h0"), _GEN_14) @[UART.scala 83:{25,25}]
    data <= mux(reset, UInt<8>("h0"), _GEN_30) @[UART.scala 84:{25,25}]
    clkCnt <= mux(reset, UInt<6>("h0"), _GEN_2) @[UART.scala 85:{25,25}]
    baudTick <= mux(reset, UInt<1>("h0"), _GEN_1) @[UART.scala 86:{25,25}]
    bitTick <= mux(reset, UInt<1>("h0"), _GEN_13) @[UART.scala 87:{25,25}]
    state <= mux(reset, UInt<2>("h0"), _GEN_29) @[UART.scala 88:{25,25}]
    bitCnt <= mux(reset, UInt<3>("h0"), _GEN_31) @[UART.scala 89:{25,25}]
    validR <= mux(reset, UInt<1>("h0"), _GEN_32) @[UART.scala 90:{25,25}]

  module Uart :
    input clock : Clock
    input reset : UInt<1>
    input io_rxd : UInt<1>
    output io_txd : UInt<1>
    input io_rxReady : UInt<1>
    output io_rxValid : UInt<1>
    output io_rxByte : UInt<8>
    output io_txReady : UInt<1>
    input io_txValid : UInt<1>
    input io_txByte : UInt<8>

    inst tx of Tx @[UART.scala 175:18]
    inst rx of Rx @[UART.scala 176:18]
    io_txd <= tx.io_tx @[UART.scala 178:10]
    io_rxValid <= rx.io_valid @[UART.scala 185:14]
    io_rxByte <= rx.io_data @[UART.scala 186:13]
    io_txReady <= tx.io_ready @[UART.scala 179:14]
    tx.clock <= clock
    tx.reset <= reset
    tx.io_valid <= io_txValid @[UART.scala 180:15]
    tx.io_data <= io_txByte @[UART.scala 181:14]
    rx.clock <= clock
    rx.reset <= reset
    rx.io_rx <= io_rxd @[UART.scala 183:12]
    rx.io_ready <= io_rxReady @[UART.scala 184:15]

  module OffChipCom :
    input clock : Clock
    input reset : UInt<1>
    output io_tx : UInt<1>
    input io_rx : UInt<1>
    output io_inC0We : UInt<1>
    output io_inC0Addr : UInt<9>
    output io_inC0Di : UInt<9>
    output io_inC1We : UInt<1>
    output io_inC1Addr : UInt<9>
    output io_inC1Di : UInt<9>
    output io_qEn : UInt<1>
    input io_qData : UInt<8>
    input io_qEmpty : UInt<1>
    input io_inC0HSin : UInt<1>
    output io_inC0HSout : UInt<1>
    input io_inC1HSin : UInt<1>
    output io_inC1HSout : UInt<1>

    inst uart of Uart @[OffChipCom.scala 34:20]
    reg txBuf : UInt<8>, clock with :
      reset => (UInt<1>("h0"), txBuf) @[OffChipCom.scala 35:22]
    reg txV : UInt<1>, clock with :
      reset => (UInt<1>("h0"), txV) @[OffChipCom.scala 36:20]
    node _T = and(uart.io_txReady, txV) @[OffChipCom.scala 46:24]
    node _GEN_0 = mux(_T, UInt<1>("h0"), txV) @[OffChipCom.scala 36:20 46:32 47:9]
    reg enReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), enReg) @[OffChipCom.scala 52:22]
    node _en_T = eq(io_qEmpty, UInt<1>("h0")) @[OffChipCom.scala 53:9]
    node _en_T_1 = eq(txV, UInt<1>("h0")) @[OffChipCom.scala 53:23]
    node _en_T_2 = and(_en_T, _en_T_1) @[OffChipCom.scala 53:20]
    node _en_T_3 = eq(enReg, UInt<1>("h0")) @[OffChipCom.scala 53:31]
    node _en_T_4 = and(_en_T_2, _en_T_3) @[OffChipCom.scala 53:28]
    node _GEN_1 = mux(enReg, io_qData, txBuf) @[OffChipCom.scala 56:15 57:11 35:22]
    node _GEN_2 = mux(enReg, UInt<1>("h1"), _GEN_0) @[OffChipCom.scala 56:15 58:9]
    reg addr1 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), addr1) @[OffChipCom.scala 62:22]
    reg addr0 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), addr0) @[OffChipCom.scala 63:22]
    reg rate1 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), rate1) @[OffChipCom.scala 64:22]
    reg rate0 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), rate0) @[OffChipCom.scala 65:22]
    reg phase : UInt<1>, clock with :
      reset => (UInt<1>("h0"), phase) @[OffChipCom.scala 68:22]
    node _defAddr_T = add(addr0, UInt<9>("h100")) @[OffChipCom.scala 71:42]
    node _defAddr_T_1 = tail(_defAddr_T, 1) @[OffChipCom.scala 71:42]
    node _defAddr_T_2 = mux(phase, addr0, _defAddr_T_1) @[OffChipCom.scala 71:21]
    node defAddr = bits(_defAddr_T_2, 8, 0) @[OffChipCom.scala 71:60]
    node _defData_T = cat(rate1, rate0) @[OffChipCom.scala 72:25]
    node defData = bits(_defData_T, 8, 0) @[OffChipCom.scala 72:34]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[OffChipCom.scala 85:25]
    reg byteCnt : UInt<2>, clock with :
      reset => (UInt<1>("h0"), byteCnt) @[OffChipCom.scala 86:25]
    reg pixCnt : UInt<9>, clock with :
      reset => (UInt<1>("h0"), pixCnt) @[OffChipCom.scala 87:25]
    node _T_1 = eq(UInt<2>("h0"), stateReg) @[Conditional.scala 37:30]
    node _T_2 = eq(phase, io_inC0HSin) @[OffChipCom.scala 91:18]
    node _T_3 = eq(io_inC0HSin, io_inC1HSin) @[OffChipCom.scala 91:49]
    node _T_4 = and(_T_2, _T_3) @[OffChipCom.scala 91:34]
    node _GEN_3 = mux(_T_4, UInt<2>("h1"), stateReg) @[OffChipCom.scala 91:66 92:18 85:25]
    node _T_5 = eq(UInt<2>("h1"), stateReg) @[Conditional.scala 37:30]
    node _GEN_4 = mux(uart.io_txReady, UInt<2>("h2"), stateReg) @[OffChipCom.scala 98:29 99:18 85:25]
    node _GEN_5 = mux(uart.io_txReady, pixCnt, UInt<1>("h0")) @[OffChipCom.scala 101:16 87:25 98:29]
    node _GEN_6 = mux(uart.io_txReady, byteCnt, UInt<1>("h0")) @[OffChipCom.scala 102:17 86:25 98:29]
    node _GEN_7 = mux(uart.io_txReady, _GEN_1, UInt<8>("hff")) @[OffChipCom.scala 103:15 98:29]
    node _GEN_8 = mux(uart.io_txReady, _GEN_2, UInt<1>("h1")) @[OffChipCom.scala 104:13 98:29]
    node _T_6 = eq(UInt<2>("h2"), stateReg) @[Conditional.scala 37:30]
    node _byteCnt_T = add(byteCnt, UInt<1>("h1")) @[OffChipCom.scala 116:28]
    node _byteCnt_T_1 = tail(_byteCnt_T, 1) @[OffChipCom.scala 116:28]
    node _T_7 = eq(byteCnt, UInt<2>("h3")) @[OffChipCom.scala 118:22]
    node _GEN_9 = mux(_T_7, UInt<2>("h3"), UInt<2>("h2")) @[OffChipCom.scala 118:31 119:20 121:20]
    node _GEN_10 = mux(uart.io_rxValid, addr0, addr1) @[OffChipCom.scala 109:29 110:15 62:22]
    node _GEN_11 = mux(uart.io_rxValid, rate1, addr0) @[OffChipCom.scala 109:29 111:15 63:22]
    node _GEN_12 = mux(uart.io_rxValid, rate0, rate1) @[OffChipCom.scala 109:29 112:15 64:22]
    node _GEN_13 = mux(uart.io_rxValid, uart.io_rxByte, rate0) @[OffChipCom.scala 109:29 113:15 65:22]
    node _GEN_14 = mux(uart.io_rxValid, UInt<1>("h1"), UInt<1>("h0")) @[OffChipCom.scala 109:29 114:25 40:19]
    node _GEN_15 = mux(uart.io_rxValid, _byteCnt_T_1, byteCnt) @[OffChipCom.scala 109:29 116:17 86:25]
    node _GEN_16 = mux(uart.io_rxValid, _GEN_9, stateReg) @[OffChipCom.scala 109:29 85:25]
    node _T_8 = eq(UInt<2>("h3"), stateReg) @[Conditional.scala 37:30]
    node _T_9 = eq(addr1, UInt<1>("h0")) @[OffChipCom.scala 127:18]
    node _GEN_17 = mux(_T_9, UInt<1>("h1"), UInt<1>("h0")) @[OffChipCom.scala 127:27 128:19 74:16]
    node _GEN_18 = mux(_T_9, UInt<1>("h0"), UInt<1>("h1")) @[OffChipCom.scala 127:27 79:16 130:19]
    node _pixCnt_T = add(pixCnt, UInt<1>("h1")) @[OffChipCom.scala 132:24]
    node _pixCnt_T_1 = tail(_pixCnt_T, 1) @[OffChipCom.scala 132:24]
    node _T_10 = eq(pixCnt, UInt<9>("h1e3")) @[OffChipCom.scala 136:19]
    node _phase_T = not(phase) @[OffChipCom.scala 138:18]
    node _GEN_19 = mux(_T_10, UInt<2>("h0"), UInt<2>("h2")) @[OffChipCom.scala 136:40 137:18 140:18]
    node _GEN_20 = mux(_T_10, _phase_T, phase) @[OffChipCom.scala 136:40 138:15 68:22]
    node _GEN_21 = mux(_T_8, _GEN_17, UInt<1>("h0")) @[Conditional.scala 39:67 OffChipCom.scala 74:16]
    node _GEN_22 = mux(_T_8, _GEN_18, UInt<1>("h0")) @[Conditional.scala 39:67 OffChipCom.scala 79:16]
    node _GEN_23 = mux(_T_8, _pixCnt_T_1, pixCnt) @[Conditional.scala 39:67 OffChipCom.scala 132:14 87:25]
    node _GEN_24 = mux(_T_8, _GEN_19, stateReg) @[Conditional.scala 39:67 OffChipCom.scala 85:25]
    node _GEN_25 = mux(_T_8, _GEN_20, phase) @[Conditional.scala 39:67 OffChipCom.scala 68:22]
    node _GEN_26 = mux(_T_6, _GEN_10, addr1) @[Conditional.scala 39:67 OffChipCom.scala 62:22]
    node _GEN_27 = mux(_T_6, _GEN_11, addr0) @[Conditional.scala 39:67 OffChipCom.scala 63:22]
    node _GEN_28 = mux(_T_6, _GEN_12, rate1) @[Conditional.scala 39:67 OffChipCom.scala 64:22]
    node _GEN_29 = mux(_T_6, _GEN_13, rate0) @[Conditional.scala 39:67 OffChipCom.scala 65:22]
    node _GEN_30 = mux(_T_6, _GEN_14, UInt<1>("h0")) @[Conditional.scala 39:67 OffChipCom.scala 40:19]
    node _GEN_31 = mux(_T_6, _GEN_15, byteCnt) @[Conditional.scala 39:67 OffChipCom.scala 86:25]
    node _GEN_32 = mux(_T_6, _GEN_16, _GEN_24) @[Conditional.scala 39:67]
    node _GEN_33 = mux(_T_6, UInt<1>("h0"), _GEN_21) @[Conditional.scala 39:67 OffChipCom.scala 74:16]
    node _GEN_34 = mux(_T_6, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 OffChipCom.scala 79:16]
    node _GEN_35 = mux(_T_6, pixCnt, _GEN_23) @[Conditional.scala 39:67 OffChipCom.scala 87:25]
    node _GEN_36 = mux(_T_6, phase, _GEN_25) @[Conditional.scala 39:67 OffChipCom.scala 68:22]
    node _GEN_37 = mux(_T_5, _GEN_4, _GEN_32) @[Conditional.scala 39:67]
    node _GEN_38 = mux(_T_5, _GEN_5, _GEN_35) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_5, _GEN_6, _GEN_31) @[Conditional.scala 39:67]
    node _GEN_40 = mux(_T_5, _GEN_7, _GEN_1) @[Conditional.scala 39:67]
    node _GEN_41 = mux(_T_5, _GEN_8, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_5, addr1, _GEN_26) @[Conditional.scala 39:67 OffChipCom.scala 62:22]
    node _GEN_43 = mux(_T_5, addr0, _GEN_27) @[Conditional.scala 39:67 OffChipCom.scala 63:22]
    node _GEN_44 = mux(_T_5, rate1, _GEN_28) @[Conditional.scala 39:67 OffChipCom.scala 64:22]
    node _GEN_45 = mux(_T_5, rate0, _GEN_29) @[Conditional.scala 39:67 OffChipCom.scala 65:22]
    node _GEN_46 = mux(_T_5, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 OffChipCom.scala 40:19]
    node _GEN_47 = mux(_T_5, UInt<1>("h0"), _GEN_33) @[Conditional.scala 39:67 OffChipCom.scala 74:16]
    node _GEN_48 = mux(_T_5, UInt<1>("h0"), _GEN_34) @[Conditional.scala 39:67 OffChipCom.scala 79:16]
    node _GEN_49 = mux(_T_5, phase, _GEN_36) @[Conditional.scala 39:67 OffChipCom.scala 68:22]
    node _GEN_50 = mux(_T_1, _GEN_3, _GEN_37) @[Conditional.scala 40:58]
    node _GEN_51 = mux(_T_1, pixCnt, _GEN_38) @[Conditional.scala 40:58 OffChipCom.scala 87:25]
    node _GEN_52 = mux(_T_1, byteCnt, _GEN_39) @[Conditional.scala 40:58 OffChipCom.scala 86:25]
    node _GEN_53 = mux(_T_1, _GEN_1, _GEN_40) @[Conditional.scala 40:58]
    node _GEN_54 = mux(_T_1, _GEN_2, _GEN_41) @[Conditional.scala 40:58]
    node _GEN_55 = mux(_T_1, addr1, _GEN_42) @[Conditional.scala 40:58 OffChipCom.scala 62:22]
    node _GEN_56 = mux(_T_1, addr0, _GEN_43) @[Conditional.scala 40:58 OffChipCom.scala 63:22]
    node _GEN_57 = mux(_T_1, rate1, _GEN_44) @[Conditional.scala 40:58 OffChipCom.scala 64:22]
    node _GEN_58 = mux(_T_1, rate0, _GEN_45) @[Conditional.scala 40:58 OffChipCom.scala 65:22]
    node _GEN_59 = mux(_T_1, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 OffChipCom.scala 40:19]
    node _GEN_60 = mux(_T_1, UInt<1>("h0"), _GEN_47) @[Conditional.scala 40:58 OffChipCom.scala 74:16]
    node _GEN_61 = mux(_T_1, UInt<1>("h0"), _GEN_48) @[Conditional.scala 40:58 OffChipCom.scala 79:16]
    node _GEN_62 = mux(_T_1, phase, _GEN_49) @[Conditional.scala 40:58 OffChipCom.scala 68:22]
    node en = _en_T_4 @[OffChipCom.scala 51:16 53:6]
    io_tx <= uart.io_txd @[OffChipCom.scala 43:9]
    io_inC0We <= _GEN_60
    io_inC0Addr <= defAddr @[OffChipCom.scala 75:16]
    io_inC0Di <= defData @[OffChipCom.scala 76:16]
    io_inC1We <= _GEN_61
    io_inC1Addr <= defAddr @[OffChipCom.scala 80:16]
    io_inC1Di <= defData @[OffChipCom.scala 81:16]
    io_qEn <= en @[OffChipCom.scala 55:10]
    io_inC0HSout <= phase @[OffChipCom.scala 73:16]
    io_inC1HSout <= phase @[OffChipCom.scala 78:16]
    uart.clock <= clock
    uart.reset <= reset
    uart.io_rxd <= io_rx @[OffChipCom.scala 39:15]
    uart.io_rxReady <= _GEN_59
    uart.io_txValid <= txV @[OffChipCom.scala 44:19]
    uart.io_txByte <= txBuf @[OffChipCom.scala 45:18]
    txBuf <= mux(reset, UInt<8>("h0"), _GEN_53) @[OffChipCom.scala 35:{22,22}]
    txV <= mux(reset, UInt<1>("h0"), _GEN_54) @[OffChipCom.scala 36:{20,20}]
    enReg <= mux(reset, UInt<1>("h0"), en) @[OffChipCom.scala 52:{22,22} 54:9]
    addr1 <= mux(reset, UInt<8>("h0"), _GEN_55) @[OffChipCom.scala 62:{22,22}]
    addr0 <= mux(reset, UInt<8>("h0"), _GEN_56) @[OffChipCom.scala 63:{22,22}]
    rate1 <= mux(reset, UInt<8>("h0"), _GEN_57) @[OffChipCom.scala 64:{22,22}]
    rate0 <= mux(reset, UInt<8>("h0"), _GEN_58) @[OffChipCom.scala 65:{22,22}]
    phase <= mux(reset, UInt<1>("h0"), _GEN_62) @[OffChipCom.scala 68:{22,22}]
    stateReg <= mux(reset, UInt<2>("h0"), _GEN_50) @[OffChipCom.scala 85:{25,25}]
    byteCnt <= mux(reset, UInt<2>("h0"), _GEN_52) @[OffChipCom.scala 86:{25,25}]
    pixCnt <= mux(reset, UInt<9>("h0"), _GEN_51) @[OffChipCom.scala 87:{25,25}]

  module BusArbiter :
    input clock : Clock
    input reset : UInt<1>
    input io_reqs_0 : UInt<1>
    input io_reqs_1 : UInt<1>
    input io_reqs_2 : UInt<1>
    input io_reqs_3 : UInt<1>
    input io_reqs_4 : UInt<1>
    output io_grants_0 : UInt<1>
    output io_grants_1 : UInt<1>
    output io_grants_2 : UInt<1>
    output io_grants_3 : UInt<1>
    output io_grants_4 : UInt<1>

    reg maskRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_0) @[BusArbiter.scala 14:27]
    reg maskRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_1) @[BusArbiter.scala 14:27]
    reg maskRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_2) @[BusArbiter.scala 14:27]
    reg maskRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_3) @[BusArbiter.scala 14:27]
    reg maskRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_4) @[BusArbiter.scala 14:27]
    reg grantRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), grantRegs_0) @[BusArbiter.scala 16:27]
    reg grantRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), grantRegs_1) @[BusArbiter.scala 16:27]
    reg grantRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), grantRegs_2) @[BusArbiter.scala 16:27]
    reg grantRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), grantRegs_3) @[BusArbiter.scala 16:27]
    reg grantRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), grantRegs_4) @[BusArbiter.scala 16:27]
    node _maskedReqs_0_T = and(maskRegs_0, io_reqs_0) @[BusArbiter.scala 31:34]
    node maskedReqs_0 = _maskedReqs_0_T @[BusArbiter.scala 12:24 31:19]
    node _GEN_0 = mux(maskedReqs_0, UInt<1>("h1"), UInt<1>("h0")) @[BusArbiter.scala 23:10 34:25 35:14]
    node _GEN_1 = mux(maskedReqs_0, UInt<1>("h0"), UInt<1>("h0")) @[BusArbiter.scala 22:10 34:25 36:14]
    node _maskedReqs_4_T = and(maskRegs_4, io_reqs_4) @[BusArbiter.scala 31:34]
    node maskedReqs_4 = _maskedReqs_4_T @[BusArbiter.scala 12:24 31:19]
    node _maskedReqs_3_T = and(maskRegs_3, io_reqs_3) @[BusArbiter.scala 31:34]
    node maskedReqs_3 = _maskedReqs_3_T @[BusArbiter.scala 12:24 31:19]
    node _maskedReqs_2_T = and(maskRegs_2, io_reqs_2) @[BusArbiter.scala 31:34]
    node maskedReqs_2 = _maskedReqs_2_T @[BusArbiter.scala 12:24 31:19]
    node _maskedReqs_1_T = and(maskRegs_1, io_reqs_1) @[BusArbiter.scala 31:34]
    node maskedReqs_1 = _maskedReqs_1_T @[BusArbiter.scala 12:24 31:19]
    node _GEN_3 = mux(maskedReqs_1, UInt<1>("h1"), _GEN_1) @[BusArbiter.scala 34:25 36:14]
    node _GEN_5 = mux(maskedReqs_2, UInt<2>("h2"), _GEN_3) @[BusArbiter.scala 34:25 36:14]
    node _GEN_7 = mux(maskedReqs_3, UInt<2>("h3"), _GEN_5) @[BusArbiter.scala 34:25 36:14]
    node _GEN_9 = mux(maskedReqs_4, UInt<3>("h4"), _GEN_7) @[BusArbiter.scala 34:25 36:14]
    node value = _GEN_9 @[BusArbiter.scala 19:24]
    node _grants_0_T = eq(UInt<1>("h0"), value) @[BusArbiter.scala 40:23]
    node _GEN_2 = mux(maskedReqs_1, UInt<1>("h1"), _GEN_0) @[BusArbiter.scala 34:25 35:14]
    node _GEN_4 = mux(maskedReqs_2, UInt<1>("h1"), _GEN_2) @[BusArbiter.scala 34:25 35:14]
    node _GEN_6 = mux(maskedReqs_3, UInt<1>("h1"), _GEN_4) @[BusArbiter.scala 34:25 35:14]
    node _GEN_8 = mux(maskedReqs_4, UInt<1>("h1"), _GEN_6) @[BusArbiter.scala 34:25 35:14]
    node oneReq = _GEN_8 @[BusArbiter.scala 18:24]
    node _grants_0_T_1 = and(_grants_0_T, oneReq) @[BusArbiter.scala 40:33]
    node _grants_1_T = eq(UInt<1>("h1"), value) @[BusArbiter.scala 40:23]
    node _grants_1_T_1 = and(_grants_1_T, oneReq) @[BusArbiter.scala 40:33]
    node _grants_2_T = eq(UInt<2>("h2"), value) @[BusArbiter.scala 40:23]
    node _grants_2_T_1 = and(_grants_2_T, oneReq) @[BusArbiter.scala 40:33]
    node _grants_3_T = eq(UInt<2>("h3"), value) @[BusArbiter.scala 40:23]
    node _grants_3_T_1 = and(_grants_3_T, oneReq) @[BusArbiter.scala 40:33]
    node _grants_4_T = eq(UInt<3>("h4"), value) @[BusArbiter.scala 40:23]
    node _grants_4_T_1 = and(_grants_4_T, oneReq) @[BusArbiter.scala 40:33]
    node _mask_4_T = eq(value, UInt<1>("h0")) @[BusArbiter.scala 47:26]
    node mask_4 = _mask_4_T @[BusArbiter.scala 13:24 47:17]
    node _mask_3_T = or(mask_4, maskedReqs_4) @[BusArbiter.scala 45:28]
    node mask_3 = _mask_3_T @[BusArbiter.scala 13:24 45:13]
    node _mask_2_T = or(mask_3, maskedReqs_3) @[BusArbiter.scala 45:28]
    node mask_2 = _mask_2_T @[BusArbiter.scala 13:24 45:13]
    node _mask_1_T = or(mask_2, maskedReqs_2) @[BusArbiter.scala 45:28]
    node mask_1 = _mask_1_T @[BusArbiter.scala 13:24 45:13]
    node _mask_0_T = or(mask_1, maskedReqs_1) @[BusArbiter.scala 45:28]
    node mask_0 = _mask_0_T @[BusArbiter.scala 13:24 45:13]
    node _maskRegs_WIRE_0 = UInt<1>("h1") @[BusArbiter.scala 14:{35,35}]
    node _maskRegs_WIRE_1 = UInt<1>("h1") @[BusArbiter.scala 14:{35,35}]
    node _maskRegs_WIRE_2 = UInt<1>("h1") @[BusArbiter.scala 14:{35,35}]
    node _maskRegs_WIRE_3 = UInt<1>("h1") @[BusArbiter.scala 14:{35,35}]
    node _maskRegs_WIRE_4 = UInt<1>("h1") @[BusArbiter.scala 14:{35,35}]
    node grants_0 = _grants_0_T_1 @[BusArbiter.scala 15:24 40:15]
    node grants_1 = _grants_1_T_1 @[BusArbiter.scala 15:24 40:15]
    node grants_2 = _grants_2_T_1 @[BusArbiter.scala 15:24 40:15]
    node grants_3 = _grants_3_T_1 @[BusArbiter.scala 15:24 40:15]
    node grants_4 = _grants_4_T_1 @[BusArbiter.scala 15:24 40:15]
    node _grantRegs_WIRE_0 = UInt<1>("h0") @[BusArbiter.scala 16:{35,35}]
    node _grantRegs_WIRE_1 = UInt<1>("h0") @[BusArbiter.scala 16:{35,35}]
    node _grantRegs_WIRE_2 = UInt<1>("h0") @[BusArbiter.scala 16:{35,35}]
    node _grantRegs_WIRE_3 = UInt<1>("h0") @[BusArbiter.scala 16:{35,35}]
    node _grantRegs_WIRE_4 = UInt<1>("h0") @[BusArbiter.scala 16:{35,35}]
    io_grants_0 <= grantRegs_0 @[BusArbiter.scala 49:13]
    io_grants_1 <= grantRegs_1 @[BusArbiter.scala 49:13]
    io_grants_2 <= grantRegs_2 @[BusArbiter.scala 49:13]
    io_grants_3 <= grantRegs_3 @[BusArbiter.scala 49:13]
    io_grants_4 <= grantRegs_4 @[BusArbiter.scala 49:13]
    maskRegs_0 <= mux(reset, _maskRegs_WIRE_0, mask_0) @[BusArbiter.scala 14:{27,27} 27:18]
    maskRegs_1 <= mux(reset, _maskRegs_WIRE_1, mask_1) @[BusArbiter.scala 14:{27,27} 27:18]
    maskRegs_2 <= mux(reset, _maskRegs_WIRE_2, mask_2) @[BusArbiter.scala 14:{27,27} 27:18]
    maskRegs_3 <= mux(reset, _maskRegs_WIRE_3, mask_3) @[BusArbiter.scala 14:{27,27} 27:18]
    maskRegs_4 <= mux(reset, _maskRegs_WIRE_4, mask_4) @[BusArbiter.scala 14:{27,27} 27:18]
    grantRegs_0 <= mux(reset, _grantRegs_WIRE_0, grants_0) @[BusArbiter.scala 16:{27,27} 28:18]
    grantRegs_1 <= mux(reset, _grantRegs_WIRE_1, grants_1) @[BusArbiter.scala 16:{27,27} 28:18]
    grantRegs_2 <= mux(reset, _grantRegs_WIRE_2, grants_2) @[BusArbiter.scala 16:{27,27} 28:18]
    grantRegs_3 <= mux(reset, _grantRegs_WIRE_3, grants_3) @[BusArbiter.scala 16:{27,27} 28:18]
    grantRegs_4 <= mux(reset, _grantRegs_WIRE_4, grants_4) @[BusArbiter.scala 16:{27,27} 28:18]

  module BusInterface :
    input clock : Clock
    input reset : UInt<1>
    input io_grant : UInt<1>
    output io_reqOut : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>
    output io_axonID : UInt<10>
    output io_valid : UInt<1>
    input io_spikeID : UInt<11>
    output io_ready : UInt<1>
    input io_reqIn : UInt<1>

    node _io_tx_T = mux(io_grant, io_spikeID, UInt<1>("h0")) @[BusInterface.scala 31:15]
    node _io_reqOut_T = not(io_grant) @[BusInterface.scala 32:28]
    node _io_reqOut_T_1 = and(io_reqIn, _io_reqOut_T) @[BusInterface.scala 32:25]
    reg axonIDLSBReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), axonIDLSBReg) @[BusInterface.scala 36:29]
    node _axonIDLSBReg_T = bits(io_rx, 7, 0) @[BusInterface.scala 37:24]
    reg synROMReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), synROMReg) @[BusInterface.scala 39:27]
    node _synROMReg_T = orr(io_rx) @[BusInterface.scala 40:26]
    node _synROMReg_T_1 = bits(io_rx, 10, 8) @[BusInterface.scala 40:46]
    node filterROM_0 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_0 = validif(eq(UInt<1>("h0"), _synROMReg_T_1), filterROM_0) @[BusInterface.scala 40:{19,19}]
    node filterROM_1 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_1 = mux(eq(UInt<1>("h1"), _synROMReg_T_1), filterROM_1, _GEN_0) @[BusInterface.scala 40:{19,19}]
    node filterROM_2 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_2 = mux(eq(UInt<2>("h2"), _synROMReg_T_1), filterROM_2, _GEN_1) @[BusInterface.scala 40:{19,19}]
    node filterROM_3 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_3 = mux(eq(UInt<2>("h3"), _synROMReg_T_1), filterROM_3, _GEN_2) @[BusInterface.scala 40:{19,19}]
    node filterROM_4 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_4 = mux(eq(UInt<3>("h4"), _synROMReg_T_1), filterROM_4, _GEN_3) @[BusInterface.scala 40:{19,19}]
    node _filterROM_synROMReg_T_1 = _GEN_4 @[BusInterface.scala 40:19]
    node _synROMReg_T_2 = mux(_synROMReg_T, _filterROM_synROMReg_T_1, UInt<1>("h0")) @[BusInterface.scala 40:19]
    node _io_valid_T = bits(synROMReg, 2, 2) @[BusInterface.scala 42:25]
    node _io_axonID_T = bits(synROMReg, 1, 0) @[BusInterface.scala 43:25]
    node _io_axonID_T_1 = cat(_io_axonID_T, axonIDLSBReg) @[BusInterface.scala 43:47]
    io_reqOut <= _io_reqOut_T_1 @[BusInterface.scala 32:13]
    io_tx <= _io_tx_T @[BusInterface.scala 31:9]
    io_axonID <= _io_axonID_T_1 @[BusInterface.scala 43:13]
    io_valid <= _io_valid_T @[BusInterface.scala 42:13]
    io_ready <= io_grant @[BusInterface.scala 33:13]
    axonIDLSBReg <= mux(reset, UInt<8>("h0"), _axonIDLSBReg_T) @[BusInterface.scala 36:{29,29} 37:16]
    synROMReg <= mux(reset, UInt<3>("h0"), _synROMReg_T_2) @[BusInterface.scala 39:{27,27} 40:13]

  module PriorityMaskRstEncoder :
    input clock : Clock
    input reset : UInt<1>
    input io_reqs_0 : UInt<1>
    input io_reqs_1 : UInt<1>
    input io_reqs_2 : UInt<1>
    input io_reqs_3 : UInt<1>
    input io_reqs_4 : UInt<1>
    input io_reqs_5 : UInt<1>
    input io_reqs_6 : UInt<1>
    input io_reqs_7 : UInt<1>
    output io_value : UInt<3>
    output io_mask_0 : UInt<1>
    output io_mask_1 : UInt<1>
    output io_mask_2 : UInt<1>
    output io_mask_3 : UInt<1>
    output io_mask_4 : UInt<1>
    output io_mask_5 : UInt<1>
    output io_mask_6 : UInt<1>
    output io_mask_7 : UInt<1>
    output io_rst_0 : UInt<1>
    output io_rst_1 : UInt<1>
    output io_rst_2 : UInt<1>
    output io_rst_3 : UInt<1>
    output io_rst_4 : UInt<1>
    output io_rst_5 : UInt<1>
    output io_rst_6 : UInt<1>
    output io_rst_7 : UInt<1>
    output io_valid : UInt<1>

    node _GEN_0 = mux(io_reqs_0, UInt<1>("h1"), UInt<1>("h0")) @[PriorityMaskRstEncoder.scala 17:12 21:22 22:16]
    node _GEN_1 = mux(io_reqs_0, UInt<1>("h0"), UInt<1>("h0")) @[PriorityMaskRstEncoder.scala 16:12 21:22 23:16]
    node _GEN_2 = mux(io_reqs_1, UInt<1>("h1"), _GEN_0) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_3 = mux(io_reqs_1, UInt<1>("h1"), _GEN_1) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _GEN_4 = mux(io_reqs_2, UInt<1>("h1"), _GEN_2) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_5 = mux(io_reqs_2, UInt<2>("h2"), _GEN_3) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _GEN_6 = mux(io_reqs_3, UInt<1>("h1"), _GEN_4) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_7 = mux(io_reqs_3, UInt<2>("h3"), _GEN_5) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _GEN_8 = mux(io_reqs_4, UInt<1>("h1"), _GEN_6) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_9 = mux(io_reqs_4, UInt<3>("h4"), _GEN_7) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _GEN_10 = mux(io_reqs_5, UInt<1>("h1"), _GEN_8) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_11 = mux(io_reqs_5, UInt<3>("h5"), _GEN_9) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _GEN_12 = mux(io_reqs_6, UInt<1>("h1"), _GEN_10) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_13 = mux(io_reqs_6, UInt<3>("h6"), _GEN_11) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _GEN_14 = mux(io_reqs_7, UInt<1>("h1"), _GEN_12) @[PriorityMaskRstEncoder.scala 21:22 22:16]
    node _GEN_15 = mux(io_reqs_7, UInt<3>("h7"), _GEN_13) @[PriorityMaskRstEncoder.scala 21:22 23:16]
    node _io_mask_0_T = or(io_mask_1, io_reqs_1) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_1_T = or(io_mask_2, io_reqs_2) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_2_T = or(io_mask_3, io_reqs_3) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_3_T = or(io_mask_4, io_reqs_4) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_4_T = or(io_mask_5, io_reqs_5) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_5_T = or(io_mask_6, io_reqs_6) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_6_T = or(io_mask_7, io_reqs_7) @[PriorityMaskRstEncoder.scala 29:34]
    node _io_mask_7_T = eq(io_value, UInt<1>("h0")) @[PriorityMaskRstEncoder.scala 30:38]
    node _io_rst_0_T = eq(UInt<1>("h0"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_0_T_1 = and(_io_rst_0_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_1_T = eq(UInt<1>("h1"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_1_T_1 = and(_io_rst_1_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_2_T = eq(UInt<2>("h2"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_2_T_1 = and(_io_rst_2_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_3_T = eq(UInt<2>("h3"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_3_T_1 = and(_io_rst_3_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_4_T = eq(UInt<3>("h4"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_4_T_1 = and(_io_rst_4_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_5_T = eq(UInt<3>("h5"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_5_T_1 = and(_io_rst_5_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_6_T = eq(UInt<3>("h6"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_6_T_1 = and(_io_rst_6_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    node _io_rst_7_T = eq(UInt<3>("h7"), io_value) @[PriorityMaskRstEncoder.scala 34:22]
    node _io_rst_7_T_1 = and(_io_rst_7_T, io_valid) @[PriorityMaskRstEncoder.scala 34:35]
    io_value <= _GEN_15
    io_mask_0 <= _io_mask_0_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_1 <= _io_mask_1_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_2 <= _io_mask_2_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_3 <= _io_mask_3_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_4 <= _io_mask_4_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_5 <= _io_mask_5_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_6 <= _io_mask_6_T @[PriorityMaskRstEncoder.scala 29:16]
    io_mask_7 <= _io_mask_7_T @[PriorityMaskRstEncoder.scala 30:26]
    io_rst_0 <= _io_rst_0_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_1 <= _io_rst_1_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_2 <= _io_rst_2_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_3 <= _io_rst_3_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_4 <= _io_rst_4_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_5 <= _io_rst_5_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_6 <= _io_rst_6_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_rst_7 <= _io_rst_7_T_1 @[PriorityMaskRstEncoder.scala 34:15]
    io_valid <= _GEN_14

  module TransmissionSystem :
    input clock : Clock
    input reset : UInt<1>
    output io_data : UInt<11>
    input io_ready : UInt<1>
    output io_valid : UInt<1>
    input io_n : UInt<5>
    input io_spikes_0 : UInt<1>
    input io_spikes_1 : UInt<1>
    input io_spikes_2 : UInt<1>
    input io_spikes_3 : UInt<1>
    input io_spikes_4 : UInt<1>
    input io_spikes_5 : UInt<1>
    input io_spikes_6 : UInt<1>
    input io_spikes_7 : UInt<1>

    inst spikeEncoder of PriorityMaskRstEncoder @[TransmissionSystem.scala 22:28]
    reg spikeRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_0) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_1) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_2) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_3) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_4) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_5) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_6) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_7) @[TransmissionSystem.scala 18:29]
    reg neuronIdMSB_0 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_0) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_1 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_1) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_2 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_2) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_3 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_3) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_4 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_4) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_5 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_5) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_6 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_6) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_7 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_7) @[TransmissionSystem.scala 19:29]
    reg maskRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_0) @[TransmissionSystem.scala 20:29]
    reg maskRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_1) @[TransmissionSystem.scala 20:29]
    reg maskRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_2) @[TransmissionSystem.scala 20:29]
    reg maskRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_3) @[TransmissionSystem.scala 20:29]
    reg maskRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_4) @[TransmissionSystem.scala 20:29]
    reg maskRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_5) @[TransmissionSystem.scala 20:29]
    reg maskRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_6) @[TransmissionSystem.scala 20:29]
    reg maskRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_7) @[TransmissionSystem.scala 20:29]
    node _encoderReqs_0_T = and(maskRegs_0, spikeRegs_0) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_0_T = and(spikeEncoder.io_rst_0, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_0_T_1 = not(_rstReadySel_0_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_0 = _rstReadySel_0_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_0_T = and(rstReadySel_0, spikeRegs_0) @[TransmissionSystem.scala 36:38]
    node _T = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_0 = mux(_T, UInt<1>("h1"), maskRegs_0) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_1 = mux(io_ready, spikeEncoder.io_mask_0, _GEN_0) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_0 = _spikeUpdate_0_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_1 = not(spikeUpdate_0) @[TransmissionSystem.scala 44:10]
    node _GEN_2 = mux(_T_1, io_n, neuronIdMSB_0) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_3 = mux(_T_1, io_spikes_0, spikeRegs_0) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_2 = eq(UInt<1>("h0"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T = cat(UInt<3>("h0"), neuronIdMSB_0) @[TransmissionSystem.scala 50:44]
    node _io_data_T_1 = cat(_io_data_T, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_4 = mux(_T_2, _io_data_T_1, UInt<1>("h0")) @[TransmissionSystem.scala 28:12 49:41 50:15]
    node _encoderReqs_1_T = and(maskRegs_1, spikeRegs_1) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_1_T = and(spikeEncoder.io_rst_1, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_1_T_1 = not(_rstReadySel_1_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_1 = _rstReadySel_1_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_1_T = and(rstReadySel_1, spikeRegs_1) @[TransmissionSystem.scala 36:38]
    node _T_3 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_5 = mux(_T_3, UInt<1>("h1"), maskRegs_1) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_6 = mux(io_ready, spikeEncoder.io_mask_1, _GEN_5) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_1 = _spikeUpdate_1_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_4 = not(spikeUpdate_1) @[TransmissionSystem.scala 44:10]
    node _GEN_7 = mux(_T_4, io_n, neuronIdMSB_1) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_8 = mux(_T_4, io_spikes_1, spikeRegs_1) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_5 = eq(UInt<1>("h1"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_2 = cat(UInt<3>("h0"), neuronIdMSB_1) @[TransmissionSystem.scala 50:44]
    node _io_data_T_3 = cat(_io_data_T_2, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_9 = mux(_T_5, _io_data_T_3, _GEN_4) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_2_T = and(maskRegs_2, spikeRegs_2) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_2_T = and(spikeEncoder.io_rst_2, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_2_T_1 = not(_rstReadySel_2_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_2 = _rstReadySel_2_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_2_T = and(rstReadySel_2, spikeRegs_2) @[TransmissionSystem.scala 36:38]
    node _T_6 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_10 = mux(_T_6, UInt<1>("h1"), maskRegs_2) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_11 = mux(io_ready, spikeEncoder.io_mask_2, _GEN_10) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_2 = _spikeUpdate_2_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_7 = not(spikeUpdate_2) @[TransmissionSystem.scala 44:10]
    node _GEN_12 = mux(_T_7, io_n, neuronIdMSB_2) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_13 = mux(_T_7, io_spikes_2, spikeRegs_2) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_8 = eq(UInt<2>("h2"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_4 = cat(UInt<3>("h0"), neuronIdMSB_2) @[TransmissionSystem.scala 50:44]
    node _io_data_T_5 = cat(_io_data_T_4, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_14 = mux(_T_8, _io_data_T_5, _GEN_9) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_3_T = and(maskRegs_3, spikeRegs_3) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_3_T = and(spikeEncoder.io_rst_3, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_3_T_1 = not(_rstReadySel_3_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_3 = _rstReadySel_3_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_3_T = and(rstReadySel_3, spikeRegs_3) @[TransmissionSystem.scala 36:38]
    node _T_9 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_15 = mux(_T_9, UInt<1>("h1"), maskRegs_3) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_16 = mux(io_ready, spikeEncoder.io_mask_3, _GEN_15) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_3 = _spikeUpdate_3_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_10 = not(spikeUpdate_3) @[TransmissionSystem.scala 44:10]
    node _GEN_17 = mux(_T_10, io_n, neuronIdMSB_3) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_18 = mux(_T_10, io_spikes_3, spikeRegs_3) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_11 = eq(UInt<2>("h3"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_6 = cat(UInt<3>("h0"), neuronIdMSB_3) @[TransmissionSystem.scala 50:44]
    node _io_data_T_7 = cat(_io_data_T_6, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_19 = mux(_T_11, _io_data_T_7, _GEN_14) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_4_T = and(maskRegs_4, spikeRegs_4) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_4_T = and(spikeEncoder.io_rst_4, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_4_T_1 = not(_rstReadySel_4_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_4 = _rstReadySel_4_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_4_T = and(rstReadySel_4, spikeRegs_4) @[TransmissionSystem.scala 36:38]
    node _T_12 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_20 = mux(_T_12, UInt<1>("h1"), maskRegs_4) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_21 = mux(io_ready, spikeEncoder.io_mask_4, _GEN_20) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_4 = _spikeUpdate_4_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_13 = not(spikeUpdate_4) @[TransmissionSystem.scala 44:10]
    node _GEN_22 = mux(_T_13, io_n, neuronIdMSB_4) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_23 = mux(_T_13, io_spikes_4, spikeRegs_4) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_14 = eq(UInt<3>("h4"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_8 = cat(UInt<3>("h0"), neuronIdMSB_4) @[TransmissionSystem.scala 50:44]
    node _io_data_T_9 = cat(_io_data_T_8, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_24 = mux(_T_14, _io_data_T_9, _GEN_19) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_5_T = and(maskRegs_5, spikeRegs_5) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_5_T = and(spikeEncoder.io_rst_5, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_5_T_1 = not(_rstReadySel_5_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_5 = _rstReadySel_5_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_5_T = and(rstReadySel_5, spikeRegs_5) @[TransmissionSystem.scala 36:38]
    node _T_15 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_25 = mux(_T_15, UInt<1>("h1"), maskRegs_5) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_26 = mux(io_ready, spikeEncoder.io_mask_5, _GEN_25) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_5 = _spikeUpdate_5_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_16 = not(spikeUpdate_5) @[TransmissionSystem.scala 44:10]
    node _GEN_27 = mux(_T_16, io_n, neuronIdMSB_5) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_28 = mux(_T_16, io_spikes_5, spikeRegs_5) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_17 = eq(UInt<3>("h5"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_10 = cat(UInt<3>("h0"), neuronIdMSB_5) @[TransmissionSystem.scala 50:44]
    node _io_data_T_11 = cat(_io_data_T_10, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_29 = mux(_T_17, _io_data_T_11, _GEN_24) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_6_T = and(maskRegs_6, spikeRegs_6) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_6_T = and(spikeEncoder.io_rst_6, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_6_T_1 = not(_rstReadySel_6_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_6 = _rstReadySel_6_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_6_T = and(rstReadySel_6, spikeRegs_6) @[TransmissionSystem.scala 36:38]
    node _T_18 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_30 = mux(_T_18, UInt<1>("h1"), maskRegs_6) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_31 = mux(io_ready, spikeEncoder.io_mask_6, _GEN_30) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_6 = _spikeUpdate_6_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_19 = not(spikeUpdate_6) @[TransmissionSystem.scala 44:10]
    node _GEN_32 = mux(_T_19, io_n, neuronIdMSB_6) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_33 = mux(_T_19, io_spikes_6, spikeRegs_6) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_20 = eq(UInt<3>("h6"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_12 = cat(UInt<3>("h0"), neuronIdMSB_6) @[TransmissionSystem.scala 50:44]
    node _io_data_T_13 = cat(_io_data_T_12, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_34 = mux(_T_20, _io_data_T_13, _GEN_29) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_7_T = and(maskRegs_7, spikeRegs_7) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_7_T = and(spikeEncoder.io_rst_7, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_7_T_1 = not(_rstReadySel_7_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_7 = _rstReadySel_7_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_7_T = and(rstReadySel_7, spikeRegs_7) @[TransmissionSystem.scala 36:38]
    node _T_21 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_35 = mux(_T_21, UInt<1>("h1"), maskRegs_7) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_36 = mux(io_ready, spikeEncoder.io_mask_7, _GEN_35) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_7 = _spikeUpdate_7_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_22 = not(spikeUpdate_7) @[TransmissionSystem.scala 44:10]
    node _GEN_37 = mux(_T_22, io_n, neuronIdMSB_7) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_38 = mux(_T_22, io_spikes_7, spikeRegs_7) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_23 = eq(UInt<3>("h7"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_14 = cat(UInt<3>("h0"), neuronIdMSB_7) @[TransmissionSystem.scala 50:44]
    node _io_data_T_15 = cat(_io_data_T_14, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_39 = mux(_T_23, _io_data_T_15, _GEN_34) @[TransmissionSystem.scala 49:41 50:15]
    node _spikeRegs_WIRE_0 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_1 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_2 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_3 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_4 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_5 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_6 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_7 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _neuronIdMSB_WIRE_0 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_1 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_2 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_3 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_4 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_5 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_6 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_7 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _maskRegs_WIRE_0 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_1 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_2 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_3 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_4 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_5 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_6 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_7 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node encoderReqs_0 = _encoderReqs_0_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_1 = _encoderReqs_1_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_2 = _encoderReqs_2_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_3 = _encoderReqs_3_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_4 = _encoderReqs_4_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_5 = _encoderReqs_5_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_6 = _encoderReqs_6_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_7 = _encoderReqs_7_T @[TransmissionSystem.scala 23:26 33:20]
    io_data <= _GEN_39
    io_valid <= spikeEncoder.io_valid @[TransmissionSystem.scala 29:12]
    spikeRegs_0 <= mux(reset, _spikeRegs_WIRE_0, _GEN_3) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_1 <= mux(reset, _spikeRegs_WIRE_1, _GEN_8) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_2 <= mux(reset, _spikeRegs_WIRE_2, _GEN_13) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_3 <= mux(reset, _spikeRegs_WIRE_3, _GEN_18) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_4 <= mux(reset, _spikeRegs_WIRE_4, _GEN_23) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_5 <= mux(reset, _spikeRegs_WIRE_5, _GEN_28) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_6 <= mux(reset, _spikeRegs_WIRE_6, _GEN_33) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_7 <= mux(reset, _spikeRegs_WIRE_7, _GEN_38) @[TransmissionSystem.scala 18:{29,29}]
    neuronIdMSB_0 <= mux(reset, _neuronIdMSB_WIRE_0, _GEN_2) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_1 <= mux(reset, _neuronIdMSB_WIRE_1, _GEN_7) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_2 <= mux(reset, _neuronIdMSB_WIRE_2, _GEN_12) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_3 <= mux(reset, _neuronIdMSB_WIRE_3, _GEN_17) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_4 <= mux(reset, _neuronIdMSB_WIRE_4, _GEN_22) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_5 <= mux(reset, _neuronIdMSB_WIRE_5, _GEN_27) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_6 <= mux(reset, _neuronIdMSB_WIRE_6, _GEN_32) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_7 <= mux(reset, _neuronIdMSB_WIRE_7, _GEN_37) @[TransmissionSystem.scala 19:{29,29}]
    maskRegs_0 <= mux(reset, _maskRegs_WIRE_0, _GEN_1) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_1 <= mux(reset, _maskRegs_WIRE_1, _GEN_6) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_2 <= mux(reset, _maskRegs_WIRE_2, _GEN_11) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_3 <= mux(reset, _maskRegs_WIRE_3, _GEN_16) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_4 <= mux(reset, _maskRegs_WIRE_4, _GEN_21) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_5 <= mux(reset, _maskRegs_WIRE_5, _GEN_26) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_6 <= mux(reset, _maskRegs_WIRE_6, _GEN_31) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_7 <= mux(reset, _maskRegs_WIRE_7, _GEN_36) @[TransmissionSystem.scala 20:{29,29}]
    spikeEncoder.clock <= clock
    spikeEncoder.reset <= reset
    spikeEncoder.io_reqs_0 <= encoderReqs_0 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_1 <= encoderReqs_1 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_2 <= encoderReqs_2 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_3 <= encoderReqs_3 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_4 <= encoderReqs_4 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_5 <= encoderReqs_5 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_6 <= encoderReqs_6 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_7 <= encoderReqs_7 @[TransmissionSystem.scala 30:24]

  module InputCore :
    input clock : Clock
    input reset : UInt<1>
    output io_pmClkEn : UInt<1>
    input io_newTS : UInt<1>
    input io_offCCHSin : UInt<1>
    output io_offCCHSout : UInt<1>
    output io_memEn : UInt<1>
    output io_memAddr : UInt<9>
    input io_memDo : UInt<9>
    input io_grant : UInt<1>
    output io_req : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>
    output io_nothing : UInt<3>

    inst interface of BusInterface @[InputCore.scala 33:25]
    inst spikeTrans of TransmissionSystem @[InputCore.scala 40:26]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[InputCore.scala 47:23]
    reg ts : UInt<9>, clock with :
      reset => (UInt<1>("h0"), ts) @[InputCore.scala 48:23]
    reg pixCnt : UInt<8>, clock with :
      reset => (UInt<1>("h0"), pixCnt) @[InputCore.scala 49:23]
    reg pixCntLate : UInt<8>, clock with :
      reset => (UInt<1>("h0"), pixCntLate) @[InputCore.scala 50:28]
    reg pixCntLater : UInt<8>, clock with :
      reset => (UInt<1>("h0"), pixCntLater) @[InputCore.scala 51:28]
    reg spikePulse_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_0) @[InputCore.scala 54:29]
    reg spikePulse_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_1) @[InputCore.scala 54:29]
    reg spikePulse_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_2) @[InputCore.scala 54:29]
    reg spikePulse_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_3) @[InputCore.scala 54:29]
    reg spikePulse_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_4) @[InputCore.scala 54:29]
    reg spikePulse_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_5) @[InputCore.scala 54:29]
    reg spikePulse_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_6) @[InputCore.scala 54:29]
    reg spikePulse_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_7) @[InputCore.scala 54:29]
    reg phase : UInt<1>, clock with :
      reset => (UInt<1>("h0"), phase) @[InputCore.scala 57:22]
    node _shouldSpike_res_T = eq(ts, UInt<1>("h0")) @[InputCore.scala 62:22]
    node _shouldSpike_res_T_1 = eq(io_memDo, UInt<1>("h0")) @[InputCore.scala 62:42]
    node _shouldSpike_res_T_2 = or(_shouldSpike_res_T, _shouldSpike_res_T_1) @[InputCore.scala 62:30]
    node _shouldSpike_res_T_3 = rem(ts, io_memDo) @[InputCore.scala 62:59]
    node shouldSpike_res = mux(_shouldSpike_res_T_2, UInt<1>("h1"), _shouldSpike_res_T_3) @[InputCore.scala 62:18]
    node _shouldSpike_T = eq(shouldSpike_res, UInt<1>("h0")) @[InputCore.scala 63:9]
    node _io_memAddr_T = add(pixCnt, UInt<9>("h100")) @[InputCore.scala 76:35]
    node _io_memAddr_T_1 = tail(_io_memAddr_T, 1) @[InputCore.scala 76:35]
    node _io_memAddr_T_2 = mux(phase, _io_memAddr_T_1, pixCnt) @[InputCore.scala 76:20]
    node _T = eq(UInt<3>("h0"), state) @[Conditional.scala 37:30]
    node _T_1 = neq(io_offCCHSin, phase) @[InputCore.scala 84:25]
    node _T_2 = and(_T_1, io_newTS) @[InputCore.scala 84:35]
    node _phase_T = eq(phase, UInt<1>("h0")) @[InputCore.scala 87:18]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 80:18 84:48 85:20]
    node _GEN_1 = mux(_T_2, UInt<3>("h1"), state) @[InputCore.scala 84:48 86:15 47:23]
    node _GEN_2 = mux(_T_2, _phase_T, phase) @[InputCore.scala 84:48 87:15 57:22]
    node _T_3 = eq(UInt<3>("h1"), state) @[Conditional.scala 37:30]
    node _pixCnt_T = add(pixCnt, UInt<1>("h1")) @[InputCore.scala 94:24]
    node _pixCnt_T_1 = tail(_pixCnt_T, 1) @[InputCore.scala 94:24]
    node _T_4 = eq(UInt<3>("h2"), state) @[Conditional.scala 37:30]
    node _pixCnt_T_2 = add(pixCnt, UInt<1>("h1")) @[InputCore.scala 103:24]
    node _pixCnt_T_3 = tail(_pixCnt_T_2, 1) @[InputCore.scala 103:24]
    node _sPulseDecSig_T = bits(pixCntLate, 2, 0) @[InputCore.scala 105:47]
    node _sPulseDecSig_T_1 = cat(UInt<1>("h0"), _sPulseDecSig_T) @[InputCore.scala 105:34]
    node shouldSpike = _shouldSpike_T @[InputCore.scala 53:26 71:17]
    node _GEN_3 = mux(shouldSpike, _sPulseDecSig_T_1, UInt<4>("h8")) @[InputCore.scala 104:25 105:22]
    node _T_5 = eq(pixCnt, UInt<8>("hff")) @[InputCore.scala 108:19]
    node _GEN_4 = mux(_T_5, UInt<3>("h3"), state) @[InputCore.scala 108:43 109:15 47:23]
    node _T_6 = eq(UInt<3>("h3"), state) @[Conditional.scala 37:30]
    node _ts_T = add(ts, UInt<1>("h1")) @[InputCore.scala 115:16]
    node _ts_T_1 = tail(_ts_T, 1) @[InputCore.scala 115:16]
    node _sPulseDecSig_T_2 = bits(pixCntLate, 2, 0) @[InputCore.scala 117:47]
    node _sPulseDecSig_T_3 = cat(UInt<1>("h0"), _sPulseDecSig_T_2) @[InputCore.scala 117:34]
    node _GEN_5 = mux(shouldSpike, _sPulseDecSig_T_3, UInt<4>("h8")) @[InputCore.scala 116:25 117:22]
    node _T_7 = eq(UInt<3>("h4"), state) @[Conditional.scala 37:30]
    node _T_8 = eq(interface.io_reqOut, UInt<1>("h0")) @[InputCore.scala 126:12]
    node _T_9 = eq(io_newTS, UInt<1>("h0")) @[InputCore.scala 126:36]
    node _T_10 = and(_T_8, _T_9) @[InputCore.scala 126:33]
    node _GEN_6 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[InputCore.scala 126:47 127:20 74:14]
    node _T_11 = eq(ts, UInt<9>("h1f3")) @[InputCore.scala 132:17]
    node _GEN_7 = mux(_T_11, UInt<3>("h0"), UInt<3>("h1")) @[InputCore.scala 132:28 133:17 135:17]
    node _GEN_8 = mux(io_newTS, UInt<1>("h1"), _GEN_6) @[InputCore.scala 130:22 131:20]
    node _GEN_9 = mux(io_newTS, _GEN_7, state) @[InputCore.scala 130:22 47:23]
    node _GEN_10 = mux(_T_7, _GEN_8, UInt<1>("h1")) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_11 = mux(_T_7, _GEN_9, state) @[Conditional.scala 39:67 InputCore.scala 47:23]
    node _GEN_12 = mux(_T_6, _ts_T_1, ts) @[Conditional.scala 39:67 InputCore.scala 115:10 48:23]
    node _GEN_13 = mux(_T_6, _GEN_5, UInt<4>("h8")) @[Conditional.scala 39:67]
    node _GEN_14 = mux(_T_6, UInt<3>("h4"), _GEN_11) @[Conditional.scala 39:67 InputCore.scala 120:13]
    node _GEN_15 = mux(_T_6, UInt<1>("h1"), _GEN_10) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_16 = mux(_T_4, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 InputCore.scala 102:16 75:14]
    node _GEN_17 = mux(_T_4, _pixCnt_T_3, pixCnt) @[Conditional.scala 39:67 InputCore.scala 103:14 49:23]
    node _GEN_18 = mux(_T_4, _GEN_3, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_19 = mux(_T_4, _GEN_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_20 = mux(_T_4, ts, _GEN_12) @[Conditional.scala 39:67 InputCore.scala 48:23]
    node _GEN_21 = mux(_T_4, UInt<1>("h1"), _GEN_15) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_22 = mux(_T_3, UInt<1>("h1"), _GEN_16) @[Conditional.scala 39:67 InputCore.scala 93:16]
    node _GEN_23 = mux(_T_3, _pixCnt_T_1, _GEN_17) @[Conditional.scala 39:67 InputCore.scala 94:14]
    node _GEN_24 = mux(_T_3, UInt<3>("h2"), _GEN_19) @[Conditional.scala 39:67 InputCore.scala 96:13]
    node _GEN_25 = mux(_T_3, UInt<4>("h8"), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_26 = mux(_T_3, ts, _GEN_20) @[Conditional.scala 39:67 InputCore.scala 48:23]
    node _GEN_27 = mux(_T_3, UInt<1>("h1"), _GEN_21) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_28 = mux(_T, _GEN_0, _GEN_27) @[Conditional.scala 40:58]
    node _GEN_29 = mux(_T, UInt<1>("h0"), _GEN_26) @[Conditional.scala 40:58 InputCore.scala 81:10]
    node _GEN_30 = mux(_T, UInt<1>("h0"), _GEN_23) @[Conditional.scala 40:58 InputCore.scala 82:14]
    node _GEN_31 = mux(_T, _GEN_1, _GEN_24) @[Conditional.scala 40:58]
    node _GEN_32 = mux(_T, _GEN_2, phase) @[Conditional.scala 40:58 InputCore.scala 57:22]
    node _GEN_33 = mux(_T, UInt<1>("h0"), _GEN_22) @[Conditional.scala 40:58 InputCore.scala 75:14]
    node _GEN_34 = mux(_T, UInt<4>("h8"), _GEN_25) @[Conditional.scala 40:58]
    node sPulseDecSig = _GEN_34
    node _T_12 = eq(sPulseDecSig, UInt<1>("h0")) @[InputCore.scala 144:24]
    node _GEN_35 = mux(_T_12, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_13 = eq(sPulseDecSig, UInt<1>("h1")) @[InputCore.scala 144:24]
    node _GEN_36 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_14 = eq(sPulseDecSig, UInt<2>("h2")) @[InputCore.scala 144:24]
    node _GEN_37 = mux(_T_14, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_15 = eq(sPulseDecSig, UInt<2>("h3")) @[InputCore.scala 144:24]
    node _GEN_38 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_16 = eq(sPulseDecSig, UInt<3>("h4")) @[InputCore.scala 144:24]
    node _GEN_39 = mux(_T_16, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_17 = eq(sPulseDecSig, UInt<3>("h5")) @[InputCore.scala 144:24]
    node _GEN_40 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_18 = eq(sPulseDecSig, UInt<3>("h6")) @[InputCore.scala 144:24]
    node _GEN_41 = mux(_T_18, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_19 = eq(sPulseDecSig, UInt<3>("h7")) @[InputCore.scala 144:24]
    node _GEN_42 = mux(_T_19, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _spikeTrans_io_n_T = bits(pixCntLater, 7, 3) @[InputCore.scala 150:33]
    node _spikePulse_WIRE_0 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_1 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_2 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_3 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_4 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_5 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_6 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_7 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    io_pmClkEn <= _GEN_28
    io_offCCHSout <= phase @[InputCore.scala 58:17]
    io_memEn <= _GEN_33
    io_memAddr <= _io_memAddr_T_2 @[InputCore.scala 76:14]
    io_req <= interface.io_reqOut @[InputCore.scala 35:22]
    io_tx <= interface.io_tx @[InputCore.scala 36:22]
    io_nothing <= UInt<1>("h0") @[InputCore.scala 30:14]
    interface.clock <= clock
    interface.reset <= reset
    interface.io_grant <= io_grant @[InputCore.scala 34:22]
    interface.io_rx <= io_rx @[InputCore.scala 37:22]
    interface.io_spikeID <= spikeTrans.io_data @[InputCore.scala 41:27]
    interface.io_reqIn <= spikeTrans.io_valid @[InputCore.scala 43:27]
    spikeTrans.clock <= clock
    spikeTrans.reset <= reset
    spikeTrans.io_ready <= interface.io_ready @[InputCore.scala 42:27]
    spikeTrans.io_n <= _spikeTrans_io_n_T @[InputCore.scala 150:19]
    spikeTrans.io_spikes_0 <= spikePulse_0 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_1 <= spikePulse_1 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_2 <= spikePulse_2 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_3 <= spikePulse_3 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_4 <= spikePulse_4 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_5 <= spikePulse_5 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_6 <= spikePulse_6 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_7 <= spikePulse_7 @[InputCore.scala 152:29]
    state <= mux(reset, UInt<3>("h0"), _GEN_31) @[InputCore.scala 47:{23,23}]
    ts <= mux(reset, UInt<9>("h0"), _GEN_29) @[InputCore.scala 48:{23,23}]
    pixCnt <= mux(reset, UInt<8>("h0"), _GEN_30) @[InputCore.scala 49:{23,23}]
    pixCntLate <= pixCnt @[InputCore.scala 50:28]
    pixCntLater <= pixCntLate @[InputCore.scala 51:28]
    spikePulse_0 <= mux(reset, _spikePulse_WIRE_0, _GEN_35) @[InputCore.scala 54:{29,29}]
    spikePulse_1 <= mux(reset, _spikePulse_WIRE_1, _GEN_36) @[InputCore.scala 54:{29,29}]
    spikePulse_2 <= mux(reset, _spikePulse_WIRE_2, _GEN_37) @[InputCore.scala 54:{29,29}]
    spikePulse_3 <= mux(reset, _spikePulse_WIRE_3, _GEN_38) @[InputCore.scala 54:{29,29}]
    spikePulse_4 <= mux(reset, _spikePulse_WIRE_4, _GEN_39) @[InputCore.scala 54:{29,29}]
    spikePulse_5 <= mux(reset, _spikePulse_WIRE_5, _GEN_40) @[InputCore.scala 54:{29,29}]
    spikePulse_6 <= mux(reset, _spikePulse_WIRE_6, _GEN_41) @[InputCore.scala 54:{29,29}]
    spikePulse_7 <= mux(reset, _spikePulse_WIRE_7, _GEN_42) @[InputCore.scala 54:{29,29}]
    phase <= mux(reset, UInt<1>("h0"), _GEN_32) @[InputCore.scala 57:{22,22}]

  module TransmissionSystem_1 :
    input clock : Clock
    input reset : UInt<1>
    output io_data : UInt<11>
    input io_ready : UInt<1>
    output io_valid : UInt<1>
    input io_n : UInt<5>
    input io_spikes_0 : UInt<1>
    input io_spikes_1 : UInt<1>
    input io_spikes_2 : UInt<1>
    input io_spikes_3 : UInt<1>
    input io_spikes_4 : UInt<1>
    input io_spikes_5 : UInt<1>
    input io_spikes_6 : UInt<1>
    input io_spikes_7 : UInt<1>

    inst spikeEncoder of PriorityMaskRstEncoder @[TransmissionSystem.scala 22:28]
    reg spikeRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_0) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_1) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_2) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_3) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_4) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_5) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_6) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_7) @[TransmissionSystem.scala 18:29]
    reg neuronIdMSB_0 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_0) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_1 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_1) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_2 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_2) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_3 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_3) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_4 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_4) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_5 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_5) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_6 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_6) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_7 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_7) @[TransmissionSystem.scala 19:29]
    reg maskRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_0) @[TransmissionSystem.scala 20:29]
    reg maskRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_1) @[TransmissionSystem.scala 20:29]
    reg maskRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_2) @[TransmissionSystem.scala 20:29]
    reg maskRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_3) @[TransmissionSystem.scala 20:29]
    reg maskRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_4) @[TransmissionSystem.scala 20:29]
    reg maskRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_5) @[TransmissionSystem.scala 20:29]
    reg maskRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_6) @[TransmissionSystem.scala 20:29]
    reg maskRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_7) @[TransmissionSystem.scala 20:29]
    node _encoderReqs_0_T = and(maskRegs_0, spikeRegs_0) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_0_T = and(spikeEncoder.io_rst_0, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_0_T_1 = not(_rstReadySel_0_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_0 = _rstReadySel_0_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_0_T = and(rstReadySel_0, spikeRegs_0) @[TransmissionSystem.scala 36:38]
    node _T = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_0 = mux(_T, UInt<1>("h1"), maskRegs_0) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_1 = mux(io_ready, spikeEncoder.io_mask_0, _GEN_0) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_0 = _spikeUpdate_0_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_1 = not(spikeUpdate_0) @[TransmissionSystem.scala 44:10]
    node _GEN_2 = mux(_T_1, io_n, neuronIdMSB_0) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_3 = mux(_T_1, io_spikes_0, spikeRegs_0) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_2 = eq(UInt<1>("h0"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T = cat(UInt<3>("h1"), neuronIdMSB_0) @[TransmissionSystem.scala 50:44]
    node _io_data_T_1 = cat(_io_data_T, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_4 = mux(_T_2, _io_data_T_1, UInt<1>("h0")) @[TransmissionSystem.scala 28:12 49:41 50:15]
    node _encoderReqs_1_T = and(maskRegs_1, spikeRegs_1) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_1_T = and(spikeEncoder.io_rst_1, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_1_T_1 = not(_rstReadySel_1_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_1 = _rstReadySel_1_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_1_T = and(rstReadySel_1, spikeRegs_1) @[TransmissionSystem.scala 36:38]
    node _T_3 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_5 = mux(_T_3, UInt<1>("h1"), maskRegs_1) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_6 = mux(io_ready, spikeEncoder.io_mask_1, _GEN_5) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_1 = _spikeUpdate_1_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_4 = not(spikeUpdate_1) @[TransmissionSystem.scala 44:10]
    node _GEN_7 = mux(_T_4, io_n, neuronIdMSB_1) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_8 = mux(_T_4, io_spikes_1, spikeRegs_1) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_5 = eq(UInt<1>("h1"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_2 = cat(UInt<3>("h1"), neuronIdMSB_1) @[TransmissionSystem.scala 50:44]
    node _io_data_T_3 = cat(_io_data_T_2, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_9 = mux(_T_5, _io_data_T_3, _GEN_4) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_2_T = and(maskRegs_2, spikeRegs_2) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_2_T = and(spikeEncoder.io_rst_2, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_2_T_1 = not(_rstReadySel_2_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_2 = _rstReadySel_2_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_2_T = and(rstReadySel_2, spikeRegs_2) @[TransmissionSystem.scala 36:38]
    node _T_6 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_10 = mux(_T_6, UInt<1>("h1"), maskRegs_2) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_11 = mux(io_ready, spikeEncoder.io_mask_2, _GEN_10) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_2 = _spikeUpdate_2_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_7 = not(spikeUpdate_2) @[TransmissionSystem.scala 44:10]
    node _GEN_12 = mux(_T_7, io_n, neuronIdMSB_2) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_13 = mux(_T_7, io_spikes_2, spikeRegs_2) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_8 = eq(UInt<2>("h2"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_4 = cat(UInt<3>("h1"), neuronIdMSB_2) @[TransmissionSystem.scala 50:44]
    node _io_data_T_5 = cat(_io_data_T_4, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_14 = mux(_T_8, _io_data_T_5, _GEN_9) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_3_T = and(maskRegs_3, spikeRegs_3) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_3_T = and(spikeEncoder.io_rst_3, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_3_T_1 = not(_rstReadySel_3_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_3 = _rstReadySel_3_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_3_T = and(rstReadySel_3, spikeRegs_3) @[TransmissionSystem.scala 36:38]
    node _T_9 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_15 = mux(_T_9, UInt<1>("h1"), maskRegs_3) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_16 = mux(io_ready, spikeEncoder.io_mask_3, _GEN_15) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_3 = _spikeUpdate_3_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_10 = not(spikeUpdate_3) @[TransmissionSystem.scala 44:10]
    node _GEN_17 = mux(_T_10, io_n, neuronIdMSB_3) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_18 = mux(_T_10, io_spikes_3, spikeRegs_3) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_11 = eq(UInt<2>("h3"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_6 = cat(UInt<3>("h1"), neuronIdMSB_3) @[TransmissionSystem.scala 50:44]
    node _io_data_T_7 = cat(_io_data_T_6, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_19 = mux(_T_11, _io_data_T_7, _GEN_14) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_4_T = and(maskRegs_4, spikeRegs_4) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_4_T = and(spikeEncoder.io_rst_4, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_4_T_1 = not(_rstReadySel_4_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_4 = _rstReadySel_4_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_4_T = and(rstReadySel_4, spikeRegs_4) @[TransmissionSystem.scala 36:38]
    node _T_12 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_20 = mux(_T_12, UInt<1>("h1"), maskRegs_4) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_21 = mux(io_ready, spikeEncoder.io_mask_4, _GEN_20) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_4 = _spikeUpdate_4_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_13 = not(spikeUpdate_4) @[TransmissionSystem.scala 44:10]
    node _GEN_22 = mux(_T_13, io_n, neuronIdMSB_4) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_23 = mux(_T_13, io_spikes_4, spikeRegs_4) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_14 = eq(UInt<3>("h4"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_8 = cat(UInt<3>("h1"), neuronIdMSB_4) @[TransmissionSystem.scala 50:44]
    node _io_data_T_9 = cat(_io_data_T_8, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_24 = mux(_T_14, _io_data_T_9, _GEN_19) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_5_T = and(maskRegs_5, spikeRegs_5) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_5_T = and(spikeEncoder.io_rst_5, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_5_T_1 = not(_rstReadySel_5_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_5 = _rstReadySel_5_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_5_T = and(rstReadySel_5, spikeRegs_5) @[TransmissionSystem.scala 36:38]
    node _T_15 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_25 = mux(_T_15, UInt<1>("h1"), maskRegs_5) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_26 = mux(io_ready, spikeEncoder.io_mask_5, _GEN_25) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_5 = _spikeUpdate_5_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_16 = not(spikeUpdate_5) @[TransmissionSystem.scala 44:10]
    node _GEN_27 = mux(_T_16, io_n, neuronIdMSB_5) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_28 = mux(_T_16, io_spikes_5, spikeRegs_5) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_17 = eq(UInt<3>("h5"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_10 = cat(UInt<3>("h1"), neuronIdMSB_5) @[TransmissionSystem.scala 50:44]
    node _io_data_T_11 = cat(_io_data_T_10, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_29 = mux(_T_17, _io_data_T_11, _GEN_24) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_6_T = and(maskRegs_6, spikeRegs_6) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_6_T = and(spikeEncoder.io_rst_6, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_6_T_1 = not(_rstReadySel_6_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_6 = _rstReadySel_6_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_6_T = and(rstReadySel_6, spikeRegs_6) @[TransmissionSystem.scala 36:38]
    node _T_18 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_30 = mux(_T_18, UInt<1>("h1"), maskRegs_6) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_31 = mux(io_ready, spikeEncoder.io_mask_6, _GEN_30) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_6 = _spikeUpdate_6_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_19 = not(spikeUpdate_6) @[TransmissionSystem.scala 44:10]
    node _GEN_32 = mux(_T_19, io_n, neuronIdMSB_6) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_33 = mux(_T_19, io_spikes_6, spikeRegs_6) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_20 = eq(UInt<3>("h6"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_12 = cat(UInt<3>("h1"), neuronIdMSB_6) @[TransmissionSystem.scala 50:44]
    node _io_data_T_13 = cat(_io_data_T_12, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_34 = mux(_T_20, _io_data_T_13, _GEN_29) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_7_T = and(maskRegs_7, spikeRegs_7) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_7_T = and(spikeEncoder.io_rst_7, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_7_T_1 = not(_rstReadySel_7_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_7 = _rstReadySel_7_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_7_T = and(rstReadySel_7, spikeRegs_7) @[TransmissionSystem.scala 36:38]
    node _T_21 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_35 = mux(_T_21, UInt<1>("h1"), maskRegs_7) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_36 = mux(io_ready, spikeEncoder.io_mask_7, _GEN_35) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_7 = _spikeUpdate_7_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_22 = not(spikeUpdate_7) @[TransmissionSystem.scala 44:10]
    node _GEN_37 = mux(_T_22, io_n, neuronIdMSB_7) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_38 = mux(_T_22, io_spikes_7, spikeRegs_7) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_23 = eq(UInt<3>("h7"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_14 = cat(UInt<3>("h1"), neuronIdMSB_7) @[TransmissionSystem.scala 50:44]
    node _io_data_T_15 = cat(_io_data_T_14, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_39 = mux(_T_23, _io_data_T_15, _GEN_34) @[TransmissionSystem.scala 49:41 50:15]
    node _spikeRegs_WIRE_0 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_1 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_2 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_3 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_4 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_5 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_6 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_7 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _neuronIdMSB_WIRE_0 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_1 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_2 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_3 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_4 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_5 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_6 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_7 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _maskRegs_WIRE_0 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_1 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_2 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_3 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_4 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_5 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_6 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_7 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node encoderReqs_0 = _encoderReqs_0_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_1 = _encoderReqs_1_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_2 = _encoderReqs_2_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_3 = _encoderReqs_3_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_4 = _encoderReqs_4_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_5 = _encoderReqs_5_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_6 = _encoderReqs_6_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_7 = _encoderReqs_7_T @[TransmissionSystem.scala 23:26 33:20]
    io_data <= _GEN_39
    io_valid <= spikeEncoder.io_valid @[TransmissionSystem.scala 29:12]
    spikeRegs_0 <= mux(reset, _spikeRegs_WIRE_0, _GEN_3) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_1 <= mux(reset, _spikeRegs_WIRE_1, _GEN_8) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_2 <= mux(reset, _spikeRegs_WIRE_2, _GEN_13) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_3 <= mux(reset, _spikeRegs_WIRE_3, _GEN_18) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_4 <= mux(reset, _spikeRegs_WIRE_4, _GEN_23) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_5 <= mux(reset, _spikeRegs_WIRE_5, _GEN_28) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_6 <= mux(reset, _spikeRegs_WIRE_6, _GEN_33) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_7 <= mux(reset, _spikeRegs_WIRE_7, _GEN_38) @[TransmissionSystem.scala 18:{29,29}]
    neuronIdMSB_0 <= mux(reset, _neuronIdMSB_WIRE_0, _GEN_2) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_1 <= mux(reset, _neuronIdMSB_WIRE_1, _GEN_7) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_2 <= mux(reset, _neuronIdMSB_WIRE_2, _GEN_12) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_3 <= mux(reset, _neuronIdMSB_WIRE_3, _GEN_17) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_4 <= mux(reset, _neuronIdMSB_WIRE_4, _GEN_22) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_5 <= mux(reset, _neuronIdMSB_WIRE_5, _GEN_27) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_6 <= mux(reset, _neuronIdMSB_WIRE_6, _GEN_32) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_7 <= mux(reset, _neuronIdMSB_WIRE_7, _GEN_37) @[TransmissionSystem.scala 19:{29,29}]
    maskRegs_0 <= mux(reset, _maskRegs_WIRE_0, _GEN_1) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_1 <= mux(reset, _maskRegs_WIRE_1, _GEN_6) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_2 <= mux(reset, _maskRegs_WIRE_2, _GEN_11) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_3 <= mux(reset, _maskRegs_WIRE_3, _GEN_16) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_4 <= mux(reset, _maskRegs_WIRE_4, _GEN_21) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_5 <= mux(reset, _maskRegs_WIRE_5, _GEN_26) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_6 <= mux(reset, _maskRegs_WIRE_6, _GEN_31) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_7 <= mux(reset, _maskRegs_WIRE_7, _GEN_36) @[TransmissionSystem.scala 20:{29,29}]
    spikeEncoder.clock <= clock
    spikeEncoder.reset <= reset
    spikeEncoder.io_reqs_0 <= encoderReqs_0 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_1 <= encoderReqs_1 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_2 <= encoderReqs_2 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_3 <= encoderReqs_3 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_4 <= encoderReqs_4 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_5 <= encoderReqs_5 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_6 <= encoderReqs_6 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_7 <= encoderReqs_7 @[TransmissionSystem.scala 30:24]

  module InputCore_1 :
    input clock : Clock
    input reset : UInt<1>
    output io_pmClkEn : UInt<1>
    input io_newTS : UInt<1>
    input io_offCCHSin : UInt<1>
    output io_offCCHSout : UInt<1>
    output io_memEn : UInt<1>
    output io_memAddr : UInt<9>
    input io_memDo : UInt<9>
    input io_grant : UInt<1>
    output io_req : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>
    output io_nothing : UInt<3>

    inst interface of BusInterface @[InputCore.scala 33:25]
    inst spikeTrans of TransmissionSystem_1 @[InputCore.scala 40:26]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[InputCore.scala 47:23]
    reg ts : UInt<9>, clock with :
      reset => (UInt<1>("h0"), ts) @[InputCore.scala 48:23]
    reg pixCnt : UInt<8>, clock with :
      reset => (UInt<1>("h0"), pixCnt) @[InputCore.scala 49:23]
    reg pixCntLate : UInt<8>, clock with :
      reset => (UInt<1>("h0"), pixCntLate) @[InputCore.scala 50:28]
    reg pixCntLater : UInt<8>, clock with :
      reset => (UInt<1>("h0"), pixCntLater) @[InputCore.scala 51:28]
    reg spikePulse_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_0) @[InputCore.scala 54:29]
    reg spikePulse_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_1) @[InputCore.scala 54:29]
    reg spikePulse_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_2) @[InputCore.scala 54:29]
    reg spikePulse_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_3) @[InputCore.scala 54:29]
    reg spikePulse_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_4) @[InputCore.scala 54:29]
    reg spikePulse_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_5) @[InputCore.scala 54:29]
    reg spikePulse_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_6) @[InputCore.scala 54:29]
    reg spikePulse_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_7) @[InputCore.scala 54:29]
    reg phase : UInt<1>, clock with :
      reset => (UInt<1>("h0"), phase) @[InputCore.scala 57:22]
    node _shouldSpike_res_T = eq(ts, UInt<1>("h0")) @[InputCore.scala 62:22]
    node _shouldSpike_res_T_1 = eq(io_memDo, UInt<1>("h0")) @[InputCore.scala 62:42]
    node _shouldSpike_res_T_2 = or(_shouldSpike_res_T, _shouldSpike_res_T_1) @[InputCore.scala 62:30]
    node _shouldSpike_res_T_3 = rem(ts, io_memDo) @[InputCore.scala 62:59]
    node shouldSpike_res = mux(_shouldSpike_res_T_2, UInt<1>("h1"), _shouldSpike_res_T_3) @[InputCore.scala 62:18]
    node _shouldSpike_T = eq(shouldSpike_res, UInt<1>("h0")) @[InputCore.scala 63:9]
    node _io_memAddr_T = add(pixCnt, UInt<9>("h100")) @[InputCore.scala 76:35]
    node _io_memAddr_T_1 = tail(_io_memAddr_T, 1) @[InputCore.scala 76:35]
    node _io_memAddr_T_2 = mux(phase, _io_memAddr_T_1, pixCnt) @[InputCore.scala 76:20]
    node _T = eq(UInt<3>("h0"), state) @[Conditional.scala 37:30]
    node _T_1 = neq(io_offCCHSin, phase) @[InputCore.scala 84:25]
    node _T_2 = and(_T_1, io_newTS) @[InputCore.scala 84:35]
    node _phase_T = eq(phase, UInt<1>("h0")) @[InputCore.scala 87:18]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 80:18 84:48 85:20]
    node _GEN_1 = mux(_T_2, UInt<3>("h1"), state) @[InputCore.scala 84:48 86:15 47:23]
    node _GEN_2 = mux(_T_2, _phase_T, phase) @[InputCore.scala 84:48 87:15 57:22]
    node _T_3 = eq(UInt<3>("h1"), state) @[Conditional.scala 37:30]
    node _pixCnt_T = add(pixCnt, UInt<1>("h1")) @[InputCore.scala 94:24]
    node _pixCnt_T_1 = tail(_pixCnt_T, 1) @[InputCore.scala 94:24]
    node _T_4 = eq(UInt<3>("h2"), state) @[Conditional.scala 37:30]
    node _pixCnt_T_2 = add(pixCnt, UInt<1>("h1")) @[InputCore.scala 103:24]
    node _pixCnt_T_3 = tail(_pixCnt_T_2, 1) @[InputCore.scala 103:24]
    node _sPulseDecSig_T = bits(pixCntLate, 2, 0) @[InputCore.scala 105:47]
    node _sPulseDecSig_T_1 = cat(UInt<1>("h0"), _sPulseDecSig_T) @[InputCore.scala 105:34]
    node shouldSpike = _shouldSpike_T @[InputCore.scala 53:26 71:17]
    node _GEN_3 = mux(shouldSpike, _sPulseDecSig_T_1, UInt<4>("h8")) @[InputCore.scala 104:25 105:22]
    node _T_5 = eq(pixCnt, UInt<8>("hff")) @[InputCore.scala 108:19]
    node _GEN_4 = mux(_T_5, UInt<3>("h3"), state) @[InputCore.scala 108:43 109:15 47:23]
    node _T_6 = eq(UInt<3>("h3"), state) @[Conditional.scala 37:30]
    node _ts_T = add(ts, UInt<1>("h1")) @[InputCore.scala 115:16]
    node _ts_T_1 = tail(_ts_T, 1) @[InputCore.scala 115:16]
    node _sPulseDecSig_T_2 = bits(pixCntLate, 2, 0) @[InputCore.scala 117:47]
    node _sPulseDecSig_T_3 = cat(UInt<1>("h0"), _sPulseDecSig_T_2) @[InputCore.scala 117:34]
    node _GEN_5 = mux(shouldSpike, _sPulseDecSig_T_3, UInt<4>("h8")) @[InputCore.scala 116:25 117:22]
    node _T_7 = eq(UInt<3>("h4"), state) @[Conditional.scala 37:30]
    node _T_8 = eq(interface.io_reqOut, UInt<1>("h0")) @[InputCore.scala 126:12]
    node _T_9 = eq(io_newTS, UInt<1>("h0")) @[InputCore.scala 126:36]
    node _T_10 = and(_T_8, _T_9) @[InputCore.scala 126:33]
    node _GEN_6 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[InputCore.scala 126:47 127:20 74:14]
    node _T_11 = eq(ts, UInt<9>("h1f3")) @[InputCore.scala 132:17]
    node _GEN_7 = mux(_T_11, UInt<3>("h0"), UInt<3>("h1")) @[InputCore.scala 132:28 133:17 135:17]
    node _GEN_8 = mux(io_newTS, UInt<1>("h1"), _GEN_6) @[InputCore.scala 130:22 131:20]
    node _GEN_9 = mux(io_newTS, _GEN_7, state) @[InputCore.scala 130:22 47:23]
    node _GEN_10 = mux(_T_7, _GEN_8, UInt<1>("h1")) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_11 = mux(_T_7, _GEN_9, state) @[Conditional.scala 39:67 InputCore.scala 47:23]
    node _GEN_12 = mux(_T_6, _ts_T_1, ts) @[Conditional.scala 39:67 InputCore.scala 115:10 48:23]
    node _GEN_13 = mux(_T_6, _GEN_5, UInt<4>("h8")) @[Conditional.scala 39:67]
    node _GEN_14 = mux(_T_6, UInt<3>("h4"), _GEN_11) @[Conditional.scala 39:67 InputCore.scala 120:13]
    node _GEN_15 = mux(_T_6, UInt<1>("h1"), _GEN_10) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_16 = mux(_T_4, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 InputCore.scala 102:16 75:14]
    node _GEN_17 = mux(_T_4, _pixCnt_T_3, pixCnt) @[Conditional.scala 39:67 InputCore.scala 103:14 49:23]
    node _GEN_18 = mux(_T_4, _GEN_3, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_19 = mux(_T_4, _GEN_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_20 = mux(_T_4, ts, _GEN_12) @[Conditional.scala 39:67 InputCore.scala 48:23]
    node _GEN_21 = mux(_T_4, UInt<1>("h1"), _GEN_15) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_22 = mux(_T_3, UInt<1>("h1"), _GEN_16) @[Conditional.scala 39:67 InputCore.scala 93:16]
    node _GEN_23 = mux(_T_3, _pixCnt_T_1, _GEN_17) @[Conditional.scala 39:67 InputCore.scala 94:14]
    node _GEN_24 = mux(_T_3, UInt<3>("h2"), _GEN_19) @[Conditional.scala 39:67 InputCore.scala 96:13]
    node _GEN_25 = mux(_T_3, UInt<4>("h8"), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_26 = mux(_T_3, ts, _GEN_20) @[Conditional.scala 39:67 InputCore.scala 48:23]
    node _GEN_27 = mux(_T_3, UInt<1>("h1"), _GEN_21) @[Conditional.scala 39:67 InputCore.scala 74:14]
    node _GEN_28 = mux(_T, _GEN_0, _GEN_27) @[Conditional.scala 40:58]
    node _GEN_29 = mux(_T, UInt<1>("h0"), _GEN_26) @[Conditional.scala 40:58 InputCore.scala 81:10]
    node _GEN_30 = mux(_T, UInt<1>("h0"), _GEN_23) @[Conditional.scala 40:58 InputCore.scala 82:14]
    node _GEN_31 = mux(_T, _GEN_1, _GEN_24) @[Conditional.scala 40:58]
    node _GEN_32 = mux(_T, _GEN_2, phase) @[Conditional.scala 40:58 InputCore.scala 57:22]
    node _GEN_33 = mux(_T, UInt<1>("h0"), _GEN_22) @[Conditional.scala 40:58 InputCore.scala 75:14]
    node _GEN_34 = mux(_T, UInt<4>("h8"), _GEN_25) @[Conditional.scala 40:58]
    node sPulseDecSig = _GEN_34
    node _T_12 = eq(sPulseDecSig, UInt<1>("h0")) @[InputCore.scala 144:24]
    node _GEN_35 = mux(_T_12, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_13 = eq(sPulseDecSig, UInt<1>("h1")) @[InputCore.scala 144:24]
    node _GEN_36 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_14 = eq(sPulseDecSig, UInt<2>("h2")) @[InputCore.scala 144:24]
    node _GEN_37 = mux(_T_14, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_15 = eq(sPulseDecSig, UInt<2>("h3")) @[InputCore.scala 144:24]
    node _GEN_38 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_16 = eq(sPulseDecSig, UInt<3>("h4")) @[InputCore.scala 144:24]
    node _GEN_39 = mux(_T_16, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_17 = eq(sPulseDecSig, UInt<3>("h5")) @[InputCore.scala 144:24]
    node _GEN_40 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_18 = eq(sPulseDecSig, UInt<3>("h6")) @[InputCore.scala 144:24]
    node _GEN_41 = mux(_T_18, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _T_19 = eq(sPulseDecSig, UInt<3>("h7")) @[InputCore.scala 144:24]
    node _GEN_42 = mux(_T_19, UInt<1>("h1"), UInt<1>("h0")) @[InputCore.scala 143:19 144:33 145:21]
    node _spikeTrans_io_n_T = bits(pixCntLater, 7, 3) @[InputCore.scala 150:33]
    node _spikePulse_WIRE_0 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_1 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_2 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_3 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_4 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_5 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_6 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    node _spikePulse_WIRE_7 = UInt<1>("h0") @[InputCore.scala 54:{37,37}]
    io_pmClkEn <= _GEN_28
    io_offCCHSout <= phase @[InputCore.scala 58:17]
    io_memEn <= _GEN_33
    io_memAddr <= _io_memAddr_T_2 @[InputCore.scala 76:14]
    io_req <= interface.io_reqOut @[InputCore.scala 35:22]
    io_tx <= interface.io_tx @[InputCore.scala 36:22]
    io_nothing <= UInt<1>("h1") @[InputCore.scala 30:14]
    interface.clock <= clock
    interface.reset <= reset
    interface.io_grant <= io_grant @[InputCore.scala 34:22]
    interface.io_rx <= io_rx @[InputCore.scala 37:22]
    interface.io_spikeID <= spikeTrans.io_data @[InputCore.scala 41:27]
    interface.io_reqIn <= spikeTrans.io_valid @[InputCore.scala 43:27]
    spikeTrans.clock <= clock
    spikeTrans.reset <= reset
    spikeTrans.io_ready <= interface.io_ready @[InputCore.scala 42:27]
    spikeTrans.io_n <= _spikeTrans_io_n_T @[InputCore.scala 150:19]
    spikeTrans.io_spikes_0 <= spikePulse_0 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_1 <= spikePulse_1 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_2 <= spikePulse_2 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_3 <= spikePulse_3 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_4 <= spikePulse_4 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_5 <= spikePulse_5 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_6 <= spikePulse_6 @[InputCore.scala 152:29]
    spikeTrans.io_spikes_7 <= spikePulse_7 @[InputCore.scala 152:29]
    state <= mux(reset, UInt<3>("h0"), _GEN_31) @[InputCore.scala 47:{23,23}]
    ts <= mux(reset, UInt<9>("h0"), _GEN_29) @[InputCore.scala 48:{23,23}]
    pixCnt <= mux(reset, UInt<8>("h0"), _GEN_30) @[InputCore.scala 49:{23,23}]
    pixCntLate <= pixCnt @[InputCore.scala 50:28]
    pixCntLater <= pixCntLate @[InputCore.scala 51:28]
    spikePulse_0 <= mux(reset, _spikePulse_WIRE_0, _GEN_35) @[InputCore.scala 54:{29,29}]
    spikePulse_1 <= mux(reset, _spikePulse_WIRE_1, _GEN_36) @[InputCore.scala 54:{29,29}]
    spikePulse_2 <= mux(reset, _spikePulse_WIRE_2, _GEN_37) @[InputCore.scala 54:{29,29}]
    spikePulse_3 <= mux(reset, _spikePulse_WIRE_3, _GEN_38) @[InputCore.scala 54:{29,29}]
    spikePulse_4 <= mux(reset, _spikePulse_WIRE_4, _GEN_39) @[InputCore.scala 54:{29,29}]
    spikePulse_5 <= mux(reset, _spikePulse_WIRE_5, _GEN_40) @[InputCore.scala 54:{29,29}]
    spikePulse_6 <= mux(reset, _spikePulse_WIRE_6, _GEN_41) @[InputCore.scala 54:{29,29}]
    spikePulse_7 <= mux(reset, _spikePulse_WIRE_7, _GEN_42) @[InputCore.scala 54:{29,29}]
    phase <= mux(reset, UInt<1>("h0"), _GEN_32) @[InputCore.scala 57:{22,22}]

  module BusInterface_2 :
    input clock : Clock
    input reset : UInt<1>
    input io_grant : UInt<1>
    output io_reqOut : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>
    output io_axonID : UInt<10>
    output io_valid : UInt<1>
    input io_spikeID : UInt<11>
    output io_ready : UInt<1>
    input io_reqIn : UInt<1>

    node _io_tx_T = mux(io_grant, io_spikeID, UInt<1>("h0")) @[BusInterface.scala 31:15]
    node _io_reqOut_T = not(io_grant) @[BusInterface.scala 32:28]
    node _io_reqOut_T_1 = and(io_reqIn, _io_reqOut_T) @[BusInterface.scala 32:25]
    reg axonIDLSBReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), axonIDLSBReg) @[BusInterface.scala 36:29]
    node _axonIDLSBReg_T = bits(io_rx, 7, 0) @[BusInterface.scala 37:24]
    reg synROMReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), synROMReg) @[BusInterface.scala 39:27]
    node _synROMReg_T = orr(io_rx) @[BusInterface.scala 40:26]
    node _synROMReg_T_1 = bits(io_rx, 10, 8) @[BusInterface.scala 40:46]
    node filterROM_0 = UInt<3>("h4") @[BusInterface.scala 28:{27,27}]
    node _GEN_0 = validif(eq(UInt<1>("h0"), _synROMReg_T_1), filterROM_0) @[BusInterface.scala 40:{19,19}]
    node filterROM_1 = UInt<3>("h5") @[BusInterface.scala 28:{27,27}]
    node _GEN_1 = mux(eq(UInt<1>("h1"), _synROMReg_T_1), filterROM_1, _GEN_0) @[BusInterface.scala 40:{19,19}]
    node filterROM_2 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_2 = mux(eq(UInt<2>("h2"), _synROMReg_T_1), filterROM_2, _GEN_1) @[BusInterface.scala 40:{19,19}]
    node filterROM_3 = UInt<3>("h6") @[BusInterface.scala 28:{27,27}]
    node _GEN_3 = mux(eq(UInt<2>("h3"), _synROMReg_T_1), filterROM_3, _GEN_2) @[BusInterface.scala 40:{19,19}]
    node filterROM_4 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_4 = mux(eq(UInt<3>("h4"), _synROMReg_T_1), filterROM_4, _GEN_3) @[BusInterface.scala 40:{19,19}]
    node _filterROM_synROMReg_T_1 = _GEN_4 @[BusInterface.scala 40:19]
    node _synROMReg_T_2 = mux(_synROMReg_T, _filterROM_synROMReg_T_1, UInt<1>("h0")) @[BusInterface.scala 40:19]
    node _io_valid_T = bits(synROMReg, 2, 2) @[BusInterface.scala 42:25]
    node _io_axonID_T = bits(synROMReg, 1, 0) @[BusInterface.scala 43:25]
    node _io_axonID_T_1 = cat(_io_axonID_T, axonIDLSBReg) @[BusInterface.scala 43:47]
    io_reqOut <= _io_reqOut_T_1 @[BusInterface.scala 32:13]
    io_tx <= _io_tx_T @[BusInterface.scala 31:9]
    io_axonID <= _io_axonID_T_1 @[BusInterface.scala 43:13]
    io_valid <= _io_valid_T @[BusInterface.scala 42:13]
    io_ready <= io_grant @[BusInterface.scala 33:13]
    axonIDLSBReg <= mux(reset, UInt<8>("h0"), _axonIDLSBReg_T) @[BusInterface.scala 36:{29,29} 37:16]
    synROMReg <= mux(reset, UInt<3>("h0"), _synROMReg_T_2) @[BusInterface.scala 39:{27,27} 40:13]

  module AxonSystem :
    input clock : Clock
    input reset : UInt<1>
    input io_axonIn : UInt<10>
    input io_axonValid : UInt<1>
    input io_inOut : UInt<1>
    output io_spikeCnt : UInt<10>
    input io_rAddr : UInt<10>
    input io_rEna : UInt<1>
    output io_rData : UInt<10>

    mem axonMem0 : @[AxonSystem.scala 36:29]
      data-type => UInt<10>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => rdata0_MPORT
      writer => MPORT
      read-under-write => undefined
    mem axonMem1 : @[AxonSystem.scala 52:29]
      data-type => UInt<10>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => rdata1_MPORT
      writer => MPORT_1
      read-under-write => undefined
    reg inOutReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), inOutReg) @[AxonSystem.scala 21:25]
    reg spikeCntReg : UInt<10>, clock with :
      reset => (UInt<1>("h0"), spikeCntReg) @[AxonSystem.scala 22:28]
    node _T = neq(inOutReg, io_inOut) @[AxonSystem.scala 23:17]
    node _spikeCntReg_T = add(spikeCntReg, UInt<1>("h1")) @[AxonSystem.scala 26:32]
    node _spikeCntReg_T_1 = tail(_spikeCntReg_T, 1) @[AxonSystem.scala 26:32]
    node _GEN_0 = mux(io_axonValid, _spikeCntReg_T_1, spikeCntReg) @[AxonSystem.scala 25:28 26:17 22:28]
    node _GEN_1 = mux(_T, UInt<1>("h0"), _GEN_0) @[AxonSystem.scala 23:31 24:17]
    node _T_1 = not(io_inOut) @[AxonSystem.scala 64:8]
    node _GEN_35 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[AxonSystem.scala 64:19 66:12 77:14]
    node wr0 = _GEN_35 @[AxonSystem.scala 32:22]
    node _GEN_37 = mux(_T_1, spikeCntReg, io_rAddr) @[AxonSystem.scala 64:19 68:12 80:14]
    node addr0 = _GEN_37 @[AxonSystem.scala 35:22]
    node _GEN_2 = validif(wr0, addr0) @[AxonSystem.scala 40:15 41:15]
    node _GEN_3 = validif(wr0, clock) @[AxonSystem.scala 40:15 41:15]
    node _GEN_4 = mux(wr0, UInt<1>("h1"), UInt<1>("h0")) @[AxonSystem.scala 40:15 41:15 36:29]
    node _GEN_5 = validif(wr0, UInt<1>("h1")) @[AxonSystem.scala 40:15 41:23]
    node _GEN_36 = mux(_T_1, io_axonIn, UInt<1>("h0")) @[AxonSystem.scala 64:19 67:12 79:14]
    node wdata0 = _GEN_36 @[AxonSystem.scala 34:22]
    node _GEN_6 = validif(wr0, wdata0) @[AxonSystem.scala 40:15 41:23]
    node _GEN_7 = validif(eq(wr0, UInt<1>("h0")), addr0) @[AxonSystem.scala 40:15 43:25]
    node _GEN_8 = validif(eq(wr0, UInt<1>("h0")), clock) @[AxonSystem.scala 40:15 43:25]
    node _GEN_9 = validif(eq(wr0, UInt<1>("h0")), axonMem0.rdata0_MPORT.data) @[AxonSystem.scala 40:15 43:14]
    node _GEN_34 = mux(_T_1, io_axonValid, io_rEna) @[AxonSystem.scala 64:19 65:12 76:14]
    node ena0 = _GEN_34 @[AxonSystem.scala 31:22]
    node _GEN_10 = validif(ena0, _GEN_2) @[AxonSystem.scala 39:14]
    node _GEN_11 = validif(ena0, _GEN_3) @[AxonSystem.scala 39:14]
    node _GEN_12 = mux(ena0, _GEN_4, UInt<1>("h0")) @[AxonSystem.scala 39:14 36:29]
    node _GEN_13 = validif(ena0, _GEN_5) @[AxonSystem.scala 39:14]
    node _GEN_14 = validif(ena0, _GEN_6) @[AxonSystem.scala 39:14]
    node _GEN_15 = validif(ena0, _GEN_7) @[AxonSystem.scala 39:14]
    node _GEN_16 = validif(ena0, _GEN_8) @[AxonSystem.scala 39:14]
    node _GEN_17 = validif(ena0, _GEN_9) @[AxonSystem.scala 39:14]
    node _GEN_40 = mux(_T_1, UInt<1>("h0"), UInt<1>("h1")) @[AxonSystem.scala 64:19 71:14 83:14]
    node wr1 = _GEN_40 @[AxonSystem.scala 48:22]
    node _GEN_43 = mux(_T_1, io_rAddr, spikeCntReg) @[AxonSystem.scala 64:19 74:14 85:14]
    node addr1 = _GEN_43 @[AxonSystem.scala 51:22]
    node _GEN_18 = validif(wr1, addr1) @[AxonSystem.scala 56:15 57:15]
    node _GEN_19 = validif(wr1, clock) @[AxonSystem.scala 56:15 57:15]
    node _GEN_20 = mux(wr1, UInt<1>("h1"), UInt<1>("h0")) @[AxonSystem.scala 56:15 57:15 52:29]
    node _GEN_21 = validif(wr1, UInt<1>("h1")) @[AxonSystem.scala 56:15 57:23]
    node _GEN_42 = mux(_T_1, UInt<1>("h0"), io_axonIn) @[AxonSystem.scala 64:19 73:14 84:14]
    node wdata1 = _GEN_42 @[AxonSystem.scala 50:22]
    node _GEN_22 = validif(wr1, wdata1) @[AxonSystem.scala 56:15 57:23]
    node _GEN_23 = validif(eq(wr1, UInt<1>("h0")), addr1) @[AxonSystem.scala 56:15 59:25]
    node _GEN_24 = validif(eq(wr1, UInt<1>("h0")), clock) @[AxonSystem.scala 56:15 59:25]
    node _GEN_25 = validif(eq(wr1, UInt<1>("h0")), axonMem1.rdata1_MPORT.data) @[AxonSystem.scala 56:15 59:14]
    node _GEN_39 = mux(_T_1, io_rEna, io_axonValid) @[AxonSystem.scala 64:19 70:14 82:14]
    node ena1 = _GEN_39 @[AxonSystem.scala 47:22]
    node _GEN_26 = validif(ena1, _GEN_18) @[AxonSystem.scala 55:14]
    node _GEN_27 = validif(ena1, _GEN_19) @[AxonSystem.scala 55:14]
    node _GEN_28 = mux(ena1, _GEN_20, UInt<1>("h0")) @[AxonSystem.scala 55:14 52:29]
    node _GEN_29 = validif(ena1, _GEN_21) @[AxonSystem.scala 55:14]
    node _GEN_30 = validif(ena1, _GEN_22) @[AxonSystem.scala 55:14]
    node _GEN_31 = validif(ena1, _GEN_23) @[AxonSystem.scala 55:14]
    node _GEN_32 = validif(ena1, _GEN_24) @[AxonSystem.scala 55:14]
    node _GEN_33 = validif(ena1, _GEN_25) @[AxonSystem.scala 55:14]
    node _GEN_38 = mux(_T_1, UInt<1>("h1"), UInt<1>("h1")) @[AxonSystem.scala 64:19 68:12 80:14]
    node rdata1 = _GEN_33 @[AxonSystem.scala 49:22]
    node rdata0 = _GEN_17 @[AxonSystem.scala 33:22]
    node _GEN_41 = mux(_T_1, rdata1, rdata0) @[AxonSystem.scala 64:19 72:14 78:14]
    io_spikeCnt <= spikeCntReg @[AxonSystem.scala 28:15]
    io_rData <= _GEN_41
    inOutReg <= io_inOut @[AxonSystem.scala 21:25]
    spikeCntReg <= mux(reset, UInt<10>("h0"), _GEN_1) @[AxonSystem.scala 22:{28,28}]
    axonMem0.rdata0_MPORT.addr <= _GEN_15
    axonMem0.rdata0_MPORT.en <= _GEN_38
    axonMem0.rdata0_MPORT.clk <= _GEN_16
    axonMem0.MPORT.addr <= _GEN_10
    axonMem0.MPORT.en <= _GEN_12
    axonMem0.MPORT.clk <= _GEN_11
    axonMem0.MPORT.data <= _GEN_14
    axonMem0.MPORT.mask <= _GEN_13
    axonMem1.rdata1_MPORT.addr <= _GEN_31
    axonMem1.rdata1_MPORT.en <= _GEN_38
    axonMem1.rdata1_MPORT.clk <= _GEN_32
    axonMem1.MPORT_1.addr <= _GEN_26
    axonMem1.MPORT_1.en <= _GEN_28
    axonMem1.MPORT_1.clk <= _GEN_27
    axonMem1.MPORT_1.data <= _GEN_30
    axonMem1.MPORT_1.mask <= _GEN_29

  module TransmissionSystem_2 :
    input clock : Clock
    input reset : UInt<1>
    output io_data : UInt<11>
    input io_ready : UInt<1>
    output io_valid : UInt<1>
    input io_n : UInt<5>
    input io_spikes_0 : UInt<1>
    input io_spikes_1 : UInt<1>
    input io_spikes_2 : UInt<1>
    input io_spikes_3 : UInt<1>
    input io_spikes_4 : UInt<1>
    input io_spikes_5 : UInt<1>
    input io_spikes_6 : UInt<1>
    input io_spikes_7 : UInt<1>

    inst spikeEncoder of PriorityMaskRstEncoder @[TransmissionSystem.scala 22:28]
    reg spikeRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_0) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_1) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_2) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_3) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_4) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_5) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_6) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_7) @[TransmissionSystem.scala 18:29]
    reg neuronIdMSB_0 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_0) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_1 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_1) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_2 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_2) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_3 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_3) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_4 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_4) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_5 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_5) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_6 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_6) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_7 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_7) @[TransmissionSystem.scala 19:29]
    reg maskRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_0) @[TransmissionSystem.scala 20:29]
    reg maskRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_1) @[TransmissionSystem.scala 20:29]
    reg maskRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_2) @[TransmissionSystem.scala 20:29]
    reg maskRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_3) @[TransmissionSystem.scala 20:29]
    reg maskRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_4) @[TransmissionSystem.scala 20:29]
    reg maskRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_5) @[TransmissionSystem.scala 20:29]
    reg maskRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_6) @[TransmissionSystem.scala 20:29]
    reg maskRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_7) @[TransmissionSystem.scala 20:29]
    node _encoderReqs_0_T = and(maskRegs_0, spikeRegs_0) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_0_T = and(spikeEncoder.io_rst_0, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_0_T_1 = not(_rstReadySel_0_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_0 = _rstReadySel_0_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_0_T = and(rstReadySel_0, spikeRegs_0) @[TransmissionSystem.scala 36:38]
    node _T = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_0 = mux(_T, UInt<1>("h1"), maskRegs_0) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_1 = mux(io_ready, spikeEncoder.io_mask_0, _GEN_0) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_0 = _spikeUpdate_0_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_1 = not(spikeUpdate_0) @[TransmissionSystem.scala 44:10]
    node _GEN_2 = mux(_T_1, io_n, neuronIdMSB_0) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_3 = mux(_T_1, io_spikes_0, spikeRegs_0) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_2 = eq(UInt<1>("h0"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T = cat(UInt<3>("h2"), neuronIdMSB_0) @[TransmissionSystem.scala 50:44]
    node _io_data_T_1 = cat(_io_data_T, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_4 = mux(_T_2, _io_data_T_1, UInt<1>("h0")) @[TransmissionSystem.scala 28:12 49:41 50:15]
    node _encoderReqs_1_T = and(maskRegs_1, spikeRegs_1) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_1_T = and(spikeEncoder.io_rst_1, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_1_T_1 = not(_rstReadySel_1_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_1 = _rstReadySel_1_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_1_T = and(rstReadySel_1, spikeRegs_1) @[TransmissionSystem.scala 36:38]
    node _T_3 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_5 = mux(_T_3, UInt<1>("h1"), maskRegs_1) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_6 = mux(io_ready, spikeEncoder.io_mask_1, _GEN_5) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_1 = _spikeUpdate_1_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_4 = not(spikeUpdate_1) @[TransmissionSystem.scala 44:10]
    node _GEN_7 = mux(_T_4, io_n, neuronIdMSB_1) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_8 = mux(_T_4, io_spikes_1, spikeRegs_1) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_5 = eq(UInt<1>("h1"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_2 = cat(UInt<3>("h2"), neuronIdMSB_1) @[TransmissionSystem.scala 50:44]
    node _io_data_T_3 = cat(_io_data_T_2, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_9 = mux(_T_5, _io_data_T_3, _GEN_4) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_2_T = and(maskRegs_2, spikeRegs_2) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_2_T = and(spikeEncoder.io_rst_2, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_2_T_1 = not(_rstReadySel_2_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_2 = _rstReadySel_2_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_2_T = and(rstReadySel_2, spikeRegs_2) @[TransmissionSystem.scala 36:38]
    node _T_6 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_10 = mux(_T_6, UInt<1>("h1"), maskRegs_2) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_11 = mux(io_ready, spikeEncoder.io_mask_2, _GEN_10) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_2 = _spikeUpdate_2_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_7 = not(spikeUpdate_2) @[TransmissionSystem.scala 44:10]
    node _GEN_12 = mux(_T_7, io_n, neuronIdMSB_2) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_13 = mux(_T_7, io_spikes_2, spikeRegs_2) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_8 = eq(UInt<2>("h2"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_4 = cat(UInt<3>("h2"), neuronIdMSB_2) @[TransmissionSystem.scala 50:44]
    node _io_data_T_5 = cat(_io_data_T_4, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_14 = mux(_T_8, _io_data_T_5, _GEN_9) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_3_T = and(maskRegs_3, spikeRegs_3) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_3_T = and(spikeEncoder.io_rst_3, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_3_T_1 = not(_rstReadySel_3_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_3 = _rstReadySel_3_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_3_T = and(rstReadySel_3, spikeRegs_3) @[TransmissionSystem.scala 36:38]
    node _T_9 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_15 = mux(_T_9, UInt<1>("h1"), maskRegs_3) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_16 = mux(io_ready, spikeEncoder.io_mask_3, _GEN_15) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_3 = _spikeUpdate_3_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_10 = not(spikeUpdate_3) @[TransmissionSystem.scala 44:10]
    node _GEN_17 = mux(_T_10, io_n, neuronIdMSB_3) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_18 = mux(_T_10, io_spikes_3, spikeRegs_3) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_11 = eq(UInt<2>("h3"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_6 = cat(UInt<3>("h2"), neuronIdMSB_3) @[TransmissionSystem.scala 50:44]
    node _io_data_T_7 = cat(_io_data_T_6, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_19 = mux(_T_11, _io_data_T_7, _GEN_14) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_4_T = and(maskRegs_4, spikeRegs_4) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_4_T = and(spikeEncoder.io_rst_4, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_4_T_1 = not(_rstReadySel_4_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_4 = _rstReadySel_4_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_4_T = and(rstReadySel_4, spikeRegs_4) @[TransmissionSystem.scala 36:38]
    node _T_12 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_20 = mux(_T_12, UInt<1>("h1"), maskRegs_4) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_21 = mux(io_ready, spikeEncoder.io_mask_4, _GEN_20) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_4 = _spikeUpdate_4_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_13 = not(spikeUpdate_4) @[TransmissionSystem.scala 44:10]
    node _GEN_22 = mux(_T_13, io_n, neuronIdMSB_4) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_23 = mux(_T_13, io_spikes_4, spikeRegs_4) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_14 = eq(UInt<3>("h4"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_8 = cat(UInt<3>("h2"), neuronIdMSB_4) @[TransmissionSystem.scala 50:44]
    node _io_data_T_9 = cat(_io_data_T_8, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_24 = mux(_T_14, _io_data_T_9, _GEN_19) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_5_T = and(maskRegs_5, spikeRegs_5) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_5_T = and(spikeEncoder.io_rst_5, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_5_T_1 = not(_rstReadySel_5_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_5 = _rstReadySel_5_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_5_T = and(rstReadySel_5, spikeRegs_5) @[TransmissionSystem.scala 36:38]
    node _T_15 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_25 = mux(_T_15, UInt<1>("h1"), maskRegs_5) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_26 = mux(io_ready, spikeEncoder.io_mask_5, _GEN_25) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_5 = _spikeUpdate_5_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_16 = not(spikeUpdate_5) @[TransmissionSystem.scala 44:10]
    node _GEN_27 = mux(_T_16, io_n, neuronIdMSB_5) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_28 = mux(_T_16, io_spikes_5, spikeRegs_5) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_17 = eq(UInt<3>("h5"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_10 = cat(UInt<3>("h2"), neuronIdMSB_5) @[TransmissionSystem.scala 50:44]
    node _io_data_T_11 = cat(_io_data_T_10, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_29 = mux(_T_17, _io_data_T_11, _GEN_24) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_6_T = and(maskRegs_6, spikeRegs_6) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_6_T = and(spikeEncoder.io_rst_6, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_6_T_1 = not(_rstReadySel_6_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_6 = _rstReadySel_6_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_6_T = and(rstReadySel_6, spikeRegs_6) @[TransmissionSystem.scala 36:38]
    node _T_18 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_30 = mux(_T_18, UInt<1>("h1"), maskRegs_6) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_31 = mux(io_ready, spikeEncoder.io_mask_6, _GEN_30) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_6 = _spikeUpdate_6_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_19 = not(spikeUpdate_6) @[TransmissionSystem.scala 44:10]
    node _GEN_32 = mux(_T_19, io_n, neuronIdMSB_6) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_33 = mux(_T_19, io_spikes_6, spikeRegs_6) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_20 = eq(UInt<3>("h6"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_12 = cat(UInt<3>("h2"), neuronIdMSB_6) @[TransmissionSystem.scala 50:44]
    node _io_data_T_13 = cat(_io_data_T_12, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_34 = mux(_T_20, _io_data_T_13, _GEN_29) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_7_T = and(maskRegs_7, spikeRegs_7) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_7_T = and(spikeEncoder.io_rst_7, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_7_T_1 = not(_rstReadySel_7_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_7 = _rstReadySel_7_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_7_T = and(rstReadySel_7, spikeRegs_7) @[TransmissionSystem.scala 36:38]
    node _T_21 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_35 = mux(_T_21, UInt<1>("h1"), maskRegs_7) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_36 = mux(io_ready, spikeEncoder.io_mask_7, _GEN_35) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_7 = _spikeUpdate_7_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_22 = not(spikeUpdate_7) @[TransmissionSystem.scala 44:10]
    node _GEN_37 = mux(_T_22, io_n, neuronIdMSB_7) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_38 = mux(_T_22, io_spikes_7, spikeRegs_7) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_23 = eq(UInt<3>("h7"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_14 = cat(UInt<3>("h2"), neuronIdMSB_7) @[TransmissionSystem.scala 50:44]
    node _io_data_T_15 = cat(_io_data_T_14, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_39 = mux(_T_23, _io_data_T_15, _GEN_34) @[TransmissionSystem.scala 49:41 50:15]
    node _spikeRegs_WIRE_0 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_1 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_2 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_3 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_4 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_5 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_6 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_7 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _neuronIdMSB_WIRE_0 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_1 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_2 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_3 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_4 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_5 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_6 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_7 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _maskRegs_WIRE_0 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_1 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_2 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_3 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_4 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_5 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_6 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_7 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node encoderReqs_0 = _encoderReqs_0_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_1 = _encoderReqs_1_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_2 = _encoderReqs_2_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_3 = _encoderReqs_3_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_4 = _encoderReqs_4_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_5 = _encoderReqs_5_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_6 = _encoderReqs_6_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_7 = _encoderReqs_7_T @[TransmissionSystem.scala 23:26 33:20]
    io_data <= _GEN_39
    io_valid <= spikeEncoder.io_valid @[TransmissionSystem.scala 29:12]
    spikeRegs_0 <= mux(reset, _spikeRegs_WIRE_0, _GEN_3) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_1 <= mux(reset, _spikeRegs_WIRE_1, _GEN_8) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_2 <= mux(reset, _spikeRegs_WIRE_2, _GEN_13) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_3 <= mux(reset, _spikeRegs_WIRE_3, _GEN_18) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_4 <= mux(reset, _spikeRegs_WIRE_4, _GEN_23) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_5 <= mux(reset, _spikeRegs_WIRE_5, _GEN_28) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_6 <= mux(reset, _spikeRegs_WIRE_6, _GEN_33) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_7 <= mux(reset, _spikeRegs_WIRE_7, _GEN_38) @[TransmissionSystem.scala 18:{29,29}]
    neuronIdMSB_0 <= mux(reset, _neuronIdMSB_WIRE_0, _GEN_2) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_1 <= mux(reset, _neuronIdMSB_WIRE_1, _GEN_7) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_2 <= mux(reset, _neuronIdMSB_WIRE_2, _GEN_12) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_3 <= mux(reset, _neuronIdMSB_WIRE_3, _GEN_17) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_4 <= mux(reset, _neuronIdMSB_WIRE_4, _GEN_22) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_5 <= mux(reset, _neuronIdMSB_WIRE_5, _GEN_27) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_6 <= mux(reset, _neuronIdMSB_WIRE_6, _GEN_32) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_7 <= mux(reset, _neuronIdMSB_WIRE_7, _GEN_37) @[TransmissionSystem.scala 19:{29,29}]
    maskRegs_0 <= mux(reset, _maskRegs_WIRE_0, _GEN_1) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_1 <= mux(reset, _maskRegs_WIRE_1, _GEN_6) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_2 <= mux(reset, _maskRegs_WIRE_2, _GEN_11) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_3 <= mux(reset, _maskRegs_WIRE_3, _GEN_16) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_4 <= mux(reset, _maskRegs_WIRE_4, _GEN_21) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_5 <= mux(reset, _maskRegs_WIRE_5, _GEN_26) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_6 <= mux(reset, _maskRegs_WIRE_6, _GEN_31) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_7 <= mux(reset, _maskRegs_WIRE_7, _GEN_36) @[TransmissionSystem.scala 20:{29,29}]
    spikeEncoder.clock <= clock
    spikeEncoder.reset <= reset
    spikeEncoder.io_reqs_0 <= encoderReqs_0 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_1 <= encoderReqs_1 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_2 <= encoderReqs_2 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_3 <= encoderReqs_3 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_4 <= encoderReqs_4 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_5 <= encoderReqs_5 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_6 <= encoderReqs_6 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_7 <= encoderReqs_7 @[TransmissionSystem.scala 30:24]

  module ControlUnit :
    input clock : Clock
    input reset : UInt<1>
    output io_done : UInt<1>
    input io_newTS : UInt<1>
    output io_addr_sel : UInt<2>
    output io_addr_pos : UInt<15>
    output io_wr : UInt<1>
    output io_ena : UInt<1>
    input io_spikeIndi_0 : UInt<1>
    input io_spikeIndi_1 : UInt<1>
    input io_spikeIndi_2 : UInt<1>
    input io_spikeIndi_3 : UInt<1>
    input io_spikeIndi_4 : UInt<1>
    input io_spikeIndi_5 : UInt<1>
    input io_spikeIndi_6 : UInt<1>
    input io_spikeIndi_7 : UInt<1>
    input io_refracIndi_0 : UInt<1>
    input io_refracIndi_1 : UInt<1>
    input io_refracIndi_2 : UInt<1>
    input io_refracIndi_3 : UInt<1>
    input io_refracIndi_4 : UInt<1>
    input io_refracIndi_5 : UInt<1>
    input io_refracIndi_6 : UInt<1>
    input io_refracIndi_7 : UInt<1>
    output io_cntrSels_0_potSel : UInt<2>
    output io_cntrSels_0_spikeSel : UInt<2>
    output io_cntrSels_0_refracSel : UInt<1>
    output io_cntrSels_0_decaySel : UInt<1>
    output io_cntrSels_0_writeDataSel : UInt<2>
    output io_cntrSels_1_potSel : UInt<2>
    output io_cntrSels_1_spikeSel : UInt<2>
    output io_cntrSels_1_refracSel : UInt<1>
    output io_cntrSels_1_decaySel : UInt<1>
    output io_cntrSels_1_writeDataSel : UInt<2>
    output io_cntrSels_2_potSel : UInt<2>
    output io_cntrSels_2_spikeSel : UInt<2>
    output io_cntrSels_2_refracSel : UInt<1>
    output io_cntrSels_2_decaySel : UInt<1>
    output io_cntrSels_2_writeDataSel : UInt<2>
    output io_cntrSels_3_potSel : UInt<2>
    output io_cntrSels_3_spikeSel : UInt<2>
    output io_cntrSels_3_refracSel : UInt<1>
    output io_cntrSels_3_decaySel : UInt<1>
    output io_cntrSels_3_writeDataSel : UInt<2>
    output io_cntrSels_4_potSel : UInt<2>
    output io_cntrSels_4_spikeSel : UInt<2>
    output io_cntrSels_4_refracSel : UInt<1>
    output io_cntrSels_4_decaySel : UInt<1>
    output io_cntrSels_4_writeDataSel : UInt<2>
    output io_cntrSels_5_potSel : UInt<2>
    output io_cntrSels_5_spikeSel : UInt<2>
    output io_cntrSels_5_refracSel : UInt<1>
    output io_cntrSels_5_decaySel : UInt<1>
    output io_cntrSels_5_writeDataSel : UInt<2>
    output io_cntrSels_6_potSel : UInt<2>
    output io_cntrSels_6_spikeSel : UInt<2>
    output io_cntrSels_6_refracSel : UInt<1>
    output io_cntrSels_6_decaySel : UInt<1>
    output io_cntrSels_6_writeDataSel : UInt<2>
    output io_cntrSels_7_potSel : UInt<2>
    output io_cntrSels_7_spikeSel : UInt<2>
    output io_cntrSels_7_refracSel : UInt<1>
    output io_cntrSels_7_decaySel : UInt<1>
    output io_cntrSels_7_writeDataSel : UInt<2>
    output io_evalEnable : UInt<1>
    output io_inOut : UInt<1>
    input io_spikeCnt : UInt<10>
    output io_aAddr : UInt<10>
    output io_aEna : UInt<1>
    input io_aData : UInt<10>
    output io_n : UInt<5>
    output io_spikes_0 : UInt<1>
    output io_spikes_1 : UInt<1>
    output io_spikes_2 : UInt<1>
    output io_spikes_3 : UInt<1>
    output io_spikes_4 : UInt<1>
    output io_spikes_5 : UInt<1>
    output io_spikes_6 : UInt<1>
    output io_spikes_7 : UInt<1>

    reg state : UInt<4>, clock with :
      reset => (UInt<1>("h0"), state) @[ControlUnit.scala 36:22]
    reg spikePulse_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_0) @[ControlUnit.scala 42:27]
    reg spikePulse_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_1) @[ControlUnit.scala 42:27]
    reg spikePulse_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_2) @[ControlUnit.scala 42:27]
    reg spikePulse_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_3) @[ControlUnit.scala 42:27]
    reg spikePulse_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_4) @[ControlUnit.scala 42:27]
    reg spikePulse_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_5) @[ControlUnit.scala 42:27]
    reg spikePulse_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_6) @[ControlUnit.scala 42:27]
    reg spikePulse_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikePulse_7) @[ControlUnit.scala 42:27]
    reg n : UInt<5>, clock with :
      reset => (UInt<1>("h0"), n) @[ControlUnit.scala 45:22]
    reg a : UInt<10>, clock with :
      reset => (UInt<1>("h0"), a) @[ControlUnit.scala 47:22]
    reg spikeCnt : UInt<10>, clock with :
      reset => (UInt<1>("h0"), spikeCnt) @[ControlUnit.scala 50:25]
    reg inOut : UInt<1>, clock with :
      reset => (UInt<1>("h0"), inOut) @[ControlUnit.scala 52:22]
    reg evalUnitActive_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_0) @[ControlUnit.scala 55:31]
    reg evalUnitActive_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_1) @[ControlUnit.scala 55:31]
    reg evalUnitActive_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_2) @[ControlUnit.scala 55:31]
    reg evalUnitActive_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_3) @[ControlUnit.scala 55:31]
    reg evalUnitActive_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_4) @[ControlUnit.scala 55:31]
    reg evalUnitActive_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_5) @[ControlUnit.scala 55:31]
    reg evalUnitActive_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_6) @[ControlUnit.scala 55:31]
    reg evalUnitActive_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), evalUnitActive_7) @[ControlUnit.scala 55:31]
    reg nrNeuMapped : UInt<8>, clock with :
      reset => (UInt<1>("h0"), nrNeuMapped) @[ControlUnit.scala 58:28]
    node _evalUnitActive_0_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_0_T_1 = add(_evalUnitActive_0_T, UInt<1>("h0")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_0_T_2 = tail(_evalUnitActive_0_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_0_T_3 = gt(nrNeuMapped, _evalUnitActive_0_T_2) @[ControlUnit.scala 70:38]
    node _T = eq(UInt<4>("h0"), state) @[Conditional.scala 37:30]
    node _T_1 = eq(UInt<4>("h1"), state) @[Conditional.scala 37:30]
    node _T_2 = eq(UInt<4>("h2"), state) @[Conditional.scala 37:30]
    node _T_3 = eq(UInt<4>("h3"), state) @[Conditional.scala 37:30]
    node _T_5 = eq(UInt<4>("h4"), state) @[Conditional.scala 37:30]
    node _GEN_45 = mux(io_refracIndi_0, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _T_7 = eq(UInt<4>("h5"), state) @[Conditional.scala 37:30]
    node _T_11 = eq(UInt<4>("h6"), state) @[Conditional.scala 37:30]
    node _T_12 = eq(spikeCnt, UInt<1>("h0")) @[ControlUnit.scala 223:21]
    node _GEN_63 = mux(_T_12, _GEN_45, _GEN_45) @[ControlUnit.scala 223:30]
    node _T_13 = eq(UInt<4>("h7"), state) @[Conditional.scala 37:30]
    node _GEN_130 = mux(_T_13, _GEN_45, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_155 = mux(_T_11, _GEN_63, _GEN_130) @[Conditional.scala 39:67]
    node _GEN_190 = mux(_T_7, _GEN_45, _GEN_155) @[Conditional.scala 39:67]
    node _GEN_224 = mux(_T_5, _GEN_45, _GEN_190) @[Conditional.scala 39:67]
    node _GEN_258 = mux(_T_3, UInt<1>("h0"), _GEN_224) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_294 = mux(_T_2, UInt<2>("h2"), _GEN_258) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_330 = mux(_T_1, UInt<2>("h2"), _GEN_294) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_370 = mux(_T, UInt<2>("h2"), _GEN_330) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_0_potSel = _GEN_370 @[ControlUnit.scala 56:28]
    node _GEN_0 = mux(evalUnitActive_0, localCntrSels_0_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node _T_14 = eq(UInt<4>("h8"), state) @[Conditional.scala 37:30]
    node _GEN_113 = mux(_T_14, UInt<1>("h0"), UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 265:35 64:35]
    node _GEN_139 = mux(_T_13, UInt<2>("h2"), _GEN_113) @[Conditional.scala 39:67 ControlUnit.scala 64:35]
    node _GEN_172 = mux(_T_11, UInt<2>("h2"), _GEN_139) @[Conditional.scala 39:67 ControlUnit.scala 64:35]
    node _GEN_207 = mux(_T_7, UInt<2>("h2"), _GEN_172) @[Conditional.scala 39:67 ControlUnit.scala 64:35]
    node _GEN_241 = mux(_T_5, UInt<2>("h2"), _GEN_207) @[Conditional.scala 39:67 ControlUnit.scala 64:35]
    node _GEN_275 = mux(_T_3, UInt<2>("h2"), _GEN_241) @[Conditional.scala 39:67 ControlUnit.scala 64:35]
    node _GEN_310 = mux(_T_2, UInt<2>("h2"), _GEN_275) @[Conditional.scala 39:67 ControlUnit.scala 64:35]
    node _GEN_325 = mux(_T_1, UInt<1>("h1"), _GEN_310) @[Conditional.scala 39:67 ControlUnit.scala 123:35]
    node _GEN_367 = mux(_T, UInt<2>("h2"), _GEN_325) @[Conditional.scala 40:58 ControlUnit.scala 64:35]
    node localCntrSels_0_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_1 = mux(evalUnitActive_0, localCntrSels_0_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node _GEN_290 = mux(_T_2, UInt<1>("h0"), UInt<1>("h1")) @[Conditional.scala 39:67 ControlUnit.scala 136:36 65:35]
    node _GEN_327 = mux(_T_1, UInt<1>("h1"), _GEN_290) @[Conditional.scala 39:67 ControlUnit.scala 65:35]
    node _GEN_368 = mux(_T, UInt<1>("h1"), _GEN_327) @[Conditional.scala 40:58 ControlUnit.scala 65:35]
    node localCntrSels_0_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_2 = mux(evalUnitActive_0, localCntrSels_0_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node _T_15 = eq(UInt<4>("h9"), state) @[Conditional.scala 37:30]
    node _T_16 = eq(UInt<4>("ha"), state) @[Conditional.scala 37:30]
    node _T_17 = eq(UInt<4>("hb"), state) @[Conditional.scala 37:30]
    node _GEN_80 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 297:19 91:10]
    node _GEN_87 = mux(_T_16, UInt<1>("h0"), _GEN_80) @[Conditional.scala 39:67 ControlUnit.scala 288:20]
    node _GEN_97 = mux(_T_15, UInt<2>("h2"), _GEN_87) @[Conditional.scala 39:67 ControlUnit.scala 278:39]
    node _GEN_115 = mux(_T_14, UInt<1>("h0"), _GEN_97) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_140 = mux(_T_13, UInt<1>("h0"), _GEN_115) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_173 = mux(_T_11, UInt<1>("h0"), _GEN_140) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_208 = mux(_T_7, UInt<1>("h0"), _GEN_173) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_242 = mux(_T_5, UInt<1>("h0"), _GEN_208) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_276 = mux(_T_3, UInt<1>("h0"), _GEN_242) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_311 = mux(_T_2, UInt<1>("h0"), _GEN_276) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_346 = mux(_T_1, UInt<1>("h0"), _GEN_311) @[Conditional.scala 39:67 ControlUnit.scala 66:35]
    node _GEN_386 = mux(_T, UInt<1>("h0"), _GEN_346) @[Conditional.scala 40:58 ControlUnit.scala 66:35]
    node localCntrSels_0_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_3 = mux(evalUnitActive_0, localCntrSels_0_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_46 = mux(io_refracIndi_0, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_64 = mux(_T_12, _GEN_46, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_156 = mux(_T_11, _GEN_64, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_199 = mux(_T_7, UInt<1>("h0"), _GEN_156) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_225 = mux(_T_5, _GEN_46, _GEN_199) @[Conditional.scala 39:67]
    node _GEN_267 = mux(_T_3, UInt<1>("h0"), _GEN_225) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_302 = mux(_T_2, UInt<1>("h0"), _GEN_267) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_338 = mux(_T_1, UInt<1>("h0"), _GEN_302) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_378 = mux(_T, UInt<1>("h0"), _GEN_338) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_0_decaySel = _GEN_378 @[ControlUnit.scala 56:28]
    node _GEN_4 = mux(evalUnitActive_0, localCntrSels_0_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_1_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_1_T_1 = add(_evalUnitActive_1_T, UInt<1>("h1")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_1_T_2 = tail(_evalUnitActive_1_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_1_T_3 = gt(nrNeuMapped, _evalUnitActive_1_T_2) @[ControlUnit.scala 70:38]
    node _GEN_47 = mux(io_refracIndi_1, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_65 = mux(_T_12, _GEN_47, _GEN_47) @[ControlUnit.scala 223:30]
    node _GEN_131 = mux(_T_13, _GEN_47, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_157 = mux(_T_11, _GEN_65, _GEN_131) @[Conditional.scala 39:67]
    node _GEN_191 = mux(_T_7, _GEN_47, _GEN_157) @[Conditional.scala 39:67]
    node _GEN_226 = mux(_T_5, _GEN_47, _GEN_191) @[Conditional.scala 39:67]
    node _GEN_259 = mux(_T_3, UInt<1>("h0"), _GEN_226) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_295 = mux(_T_2, UInt<2>("h2"), _GEN_259) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_331 = mux(_T_1, UInt<2>("h2"), _GEN_295) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_371 = mux(_T, UInt<2>("h2"), _GEN_331) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_1_potSel = _GEN_371 @[ControlUnit.scala 56:28]
    node _GEN_5 = mux(evalUnitActive_1, localCntrSels_1_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_1_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_6 = mux(evalUnitActive_1, localCntrSels_1_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_1_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_7 = mux(evalUnitActive_1, localCntrSels_1_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_1_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_8 = mux(evalUnitActive_1, localCntrSels_1_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_48 = mux(io_refracIndi_1, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_66 = mux(_T_12, _GEN_48, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_158 = mux(_T_11, _GEN_66, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_200 = mux(_T_7, UInt<1>("h0"), _GEN_158) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_227 = mux(_T_5, _GEN_48, _GEN_200) @[Conditional.scala 39:67]
    node _GEN_268 = mux(_T_3, UInt<1>("h0"), _GEN_227) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_303 = mux(_T_2, UInt<1>("h0"), _GEN_268) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_339 = mux(_T_1, UInt<1>("h0"), _GEN_303) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_379 = mux(_T, UInt<1>("h0"), _GEN_339) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_1_decaySel = _GEN_379 @[ControlUnit.scala 56:28]
    node _GEN_9 = mux(evalUnitActive_1, localCntrSels_1_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_2_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_2_T_1 = add(_evalUnitActive_2_T, UInt<2>("h2")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_2_T_2 = tail(_evalUnitActive_2_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_2_T_3 = gt(nrNeuMapped, _evalUnitActive_2_T_2) @[ControlUnit.scala 70:38]
    node _GEN_49 = mux(io_refracIndi_2, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_67 = mux(_T_12, _GEN_49, _GEN_49) @[ControlUnit.scala 223:30]
    node _GEN_132 = mux(_T_13, _GEN_49, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_159 = mux(_T_11, _GEN_67, _GEN_132) @[Conditional.scala 39:67]
    node _GEN_192 = mux(_T_7, _GEN_49, _GEN_159) @[Conditional.scala 39:67]
    node _GEN_228 = mux(_T_5, _GEN_49, _GEN_192) @[Conditional.scala 39:67]
    node _GEN_260 = mux(_T_3, UInt<1>("h0"), _GEN_228) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_296 = mux(_T_2, UInt<2>("h2"), _GEN_260) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_332 = mux(_T_1, UInt<2>("h2"), _GEN_296) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_372 = mux(_T, UInt<2>("h2"), _GEN_332) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_2_potSel = _GEN_372 @[ControlUnit.scala 56:28]
    node _GEN_10 = mux(evalUnitActive_2, localCntrSels_2_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_2_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_11 = mux(evalUnitActive_2, localCntrSels_2_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_2_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_12 = mux(evalUnitActive_2, localCntrSels_2_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_2_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_13 = mux(evalUnitActive_2, localCntrSels_2_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_50 = mux(io_refracIndi_2, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_68 = mux(_T_12, _GEN_50, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_160 = mux(_T_11, _GEN_68, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_201 = mux(_T_7, UInt<1>("h0"), _GEN_160) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_229 = mux(_T_5, _GEN_50, _GEN_201) @[Conditional.scala 39:67]
    node _GEN_269 = mux(_T_3, UInt<1>("h0"), _GEN_229) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_304 = mux(_T_2, UInt<1>("h0"), _GEN_269) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_340 = mux(_T_1, UInt<1>("h0"), _GEN_304) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_380 = mux(_T, UInt<1>("h0"), _GEN_340) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_2_decaySel = _GEN_380 @[ControlUnit.scala 56:28]
    node _GEN_14 = mux(evalUnitActive_2, localCntrSels_2_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_3_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_3_T_1 = add(_evalUnitActive_3_T, UInt<2>("h3")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_3_T_2 = tail(_evalUnitActive_3_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_3_T_3 = gt(nrNeuMapped, _evalUnitActive_3_T_2) @[ControlUnit.scala 70:38]
    node _GEN_51 = mux(io_refracIndi_3, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_69 = mux(_T_12, _GEN_51, _GEN_51) @[ControlUnit.scala 223:30]
    node _GEN_133 = mux(_T_13, _GEN_51, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_161 = mux(_T_11, _GEN_69, _GEN_133) @[Conditional.scala 39:67]
    node _GEN_193 = mux(_T_7, _GEN_51, _GEN_161) @[Conditional.scala 39:67]
    node _GEN_230 = mux(_T_5, _GEN_51, _GEN_193) @[Conditional.scala 39:67]
    node _GEN_261 = mux(_T_3, UInt<1>("h0"), _GEN_230) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_297 = mux(_T_2, UInt<2>("h2"), _GEN_261) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_333 = mux(_T_1, UInt<2>("h2"), _GEN_297) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_373 = mux(_T, UInt<2>("h2"), _GEN_333) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_3_potSel = _GEN_373 @[ControlUnit.scala 56:28]
    node _GEN_15 = mux(evalUnitActive_3, localCntrSels_3_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_3_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_16 = mux(evalUnitActive_3, localCntrSels_3_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_3_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_17 = mux(evalUnitActive_3, localCntrSels_3_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_3_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_18 = mux(evalUnitActive_3, localCntrSels_3_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_52 = mux(io_refracIndi_3, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_70 = mux(_T_12, _GEN_52, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_162 = mux(_T_11, _GEN_70, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_202 = mux(_T_7, UInt<1>("h0"), _GEN_162) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_231 = mux(_T_5, _GEN_52, _GEN_202) @[Conditional.scala 39:67]
    node _GEN_270 = mux(_T_3, UInt<1>("h0"), _GEN_231) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_305 = mux(_T_2, UInt<1>("h0"), _GEN_270) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_341 = mux(_T_1, UInt<1>("h0"), _GEN_305) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_381 = mux(_T, UInt<1>("h0"), _GEN_341) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_3_decaySel = _GEN_381 @[ControlUnit.scala 56:28]
    node _GEN_19 = mux(evalUnitActive_3, localCntrSels_3_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_4_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_4_T_1 = add(_evalUnitActive_4_T, UInt<3>("h4")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_4_T_2 = tail(_evalUnitActive_4_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_4_T_3 = gt(nrNeuMapped, _evalUnitActive_4_T_2) @[ControlUnit.scala 70:38]
    node _GEN_53 = mux(io_refracIndi_4, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_71 = mux(_T_12, _GEN_53, _GEN_53) @[ControlUnit.scala 223:30]
    node _GEN_134 = mux(_T_13, _GEN_53, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_163 = mux(_T_11, _GEN_71, _GEN_134) @[Conditional.scala 39:67]
    node _GEN_194 = mux(_T_7, _GEN_53, _GEN_163) @[Conditional.scala 39:67]
    node _GEN_232 = mux(_T_5, _GEN_53, _GEN_194) @[Conditional.scala 39:67]
    node _GEN_262 = mux(_T_3, UInt<1>("h0"), _GEN_232) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_298 = mux(_T_2, UInt<2>("h2"), _GEN_262) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_334 = mux(_T_1, UInt<2>("h2"), _GEN_298) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_374 = mux(_T, UInt<2>("h2"), _GEN_334) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_4_potSel = _GEN_374 @[ControlUnit.scala 56:28]
    node _GEN_20 = mux(evalUnitActive_4, localCntrSels_4_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_4_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_21 = mux(evalUnitActive_4, localCntrSels_4_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_4_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_22 = mux(evalUnitActive_4, localCntrSels_4_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_4_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_23 = mux(evalUnitActive_4, localCntrSels_4_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_54 = mux(io_refracIndi_4, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_72 = mux(_T_12, _GEN_54, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_164 = mux(_T_11, _GEN_72, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_203 = mux(_T_7, UInt<1>("h0"), _GEN_164) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_233 = mux(_T_5, _GEN_54, _GEN_203) @[Conditional.scala 39:67]
    node _GEN_271 = mux(_T_3, UInt<1>("h0"), _GEN_233) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_306 = mux(_T_2, UInt<1>("h0"), _GEN_271) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_342 = mux(_T_1, UInt<1>("h0"), _GEN_306) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_382 = mux(_T, UInt<1>("h0"), _GEN_342) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_4_decaySel = _GEN_382 @[ControlUnit.scala 56:28]
    node _GEN_24 = mux(evalUnitActive_4, localCntrSels_4_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_5_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_5_T_1 = add(_evalUnitActive_5_T, UInt<3>("h5")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_5_T_2 = tail(_evalUnitActive_5_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_5_T_3 = gt(nrNeuMapped, _evalUnitActive_5_T_2) @[ControlUnit.scala 70:38]
    node _GEN_55 = mux(io_refracIndi_5, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_73 = mux(_T_12, _GEN_55, _GEN_55) @[ControlUnit.scala 223:30]
    node _GEN_135 = mux(_T_13, _GEN_55, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_165 = mux(_T_11, _GEN_73, _GEN_135) @[Conditional.scala 39:67]
    node _GEN_195 = mux(_T_7, _GEN_55, _GEN_165) @[Conditional.scala 39:67]
    node _GEN_234 = mux(_T_5, _GEN_55, _GEN_195) @[Conditional.scala 39:67]
    node _GEN_263 = mux(_T_3, UInt<1>("h0"), _GEN_234) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_299 = mux(_T_2, UInt<2>("h2"), _GEN_263) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_335 = mux(_T_1, UInt<2>("h2"), _GEN_299) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_375 = mux(_T, UInt<2>("h2"), _GEN_335) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_5_potSel = _GEN_375 @[ControlUnit.scala 56:28]
    node _GEN_25 = mux(evalUnitActive_5, localCntrSels_5_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_5_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_26 = mux(evalUnitActive_5, localCntrSels_5_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_5_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_27 = mux(evalUnitActive_5, localCntrSels_5_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_5_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_28 = mux(evalUnitActive_5, localCntrSels_5_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_56 = mux(io_refracIndi_5, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_74 = mux(_T_12, _GEN_56, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_166 = mux(_T_11, _GEN_74, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_204 = mux(_T_7, UInt<1>("h0"), _GEN_166) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_235 = mux(_T_5, _GEN_56, _GEN_204) @[Conditional.scala 39:67]
    node _GEN_272 = mux(_T_3, UInt<1>("h0"), _GEN_235) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_307 = mux(_T_2, UInt<1>("h0"), _GEN_272) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_343 = mux(_T_1, UInt<1>("h0"), _GEN_307) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_383 = mux(_T, UInt<1>("h0"), _GEN_343) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_5_decaySel = _GEN_383 @[ControlUnit.scala 56:28]
    node _GEN_29 = mux(evalUnitActive_5, localCntrSels_5_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_6_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_6_T_1 = add(_evalUnitActive_6_T, UInt<3>("h6")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_6_T_2 = tail(_evalUnitActive_6_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_6_T_3 = gt(nrNeuMapped, _evalUnitActive_6_T_2) @[ControlUnit.scala 70:38]
    node _GEN_57 = mux(io_refracIndi_6, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_75 = mux(_T_12, _GEN_57, _GEN_57) @[ControlUnit.scala 223:30]
    node _GEN_136 = mux(_T_13, _GEN_57, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_167 = mux(_T_11, _GEN_75, _GEN_136) @[Conditional.scala 39:67]
    node _GEN_196 = mux(_T_7, _GEN_57, _GEN_167) @[Conditional.scala 39:67]
    node _GEN_236 = mux(_T_5, _GEN_57, _GEN_196) @[Conditional.scala 39:67]
    node _GEN_264 = mux(_T_3, UInt<1>("h0"), _GEN_236) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_300 = mux(_T_2, UInt<2>("h2"), _GEN_264) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_336 = mux(_T_1, UInt<2>("h2"), _GEN_300) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_376 = mux(_T, UInt<2>("h2"), _GEN_336) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_6_potSel = _GEN_376 @[ControlUnit.scala 56:28]
    node _GEN_30 = mux(evalUnitActive_6, localCntrSels_6_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_6_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_31 = mux(evalUnitActive_6, localCntrSels_6_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_6_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_32 = mux(evalUnitActive_6, localCntrSels_6_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_6_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_33 = mux(evalUnitActive_6, localCntrSels_6_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_58 = mux(io_refracIndi_6, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_76 = mux(_T_12, _GEN_58, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_168 = mux(_T_11, _GEN_76, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_205 = mux(_T_7, UInt<1>("h0"), _GEN_168) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_237 = mux(_T_5, _GEN_58, _GEN_205) @[Conditional.scala 39:67]
    node _GEN_273 = mux(_T_3, UInt<1>("h0"), _GEN_237) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_308 = mux(_T_2, UInt<1>("h0"), _GEN_273) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_344 = mux(_T_1, UInt<1>("h0"), _GEN_308) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_384 = mux(_T, UInt<1>("h0"), _GEN_344) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_6_decaySel = _GEN_384 @[ControlUnit.scala 56:28]
    node _GEN_34 = mux(evalUnitActive_6, localCntrSels_6_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _evalUnitActive_7_T = shl(n, 3) @[ControlUnit.scala 70:44]
    node _evalUnitActive_7_T_1 = add(_evalUnitActive_7_T, UInt<3>("h7")) @[ControlUnit.scala 70:66]
    node _evalUnitActive_7_T_2 = tail(_evalUnitActive_7_T_1, 1) @[ControlUnit.scala 70:66]
    node _evalUnitActive_7_T_3 = gt(nrNeuMapped, _evalUnitActive_7_T_2) @[ControlUnit.scala 70:38]
    node _GEN_59 = mux(io_refracIndi_7, UInt<1>("h1"), UInt<2>("h2")) @[ControlUnit.scala 176:32 177:37 63:35]
    node _GEN_77 = mux(_T_12, _GEN_59, _GEN_59) @[ControlUnit.scala 223:30]
    node _GEN_137 = mux(_T_13, _GEN_59, UInt<2>("h2")) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_169 = mux(_T_11, _GEN_77, _GEN_137) @[Conditional.scala 39:67]
    node _GEN_197 = mux(_T_7, _GEN_59, _GEN_169) @[Conditional.scala 39:67]
    node _GEN_238 = mux(_T_5, _GEN_59, _GEN_197) @[Conditional.scala 39:67]
    node _GEN_265 = mux(_T_3, UInt<1>("h0"), _GEN_238) @[Conditional.scala 39:67 ControlUnit.scala 152:33]
    node _GEN_301 = mux(_T_2, UInt<2>("h2"), _GEN_265) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_337 = mux(_T_1, UInt<2>("h2"), _GEN_301) @[Conditional.scala 39:67 ControlUnit.scala 63:35]
    node _GEN_377 = mux(_T, UInt<2>("h2"), _GEN_337) @[Conditional.scala 40:58 ControlUnit.scala 63:35]
    node localCntrSels_7_potSel = _GEN_377 @[ControlUnit.scala 56:28]
    node _GEN_35 = mux(evalUnitActive_7, localCntrSels_7_potSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 72:35 78:35]
    node localCntrSels_7_spikeSel = _GEN_367 @[ControlUnit.scala 56:28]
    node _GEN_36 = mux(evalUnitActive_7, localCntrSels_7_spikeSel, UInt<2>("h2")) @[ControlUnit.scala 71:29 73:35 79:35]
    node localCntrSels_7_refracSel = _GEN_368 @[ControlUnit.scala 56:28]
    node _GEN_37 = mux(evalUnitActive_7, localCntrSels_7_refracSel, UInt<1>("h1")) @[ControlUnit.scala 71:29 74:35 80:35]
    node localCntrSels_7_writeDataSel = _GEN_386 @[ControlUnit.scala 56:28]
    node _GEN_38 = mux(evalUnitActive_7, localCntrSels_7_writeDataSel, UInt<1>("h0")) @[ControlUnit.scala 71:29 75:35 81:35]
    node _GEN_60 = mux(io_refracIndi_7, UInt<1>("h1"), UInt<1>("h0")) @[ControlUnit.scala 176:32 178:37 67:35]
    node _GEN_78 = mux(_T_12, _GEN_60, UInt<1>("h0")) @[ControlUnit.scala 223:30 67:35]
    node _GEN_170 = mux(_T_11, _GEN_78, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_206 = mux(_T_7, UInt<1>("h0"), _GEN_170) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_239 = mux(_T_5, _GEN_60, _GEN_206) @[Conditional.scala 39:67]
    node _GEN_274 = mux(_T_3, UInt<1>("h0"), _GEN_239) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_309 = mux(_T_2, UInt<1>("h0"), _GEN_274) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_345 = mux(_T_1, UInt<1>("h0"), _GEN_309) @[Conditional.scala 39:67 ControlUnit.scala 67:35]
    node _GEN_385 = mux(_T, UInt<1>("h0"), _GEN_345) @[Conditional.scala 40:58 ControlUnit.scala 67:35]
    node localCntrSels_7_decaySel = _GEN_385 @[ControlUnit.scala 56:28]
    node _GEN_39 = mux(evalUnitActive_7, localCntrSels_7_decaySel, UInt<1>("h0")) @[ControlUnit.scala 71:29 76:35 82:35]
    node _inOut_T = not(inOut) @[ControlUnit.scala 110:21]
    node _GEN_40 = mux(io_newTS, UInt<1>("h0"), UInt<1>("h1")) @[ControlUnit.scala 103:15 107:22 108:18]
    node _GEN_41 = mux(io_newTS, io_spikeCnt, spikeCnt) @[ControlUnit.scala 107:22 109:18 50:25]
    node _GEN_42 = mux(io_newTS, _inOut_T, inOut) @[ControlUnit.scala 107:22 110:18 52:22]
    node _GEN_43 = mux(io_newTS, UInt<4>("h1"), state) @[ControlUnit.scala 107:22 111:18 36:22]
    node _io_addr_pos_T = add(n, UInt<6>("h20")) @[ControlUnit.scala 133:24]
    node _io_addr_pos_T_1 = tail(_io_addr_pos_T, 1) @[ControlUnit.scala 133:24]
    node _a_T = add(a, UInt<1>("h1")) @[ControlUnit.scala 148:14]
    node _a_T_1 = tail(_a_T, 1) @[ControlUnit.scala 148:14]
    node _T_4 = eq(spikeCnt, UInt<1>("h0")) @[ControlUnit.scala 154:21]
    node _GEN_44 = mux(_T_4, UInt<4>("h6"), UInt<4>("h4")) @[ControlUnit.scala 154:30 155:15 157:15]
    node _io_addr_pos_T_2 = mul(n, UInt<10>("h300")) @[ControlUnit.scala 167:27]
    node _io_addr_pos_T_3 = add(_io_addr_pos_T_2, io_aData) @[ControlUnit.scala 167:40]
    node _io_addr_pos_T_4 = tail(_io_addr_pos_T_3, 1) @[ControlUnit.scala 167:40]
    node _a_T_2 = add(a, UInt<1>("h1")) @[ControlUnit.scala 173:14]
    node _a_T_3 = tail(_a_T_2, 1) @[ControlUnit.scala 173:14]
    node _T_6 = eq(spikeCnt, a) @[ControlUnit.scala 182:21]
    node _GEN_61 = mux(_T_6, UInt<4>("h6"), UInt<4>("h5")) @[ControlUnit.scala 182:28 183:15 185:15]
    node _io_addr_pos_T_5 = mul(n, UInt<10>("h300")) @[ControlUnit.scala 195:27]
    node _io_addr_pos_T_6 = add(_io_addr_pos_T_5, io_aData) @[ControlUnit.scala 195:40]
    node _io_addr_pos_T_7 = tail(_io_addr_pos_T_6, 1) @[ControlUnit.scala 195:40]
    node _a_T_4 = add(a, UInt<1>("h1")) @[ControlUnit.scala 200:14]
    node _a_T_5 = tail(_a_T_4, 1) @[ControlUnit.scala 200:14]
    node _T_8 = sub(a, UInt<1>("h1")) @[ControlUnit.scala 209:27]
    node _T_9 = tail(_T_8, 1) @[ControlUnit.scala 209:27]
    node _T_10 = eq(spikeCnt, _T_9) @[ControlUnit.scala 209:21]
    node _GEN_62 = mux(_T_10, UInt<4>("h6"), UInt<4>("h5")) @[ControlUnit.scala 209:34 210:15 212:15]
    node _io_addr_pos_T_8 = add(n, UInt<6>("h20")) @[ControlUnit.scala 246:25]
    node _io_addr_pos_T_9 = tail(_io_addr_pos_T_8, 1) @[ControlUnit.scala 246:25]
    node _io_addr_pos_T_10 = add(n, UInt<6>("h20")) @[ControlUnit.scala 300:24]
    node _io_addr_pos_T_11 = tail(_io_addr_pos_T_10, 1) @[ControlUnit.scala 300:24]
    node _nNext_T = add(n, UInt<1>("h1")) @[ControlUnit.scala 306:21]
    node nNext = tail(_nNext_T, 1) @[ControlUnit.scala 306:21]
    node _T_18 = shl(nNext, 3) @[ControlUnit.scala 308:19]
    node _T_19 = geq(_T_18, nrNeuMapped) @[ControlUnit.scala 308:41]
    node _GEN_79 = mux(_T_19, UInt<4>("h0"), UInt<4>("h1")) @[ControlUnit.scala 308:58 309:15 311:15]
    node _GEN_81 = mux(_T_17, UInt<2>("h1"), UInt<2>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 299:19 89:15]
    node _GEN_82 = mux(_T_17, _io_addr_pos_T_11, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 300:19 90:15]
    node _GEN_83 = mux(_T_17, UInt<1>("h0"), a) @[Conditional.scala 39:67 ControlUnit.scala 305:9 47:22]
    node _GEN_84 = mux(_T_17, nNext, n) @[Conditional.scala 39:67 ControlUnit.scala 307:9 45:22]
    node _GEN_85 = mux(_T_17, _GEN_79, state) @[Conditional.scala 39:67 ControlUnit.scala 36:22]
    node _GEN_86 = mux(_T_16, UInt<1>("h1"), _GEN_80) @[Conditional.scala 39:67 ControlUnit.scala 287:20]
    node _GEN_88 = mux(_T_16, UInt<2>("h0"), _GEN_81) @[Conditional.scala 39:67 ControlUnit.scala 289:19]
    node _GEN_89 = mux(_T_16, UInt<2>("h0"), _GEN_82) @[Conditional.scala 39:67 ControlUnit.scala 290:19]
    node _GEN_90 = mux(_T_16, UInt<4>("hb"), _GEN_85) @[Conditional.scala 39:67 ControlUnit.scala 292:17]
    node _GEN_91 = mux(_T_16, a, _GEN_83) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_92 = mux(_T_16, n, _GEN_84) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_93 = mux(_T_15, UInt<1>("h1"), _GEN_86) @[Conditional.scala 39:67 ControlUnit.scala 272:19]
    node _GEN_94 = mux(_T_15, UInt<1>("h1"), _GEN_87) @[Conditional.scala 39:67 ControlUnit.scala 273:19]
    node _GEN_95 = mux(_T_15, UInt<2>("h1"), _GEN_88) @[Conditional.scala 39:67 ControlUnit.scala 274:19]
    node _GEN_96 = mux(_T_15, n, _GEN_89) @[Conditional.scala 39:67 ControlUnit.scala 275:19]
    node _GEN_98 = mux(_T_15, io_spikeIndi_0, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_99 = mux(_T_15, io_spikeIndi_1, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_100 = mux(_T_15, io_spikeIndi_2, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_101 = mux(_T_15, io_spikeIndi_3, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_102 = mux(_T_15, io_spikeIndi_4, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_103 = mux(_T_15, io_spikeIndi_5, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_104 = mux(_T_15, io_spikeIndi_6, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_105 = mux(_T_15, io_spikeIndi_7, UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 279:23 62:35]
    node _GEN_106 = mux(_T_15, UInt<4>("ha"), _GEN_90) @[Conditional.scala 39:67 ControlUnit.scala 282:13]
    node _GEN_107 = mux(_T_15, a, _GEN_91) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_108 = mux(_T_15, n, _GEN_92) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_109 = mux(_T_14, UInt<1>("h1"), _GEN_93) @[Conditional.scala 39:67 ControlUnit.scala 259:19]
    node _GEN_110 = mux(_T_14, UInt<1>("h0"), _GEN_94) @[Conditional.scala 39:67 ControlUnit.scala 260:19]
    node _GEN_111 = mux(_T_14, UInt<2>("h0"), _GEN_95) @[Conditional.scala 39:67 ControlUnit.scala 261:19]
    node _GEN_112 = mux(_T_14, UInt<2>("h1"), _GEN_96) @[Conditional.scala 39:67 ControlUnit.scala 262:19]
    node _GEN_114 = mux(_T_14, UInt<4>("h9"), _GEN_106) @[Conditional.scala 39:67 ControlUnit.scala 267:13]
    node _GEN_116 = mux(_T_14, UInt<1>("h0"), _GEN_98) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_117 = mux(_T_14, UInt<1>("h0"), _GEN_99) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_118 = mux(_T_14, UInt<1>("h0"), _GEN_100) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_119 = mux(_T_14, UInt<1>("h0"), _GEN_101) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_120 = mux(_T_14, UInt<1>("h0"), _GEN_102) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_121 = mux(_T_14, UInt<1>("h0"), _GEN_103) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_122 = mux(_T_14, UInt<1>("h0"), _GEN_104) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_123 = mux(_T_14, UInt<1>("h0"), _GEN_105) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_124 = mux(_T_14, a, _GEN_107) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_125 = mux(_T_14, n, _GEN_108) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_126 = mux(_T_13, UInt<1>("h1"), _GEN_109) @[Conditional.scala 39:67 ControlUnit.scala 243:20]
    node _GEN_127 = mux(_T_13, UInt<1>("h0"), _GEN_110) @[Conditional.scala 39:67 ControlUnit.scala 244:20]
    node _GEN_128 = mux(_T_13, UInt<2>("h2"), _GEN_111) @[Conditional.scala 39:67 ControlUnit.scala 245:20]
    node _GEN_129 = mux(_T_13, _io_addr_pos_T_9, _GEN_112) @[Conditional.scala 39:67 ControlUnit.scala 246:20]
    node _GEN_138 = mux(_T_13, UInt<4>("h8"), _GEN_114) @[Conditional.scala 39:67 ControlUnit.scala 254:13]
    node _GEN_141 = mux(_T_13, UInt<1>("h0"), _GEN_116) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_142 = mux(_T_13, UInt<1>("h0"), _GEN_117) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_143 = mux(_T_13, UInt<1>("h0"), _GEN_118) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_144 = mux(_T_13, UInt<1>("h0"), _GEN_119) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_145 = mux(_T_13, UInt<1>("h0"), _GEN_120) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_146 = mux(_T_13, UInt<1>("h0"), _GEN_121) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_147 = mux(_T_13, UInt<1>("h0"), _GEN_122) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_148 = mux(_T_13, UInt<1>("h0"), _GEN_123) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_149 = mux(_T_13, a, _GEN_124) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_150 = mux(_T_13, n, _GEN_125) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_151 = mux(_T_11, UInt<1>("h1"), _GEN_126) @[Conditional.scala 39:67 ControlUnit.scala 218:19]
    node _GEN_152 = mux(_T_11, UInt<1>("h0"), _GEN_127) @[Conditional.scala 39:67 ControlUnit.scala 219:19]
    node _GEN_153 = mux(_T_11, UInt<2>("h2"), _GEN_128) @[Conditional.scala 39:67 ControlUnit.scala 220:19]
    node _GEN_154 = mux(_T_11, n, _GEN_129) @[Conditional.scala 39:67 ControlUnit.scala 221:19]
    node _GEN_171 = mux(_T_11, UInt<4>("h7"), _GEN_138) @[Conditional.scala 39:67 ControlUnit.scala 238:13]
    node _GEN_174 = mux(_T_11, UInt<1>("h0"), _GEN_141) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_175 = mux(_T_11, UInt<1>("h0"), _GEN_142) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_176 = mux(_T_11, UInt<1>("h0"), _GEN_143) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_177 = mux(_T_11, UInt<1>("h0"), _GEN_144) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_178 = mux(_T_11, UInt<1>("h0"), _GEN_145) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_179 = mux(_T_11, UInt<1>("h0"), _GEN_146) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_180 = mux(_T_11, UInt<1>("h0"), _GEN_147) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_181 = mux(_T_11, UInt<1>("h0"), _GEN_148) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_182 = mux(_T_11, a, _GEN_149) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_183 = mux(_T_11, n, _GEN_150) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_184 = mux(_T_7, UInt<1>("h1"), _GEN_151) @[Conditional.scala 39:67 ControlUnit.scala 191:19]
    node _GEN_185 = mux(_T_7, UInt<1>("h0"), _GEN_152) @[Conditional.scala 39:67 ControlUnit.scala 192:19]
    node _GEN_186 = mux(_T_7, UInt<2>("h3"), _GEN_153) @[Conditional.scala 39:67 ControlUnit.scala 193:19]
    node _GEN_187 = mux(_T_7, _io_addr_pos_T_7, _GEN_154) @[Conditional.scala 39:67 ControlUnit.scala 195:21]
    node _GEN_188 = mux(_T_7, _a_T_5, _GEN_182) @[Conditional.scala 39:67 ControlUnit.scala 200:9]
    node _GEN_189 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 ControlUnit.scala 201:15 96:11]
    node _GEN_198 = mux(_T_7, _GEN_62, _GEN_171) @[Conditional.scala 39:67]
    node _GEN_209 = mux(_T_7, UInt<1>("h0"), _GEN_174) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_210 = mux(_T_7, UInt<1>("h0"), _GEN_175) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_211 = mux(_T_7, UInt<1>("h0"), _GEN_176) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_212 = mux(_T_7, UInt<1>("h0"), _GEN_177) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_213 = mux(_T_7, UInt<1>("h0"), _GEN_178) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_214 = mux(_T_7, UInt<1>("h0"), _GEN_179) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_215 = mux(_T_7, UInt<1>("h0"), _GEN_180) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_216 = mux(_T_7, UInt<1>("h0"), _GEN_181) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_217 = mux(_T_7, n, _GEN_183) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_218 = mux(_T_5, UInt<1>("h1"), _GEN_184) @[Conditional.scala 39:67 ControlUnit.scala 163:19]
    node _GEN_219 = mux(_T_5, UInt<1>("h0"), _GEN_185) @[Conditional.scala 39:67 ControlUnit.scala 164:19]
    node _GEN_220 = mux(_T_5, UInt<2>("h3"), _GEN_186) @[Conditional.scala 39:67 ControlUnit.scala 165:19]
    node _GEN_221 = mux(_T_5, _io_addr_pos_T_4, _GEN_187) @[Conditional.scala 39:67 ControlUnit.scala 167:21]
    node _GEN_222 = mux(_T_5, UInt<1>("h1"), _GEN_189) @[Conditional.scala 39:67 ControlUnit.scala 172:15]
    node _GEN_223 = mux(_T_5, _a_T_3, _GEN_188) @[Conditional.scala 39:67 ControlUnit.scala 173:9]
    node _GEN_240 = mux(_T_5, _GEN_61, _GEN_198) @[Conditional.scala 39:67]
    node _GEN_243 = mux(_T_5, UInt<1>("h0"), _GEN_209) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_244 = mux(_T_5, UInt<1>("h0"), _GEN_210) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_245 = mux(_T_5, UInt<1>("h0"), _GEN_211) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_246 = mux(_T_5, UInt<1>("h0"), _GEN_212) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_247 = mux(_T_5, UInt<1>("h0"), _GEN_213) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_248 = mux(_T_5, UInt<1>("h0"), _GEN_214) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_249 = mux(_T_5, UInt<1>("h0"), _GEN_215) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_250 = mux(_T_5, UInt<1>("h0"), _GEN_216) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_251 = mux(_T_5, n, _GEN_217) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_252 = mux(_T_3, UInt<1>("h1"), _GEN_218) @[Conditional.scala 39:67 ControlUnit.scala 143:19]
    node _GEN_253 = mux(_T_3, UInt<1>("h0"), _GEN_219) @[Conditional.scala 39:67 ControlUnit.scala 144:19]
    node _GEN_254 = mux(_T_3, UInt<2>("h0"), _GEN_220) @[Conditional.scala 39:67 ControlUnit.scala 145:19]
    node _GEN_255 = mux(_T_3, UInt<2>("h2"), _GEN_221) @[Conditional.scala 39:67 ControlUnit.scala 146:19]
    node _GEN_256 = mux(_T_3, _a_T_1, _GEN_223) @[Conditional.scala 39:67 ControlUnit.scala 148:9]
    node _GEN_257 = mux(_T_3, UInt<1>("h1"), _GEN_222) @[Conditional.scala 39:67 ControlUnit.scala 149:15]
    node _GEN_266 = mux(_T_3, _GEN_44, _GEN_240) @[Conditional.scala 39:67]
    node _GEN_277 = mux(_T_3, UInt<1>("h0"), _GEN_243) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_278 = mux(_T_3, UInt<1>("h0"), _GEN_244) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_279 = mux(_T_3, UInt<1>("h0"), _GEN_245) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_280 = mux(_T_3, UInt<1>("h0"), _GEN_246) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_281 = mux(_T_3, UInt<1>("h0"), _GEN_247) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_282 = mux(_T_3, UInt<1>("h0"), _GEN_248) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_283 = mux(_T_3, UInt<1>("h0"), _GEN_249) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_284 = mux(_T_3, UInt<1>("h0"), _GEN_250) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_285 = mux(_T_3, n, _GEN_251) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_286 = mux(_T_2, UInt<1>("h1"), _GEN_252) @[Conditional.scala 39:67 ControlUnit.scala 130:19]
    node _GEN_287 = mux(_T_2, UInt<1>("h0"), _GEN_253) @[Conditional.scala 39:67 ControlUnit.scala 131:19]
    node _GEN_288 = mux(_T_2, UInt<2>("h1"), _GEN_254) @[Conditional.scala 39:67 ControlUnit.scala 132:19]
    node _GEN_289 = mux(_T_2, _io_addr_pos_T_1, _GEN_255) @[Conditional.scala 39:67 ControlUnit.scala 133:19]
    node _GEN_291 = mux(_T_2, UInt<4>("h3"), _GEN_266) @[Conditional.scala 39:67 ControlUnit.scala 138:13]
    node _GEN_292 = mux(_T_2, a, _GEN_256) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_293 = mux(_T_2, UInt<1>("h0"), _GEN_257) @[Conditional.scala 39:67 ControlUnit.scala 96:11]
    node _GEN_312 = mux(_T_2, UInt<1>("h0"), _GEN_277) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_313 = mux(_T_2, UInt<1>("h0"), _GEN_278) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_314 = mux(_T_2, UInt<1>("h0"), _GEN_279) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_315 = mux(_T_2, UInt<1>("h0"), _GEN_280) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_316 = mux(_T_2, UInt<1>("h0"), _GEN_281) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_317 = mux(_T_2, UInt<1>("h0"), _GEN_282) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_318 = mux(_T_2, UInt<1>("h0"), _GEN_283) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_319 = mux(_T_2, UInt<1>("h0"), _GEN_284) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_320 = mux(_T_2, n, _GEN_285) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_321 = mux(_T_1, UInt<1>("h1"), _GEN_286) @[Conditional.scala 39:67 ControlUnit.scala 117:19]
    node _GEN_322 = mux(_T_1, UInt<1>("h0"), _GEN_287) @[Conditional.scala 39:67 ControlUnit.scala 118:19]
    node _GEN_323 = mux(_T_1, UInt<2>("h1"), _GEN_288) @[Conditional.scala 39:67 ControlUnit.scala 119:19]
    node _GEN_324 = mux(_T_1, n, _GEN_289) @[Conditional.scala 39:67 ControlUnit.scala 120:19]
    node _GEN_326 = mux(_T_1, UInt<4>("h2"), _GEN_291) @[Conditional.scala 39:67 ControlUnit.scala 125:13]
    node _GEN_328 = mux(_T_1, a, _GEN_292) @[Conditional.scala 39:67 ControlUnit.scala 47:22]
    node _GEN_329 = mux(_T_1, UInt<1>("h0"), _GEN_293) @[Conditional.scala 39:67 ControlUnit.scala 96:11]
    node _GEN_347 = mux(_T_1, UInt<1>("h0"), _GEN_312) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_348 = mux(_T_1, UInt<1>("h0"), _GEN_313) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_349 = mux(_T_1, UInt<1>("h0"), _GEN_314) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_350 = mux(_T_1, UInt<1>("h0"), _GEN_315) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_351 = mux(_T_1, UInt<1>("h0"), _GEN_316) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_352 = mux(_T_1, UInt<1>("h0"), _GEN_317) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_353 = mux(_T_1, UInt<1>("h0"), _GEN_318) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_354 = mux(_T_1, UInt<1>("h0"), _GEN_319) @[Conditional.scala 39:67 ControlUnit.scala 62:35]
    node _GEN_355 = mux(_T_1, n, _GEN_320) @[Conditional.scala 39:67 ControlUnit.scala 45:22]
    node _GEN_356 = mux(_T, _GEN_40, UInt<1>("h0")) @[Conditional.scala 40:58 ControlUnit.scala 99:11]
    node _GEN_357 = mux(_T, UInt<1>("h0"), _GEN_355) @[Conditional.scala 40:58 ControlUnit.scala 104:9]
    node _GEN_358 = mux(_T, UInt<1>("h0"), _GEN_328) @[Conditional.scala 40:58 ControlUnit.scala 105:9]
    node _GEN_359 = mux(_T, UInt<1>("h0"), UInt<1>("h1")) @[Conditional.scala 40:58 ControlUnit.scala 106:21 94:17]
    node _GEN_360 = mux(_T, _GEN_41, spikeCnt) @[Conditional.scala 40:58 ControlUnit.scala 50:25]
    node _GEN_361 = mux(_T, _GEN_42, inOut) @[Conditional.scala 40:58 ControlUnit.scala 52:22]
    node _GEN_362 = mux(_T, _GEN_43, _GEN_326) @[Conditional.scala 40:58]
    node _GEN_363 = mux(_T, UInt<1>("h0"), _GEN_321) @[Conditional.scala 40:58 ControlUnit.scala 91:10]
    node _GEN_364 = mux(_T, UInt<1>("h0"), _GEN_322) @[Conditional.scala 40:58 ControlUnit.scala 92:10]
    node _GEN_365 = mux(_T, UInt<2>("h0"), _GEN_323) @[Conditional.scala 40:58 ControlUnit.scala 89:15]
    node _GEN_366 = mux(_T, UInt<1>("h0"), _GEN_324) @[Conditional.scala 40:58 ControlUnit.scala 90:15]
    node _GEN_369 = mux(_T, UInt<1>("h0"), _GEN_329) @[Conditional.scala 40:58 ControlUnit.scala 96:11]
    node _GEN_387 = mux(_T, UInt<1>("h0"), _GEN_347) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_388 = mux(_T, UInt<1>("h0"), _GEN_348) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_389 = mux(_T, UInt<1>("h0"), _GEN_349) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_390 = mux(_T, UInt<1>("h0"), _GEN_350) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_391 = mux(_T, UInt<1>("h0"), _GEN_351) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_392 = mux(_T, UInt<1>("h0"), _GEN_352) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_393 = mux(_T, UInt<1>("h0"), _GEN_353) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _GEN_394 = mux(_T, UInt<1>("h0"), _GEN_354) @[Conditional.scala 40:58 ControlUnit.scala 62:35]
    node _spikePulse_WIRE_0 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_1 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_2 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_3 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_4 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_5 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_6 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _spikePulse_WIRE_7 = UInt<1>("h0") @[ControlUnit.scala 42:{35,35}]
    node _evalUnitActive_WIRE_0 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_1 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_2 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_3 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_4 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_5 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_6 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    node _evalUnitActive_WIRE_7 = UInt<1>("h0") @[ControlUnit.scala 55:{39,39}]
    io_done <= _GEN_356
    io_addr_sel <= _GEN_365
    io_addr_pos <= _GEN_366
    io_wr <= _GEN_364
    io_ena <= _GEN_363
    io_cntrSels_0_potSel <= _GEN_0
    io_cntrSels_0_spikeSel <= _GEN_1
    io_cntrSels_0_refracSel <= _GEN_2
    io_cntrSels_0_decaySel <= _GEN_4
    io_cntrSels_0_writeDataSel <= _GEN_3
    io_cntrSels_1_potSel <= _GEN_5
    io_cntrSels_1_spikeSel <= _GEN_6
    io_cntrSels_1_refracSel <= _GEN_7
    io_cntrSels_1_decaySel <= _GEN_9
    io_cntrSels_1_writeDataSel <= _GEN_8
    io_cntrSels_2_potSel <= _GEN_10
    io_cntrSels_2_spikeSel <= _GEN_11
    io_cntrSels_2_refracSel <= _GEN_12
    io_cntrSels_2_decaySel <= _GEN_14
    io_cntrSels_2_writeDataSel <= _GEN_13
    io_cntrSels_3_potSel <= _GEN_15
    io_cntrSels_3_spikeSel <= _GEN_16
    io_cntrSels_3_refracSel <= _GEN_17
    io_cntrSels_3_decaySel <= _GEN_19
    io_cntrSels_3_writeDataSel <= _GEN_18
    io_cntrSels_4_potSel <= _GEN_20
    io_cntrSels_4_spikeSel <= _GEN_21
    io_cntrSels_4_refracSel <= _GEN_22
    io_cntrSels_4_decaySel <= _GEN_24
    io_cntrSels_4_writeDataSel <= _GEN_23
    io_cntrSels_5_potSel <= _GEN_25
    io_cntrSels_5_spikeSel <= _GEN_26
    io_cntrSels_5_refracSel <= _GEN_27
    io_cntrSels_5_decaySel <= _GEN_29
    io_cntrSels_5_writeDataSel <= _GEN_28
    io_cntrSels_6_potSel <= _GEN_30
    io_cntrSels_6_spikeSel <= _GEN_31
    io_cntrSels_6_refracSel <= _GEN_32
    io_cntrSels_6_decaySel <= _GEN_34
    io_cntrSels_6_writeDataSel <= _GEN_33
    io_cntrSels_7_potSel <= _GEN_35
    io_cntrSels_7_spikeSel <= _GEN_36
    io_cntrSels_7_refracSel <= _GEN_37
    io_cntrSels_7_decaySel <= _GEN_39
    io_cntrSels_7_writeDataSel <= _GEN_38
    io_evalEnable <= _GEN_359
    io_inOut <= inOut @[ControlUnit.scala 53:12]
    io_aAddr <= a @[ControlUnit.scala 48:12]
    io_aEna <= _GEN_369
    io_n <= n @[ControlUnit.scala 46:12]
    io_spikes_0 <= spikePulse_0 @[ControlUnit.scala 86:18]
    io_spikes_1 <= spikePulse_1 @[ControlUnit.scala 86:18]
    io_spikes_2 <= spikePulse_2 @[ControlUnit.scala 86:18]
    io_spikes_3 <= spikePulse_3 @[ControlUnit.scala 86:18]
    io_spikes_4 <= spikePulse_4 @[ControlUnit.scala 86:18]
    io_spikes_5 <= spikePulse_5 @[ControlUnit.scala 86:18]
    io_spikes_6 <= spikePulse_6 @[ControlUnit.scala 86:18]
    io_spikes_7 <= spikePulse_7 @[ControlUnit.scala 86:18]
    state <= mux(reset, UInt<4>("h0"), _GEN_362) @[ControlUnit.scala 36:{22,22}]
    spikePulse_0 <= mux(reset, _spikePulse_WIRE_0, _GEN_387) @[ControlUnit.scala 42:{27,27}]
    spikePulse_1 <= mux(reset, _spikePulse_WIRE_1, _GEN_388) @[ControlUnit.scala 42:{27,27}]
    spikePulse_2 <= mux(reset, _spikePulse_WIRE_2, _GEN_389) @[ControlUnit.scala 42:{27,27}]
    spikePulse_3 <= mux(reset, _spikePulse_WIRE_3, _GEN_390) @[ControlUnit.scala 42:{27,27}]
    spikePulse_4 <= mux(reset, _spikePulse_WIRE_4, _GEN_391) @[ControlUnit.scala 42:{27,27}]
    spikePulse_5 <= mux(reset, _spikePulse_WIRE_5, _GEN_392) @[ControlUnit.scala 42:{27,27}]
    spikePulse_6 <= mux(reset, _spikePulse_WIRE_6, _GEN_393) @[ControlUnit.scala 42:{27,27}]
    spikePulse_7 <= mux(reset, _spikePulse_WIRE_7, _GEN_394) @[ControlUnit.scala 42:{27,27}]
    n <= mux(reset, UInt<5>("h0"), _GEN_357) @[ControlUnit.scala 45:{22,22}]
    a <= mux(reset, UInt<10>("h0"), _GEN_358) @[ControlUnit.scala 47:{22,22}]
    spikeCnt <= mux(reset, UInt<10>("h0"), _GEN_360) @[ControlUnit.scala 50:{25,25}]
    inOut <= mux(reset, UInt<1>("h0"), _GEN_361) @[ControlUnit.scala 52:{22,22}]
    evalUnitActive_0 <= mux(reset, _evalUnitActive_WIRE_0, _evalUnitActive_0_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_1 <= mux(reset, _evalUnitActive_WIRE_1, _evalUnitActive_1_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_2 <= mux(reset, _evalUnitActive_WIRE_2, _evalUnitActive_2_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_3 <= mux(reset, _evalUnitActive_WIRE_3, _evalUnitActive_3_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_4 <= mux(reset, _evalUnitActive_WIRE_4, _evalUnitActive_4_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_5 <= mux(reset, _evalUnitActive_WIRE_5, _evalUnitActive_5_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_6 <= mux(reset, _evalUnitActive_WIRE_6, _evalUnitActive_6_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    evalUnitActive_7 <= mux(reset, _evalUnitActive_WIRE_7, _evalUnitActive_7_T_3) @[ControlUnit.scala 55:{31,31} 70:23]
    nrNeuMapped <= mux(reset, UInt<8>("hc8"), nrNeuMapped) @[ControlUnit.scala 58:{28,28,28}]

  module NeuronEvaluator :
    input clock : Clock
    input reset : UInt<1>
    input io_dataIn : SInt<17>
    output io_dataOut : SInt<17>
    output io_spikeIndi : UInt<1>
    output io_refracIndi : UInt<1>
    input io_cntrSels_potSel : UInt<2>
    input io_cntrSels_spikeSel : UInt<2>
    input io_cntrSels_refracSel : UInt<1>
    input io_cntrSels_decaySel : UInt<1>
    input io_cntrSels_writeDataSel : UInt<2>
    input io_evalEnable : UInt<1>

    reg membPotReg : SInt<17>, clock with :
      reset => (UInt<1>("h0"), membPotReg) @[Reg.scala 27:20]
    node _T_2 = eq(UInt<1>("h0"), io_cntrSels_potSel) @[Conditional.scala 37:30]
    node _T_3 = eq(UInt<1>("h1"), io_cntrSels_potSel) @[Conditional.scala 37:30]
    node sumIn1 = pad(membPotReg, 18) @[NeuronEvaluator.scala 21:30 34:14]
    node _potDecay_T = bits(io_dataIn, 2, 0) @[NeuronEvaluator.scala 73:38]
    node _potDecay_T_1 = dshr(membPotReg, _potDecay_T) @[NeuronEvaluator.scala 73:26]
    node potDecay = _potDecay_T_1 @[NeuronEvaluator.scala 23:30 73:12]
    node _sumIn2_T = sub(asSInt(UInt<1>("h0")), potDecay) @[NeuronEvaluator.scala 35:43]
    node _sumIn2_T_1 = tail(_sumIn2_T, 1) @[NeuronEvaluator.scala 35:43]
    node _sumIn2_T_2 = asSInt(_sumIn2_T_1) @[NeuronEvaluator.scala 35:43]
    node _sumIn2_T_3 = mux(io_cntrSels_decaySel, _sumIn2_T_2, io_dataIn) @[NeuronEvaluator.scala 35:20]
    node sumIn2 = pad(_sumIn2_T_3, 18) @[NeuronEvaluator.scala 22:30 35:14]
    node _sum_T = add(sumIn1, sumIn2) @[NeuronEvaluator.scala 36:24]
    node _sum_T_1 = tail(_sum_T, 1) @[NeuronEvaluator.scala 36:24]
    node _sum_T_2 = asSInt(_sum_T_1) @[NeuronEvaluator.scala 36:24]
    node sum = _sum_T_2 @[NeuronEvaluator.scala 19:30 36:14]
    node _T = lt(sum, asSInt(UInt<17>("h10000"))) @[NeuronEvaluator.scala 42:12]
    node _T_1 = gt(sum, asSInt(UInt<17>("hffff"))) @[NeuronEvaluator.scala 44:18]
    node _GEN_3 = mux(_T_1, asSInt(UInt<17>("hffff")), sum) @[NeuronEvaluator.scala 44:53 45:12 47:12]
    node _GEN_4 = mux(_T, asSInt(UInt<17>("h10000")), _GEN_3) @[NeuronEvaluator.scala 42:47 43:12]
    node sumSat = asSInt(bits(_GEN_4, 16, 0)) @[NeuronEvaluator.scala 20:30]
    node _T_4 = eq(UInt<2>("h2"), io_cntrSels_potSel) @[Conditional.scala 37:30]
    node _GEN_5 = mux(_T_4, membPotReg, membPotReg) @[Conditional.scala 39:67 NeuronEvaluator.scala 38:20 59:22]
    node _GEN_6 = mux(_T_3, sumSat, _GEN_5) @[Conditional.scala 39:67 NeuronEvaluator.scala 56:22]
    node _GEN_7 = mux(_T_2, io_dataIn, _GEN_6) @[Conditional.scala 40:58 NeuronEvaluator.scala 53:22]
    node membPotRegNext = _GEN_7 @[NeuronEvaluator.scala 25:30]
    node _GEN_0 = mux(io_evalEnable, membPotRegNext, membPotReg) @[Reg.scala 28:19 27:20 28:23]
    reg refracCntReg : SInt<17>, clock with :
      reset => (UInt<1>("h0"), refracCntReg) @[Reg.scala 15:16]
    node _refracRegNext_T = eq(io_cntrSels_refracSel, UInt<1>("h0")) @[NeuronEvaluator.scala 76:46]
    node _refracRegNext_T_1 = mux(_refracRegNext_T, io_dataIn, refracCntReg) @[NeuronEvaluator.scala 76:23]
    node refracRegNext = _refracRegNext_T_1 @[NeuronEvaluator.scala 24:30 76:17]
    node _GEN_1 = mux(io_evalEnable, refracRegNext, refracCntReg) @[Reg.scala 15:16 16:{19,23}]
    reg spikeIndiReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeIndiReg) @[Reg.scala 27:20]
    node _T_5 = eq(UInt<1>("h0"), io_cntrSels_spikeSel) @[Conditional.scala 37:30]
    node _spikeIndiRegNext_T = gt(membPotReg, io_dataIn) @[NeuronEvaluator.scala 81:38]
    node _T_6 = eq(UInt<1>("h1"), io_cntrSels_spikeSel) @[Conditional.scala 37:30]
    node _GEN_8 = mux(_T_6, UInt<1>("h0"), spikeIndiReg) @[Conditional.scala 39:67 NeuronEvaluator.scala 39:20 84:24]
    node _GEN_9 = mux(_T_5, _spikeIndiRegNext_T, _GEN_8) @[Conditional.scala 40:58 NeuronEvaluator.scala 81:24]
    node spikeIndiRegNext = _GEN_9 @[NeuronEvaluator.scala 26:30]
    node _GEN_2 = mux(io_evalEnable, spikeIndiRegNext, spikeIndiReg) @[Reg.scala 28:19 27:20 28:23]
    node _T_7 = eq(UInt<1>("h0"), io_cntrSels_writeDataSel) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<1>("h1"), io_cntrSels_writeDataSel) @[Conditional.scala 37:30]
    node _T_9 = not(spikeIndiReg) @[NeuronEvaluator.scala 94:12]
    node _GEN_10 = mux(_T_9, membPotReg, io_dataIn) @[NeuronEvaluator.scala 94:27 95:20 97:20]
    node _T_10 = eq(UInt<2>("h2"), io_cntrSels_writeDataSel) @[Conditional.scala 37:30]
    node _GEN_11 = mux(spikeIndiReg, io_dataIn, refracCntReg) @[NeuronEvaluator.scala 102:28 103:22 105:22]
    node _io_dataOut_T = sub(refracCntReg, asSInt(UInt<2>("h1"))) @[NeuronEvaluator.scala 108:36]
    node _io_dataOut_T_1 = tail(_io_dataOut_T, 1) @[NeuronEvaluator.scala 108:36]
    node _io_dataOut_T_2 = asSInt(_io_dataOut_T_1) @[NeuronEvaluator.scala 108:36]
    node _GEN_12 = mux(io_refracIndi, _GEN_11, _io_dataOut_T_2) @[NeuronEvaluator.scala 101:27 108:20]
    node _GEN_13 = mux(_T_10, _GEN_12, io_dataIn) @[Conditional.scala 39:67 NeuronEvaluator.scala 33:14]
    node _GEN_14 = mux(_T_8, _GEN_10, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_15 = mux(_T_7, io_dataIn, _GEN_14) @[Conditional.scala 40:58 NeuronEvaluator.scala 91:18]
    node _io_refracIndi_T = eq(refracRegNext, asSInt(UInt<1>("h0"))) @[NeuronEvaluator.scala 113:34]
    io_dataOut <= _GEN_15
    io_spikeIndi <= spikeIndiReg @[NeuronEvaluator.scala 114:17]
    io_refracIndi <= _io_refracIndi_T @[NeuronEvaluator.scala 113:17]
    membPotReg <= mux(reset, asSInt(UInt<17>("h0")), _GEN_0) @[Reg.scala 27:{20,20}]
    refracCntReg <= _GEN_1
    spikeIndiReg <= mux(reset, UInt<1>("h0"), _GEN_2) @[Reg.scala 27:{20,20}]

  module EvaluationMemory :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<1>("h0")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_1 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<1>("h1")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_2 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<2>("h2")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_3 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<2>("h3")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_4 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<3>("h4")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_5 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<3>("h5")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_6 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<3>("h6")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_7 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h2"), UInt<3>("h7")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module Neurons :
    input clock : Clock
    input reset : UInt<1>
    output io_done : UInt<1>
    input io_newTS : UInt<1>
    output io_inOut : UInt<1>
    input io_spikeCnt : UInt<10>
    output io_aAddr : UInt<10>
    output io_aEna : UInt<1>
    input io_aData : UInt<10>
    output io_n : UInt<5>
    output io_spikes_0 : UInt<1>
    output io_spikes_1 : UInt<1>
    output io_spikes_2 : UInt<1>
    output io_spikes_3 : UInt<1>
    output io_spikes_4 : UInt<1>
    output io_spikes_5 : UInt<1>
    output io_spikes_6 : UInt<1>
    output io_spikes_7 : UInt<1>

    inst controlUnit of ControlUnit @[Neurons.scala 22:27]
    inst evalUnits_0 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_1 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_2 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_3 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_4 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_5 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_6 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_7 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalMems_0 of EvaluationMemory @[Neurons.scala 24:56]
    inst evalMems_1 of EvaluationMemory_1 @[Neurons.scala 24:56]
    inst evalMems_2 of EvaluationMemory_2 @[Neurons.scala 24:56]
    inst evalMems_3 of EvaluationMemory_3 @[Neurons.scala 24:56]
    inst evalMems_4 of EvaluationMemory_4 @[Neurons.scala 24:56]
    inst evalMems_5 of EvaluationMemory_5 @[Neurons.scala 24:56]
    inst evalMems_6 of EvaluationMemory_6 @[Neurons.scala 24:56]
    inst evalMems_7 of EvaluationMemory_7 @[Neurons.scala 24:56]
    io_done <= controlUnit.io_done @[Neurons.scala 33:11]
    io_inOut <= controlUnit.io_inOut @[Neurons.scala 26:27]
    io_aAddr <= controlUnit.io_aAddr @[Neurons.scala 28:27]
    io_aEna <= controlUnit.io_aEna @[Neurons.scala 29:27]
    io_n <= controlUnit.io_n @[Neurons.scala 31:27]
    io_spikes_0 <= controlUnit.io_spikes_0 @[Neurons.scala 37:18]
    io_spikes_1 <= controlUnit.io_spikes_1 @[Neurons.scala 37:18]
    io_spikes_2 <= controlUnit.io_spikes_2 @[Neurons.scala 37:18]
    io_spikes_3 <= controlUnit.io_spikes_3 @[Neurons.scala 37:18]
    io_spikes_4 <= controlUnit.io_spikes_4 @[Neurons.scala 37:18]
    io_spikes_5 <= controlUnit.io_spikes_5 @[Neurons.scala 37:18]
    io_spikes_6 <= controlUnit.io_spikes_6 @[Neurons.scala 37:18]
    io_spikes_7 <= controlUnit.io_spikes_7 @[Neurons.scala 37:18]
    controlUnit.clock <= clock
    controlUnit.reset <= reset
    controlUnit.io_newTS <= io_newTS @[Neurons.scala 34:24]
    controlUnit.io_spikeIndi_0 <= evalUnits_0.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_1 <= evalUnits_1.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_2 <= evalUnits_2.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_3 <= evalUnits_3.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_4 <= evalUnits_4.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_5 <= evalUnits_5.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_6 <= evalUnits_6.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_7 <= evalUnits_7.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_refracIndi_0 <= evalUnits_0.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_1 <= evalUnits_1.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_2 <= evalUnits_2.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_3 <= evalUnits_3.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_4 <= evalUnits_4.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_5 <= evalUnits_5.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_6 <= evalUnits_6.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_7 <= evalUnits_7.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_spikeCnt <= io_spikeCnt @[Neurons.scala 27:27]
    controlUnit.io_aData <= io_aData @[Neurons.scala 30:27]
    evalUnits_0.clock <= clock
    evalUnits_0.reset <= reset
    evalUnits_0.io_dataIn <= evalMems_0.io_readData @[Neurons.scala 39:43]
    evalUnits_0.io_cntrSels_potSel <= controlUnit.io_cntrSels_0_potSel @[Neurons.scala 43:43]
    evalUnits_0.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_0_spikeSel @[Neurons.scala 44:43]
    evalUnits_0.io_cntrSels_refracSel <= controlUnit.io_cntrSels_0_refracSel @[Neurons.scala 45:43]
    evalUnits_0.io_cntrSels_decaySel <= controlUnit.io_cntrSels_0_decaySel @[Neurons.scala 47:43]
    evalUnits_0.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_0_writeDataSel @[Neurons.scala 46:43]
    evalUnits_0.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_1.clock <= clock
    evalUnits_1.reset <= reset
    evalUnits_1.io_dataIn <= evalMems_1.io_readData @[Neurons.scala 39:43]
    evalUnits_1.io_cntrSels_potSel <= controlUnit.io_cntrSels_1_potSel @[Neurons.scala 43:43]
    evalUnits_1.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_1_spikeSel @[Neurons.scala 44:43]
    evalUnits_1.io_cntrSels_refracSel <= controlUnit.io_cntrSels_1_refracSel @[Neurons.scala 45:43]
    evalUnits_1.io_cntrSels_decaySel <= controlUnit.io_cntrSels_1_decaySel @[Neurons.scala 47:43]
    evalUnits_1.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_1_writeDataSel @[Neurons.scala 46:43]
    evalUnits_1.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_2.clock <= clock
    evalUnits_2.reset <= reset
    evalUnits_2.io_dataIn <= evalMems_2.io_readData @[Neurons.scala 39:43]
    evalUnits_2.io_cntrSels_potSel <= controlUnit.io_cntrSels_2_potSel @[Neurons.scala 43:43]
    evalUnits_2.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_2_spikeSel @[Neurons.scala 44:43]
    evalUnits_2.io_cntrSels_refracSel <= controlUnit.io_cntrSels_2_refracSel @[Neurons.scala 45:43]
    evalUnits_2.io_cntrSels_decaySel <= controlUnit.io_cntrSels_2_decaySel @[Neurons.scala 47:43]
    evalUnits_2.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_2_writeDataSel @[Neurons.scala 46:43]
    evalUnits_2.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_3.clock <= clock
    evalUnits_3.reset <= reset
    evalUnits_3.io_dataIn <= evalMems_3.io_readData @[Neurons.scala 39:43]
    evalUnits_3.io_cntrSels_potSel <= controlUnit.io_cntrSels_3_potSel @[Neurons.scala 43:43]
    evalUnits_3.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_3_spikeSel @[Neurons.scala 44:43]
    evalUnits_3.io_cntrSels_refracSel <= controlUnit.io_cntrSels_3_refracSel @[Neurons.scala 45:43]
    evalUnits_3.io_cntrSels_decaySel <= controlUnit.io_cntrSels_3_decaySel @[Neurons.scala 47:43]
    evalUnits_3.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_3_writeDataSel @[Neurons.scala 46:43]
    evalUnits_3.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_4.clock <= clock
    evalUnits_4.reset <= reset
    evalUnits_4.io_dataIn <= evalMems_4.io_readData @[Neurons.scala 39:43]
    evalUnits_4.io_cntrSels_potSel <= controlUnit.io_cntrSels_4_potSel @[Neurons.scala 43:43]
    evalUnits_4.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_4_spikeSel @[Neurons.scala 44:43]
    evalUnits_4.io_cntrSels_refracSel <= controlUnit.io_cntrSels_4_refracSel @[Neurons.scala 45:43]
    evalUnits_4.io_cntrSels_decaySel <= controlUnit.io_cntrSels_4_decaySel @[Neurons.scala 47:43]
    evalUnits_4.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_4_writeDataSel @[Neurons.scala 46:43]
    evalUnits_4.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_5.clock <= clock
    evalUnits_5.reset <= reset
    evalUnits_5.io_dataIn <= evalMems_5.io_readData @[Neurons.scala 39:43]
    evalUnits_5.io_cntrSels_potSel <= controlUnit.io_cntrSels_5_potSel @[Neurons.scala 43:43]
    evalUnits_5.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_5_spikeSel @[Neurons.scala 44:43]
    evalUnits_5.io_cntrSels_refracSel <= controlUnit.io_cntrSels_5_refracSel @[Neurons.scala 45:43]
    evalUnits_5.io_cntrSels_decaySel <= controlUnit.io_cntrSels_5_decaySel @[Neurons.scala 47:43]
    evalUnits_5.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_5_writeDataSel @[Neurons.scala 46:43]
    evalUnits_5.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_6.clock <= clock
    evalUnits_6.reset <= reset
    evalUnits_6.io_dataIn <= evalMems_6.io_readData @[Neurons.scala 39:43]
    evalUnits_6.io_cntrSels_potSel <= controlUnit.io_cntrSels_6_potSel @[Neurons.scala 43:43]
    evalUnits_6.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_6_spikeSel @[Neurons.scala 44:43]
    evalUnits_6.io_cntrSels_refracSel <= controlUnit.io_cntrSels_6_refracSel @[Neurons.scala 45:43]
    evalUnits_6.io_cntrSels_decaySel <= controlUnit.io_cntrSels_6_decaySel @[Neurons.scala 47:43]
    evalUnits_6.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_6_writeDataSel @[Neurons.scala 46:43]
    evalUnits_6.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_7.clock <= clock
    evalUnits_7.reset <= reset
    evalUnits_7.io_dataIn <= evalMems_7.io_readData @[Neurons.scala 39:43]
    evalUnits_7.io_cntrSels_potSel <= controlUnit.io_cntrSels_7_potSel @[Neurons.scala 43:43]
    evalUnits_7.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_7_spikeSel @[Neurons.scala 44:43]
    evalUnits_7.io_cntrSels_refracSel <= controlUnit.io_cntrSels_7_refracSel @[Neurons.scala 45:43]
    evalUnits_7.io_cntrSels_decaySel <= controlUnit.io_cntrSels_7_decaySel @[Neurons.scala 47:43]
    evalUnits_7.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_7_writeDataSel @[Neurons.scala 46:43]
    evalUnits_7.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalMems_0.clock <= clock
    evalMems_0.reset <= reset
    evalMems_0.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_0.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_0.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_0.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_0.io_writeData <= evalUnits_0.io_dataOut @[Neurons.scala 40:43]
    evalMems_1.clock <= clock
    evalMems_1.reset <= reset
    evalMems_1.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_1.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_1.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_1.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_1.io_writeData <= evalUnits_1.io_dataOut @[Neurons.scala 40:43]
    evalMems_2.clock <= clock
    evalMems_2.reset <= reset
    evalMems_2.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_2.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_2.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_2.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_2.io_writeData <= evalUnits_2.io_dataOut @[Neurons.scala 40:43]
    evalMems_3.clock <= clock
    evalMems_3.reset <= reset
    evalMems_3.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_3.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_3.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_3.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_3.io_writeData <= evalUnits_3.io_dataOut @[Neurons.scala 40:43]
    evalMems_4.clock <= clock
    evalMems_4.reset <= reset
    evalMems_4.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_4.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_4.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_4.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_4.io_writeData <= evalUnits_4.io_dataOut @[Neurons.scala 40:43]
    evalMems_5.clock <= clock
    evalMems_5.reset <= reset
    evalMems_5.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_5.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_5.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_5.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_5.io_writeData <= evalUnits_5.io_dataOut @[Neurons.scala 40:43]
    evalMems_6.clock <= clock
    evalMems_6.reset <= reset
    evalMems_6.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_6.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_6.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_6.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_6.io_writeData <= evalUnits_6.io_dataOut @[Neurons.scala 40:43]
    evalMems_7.clock <= clock
    evalMems_7.reset <= reset
    evalMems_7.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_7.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_7.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_7.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_7.io_writeData <= evalUnits_7.io_dataOut @[Neurons.scala 40:43]

  module NeuronCore :
    input clock : Clock
    input reset : UInt<1>
    output io_pmClkEn : UInt<1>
    input io_newTS : UInt<1>
    input io_grant : UInt<1>
    output io_req : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>

    inst interface of BusInterface_2 @[NeuronCore.scala 19:26]
    inst axonSystem of AxonSystem @[NeuronCore.scala 20:26]
    inst spikeTrans of TransmissionSystem_2 @[NeuronCore.scala 21:26]
    inst neurons of Neurons @[NeuronCore.scala 22:26]
    node _io_pmClkEn_T = eq(neurons.io_done, UInt<1>("h0")) @[NeuronCore.scala 43:17]
    node _io_pmClkEn_T_1 = or(_io_pmClkEn_T, interface.io_reqOut) @[NeuronCore.scala 43:34]
    io_pmClkEn <= _io_pmClkEn_T_1 @[NeuronCore.scala 43:14]
    io_req <= interface.io_reqOut @[NeuronCore.scala 25:27]
    io_tx <= interface.io_tx @[NeuronCore.scala 26:27]
    interface.clock <= clock
    interface.reset <= reset
    interface.io_grant <= io_grant @[NeuronCore.scala 24:27]
    interface.io_rx <= io_rx @[NeuronCore.scala 27:27]
    interface.io_spikeID <= spikeTrans.io_data @[NeuronCore.scala 30:27]
    interface.io_reqIn <= spikeTrans.io_valid @[NeuronCore.scala 32:27]
    axonSystem.clock <= clock
    axonSystem.reset <= reset
    axonSystem.io_axonIn <= interface.io_axonID @[NeuronCore.scala 28:27]
    axonSystem.io_axonValid <= interface.io_valid @[NeuronCore.scala 29:27]
    axonSystem.io_inOut <= neurons.io_inOut @[NeuronCore.scala 34:27]
    axonSystem.io_rAddr <= neurons.io_aAddr @[NeuronCore.scala 36:27]
    axonSystem.io_rEna <= neurons.io_aEna @[NeuronCore.scala 37:27]
    spikeTrans.clock <= clock
    spikeTrans.reset <= reset
    spikeTrans.io_ready <= interface.io_ready @[NeuronCore.scala 31:27]
    spikeTrans.io_n <= neurons.io_n @[NeuronCore.scala 40:27]
    spikeTrans.io_spikes_0 <= neurons.io_spikes_0 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_1 <= neurons.io_spikes_1 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_2 <= neurons.io_spikes_2 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_3 <= neurons.io_spikes_3 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_4 <= neurons.io_spikes_4 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_5 <= neurons.io_spikes_5 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_6 <= neurons.io_spikes_6 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_7 <= neurons.io_spikes_7 @[NeuronCore.scala 41:27]
    neurons.clock <= clock
    neurons.reset <= reset
    neurons.io_newTS <= io_newTS @[NeuronCore.scala 44:20]
    neurons.io_spikeCnt <= axonSystem.io_spikeCnt @[NeuronCore.scala 35:27]
    neurons.io_aData <= axonSystem.io_rData @[NeuronCore.scala 38:27]

  module BusInterface_3 :
    input clock : Clock
    input reset : UInt<1>
    input io_grant : UInt<1>
    output io_reqOut : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>
    output io_axonID : UInt<10>
    output io_valid : UInt<1>
    input io_spikeID : UInt<11>
    output io_ready : UInt<1>
    input io_reqIn : UInt<1>

    node _io_tx_T = mux(io_grant, io_spikeID, UInt<1>("h0")) @[BusInterface.scala 31:15]
    node _io_reqOut_T = not(io_grant) @[BusInterface.scala 32:28]
    node _io_reqOut_T_1 = and(io_reqIn, _io_reqOut_T) @[BusInterface.scala 32:25]
    reg axonIDLSBReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), axonIDLSBReg) @[BusInterface.scala 36:29]
    node _axonIDLSBReg_T = bits(io_rx, 7, 0) @[BusInterface.scala 37:24]
    reg synROMReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), synROMReg) @[BusInterface.scala 39:27]
    node _synROMReg_T = orr(io_rx) @[BusInterface.scala 40:26]
    node _synROMReg_T_1 = bits(io_rx, 10, 8) @[BusInterface.scala 40:46]
    node filterROM_0 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_0 = validif(eq(UInt<1>("h0"), _synROMReg_T_1), filterROM_0) @[BusInterface.scala 40:{19,19}]
    node filterROM_1 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_1 = mux(eq(UInt<1>("h1"), _synROMReg_T_1), filterROM_1, _GEN_0) @[BusInterface.scala 40:{19,19}]
    node filterROM_2 = UInt<3>("h4") @[BusInterface.scala 28:{27,27}]
    node _GEN_2 = mux(eq(UInt<2>("h2"), _synROMReg_T_1), filterROM_2, _GEN_1) @[BusInterface.scala 40:{19,19}]
    node filterROM_3 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_3 = mux(eq(UInt<2>("h3"), _synROMReg_T_1), filterROM_3, _GEN_2) @[BusInterface.scala 40:{19,19}]
    node filterROM_4 = UInt<3>("h0") @[BusInterface.scala 28:{27,27}]
    node _GEN_4 = mux(eq(UInt<3>("h4"), _synROMReg_T_1), filterROM_4, _GEN_3) @[BusInterface.scala 40:{19,19}]
    node _filterROM_synROMReg_T_1 = _GEN_4 @[BusInterface.scala 40:19]
    node _synROMReg_T_2 = mux(_synROMReg_T, _filterROM_synROMReg_T_1, UInt<1>("h0")) @[BusInterface.scala 40:19]
    node _io_valid_T = bits(synROMReg, 2, 2) @[BusInterface.scala 42:25]
    node _io_axonID_T = bits(synROMReg, 1, 0) @[BusInterface.scala 43:25]
    node _io_axonID_T_1 = cat(_io_axonID_T, axonIDLSBReg) @[BusInterface.scala 43:47]
    io_reqOut <= _io_reqOut_T_1 @[BusInterface.scala 32:13]
    io_tx <= _io_tx_T @[BusInterface.scala 31:9]
    io_axonID <= _io_axonID_T_1 @[BusInterface.scala 43:13]
    io_valid <= _io_valid_T @[BusInterface.scala 42:13]
    io_ready <= io_grant @[BusInterface.scala 33:13]
    axonIDLSBReg <= mux(reset, UInt<8>("h0"), _axonIDLSBReg_T) @[BusInterface.scala 36:{29,29} 37:16]
    synROMReg <= mux(reset, UInt<3>("h0"), _synROMReg_T_2) @[BusInterface.scala 39:{27,27} 40:13]

  module TransmissionSystem_3 :
    input clock : Clock
    input reset : UInt<1>
    output io_data : UInt<11>
    input io_ready : UInt<1>
    output io_valid : UInt<1>
    input io_n : UInt<5>
    input io_spikes_0 : UInt<1>
    input io_spikes_1 : UInt<1>
    input io_spikes_2 : UInt<1>
    input io_spikes_3 : UInt<1>
    input io_spikes_4 : UInt<1>
    input io_spikes_5 : UInt<1>
    input io_spikes_6 : UInt<1>
    input io_spikes_7 : UInt<1>

    inst spikeEncoder of PriorityMaskRstEncoder @[TransmissionSystem.scala 22:28]
    reg spikeRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_0) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_1) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_2) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_3) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_4) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_5) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_6) @[TransmissionSystem.scala 18:29]
    reg spikeRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), spikeRegs_7) @[TransmissionSystem.scala 18:29]
    reg neuronIdMSB_0 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_0) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_1 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_1) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_2 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_2) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_3 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_3) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_4 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_4) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_5 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_5) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_6 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_6) @[TransmissionSystem.scala 19:29]
    reg neuronIdMSB_7 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), neuronIdMSB_7) @[TransmissionSystem.scala 19:29]
    reg maskRegs_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_0) @[TransmissionSystem.scala 20:29]
    reg maskRegs_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_1) @[TransmissionSystem.scala 20:29]
    reg maskRegs_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_2) @[TransmissionSystem.scala 20:29]
    reg maskRegs_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_3) @[TransmissionSystem.scala 20:29]
    reg maskRegs_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_4) @[TransmissionSystem.scala 20:29]
    reg maskRegs_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_5) @[TransmissionSystem.scala 20:29]
    reg maskRegs_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_6) @[TransmissionSystem.scala 20:29]
    reg maskRegs_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maskRegs_7) @[TransmissionSystem.scala 20:29]
    node _encoderReqs_0_T = and(maskRegs_0, spikeRegs_0) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_0_T = and(spikeEncoder.io_rst_0, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_0_T_1 = not(_rstReadySel_0_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_0 = _rstReadySel_0_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_0_T = and(rstReadySel_0, spikeRegs_0) @[TransmissionSystem.scala 36:38]
    node _T = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_0 = mux(_T, UInt<1>("h1"), maskRegs_0) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_1 = mux(io_ready, spikeEncoder.io_mask_0, _GEN_0) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_0 = _spikeUpdate_0_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_1 = not(spikeUpdate_0) @[TransmissionSystem.scala 44:10]
    node _GEN_2 = mux(_T_1, io_n, neuronIdMSB_0) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_3 = mux(_T_1, io_spikes_0, spikeRegs_0) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_2 = eq(UInt<1>("h0"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T = cat(UInt<3>("h3"), neuronIdMSB_0) @[TransmissionSystem.scala 50:44]
    node _io_data_T_1 = cat(_io_data_T, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_4 = mux(_T_2, _io_data_T_1, UInt<1>("h0")) @[TransmissionSystem.scala 28:12 49:41 50:15]
    node _encoderReqs_1_T = and(maskRegs_1, spikeRegs_1) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_1_T = and(spikeEncoder.io_rst_1, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_1_T_1 = not(_rstReadySel_1_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_1 = _rstReadySel_1_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_1_T = and(rstReadySel_1, spikeRegs_1) @[TransmissionSystem.scala 36:38]
    node _T_3 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_5 = mux(_T_3, UInt<1>("h1"), maskRegs_1) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_6 = mux(io_ready, spikeEncoder.io_mask_1, _GEN_5) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_1 = _spikeUpdate_1_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_4 = not(spikeUpdate_1) @[TransmissionSystem.scala 44:10]
    node _GEN_7 = mux(_T_4, io_n, neuronIdMSB_1) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_8 = mux(_T_4, io_spikes_1, spikeRegs_1) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_5 = eq(UInt<1>("h1"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_2 = cat(UInt<3>("h3"), neuronIdMSB_1) @[TransmissionSystem.scala 50:44]
    node _io_data_T_3 = cat(_io_data_T_2, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_9 = mux(_T_5, _io_data_T_3, _GEN_4) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_2_T = and(maskRegs_2, spikeRegs_2) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_2_T = and(spikeEncoder.io_rst_2, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_2_T_1 = not(_rstReadySel_2_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_2 = _rstReadySel_2_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_2_T = and(rstReadySel_2, spikeRegs_2) @[TransmissionSystem.scala 36:38]
    node _T_6 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_10 = mux(_T_6, UInt<1>("h1"), maskRegs_2) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_11 = mux(io_ready, spikeEncoder.io_mask_2, _GEN_10) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_2 = _spikeUpdate_2_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_7 = not(spikeUpdate_2) @[TransmissionSystem.scala 44:10]
    node _GEN_12 = mux(_T_7, io_n, neuronIdMSB_2) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_13 = mux(_T_7, io_spikes_2, spikeRegs_2) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_8 = eq(UInt<2>("h2"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_4 = cat(UInt<3>("h3"), neuronIdMSB_2) @[TransmissionSystem.scala 50:44]
    node _io_data_T_5 = cat(_io_data_T_4, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_14 = mux(_T_8, _io_data_T_5, _GEN_9) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_3_T = and(maskRegs_3, spikeRegs_3) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_3_T = and(spikeEncoder.io_rst_3, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_3_T_1 = not(_rstReadySel_3_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_3 = _rstReadySel_3_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_3_T = and(rstReadySel_3, spikeRegs_3) @[TransmissionSystem.scala 36:38]
    node _T_9 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_15 = mux(_T_9, UInt<1>("h1"), maskRegs_3) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_16 = mux(io_ready, spikeEncoder.io_mask_3, _GEN_15) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_3 = _spikeUpdate_3_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_10 = not(spikeUpdate_3) @[TransmissionSystem.scala 44:10]
    node _GEN_17 = mux(_T_10, io_n, neuronIdMSB_3) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_18 = mux(_T_10, io_spikes_3, spikeRegs_3) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_11 = eq(UInt<2>("h3"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_6 = cat(UInt<3>("h3"), neuronIdMSB_3) @[TransmissionSystem.scala 50:44]
    node _io_data_T_7 = cat(_io_data_T_6, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_19 = mux(_T_11, _io_data_T_7, _GEN_14) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_4_T = and(maskRegs_4, spikeRegs_4) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_4_T = and(spikeEncoder.io_rst_4, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_4_T_1 = not(_rstReadySel_4_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_4 = _rstReadySel_4_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_4_T = and(rstReadySel_4, spikeRegs_4) @[TransmissionSystem.scala 36:38]
    node _T_12 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_20 = mux(_T_12, UInt<1>("h1"), maskRegs_4) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_21 = mux(io_ready, spikeEncoder.io_mask_4, _GEN_20) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_4 = _spikeUpdate_4_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_13 = not(spikeUpdate_4) @[TransmissionSystem.scala 44:10]
    node _GEN_22 = mux(_T_13, io_n, neuronIdMSB_4) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_23 = mux(_T_13, io_spikes_4, spikeRegs_4) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_14 = eq(UInt<3>("h4"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_8 = cat(UInt<3>("h3"), neuronIdMSB_4) @[TransmissionSystem.scala 50:44]
    node _io_data_T_9 = cat(_io_data_T_8, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_24 = mux(_T_14, _io_data_T_9, _GEN_19) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_5_T = and(maskRegs_5, spikeRegs_5) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_5_T = and(spikeEncoder.io_rst_5, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_5_T_1 = not(_rstReadySel_5_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_5 = _rstReadySel_5_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_5_T = and(rstReadySel_5, spikeRegs_5) @[TransmissionSystem.scala 36:38]
    node _T_15 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_25 = mux(_T_15, UInt<1>("h1"), maskRegs_5) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_26 = mux(io_ready, spikeEncoder.io_mask_5, _GEN_25) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_5 = _spikeUpdate_5_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_16 = not(spikeUpdate_5) @[TransmissionSystem.scala 44:10]
    node _GEN_27 = mux(_T_16, io_n, neuronIdMSB_5) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_28 = mux(_T_16, io_spikes_5, spikeRegs_5) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_17 = eq(UInt<3>("h5"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_10 = cat(UInt<3>("h3"), neuronIdMSB_5) @[TransmissionSystem.scala 50:44]
    node _io_data_T_11 = cat(_io_data_T_10, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_29 = mux(_T_17, _io_data_T_11, _GEN_24) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_6_T = and(maskRegs_6, spikeRegs_6) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_6_T = and(spikeEncoder.io_rst_6, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_6_T_1 = not(_rstReadySel_6_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_6 = _rstReadySel_6_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_6_T = and(rstReadySel_6, spikeRegs_6) @[TransmissionSystem.scala 36:38]
    node _T_18 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_30 = mux(_T_18, UInt<1>("h1"), maskRegs_6) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_31 = mux(io_ready, spikeEncoder.io_mask_6, _GEN_30) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_6 = _spikeUpdate_6_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_19 = not(spikeUpdate_6) @[TransmissionSystem.scala 44:10]
    node _GEN_32 = mux(_T_19, io_n, neuronIdMSB_6) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_33 = mux(_T_19, io_spikes_6, spikeRegs_6) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_20 = eq(UInt<3>("h6"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_12 = cat(UInt<3>("h3"), neuronIdMSB_6) @[TransmissionSystem.scala 50:44]
    node _io_data_T_13 = cat(_io_data_T_12, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_34 = mux(_T_20, _io_data_T_13, _GEN_29) @[TransmissionSystem.scala 49:41 50:15]
    node _encoderReqs_7_T = and(maskRegs_7, spikeRegs_7) @[TransmissionSystem.scala 33:35]
    node _rstReadySel_7_T = and(spikeEncoder.io_rst_7, io_ready) @[TransmissionSystem.scala 35:48]
    node _rstReadySel_7_T_1 = not(_rstReadySel_7_T) @[TransmissionSystem.scala 35:23]
    node rstReadySel_7 = _rstReadySel_7_T_1 @[TransmissionSystem.scala 24:26 35:20]
    node _spikeUpdate_7_T = and(rstReadySel_7, spikeRegs_7) @[TransmissionSystem.scala 36:38]
    node _T_21 = eq(spikeEncoder.io_valid, UInt<1>("h0")) @[TransmissionSystem.scala 40:16]
    node _GEN_35 = mux(_T_21, UInt<1>("h1"), maskRegs_7) @[TransmissionSystem.scala 40:40 41:19 20:29]
    node _GEN_36 = mux(io_ready, spikeEncoder.io_mask_7, _GEN_35) @[TransmissionSystem.scala 38:20 39:19]
    node spikeUpdate_7 = _spikeUpdate_7_T @[TransmissionSystem.scala 25:26 36:20]
    node _T_22 = not(spikeUpdate_7) @[TransmissionSystem.scala 44:10]
    node _GEN_37 = mux(_T_22, io_n, neuronIdMSB_7) @[TransmissionSystem.scala 44:27 45:22 19:29]
    node _GEN_38 = mux(_T_22, io_spikes_7, spikeRegs_7) @[TransmissionSystem.scala 44:27 46:20 18:29]
    node _T_23 = eq(UInt<3>("h7"), spikeEncoder.io_value) @[TransmissionSystem.scala 49:14]
    node _io_data_T_14 = cat(UInt<3>("h3"), neuronIdMSB_7) @[TransmissionSystem.scala 50:44]
    node _io_data_T_15 = cat(_io_data_T_14, spikeEncoder.io_value) @[TransmissionSystem.scala 50:62]
    node _GEN_39 = mux(_T_23, _io_data_T_15, _GEN_34) @[TransmissionSystem.scala 49:41 50:15]
    node _spikeRegs_WIRE_0 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_1 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_2 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_3 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_4 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_5 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_6 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _spikeRegs_WIRE_7 = UInt<1>("h0") @[TransmissionSystem.scala 18:{37,37}]
    node _neuronIdMSB_WIRE_0 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_1 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_2 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_3 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_4 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_5 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_6 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _neuronIdMSB_WIRE_7 = UInt<5>("h0") @[TransmissionSystem.scala 19:{37,37}]
    node _maskRegs_WIRE_0 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_1 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_2 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_3 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_4 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_5 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_6 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node _maskRegs_WIRE_7 = UInt<1>("h1") @[TransmissionSystem.scala 20:{37,37}]
    node encoderReqs_0 = _encoderReqs_0_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_1 = _encoderReqs_1_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_2 = _encoderReqs_2_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_3 = _encoderReqs_3_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_4 = _encoderReqs_4_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_5 = _encoderReqs_5_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_6 = _encoderReqs_6_T @[TransmissionSystem.scala 23:26 33:20]
    node encoderReqs_7 = _encoderReqs_7_T @[TransmissionSystem.scala 23:26 33:20]
    io_data <= _GEN_39
    io_valid <= spikeEncoder.io_valid @[TransmissionSystem.scala 29:12]
    spikeRegs_0 <= mux(reset, _spikeRegs_WIRE_0, _GEN_3) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_1 <= mux(reset, _spikeRegs_WIRE_1, _GEN_8) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_2 <= mux(reset, _spikeRegs_WIRE_2, _GEN_13) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_3 <= mux(reset, _spikeRegs_WIRE_3, _GEN_18) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_4 <= mux(reset, _spikeRegs_WIRE_4, _GEN_23) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_5 <= mux(reset, _spikeRegs_WIRE_5, _GEN_28) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_6 <= mux(reset, _spikeRegs_WIRE_6, _GEN_33) @[TransmissionSystem.scala 18:{29,29}]
    spikeRegs_7 <= mux(reset, _spikeRegs_WIRE_7, _GEN_38) @[TransmissionSystem.scala 18:{29,29}]
    neuronIdMSB_0 <= mux(reset, _neuronIdMSB_WIRE_0, _GEN_2) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_1 <= mux(reset, _neuronIdMSB_WIRE_1, _GEN_7) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_2 <= mux(reset, _neuronIdMSB_WIRE_2, _GEN_12) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_3 <= mux(reset, _neuronIdMSB_WIRE_3, _GEN_17) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_4 <= mux(reset, _neuronIdMSB_WIRE_4, _GEN_22) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_5 <= mux(reset, _neuronIdMSB_WIRE_5, _GEN_27) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_6 <= mux(reset, _neuronIdMSB_WIRE_6, _GEN_32) @[TransmissionSystem.scala 19:{29,29}]
    neuronIdMSB_7 <= mux(reset, _neuronIdMSB_WIRE_7, _GEN_37) @[TransmissionSystem.scala 19:{29,29}]
    maskRegs_0 <= mux(reset, _maskRegs_WIRE_0, _GEN_1) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_1 <= mux(reset, _maskRegs_WIRE_1, _GEN_6) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_2 <= mux(reset, _maskRegs_WIRE_2, _GEN_11) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_3 <= mux(reset, _maskRegs_WIRE_3, _GEN_16) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_4 <= mux(reset, _maskRegs_WIRE_4, _GEN_21) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_5 <= mux(reset, _maskRegs_WIRE_5, _GEN_26) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_6 <= mux(reset, _maskRegs_WIRE_6, _GEN_31) @[TransmissionSystem.scala 20:{29,29}]
    maskRegs_7 <= mux(reset, _maskRegs_WIRE_7, _GEN_36) @[TransmissionSystem.scala 20:{29,29}]
    spikeEncoder.clock <= clock
    spikeEncoder.reset <= reset
    spikeEncoder.io_reqs_0 <= encoderReqs_0 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_1 <= encoderReqs_1 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_2 <= encoderReqs_2 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_3 <= encoderReqs_3 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_4 <= encoderReqs_4 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_5 <= encoderReqs_5 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_6 <= encoderReqs_6 @[TransmissionSystem.scala 30:24]
    spikeEncoder.io_reqs_7 <= encoderReqs_7 @[TransmissionSystem.scala 30:24]

  module EvaluationMemory_8 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<1>("h0")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_9 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<1>("h1")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_10 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<2>("h2")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_11 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<2>("h3")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_12 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<3>("h4")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_13 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<3>("h5")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_14 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<3>("h6")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module EvaluationMemory_15 :
    input clock : Clock
    input reset : UInt<1>
    input io_addr_sel : UInt<2>
    input io_addr_pos : UInt<15>
    input io_ena : UInt<1>
    input io_wr : UInt<1>
    output io_readData : SInt<17>
    input io_writeData : SInt<17>
    output io_nothing : UInt<6>

    mem constmem : @[EvaluationMemory.scala 24:29]
      data-type => UInt<5>
      depth => 4
      read-latency => 1
      write-latency => 1
      reader => constRead_MPORT
      read-under-write => undefined
    mem dynamem : @[EvaluationMemory.scala 25:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => dynaRead_MPORT
      writer => MPORT
      read-under-write => undefined
    mem btmem : @[EvaluationMemory.scala 26:29]
      data-type => SInt<17>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => btRead_MPORT
      read-under-write => undefined
    mem wghtmem : @[EvaluationMemory.scala 27:29]
      data-type => UInt<11>
      depth => 24576
      read-latency => 1
      write-latency => 1
      reader => wghtRead_MPORT
      writer => MPORT_1
      read-under-write => undefined
    node _io_nothing_T = cat(UInt<2>("h3"), UInt<3>("h7")) @[EvaluationMemory.scala 48:26]
    reg selPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), selPipe) @[Reg.scala 15:16]
    node _GEN_0 = mux(io_ena, io_addr_sel, selPipe) @[Reg.scala 15:16 16:{19,23}]
    node _addrPipe_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 52:40]
    reg addrPipe : UInt<2>, clock with :
      reset => (UInt<1>("h0"), addrPipe) @[Reg.scala 15:16]
    node _GEN_1 = mux(io_ena, _addrPipe_T, addrPipe) @[Reg.scala 15:16 16:{19,23}]
    node _T = eq(UInt<2>("h0"), io_addr_sel) @[Conditional.scala 37:30]
    node _constRead_T = bits(io_addr_pos, 1, 0) @[EvaluationMemory.scala 61:30]
    node _T_1 = eq(UInt<2>("h1"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_2 = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 65:18]
    node _dynaRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 67:30]
    node _GEN_2 = validif(io_wr, _T_2) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_3 = validif(io_wr, clock) @[EvaluationMemory.scala 64:21 65:18]
    node _GEN_4 = mux(io_wr, UInt<1>("h1"), UInt<1>("h0")) @[EvaluationMemory.scala 64:21 65:18 25:29]
    node _GEN_5 = validif(io_wr, UInt<1>("h1")) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_6 = validif(io_wr, io_writeData) @[EvaluationMemory.scala 64:21 65:32]
    node _GEN_7 = mux(io_wr, UInt<1>("h0"), UInt<1>("h1")) @[EvaluationMemory.scala 64:21 25:29 67:30]
    node _GEN_8 = validif(eq(io_wr, UInt<1>("h0")), _dynaRead_T) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_9 = validif(eq(io_wr, UInt<1>("h0")), clock) @[EvaluationMemory.scala 64:21 67:30]
    node _GEN_10 = validif(eq(io_wr, UInt<1>("h0")), dynamem.dynaRead_MPORT.data) @[EvaluationMemory.scala 64:21 67:20]
    node _T_3 = eq(UInt<2>("h2"), io_addr_sel) @[Conditional.scala 37:30]
    node _btRead_T = bits(io_addr_pos, 5, 0) @[EvaluationMemory.scala 71:24]
    node _T_4 = eq(UInt<2>("h3"), io_addr_sel) @[Conditional.scala 37:30]
    node _T_5 = bits(io_writeData, 10, 0) @[EvaluationMemory.scala 76:47]
    node _GEN_11 = validif(io_wr, io_addr_pos) @[EvaluationMemory.scala 75:21 76:18]
    node _GEN_12 = validif(io_wr, _T_5) @[EvaluationMemory.scala 75:21 76:32]
    node _GEN_13 = validif(eq(io_wr, UInt<1>("h0")), io_addr_pos) @[EvaluationMemory.scala 75:21 78:30]
    node _GEN_14 = validif(eq(io_wr, UInt<1>("h0")), wghtmem.wghtRead_MPORT.data) @[EvaluationMemory.scala 75:21 78:20]
    node _GEN_15 = validif(_T_4, _GEN_11) @[Conditional.scala 39:67]
    node _GEN_16 = validif(_T_4, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_17 = mux(_T_4, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_18 = validif(_T_4, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_19 = validif(_T_4, _GEN_12) @[Conditional.scala 39:67]
    node _GEN_20 = validif(_T_4, _GEN_13) @[Conditional.scala 39:67]
    node _GEN_21 = validif(_T_4, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_22 = mux(_T_4, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_23 = validif(_T_4, _GEN_14) @[Conditional.scala 39:67]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24 26:29]
    node _GEN_25 = validif(_T_3, _btRead_T) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_26 = validif(_T_3, clock) @[Conditional.scala 39:67 EvaluationMemory.scala 71:24]
    node _GEN_27 = validif(_T_3, btmem.btRead_MPORT.data) @[Conditional.scala 39:67 EvaluationMemory.scala 71:16]
    node _GEN_28 = validif(eq(_T_3, UInt<1>("h0")), _GEN_15) @[Conditional.scala 39:67]
    node _GEN_29 = validif(eq(_T_3, UInt<1>("h0")), _GEN_16) @[Conditional.scala 39:67]
    node _GEN_30 = mux(_T_3, UInt<1>("h0"), _GEN_17) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_31 = validif(eq(_T_3, UInt<1>("h0")), _GEN_18) @[Conditional.scala 39:67]
    node _GEN_32 = validif(eq(_T_3, UInt<1>("h0")), _GEN_19) @[Conditional.scala 39:67]
    node _GEN_33 = validif(eq(_T_3, UInt<1>("h0")), _GEN_20) @[Conditional.scala 39:67]
    node _GEN_34 = validif(eq(_T_3, UInt<1>("h0")), _GEN_21) @[Conditional.scala 39:67]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_36 = validif(eq(_T_3, UInt<1>("h0")), _GEN_23) @[Conditional.scala 39:67]
    node _GEN_37 = validif(_T_1, _GEN_2) @[Conditional.scala 39:67]
    node _GEN_38 = validif(_T_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_39 = mux(_T_1, _GEN_4, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_40 = validif(_T_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_41 = validif(_T_1, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_42 = mux(_T_1, _GEN_7, UInt<1>("h0")) @[Conditional.scala 39:67 EvaluationMemory.scala 25:29]
    node _GEN_43 = validif(_T_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_44 = validif(_T_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_45 = validif(_T_1, _GEN_10) @[Conditional.scala 39:67]
    node _GEN_46 = mux(_T_1, UInt<1>("h0"), _GEN_24) @[Conditional.scala 39:67 EvaluationMemory.scala 26:29]
    node _GEN_47 = validif(eq(_T_1, UInt<1>("h0")), _GEN_25) @[Conditional.scala 39:67]
    node _GEN_48 = validif(eq(_T_1, UInt<1>("h0")), _GEN_26) @[Conditional.scala 39:67]
    node _GEN_49 = validif(eq(_T_1, UInt<1>("h0")), _GEN_27) @[Conditional.scala 39:67]
    node _GEN_50 = validif(eq(_T_1, UInt<1>("h0")), _GEN_28) @[Conditional.scala 39:67]
    node _GEN_51 = validif(eq(_T_1, UInt<1>("h0")), _GEN_29) @[Conditional.scala 39:67]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_30) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_53 = validif(eq(_T_1, UInt<1>("h0")), _GEN_31) @[Conditional.scala 39:67]
    node _GEN_54 = validif(eq(_T_1, UInt<1>("h0")), _GEN_32) @[Conditional.scala 39:67]
    node _GEN_55 = validif(eq(_T_1, UInt<1>("h0")), _GEN_33) @[Conditional.scala 39:67]
    node _GEN_56 = validif(eq(_T_1, UInt<1>("h0")), _GEN_34) @[Conditional.scala 39:67]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_35) @[Conditional.scala 39:67 EvaluationMemory.scala 27:29]
    node _GEN_58 = validif(eq(_T_1, UInt<1>("h0")), _GEN_36) @[Conditional.scala 39:67]
    node _GEN_59 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 EvaluationMemory.scala 24:29 61:30]
    node _GEN_60 = validif(_T, _constRead_T) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_61 = validif(_T, clock) @[Conditional.scala 40:58 EvaluationMemory.scala 61:30]
    node _GEN_62 = validif(_T, constmem.constRead_MPORT.data) @[Conditional.scala 40:58 EvaluationMemory.scala 61:19]
    node _GEN_63 = validif(eq(_T, UInt<1>("h0")), _GEN_37) @[Conditional.scala 40:58]
    node _GEN_64 = validif(eq(_T, UInt<1>("h0")), _GEN_38) @[Conditional.scala 40:58]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_39) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_66 = validif(eq(_T, UInt<1>("h0")), _GEN_40) @[Conditional.scala 40:58]
    node _GEN_67 = validif(eq(_T, UInt<1>("h0")), _GEN_41) @[Conditional.scala 40:58]
    node _GEN_68 = mux(_T, UInt<1>("h0"), _GEN_42) @[Conditional.scala 40:58 EvaluationMemory.scala 25:29]
    node _GEN_69 = validif(eq(_T, UInt<1>("h0")), _GEN_43) @[Conditional.scala 40:58]
    node _GEN_70 = validif(eq(_T, UInt<1>("h0")), _GEN_44) @[Conditional.scala 40:58]
    node _GEN_71 = validif(eq(_T, UInt<1>("h0")), _GEN_45) @[Conditional.scala 40:58]
    node _GEN_72 = mux(_T, UInt<1>("h0"), _GEN_46) @[Conditional.scala 40:58 EvaluationMemory.scala 26:29]
    node _GEN_73 = validif(eq(_T, UInt<1>("h0")), _GEN_47) @[Conditional.scala 40:58]
    node _GEN_74 = validif(eq(_T, UInt<1>("h0")), _GEN_48) @[Conditional.scala 40:58]
    node _GEN_75 = validif(eq(_T, UInt<1>("h0")), _GEN_49) @[Conditional.scala 40:58]
    node _GEN_76 = validif(eq(_T, UInt<1>("h0")), _GEN_50) @[Conditional.scala 40:58]
    node _GEN_77 = validif(eq(_T, UInt<1>("h0")), _GEN_51) @[Conditional.scala 40:58]
    node _GEN_78 = mux(_T, UInt<1>("h0"), _GEN_52) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_79 = validif(eq(_T, UInt<1>("h0")), _GEN_53) @[Conditional.scala 40:58]
    node _GEN_80 = validif(eq(_T, UInt<1>("h0")), _GEN_54) @[Conditional.scala 40:58]
    node _GEN_81 = validif(eq(_T, UInt<1>("h0")), _GEN_55) @[Conditional.scala 40:58]
    node _GEN_82 = validif(eq(_T, UInt<1>("h0")), _GEN_56) @[Conditional.scala 40:58]
    node _GEN_83 = mux(_T, UInt<1>("h0"), _GEN_57) @[Conditional.scala 40:58 EvaluationMemory.scala 27:29]
    node _GEN_84 = validif(eq(_T, UInt<1>("h0")), _GEN_58) @[Conditional.scala 40:58]
    node _GEN_85 = mux(io_ena, _GEN_59, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 24:29]
    node _GEN_86 = validif(io_ena, _GEN_60) @[EvaluationMemory.scala 58:16]
    node _GEN_87 = validif(io_ena, _GEN_61) @[EvaluationMemory.scala 58:16]
    node _GEN_88 = validif(io_ena, _GEN_62) @[EvaluationMemory.scala 58:16]
    node _GEN_89 = validif(io_ena, _GEN_63) @[EvaluationMemory.scala 58:16]
    node _GEN_90 = validif(io_ena, _GEN_64) @[EvaluationMemory.scala 58:16]
    node _GEN_91 = mux(io_ena, _GEN_65, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_92 = validif(io_ena, _GEN_66) @[EvaluationMemory.scala 58:16]
    node _GEN_93 = validif(io_ena, _GEN_67) @[EvaluationMemory.scala 58:16]
    node _GEN_94 = mux(io_ena, _GEN_68, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 25:29]
    node _GEN_95 = validif(io_ena, _GEN_69) @[EvaluationMemory.scala 58:16]
    node _GEN_96 = validif(io_ena, _GEN_70) @[EvaluationMemory.scala 58:16]
    node _GEN_97 = validif(io_ena, _GEN_71) @[EvaluationMemory.scala 58:16]
    node _GEN_98 = mux(io_ena, _GEN_72, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 26:29]
    node _GEN_99 = validif(io_ena, _GEN_73) @[EvaluationMemory.scala 58:16]
    node _GEN_100 = validif(io_ena, _GEN_74) @[EvaluationMemory.scala 58:16]
    node _GEN_101 = validif(io_ena, _GEN_75) @[EvaluationMemory.scala 58:16]
    node _GEN_102 = validif(io_ena, _GEN_76) @[EvaluationMemory.scala 58:16]
    node _GEN_103 = validif(io_ena, _GEN_77) @[EvaluationMemory.scala 58:16]
    node _GEN_104 = mux(io_ena, _GEN_78, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_105 = validif(io_ena, _GEN_79) @[EvaluationMemory.scala 58:16]
    node _GEN_106 = validif(io_ena, _GEN_80) @[EvaluationMemory.scala 58:16]
    node _GEN_107 = validif(io_ena, _GEN_81) @[EvaluationMemory.scala 58:16]
    node _GEN_108 = validif(io_ena, _GEN_82) @[EvaluationMemory.scala 58:16]
    node _GEN_109 = mux(io_ena, _GEN_83, UInt<1>("h0")) @[EvaluationMemory.scala 58:16 27:29]
    node _GEN_110 = validif(io_ena, _GEN_84) @[EvaluationMemory.scala 58:16]
    node _T_6 = eq(UInt<2>("h0"), selPipe) @[Conditional.scala 37:30]
    node constRead = _GEN_88
    node _res_T = cat(constRead, UInt<10>("h0")) @[EvaluationMemory.scala 85:28]
    node _res_T_1 = asSInt(_res_T) @[EvaluationMemory.scala 85:42]
    node res = pad(_res_T_1, 17) @[EvaluationMemory.scala 85:52]
    node _oth_T = pad(constRead, 17) @[EvaluationMemory.scala 86:30]
    node oth = asSInt(_oth_T) @[EvaluationMemory.scala 86:45]
    node _memRead_T = orr(addrPipe) @[EvaluationMemory.scala 87:32]
    node _memRead_T_1 = eq(_memRead_T, UInt<1>("h0")) @[EvaluationMemory.scala 87:22]
    node _memRead_T_2 = mux(_memRead_T_1, res, oth) @[EvaluationMemory.scala 87:21]
    node _T_7 = eq(UInt<2>("h1"), selPipe) @[Conditional.scala 37:30]
    node _T_8 = eq(UInt<2>("h2"), selPipe) @[Conditional.scala 37:30]
    node _T_9 = eq(UInt<2>("h3"), selPipe) @[Conditional.scala 37:30]
    node wghtRead = _GEN_110
    node _res_T_2 = bits(wghtRead, 9, 0) @[EvaluationMemory.scala 97:26]
    node _res_T_3 = cat(_res_T_2, UInt<6>("h0")) @[EvaluationMemory.scala 97:51]
    node _res_T_4 = asSInt(_res_T_3) @[EvaluationMemory.scala 97:64]
    node res_1 = pad(_res_T_4, 17) @[EvaluationMemory.scala 97:74]
    node _oth_T_1 = pad(wghtRead, 17) @[EvaluationMemory.scala 98:29]
    node oth_1 = asSInt(_oth_T_1) @[EvaluationMemory.scala 98:44]
    node _memRead_T_3 = bits(wghtRead, 10, 10) @[EvaluationMemory.scala 99:30]
    node _memRead_T_4 = mux(_memRead_T_3, res_1, oth_1) @[EvaluationMemory.scala 99:21]
    node _GEN_111 = validif(_T_9, _memRead_T_4) @[Conditional.scala 39:67 EvaluationMemory.scala 99:15]
    node btRead = _GEN_101
    node _GEN_112 = mux(_T_8, btRead, _GEN_111) @[Conditional.scala 39:67 EvaluationMemory.scala 93:15]
    node dynaRead = _GEN_97
    node _GEN_113 = mux(_T_7, dynaRead, _GEN_112) @[Conditional.scala 39:67 EvaluationMemory.scala 90:15]
    node _GEN_114 = mux(_T_6, _memRead_T_2, _GEN_113) @[Conditional.scala 40:58 EvaluationMemory.scala 87:15]
    node memRead = _GEN_114
    io_readData <= memRead @[EvaluationMemory.scala 102:15]
    io_nothing <= _io_nothing_T @[EvaluationMemory.scala 48:14]
    constmem.constRead_MPORT.addr <= _GEN_86
    constmem.constRead_MPORT.en <= _GEN_85
    constmem.constRead_MPORT.clk <= _GEN_87
    dynamem.dynaRead_MPORT.addr <= _GEN_95
    dynamem.dynaRead_MPORT.en <= _GEN_94
    dynamem.dynaRead_MPORT.clk <= _GEN_96
    dynamem.MPORT.addr <= _GEN_89
    dynamem.MPORT.en <= _GEN_91
    dynamem.MPORT.clk <= _GEN_90
    dynamem.MPORT.data <= _GEN_93
    dynamem.MPORT.mask <= _GEN_92
    btmem.btRead_MPORT.addr <= _GEN_99
    btmem.btRead_MPORT.en <= _GEN_98
    btmem.btRead_MPORT.clk <= _GEN_100
    wghtmem.wghtRead_MPORT.addr <= _GEN_107
    wghtmem.wghtRead_MPORT.en <= _GEN_109
    wghtmem.wghtRead_MPORT.clk <= _GEN_108
    wghtmem.MPORT_1.addr <= _GEN_102
    wghtmem.MPORT_1.en <= _GEN_104
    wghtmem.MPORT_1.clk <= _GEN_103
    wghtmem.MPORT_1.data <= _GEN_106
    wghtmem.MPORT_1.mask <= _GEN_105
    selPipe <= _GEN_0
    addrPipe <= _GEN_1

  module Neurons_1 :
    input clock : Clock
    input reset : UInt<1>
    output io_done : UInt<1>
    input io_newTS : UInt<1>
    output io_inOut : UInt<1>
    input io_spikeCnt : UInt<10>
    output io_aAddr : UInt<10>
    output io_aEna : UInt<1>
    input io_aData : UInt<10>
    output io_n : UInt<5>
    output io_spikes_0 : UInt<1>
    output io_spikes_1 : UInt<1>
    output io_spikes_2 : UInt<1>
    output io_spikes_3 : UInt<1>
    output io_spikes_4 : UInt<1>
    output io_spikes_5 : UInt<1>
    output io_spikes_6 : UInt<1>
    output io_spikes_7 : UInt<1>

    inst controlUnit of ControlUnit @[Neurons.scala 22:27]
    inst evalUnits_0 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_1 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_2 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_3 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_4 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_5 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_6 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalUnits_7 of NeuronEvaluator @[Neurons.scala 23:56]
    inst evalMems_0 of EvaluationMemory_8 @[Neurons.scala 24:56]
    inst evalMems_1 of EvaluationMemory_9 @[Neurons.scala 24:56]
    inst evalMems_2 of EvaluationMemory_10 @[Neurons.scala 24:56]
    inst evalMems_3 of EvaluationMemory_11 @[Neurons.scala 24:56]
    inst evalMems_4 of EvaluationMemory_12 @[Neurons.scala 24:56]
    inst evalMems_5 of EvaluationMemory_13 @[Neurons.scala 24:56]
    inst evalMems_6 of EvaluationMemory_14 @[Neurons.scala 24:56]
    inst evalMems_7 of EvaluationMemory_15 @[Neurons.scala 24:56]
    io_done <= controlUnit.io_done @[Neurons.scala 33:11]
    io_inOut <= controlUnit.io_inOut @[Neurons.scala 26:27]
    io_aAddr <= controlUnit.io_aAddr @[Neurons.scala 28:27]
    io_aEna <= controlUnit.io_aEna @[Neurons.scala 29:27]
    io_n <= controlUnit.io_n @[Neurons.scala 31:27]
    io_spikes_0 <= controlUnit.io_spikes_0 @[Neurons.scala 37:18]
    io_spikes_1 <= controlUnit.io_spikes_1 @[Neurons.scala 37:18]
    io_spikes_2 <= controlUnit.io_spikes_2 @[Neurons.scala 37:18]
    io_spikes_3 <= controlUnit.io_spikes_3 @[Neurons.scala 37:18]
    io_spikes_4 <= controlUnit.io_spikes_4 @[Neurons.scala 37:18]
    io_spikes_5 <= controlUnit.io_spikes_5 @[Neurons.scala 37:18]
    io_spikes_6 <= controlUnit.io_spikes_6 @[Neurons.scala 37:18]
    io_spikes_7 <= controlUnit.io_spikes_7 @[Neurons.scala 37:18]
    controlUnit.clock <= clock
    controlUnit.reset <= reset
    controlUnit.io_newTS <= io_newTS @[Neurons.scala 34:24]
    controlUnit.io_spikeIndi_0 <= evalUnits_0.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_1 <= evalUnits_1.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_2 <= evalUnits_2.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_3 <= evalUnits_3.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_4 <= evalUnits_4.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_5 <= evalUnits_5.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_6 <= evalUnits_6.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_spikeIndi_7 <= evalUnits_7.io_spikeIndi @[Neurons.scala 41:43]
    controlUnit.io_refracIndi_0 <= evalUnits_0.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_1 <= evalUnits_1.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_2 <= evalUnits_2.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_3 <= evalUnits_3.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_4 <= evalUnits_4.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_5 <= evalUnits_5.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_6 <= evalUnits_6.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_refracIndi_7 <= evalUnits_7.io_refracIndi @[Neurons.scala 42:43]
    controlUnit.io_spikeCnt <= io_spikeCnt @[Neurons.scala 27:27]
    controlUnit.io_aData <= io_aData @[Neurons.scala 30:27]
    evalUnits_0.clock <= clock
    evalUnits_0.reset <= reset
    evalUnits_0.io_dataIn <= evalMems_0.io_readData @[Neurons.scala 39:43]
    evalUnits_0.io_cntrSels_potSel <= controlUnit.io_cntrSels_0_potSel @[Neurons.scala 43:43]
    evalUnits_0.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_0_spikeSel @[Neurons.scala 44:43]
    evalUnits_0.io_cntrSels_refracSel <= controlUnit.io_cntrSels_0_refracSel @[Neurons.scala 45:43]
    evalUnits_0.io_cntrSels_decaySel <= controlUnit.io_cntrSels_0_decaySel @[Neurons.scala 47:43]
    evalUnits_0.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_0_writeDataSel @[Neurons.scala 46:43]
    evalUnits_0.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_1.clock <= clock
    evalUnits_1.reset <= reset
    evalUnits_1.io_dataIn <= evalMems_1.io_readData @[Neurons.scala 39:43]
    evalUnits_1.io_cntrSels_potSel <= controlUnit.io_cntrSels_1_potSel @[Neurons.scala 43:43]
    evalUnits_1.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_1_spikeSel @[Neurons.scala 44:43]
    evalUnits_1.io_cntrSels_refracSel <= controlUnit.io_cntrSels_1_refracSel @[Neurons.scala 45:43]
    evalUnits_1.io_cntrSels_decaySel <= controlUnit.io_cntrSels_1_decaySel @[Neurons.scala 47:43]
    evalUnits_1.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_1_writeDataSel @[Neurons.scala 46:43]
    evalUnits_1.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_2.clock <= clock
    evalUnits_2.reset <= reset
    evalUnits_2.io_dataIn <= evalMems_2.io_readData @[Neurons.scala 39:43]
    evalUnits_2.io_cntrSels_potSel <= controlUnit.io_cntrSels_2_potSel @[Neurons.scala 43:43]
    evalUnits_2.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_2_spikeSel @[Neurons.scala 44:43]
    evalUnits_2.io_cntrSels_refracSel <= controlUnit.io_cntrSels_2_refracSel @[Neurons.scala 45:43]
    evalUnits_2.io_cntrSels_decaySel <= controlUnit.io_cntrSels_2_decaySel @[Neurons.scala 47:43]
    evalUnits_2.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_2_writeDataSel @[Neurons.scala 46:43]
    evalUnits_2.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_3.clock <= clock
    evalUnits_3.reset <= reset
    evalUnits_3.io_dataIn <= evalMems_3.io_readData @[Neurons.scala 39:43]
    evalUnits_3.io_cntrSels_potSel <= controlUnit.io_cntrSels_3_potSel @[Neurons.scala 43:43]
    evalUnits_3.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_3_spikeSel @[Neurons.scala 44:43]
    evalUnits_3.io_cntrSels_refracSel <= controlUnit.io_cntrSels_3_refracSel @[Neurons.scala 45:43]
    evalUnits_3.io_cntrSels_decaySel <= controlUnit.io_cntrSels_3_decaySel @[Neurons.scala 47:43]
    evalUnits_3.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_3_writeDataSel @[Neurons.scala 46:43]
    evalUnits_3.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_4.clock <= clock
    evalUnits_4.reset <= reset
    evalUnits_4.io_dataIn <= evalMems_4.io_readData @[Neurons.scala 39:43]
    evalUnits_4.io_cntrSels_potSel <= controlUnit.io_cntrSels_4_potSel @[Neurons.scala 43:43]
    evalUnits_4.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_4_spikeSel @[Neurons.scala 44:43]
    evalUnits_4.io_cntrSels_refracSel <= controlUnit.io_cntrSels_4_refracSel @[Neurons.scala 45:43]
    evalUnits_4.io_cntrSels_decaySel <= controlUnit.io_cntrSels_4_decaySel @[Neurons.scala 47:43]
    evalUnits_4.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_4_writeDataSel @[Neurons.scala 46:43]
    evalUnits_4.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_5.clock <= clock
    evalUnits_5.reset <= reset
    evalUnits_5.io_dataIn <= evalMems_5.io_readData @[Neurons.scala 39:43]
    evalUnits_5.io_cntrSels_potSel <= controlUnit.io_cntrSels_5_potSel @[Neurons.scala 43:43]
    evalUnits_5.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_5_spikeSel @[Neurons.scala 44:43]
    evalUnits_5.io_cntrSels_refracSel <= controlUnit.io_cntrSels_5_refracSel @[Neurons.scala 45:43]
    evalUnits_5.io_cntrSels_decaySel <= controlUnit.io_cntrSels_5_decaySel @[Neurons.scala 47:43]
    evalUnits_5.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_5_writeDataSel @[Neurons.scala 46:43]
    evalUnits_5.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_6.clock <= clock
    evalUnits_6.reset <= reset
    evalUnits_6.io_dataIn <= evalMems_6.io_readData @[Neurons.scala 39:43]
    evalUnits_6.io_cntrSels_potSel <= controlUnit.io_cntrSels_6_potSel @[Neurons.scala 43:43]
    evalUnits_6.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_6_spikeSel @[Neurons.scala 44:43]
    evalUnits_6.io_cntrSels_refracSel <= controlUnit.io_cntrSels_6_refracSel @[Neurons.scala 45:43]
    evalUnits_6.io_cntrSels_decaySel <= controlUnit.io_cntrSels_6_decaySel @[Neurons.scala 47:43]
    evalUnits_6.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_6_writeDataSel @[Neurons.scala 46:43]
    evalUnits_6.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalUnits_7.clock <= clock
    evalUnits_7.reset <= reset
    evalUnits_7.io_dataIn <= evalMems_7.io_readData @[Neurons.scala 39:43]
    evalUnits_7.io_cntrSels_potSel <= controlUnit.io_cntrSels_7_potSel @[Neurons.scala 43:43]
    evalUnits_7.io_cntrSels_spikeSel <= controlUnit.io_cntrSels_7_spikeSel @[Neurons.scala 44:43]
    evalUnits_7.io_cntrSels_refracSel <= controlUnit.io_cntrSels_7_refracSel @[Neurons.scala 45:43]
    evalUnits_7.io_cntrSels_decaySel <= controlUnit.io_cntrSels_7_decaySel @[Neurons.scala 47:43]
    evalUnits_7.io_cntrSels_writeDataSel <= controlUnit.io_cntrSels_7_writeDataSel @[Neurons.scala 46:43]
    evalUnits_7.io_evalEnable <= controlUnit.io_evalEnable @[Neurons.scala 48:43]
    evalMems_0.clock <= clock
    evalMems_0.reset <= reset
    evalMems_0.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_0.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_0.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_0.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_0.io_writeData <= evalUnits_0.io_dataOut @[Neurons.scala 40:43]
    evalMems_1.clock <= clock
    evalMems_1.reset <= reset
    evalMems_1.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_1.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_1.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_1.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_1.io_writeData <= evalUnits_1.io_dataOut @[Neurons.scala 40:43]
    evalMems_2.clock <= clock
    evalMems_2.reset <= reset
    evalMems_2.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_2.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_2.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_2.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_2.io_writeData <= evalUnits_2.io_dataOut @[Neurons.scala 40:43]
    evalMems_3.clock <= clock
    evalMems_3.reset <= reset
    evalMems_3.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_3.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_3.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_3.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_3.io_writeData <= evalUnits_3.io_dataOut @[Neurons.scala 40:43]
    evalMems_4.clock <= clock
    evalMems_4.reset <= reset
    evalMems_4.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_4.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_4.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_4.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_4.io_writeData <= evalUnits_4.io_dataOut @[Neurons.scala 40:43]
    evalMems_5.clock <= clock
    evalMems_5.reset <= reset
    evalMems_5.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_5.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_5.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_5.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_5.io_writeData <= evalUnits_5.io_dataOut @[Neurons.scala 40:43]
    evalMems_6.clock <= clock
    evalMems_6.reset <= reset
    evalMems_6.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_6.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_6.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_6.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_6.io_writeData <= evalUnits_6.io_dataOut @[Neurons.scala 40:43]
    evalMems_7.clock <= clock
    evalMems_7.reset <= reset
    evalMems_7.io_addr_sel <= controlUnit.io_addr_sel @[Neurons.scala 50:43]
    evalMems_7.io_addr_pos <= controlUnit.io_addr_pos @[Neurons.scala 50:43]
    evalMems_7.io_ena <= controlUnit.io_ena @[Neurons.scala 52:43]
    evalMems_7.io_wr <= controlUnit.io_wr @[Neurons.scala 51:43]
    evalMems_7.io_writeData <= evalUnits_7.io_dataOut @[Neurons.scala 40:43]

  module NeuronCore_1 :
    input clock : Clock
    input reset : UInt<1>
    output io_pmClkEn : UInt<1>
    input io_newTS : UInt<1>
    input io_grant : UInt<1>
    output io_req : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>

    inst interface of BusInterface_3 @[NeuronCore.scala 19:26]
    inst axonSystem of AxonSystem @[NeuronCore.scala 20:26]
    inst spikeTrans of TransmissionSystem_3 @[NeuronCore.scala 21:26]
    inst neurons of Neurons_1 @[NeuronCore.scala 22:26]
    node _io_pmClkEn_T = eq(neurons.io_done, UInt<1>("h0")) @[NeuronCore.scala 43:17]
    node _io_pmClkEn_T_1 = or(_io_pmClkEn_T, interface.io_reqOut) @[NeuronCore.scala 43:34]
    io_pmClkEn <= _io_pmClkEn_T_1 @[NeuronCore.scala 43:14]
    io_req <= interface.io_reqOut @[NeuronCore.scala 25:27]
    io_tx <= interface.io_tx @[NeuronCore.scala 26:27]
    interface.clock <= clock
    interface.reset <= reset
    interface.io_grant <= io_grant @[NeuronCore.scala 24:27]
    interface.io_rx <= io_rx @[NeuronCore.scala 27:27]
    interface.io_spikeID <= spikeTrans.io_data @[NeuronCore.scala 30:27]
    interface.io_reqIn <= spikeTrans.io_valid @[NeuronCore.scala 32:27]
    axonSystem.clock <= clock
    axonSystem.reset <= reset
    axonSystem.io_axonIn <= interface.io_axonID @[NeuronCore.scala 28:27]
    axonSystem.io_axonValid <= interface.io_valid @[NeuronCore.scala 29:27]
    axonSystem.io_inOut <= neurons.io_inOut @[NeuronCore.scala 34:27]
    axonSystem.io_rAddr <= neurons.io_aAddr @[NeuronCore.scala 36:27]
    axonSystem.io_rEna <= neurons.io_aEna @[NeuronCore.scala 37:27]
    spikeTrans.clock <= clock
    spikeTrans.reset <= reset
    spikeTrans.io_ready <= interface.io_ready @[NeuronCore.scala 31:27]
    spikeTrans.io_n <= neurons.io_n @[NeuronCore.scala 40:27]
    spikeTrans.io_spikes_0 <= neurons.io_spikes_0 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_1 <= neurons.io_spikes_1 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_2 <= neurons.io_spikes_2 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_3 <= neurons.io_spikes_3 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_4 <= neurons.io_spikes_4 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_5 <= neurons.io_spikes_5 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_6 <= neurons.io_spikes_6 @[NeuronCore.scala 41:27]
    spikeTrans.io_spikes_7 <= neurons.io_spikes_7 @[NeuronCore.scala 41:27]
    neurons.clock <= clock
    neurons.reset <= reset
    neurons.io_newTS <= io_newTS @[NeuronCore.scala 44:20]
    neurons.io_spikeCnt <= axonSystem.io_spikeCnt @[NeuronCore.scala 35:27]
    neurons.io_aData <= axonSystem.io_rData @[NeuronCore.scala 38:27]

  module OutputCore :
    input clock : Clock
    input reset : UInt<1>
    output io_pmClkEn : UInt<1>
    output io_qWe : UInt<1>
    output io_qDi : UInt<8>
    input io_qFull : UInt<1>
    input io_grant : UInt<1>
    output io_req : UInt<1>
    output io_tx : UInt<11>
    input io_rx : UInt<11>

    inst interface of BusInterface_3 @[OutputCore.scala 23:25]
    node _io_qDi_T = bits(interface.io_axonID, 7, 0) @[OutputCore.scala 33:32]
    node _T = eq(io_qFull, UInt<1>("h0")) @[OutputCore.scala 34:30]
    node _T_1 = and(interface.io_valid, _T) @[OutputCore.scala 34:27]
    node _GEN_0 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[OutputCore.scala 32:10 34:41 35:12]
    node _io_pmClkEn_T = orr(io_rx) @[OutputCore.scala 39:23]
    node _io_pmClkEn_T_1 = or(_io_pmClkEn_T, interface.io_valid) @[OutputCore.scala 39:27]
    io_pmClkEn <= _io_pmClkEn_T_1 @[OutputCore.scala 39:14]
    io_qWe <= _GEN_0
    io_qDi <= _io_qDi_T @[OutputCore.scala 33:10]
    io_req <= interface.io_reqOut @[OutputCore.scala 25:24]
    io_tx <= interface.io_tx @[OutputCore.scala 26:24]
    interface.clock <= clock
    interface.reset <= reset
    interface.io_grant <= io_grant @[OutputCore.scala 24:24]
    interface.io_rx <= io_rx @[OutputCore.scala 27:24]
    interface.io_spikeID <= UInt<1>("h0") @[OutputCore.scala 29:24]
    interface.io_reqIn <= UInt<1>("h0") @[OutputCore.scala 28:24]

  module NeuromorphicProcessor :
    input clock : Clock
    input reset : UInt<1>
    output io_uartTx : UInt<1>
    input io_uartRx : UInt<1>

    inst cBufTop of ClockBufferVerilog @[NeuromorphicProcessor.scala 32:24]
    inst cBufCore of ClockBufferVerilog @[NeuromorphicProcessor.scala 38:25]
    inst inC0Mem of TrueDualPortMemory @[NeuromorphicProcessor.scala 44:23]
    inst inC1Mem of TrueDualPortMemory @[NeuromorphicProcessor.scala 50:23]
    inst outMem of TrueDualPortFIFO @[NeuromorphicProcessor.scala 56:22]
    inst offCC of OffChipCom @[NeuromorphicProcessor.scala 75:23]
    inst arbiter of BusArbiter @[NeuromorphicProcessor.scala 104:25]
    inst inCores_0 of InputCore @[NeuromorphicProcessor.scala 110:46]
    inst inCores_1 of InputCore_1 @[NeuromorphicProcessor.scala 110:46]
    inst neuCores_0 of NeuronCore @[NeuromorphicProcessor.scala 111:47]
    inst neuCores_1 of NeuronCore_1 @[NeuromorphicProcessor.scala 111:47]
    inst outCore of OutputCore @[NeuromorphicProcessor.scala 112:25]
    reg enCnt : UInt<6>, clock with :
      reset => (UInt<1>("h0"), enCnt) @[NeuromorphicProcessor.scala 23:23]
    node _T = neq(enCnt, UInt<6>("h32")) @[NeuromorphicProcessor.scala 24:23]
    node enVec_0 = inCores_0.io_pmClkEn @[NeuromorphicProcessor.scala 107:21 146:23]
    node enVec_1 = inCores_1.io_pmClkEn @[NeuromorphicProcessor.scala 107:21 146:23]
    node _clkEn_T = or(enVec_0, enVec_1) @[NeuromorphicProcessor.scala 162:33]
    node _clkEn_WIRE__0 = _clkEn_T @[NeuromorphicProcessor.scala 162:{30,30}]
    node enVec_2 = neuCores_0.io_pmClkEn @[NeuromorphicProcessor.scala 107:21 152:23]
    node enVec_3 = neuCores_1.io_pmClkEn @[NeuromorphicProcessor.scala 107:21 152:23]
    node _clkEn_T_1 = or(enVec_2, enVec_3) @[NeuromorphicProcessor.scala 162:33]
    node _clkEn_WIRE__1 = _clkEn_T_1 @[NeuromorphicProcessor.scala 162:{30,30}]
    node _clkEn_T_2 = or(_clkEn_WIRE__0, _clkEn_WIRE__1) @[NeuromorphicProcessor.scala 162:33]
    node _clkEn_WIRE_1_0 = _clkEn_T_2 @[NeuromorphicProcessor.scala 162:{30,30}]
    node enVec_4 = outCore.io_pmClkEn @[NeuromorphicProcessor.scala 107:21 158:23]
    node _clkEn_WIRE__2 = enVec_4 @[NeuromorphicProcessor.scala 162:{30,30}]
    node _clkEn_WIRE_1_1 = _clkEn_WIRE__2 @[NeuromorphicProcessor.scala 162:{30,30}]
    node _clkEn_T_3 = or(_clkEn_WIRE_1_0, _clkEn_WIRE_1_1) @[NeuromorphicProcessor.scala 162:33]
    node _clkEn_WIRE_2_0 = _clkEn_T_3 @[NeuromorphicProcessor.scala 162:{30,30}]
    node clkEn = _clkEn_WIRE_2_0 @[NeuromorphicProcessor.scala 13:20 162:11]
    node _T_1 = and(clkEn, _T) @[NeuromorphicProcessor.scala 24:14]
    node _T_2 = eq(clkEn, UInt<1>("h0")) @[NeuromorphicProcessor.scala 26:14]
    node _T_3 = neq(enCnt, UInt<1>("h0")) @[NeuromorphicProcessor.scala 26:30]
    node _T_4 = and(_T_2, _T_3) @[NeuromorphicProcessor.scala 26:21]
    node _enCnt_T = sub(enCnt, UInt<1>("h1")) @[NeuromorphicProcessor.scala 27:20]
    node _enCnt_T_1 = tail(_enCnt_T, 1) @[NeuromorphicProcessor.scala 27:20]
    node _GEN_0 = mux(_T_4, _enCnt_T_1, enCnt) @[NeuromorphicProcessor.scala 26:39 27:11 23:23]
    node _GEN_1 = mux(_T_1, UInt<6>("h32"), _GEN_0) @[NeuromorphicProcessor.scala 24:35 25:11]
    node _coreEn_T = neq(enCnt, UInt<1>("h0")) @[NeuromorphicProcessor.scala 29:31]
    node topClock = cBufTop.io_O @[NeuromorphicProcessor.scala 31:22 35:12]
    reg tsCycleCnt : UInt<17>, topClock with :
      reset => (UInt<1>("h0"), tsCycleCnt) @[NeuromorphicProcessor.scala 70:29]
    node _newTS_T = eq(tsCycleCnt, UInt<1>("h0")) @[NeuromorphicProcessor.scala 71:25]
    node newTS = _newTS_T @[NeuromorphicProcessor.scala 14:19 71:11]
    node coreEn = or(newTS, _coreEn_T) @[NeuromorphicProcessor.scala 29:22]
    node _outMem_io_rst_T = bits(reset, 0, 0) @[NeuromorphicProcessor.scala 59:27]
    node _tsCycleCnt_T = sub(tsCycleCnt, UInt<1>("h1")) @[NeuromorphicProcessor.scala 72:57]
    node _tsCycleCnt_T_1 = tail(_tsCycleCnt_T, 1) @[NeuromorphicProcessor.scala 72:57]
    node _tsCycleCnt_T_2 = mux(newTS, UInt<17>("h13880"), _tsCycleCnt_T_1) @[NeuromorphicProcessor.scala 72:22]
    node txVec_0 = inCores_0.io_tx @[NeuromorphicProcessor.scala 105:21 145:23]
    node txVec_1 = inCores_1.io_tx @[NeuromorphicProcessor.scala 105:21 145:23]
    node _busTx_T = or(txVec_0, txVec_1) @[NeuromorphicProcessor.scala 161:33]
    node txVec_2 = neuCores_0.io_tx @[NeuromorphicProcessor.scala 105:21 151:23]
    node txVec_3 = neuCores_1.io_tx @[NeuromorphicProcessor.scala 105:21 151:23]
    node _busTx_T_1 = or(txVec_2, txVec_3) @[NeuromorphicProcessor.scala 161:33]
    node _busTx_WIRE__0 = _busTx_T @[NeuromorphicProcessor.scala 161:{30,30}]
    node _busTx_WIRE__1 = _busTx_T_1 @[NeuromorphicProcessor.scala 161:{30,30}]
    node _busTx_T_2 = or(_busTx_WIRE__0, _busTx_WIRE__1) @[NeuromorphicProcessor.scala 161:33]
    node _busTx_WIRE_1_0 = _busTx_T_2 @[NeuromorphicProcessor.scala 161:{30,30}]
    node txVec_4 = outCore.io_tx @[NeuromorphicProcessor.scala 105:21 157:23]
    node _busTx_WIRE__2 = txVec_4 @[NeuromorphicProcessor.scala 161:{30,30}]
    node _busTx_WIRE_1_1 = _busTx_WIRE__2 @[NeuromorphicProcessor.scala 161:{30,30}]
    node _busTx_T_3 = or(_busTx_WIRE_1_0, _busTx_WIRE_1_1) @[NeuromorphicProcessor.scala 161:33]
    node coreClock = cBufCore.io_O @[NeuromorphicProcessor.scala 37:23 41:13]
    node inC0HSin = inCores_0.io_offCCHSout @[NeuromorphicProcessor.scala 115:14 62:22]
    node inC1HSin = inCores_1.io_offCCHSout @[NeuromorphicProcessor.scala 122:14 63:22]
    node offCCHSin0 = offCC.io_inC0HSout @[NeuromorphicProcessor.scala 64:24 80:16]
    node offCCHSin1 = offCC.io_inC1HSout @[NeuromorphicProcessor.scala 65:24 81:16]
    node _busTx_WIRE_2_0 = _busTx_T_3 @[NeuromorphicProcessor.scala 161:{30,30}]
    node busTx = _busTx_WIRE_2_0 @[NeuromorphicProcessor.scala 106:21 161:11]
    io_uartTx <= offCC.io_tx @[NeuromorphicProcessor.scala 76:15]
    enCnt <= mux(reset, UInt<6>("h32"), _GEN_1) @[NeuromorphicProcessor.scala 23:{23,23}]
    cBufTop.clock <= clock
    cBufTop.reset <= reset
    cBufTop.io_I <= clock @[NeuromorphicProcessor.scala 34:17]
    cBufTop.io_CE <= UInt<1>("h1") @[NeuromorphicProcessor.scala 33:17]
    cBufCore.clock <= clock
    cBufCore.reset <= reset
    cBufCore.io_I <= clock @[NeuromorphicProcessor.scala 40:18]
    cBufCore.io_CE <= coreEn @[NeuromorphicProcessor.scala 39:18]
    inC0Mem.io_clka <= topClock @[NeuromorphicProcessor.scala 45:19]
    inC0Mem.io_ena <= offCC.io_inC0We @[NeuromorphicProcessor.scala 85:20]
    inC0Mem.io_wea <= offCC.io_inC0We @[NeuromorphicProcessor.scala 86:20]
    inC0Mem.io_addra <= offCC.io_inC0Addr @[NeuromorphicProcessor.scala 87:22]
    inC0Mem.io_dia <= offCC.io_inC0Di @[NeuromorphicProcessor.scala 84:20]
    inC0Mem.io_clkb <= coreClock @[NeuromorphicProcessor.scala 46:19]
    inC0Mem.io_enb <= inCores_0.io_memEn @[NeuromorphicProcessor.scala 116:25]
    inC0Mem.io_web <= UInt<1>("h0") @[NeuromorphicProcessor.scala 47:19]
    inC0Mem.io_addrb <= inCores_0.io_memAddr @[NeuromorphicProcessor.scala 117:25]
    inC0Mem.io_dib <= UInt<1>("h0") @[NeuromorphicProcessor.scala 48:19]
    inC1Mem.io_clka <= topClock @[NeuromorphicProcessor.scala 51:19]
    inC1Mem.io_ena <= offCC.io_inC1We @[NeuromorphicProcessor.scala 90:20]
    inC1Mem.io_wea <= offCC.io_inC1We @[NeuromorphicProcessor.scala 91:20]
    inC1Mem.io_addra <= offCC.io_inC1Addr @[NeuromorphicProcessor.scala 92:22]
    inC1Mem.io_dia <= offCC.io_inC1Di @[NeuromorphicProcessor.scala 89:20]
    inC1Mem.io_clkb <= coreClock @[NeuromorphicProcessor.scala 52:19]
    inC1Mem.io_enb <= inCores_1.io_memEn @[NeuromorphicProcessor.scala 123:25]
    inC1Mem.io_web <= UInt<1>("h0") @[NeuromorphicProcessor.scala 53:19]
    inC1Mem.io_addrb <= inCores_1.io_memAddr @[NeuromorphicProcessor.scala 124:25]
    inC1Mem.io_dib <= UInt<1>("h0") @[NeuromorphicProcessor.scala 54:19]
    outMem.io_clki <= coreClock @[NeuromorphicProcessor.scala 57:18]
    outMem.io_we <= outCore.io_qWe @[NeuromorphicProcessor.scala 133:22]
    outMem.io_datai <= outCore.io_qDi @[NeuromorphicProcessor.scala 134:22]
    outMem.io_clko <= topClock @[NeuromorphicProcessor.scala 58:18]
    outMem.io_en <= offCC.io_qEn @[NeuromorphicProcessor.scala 94:22]
    outMem.io_rst <= _outMem_io_rst_T @[NeuromorphicProcessor.scala 59:18]
    tsCycleCnt <= mux(reset, UInt<17>("h13880"), _tsCycleCnt_T_2) @[NeuromorphicProcessor.scala 70:{29,29} 72:16]
    offCC.clock <= topClock
    offCC.reset <= reset
    offCC.io_rx <= io_uartRx @[NeuromorphicProcessor.scala 77:17]
    offCC.io_qData <= outMem.io_datao @[NeuromorphicProcessor.scala 95:22]
    offCC.io_qEmpty <= outMem.io_empty @[NeuromorphicProcessor.scala 96:22]
    offCC.io_inC0HSin <= inC0HSin @[NeuromorphicProcessor.scala 78:23]
    offCC.io_inC1HSin <= inC1HSin @[NeuromorphicProcessor.scala 79:23]
    arbiter.clock <= coreClock
    arbiter.reset <= reset
    arbiter.io_reqs_0 <= inCores_0.io_req @[NeuromorphicProcessor.scala 143:33]
    arbiter.io_reqs_1 <= inCores_1.io_req @[NeuromorphicProcessor.scala 143:33]
    arbiter.io_reqs_2 <= neuCores_0.io_req @[NeuromorphicProcessor.scala 149:33]
    arbiter.io_reqs_3 <= neuCores_1.io_req @[NeuromorphicProcessor.scala 149:33]
    arbiter.io_reqs_4 <= outCore.io_req @[NeuromorphicProcessor.scala 155:33]
    inCores_0.clock <= coreClock
    inCores_0.reset <= reset
    inCores_0.io_newTS <= newTS @[NeuromorphicProcessor.scala 119:25]
    inCores_0.io_offCCHSin <= offCCHSin0 @[NeuromorphicProcessor.scala 120:29]
    inCores_0.io_memDo <= inC0Mem.io_dob @[NeuromorphicProcessor.scala 118:25]
    inCores_0.io_grant <= arbiter.io_grants_0 @[NeuromorphicProcessor.scala 144:22]
    inCores_0.io_rx <= busTx @[NeuromorphicProcessor.scala 142:19]
    inCores_1.clock <= coreClock
    inCores_1.reset <= reset
    inCores_1.io_newTS <= newTS @[NeuromorphicProcessor.scala 126:25]
    inCores_1.io_offCCHSin <= offCCHSin1 @[NeuromorphicProcessor.scala 127:29]
    inCores_1.io_memDo <= inC1Mem.io_dob @[NeuromorphicProcessor.scala 125:25]
    inCores_1.io_grant <= arbiter.io_grants_1 @[NeuromorphicProcessor.scala 144:22]
    inCores_1.io_rx <= busTx @[NeuromorphicProcessor.scala 142:19]
    neuCores_0.clock <= coreClock
    neuCores_0.reset <= reset
    neuCores_0.io_newTS <= newTS @[NeuromorphicProcessor.scala 129:26]
    neuCores_0.io_grant <= arbiter.io_grants_2 @[NeuromorphicProcessor.scala 150:22]
    neuCores_0.io_rx <= busTx @[NeuromorphicProcessor.scala 148:19]
    neuCores_1.clock <= coreClock
    neuCores_1.reset <= reset
    neuCores_1.io_newTS <= newTS @[NeuromorphicProcessor.scala 131:26]
    neuCores_1.io_grant <= arbiter.io_grants_3 @[NeuromorphicProcessor.scala 150:22]
    neuCores_1.io_rx <= busTx @[NeuromorphicProcessor.scala 148:19]
    outCore.clock <= coreClock
    outCore.reset <= reset
    outCore.io_qFull <= outMem.io_full @[NeuromorphicProcessor.scala 135:22]
    outCore.io_grant <= arbiter.io_grants_4 @[NeuromorphicProcessor.scala 156:22]
    outCore.io_rx <= busTx @[NeuromorphicProcessor.scala 154:19]
