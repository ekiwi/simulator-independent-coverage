circuit TLRAMStandalone :
  module Atomics :
    input clock : Clock
    input reset : UInt<1>
    input io_write : UInt<1>
    input io_a_opcode : UInt<3>
    input io_a_param : UInt<3>
    input io_a_size : UInt<2>
    input io_a_source : UInt<3>
    input io_a_address : UInt<9>
    input io_a_mask : UInt<8>
    input io_a_data : UInt<64>
    input io_a_corrupt : UInt<1>
    input io_data_in : UInt<64>
    output io_data_out : UInt<64>

    node adder = bits(io_a_param, 2, 2) @[Atomics.scala 19:28]
    node unsigned = bits(io_a_param, 1, 1) @[Atomics.scala 20:28]
    node take_max = bits(io_a_param, 0, 0) @[Atomics.scala 21:28]
    node _signBit_T = not(io_a_mask) @[Atomics.scala 23:42]
    node signBit_lo = shr(_signBit_T, 1) @[Atomics.scala 23:53]
    node _signBit_T_1 = cat(UInt<1>("h1"), signBit_lo) @[Cat.scala 30:58]
    node signBit = and(io_a_mask, _signBit_T_1) @[Atomics.scala 23:27]
    node _inv_d_T = not(io_data_in) @[Atomics.scala 24:38]
    node inv_d = mux(adder, io_data_in, _inv_d_T) @[Atomics.scala 24:18]
    node _sum_T = bits(io_a_mask, 0, 0) @[Bitwise.scala 26:51]
    node _sum_T_1 = bits(io_a_mask, 1, 1) @[Bitwise.scala 26:51]
    node _sum_T_2 = bits(io_a_mask, 2, 2) @[Bitwise.scala 26:51]
    node _sum_T_3 = bits(io_a_mask, 3, 3) @[Bitwise.scala 26:51]
    node _sum_T_4 = bits(io_a_mask, 4, 4) @[Bitwise.scala 26:51]
    node _sum_T_5 = bits(io_a_mask, 5, 5) @[Bitwise.scala 26:51]
    node _sum_T_6 = bits(io_a_mask, 6, 6) @[Bitwise.scala 26:51]
    node _sum_T_7 = bits(io_a_mask, 7, 7) @[Bitwise.scala 26:51]
    node _sum_T_8 = bits(_sum_T, 0, 0) @[Bitwise.scala 72:15]
    node sum_lo_lo_lo = mux(_sum_T_8, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_9 = bits(_sum_T_1, 0, 0) @[Bitwise.scala 72:15]
    node sum_lo_lo_hi = mux(_sum_T_9, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_10 = bits(_sum_T_2, 0, 0) @[Bitwise.scala 72:15]
    node sum_lo_hi_lo = mux(_sum_T_10, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_11 = bits(_sum_T_3, 0, 0) @[Bitwise.scala 72:15]
    node sum_lo_hi_hi = mux(_sum_T_11, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_12 = bits(_sum_T_4, 0, 0) @[Bitwise.scala 72:15]
    node sum_hi_lo_lo = mux(_sum_T_12, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_13 = bits(_sum_T_5, 0, 0) @[Bitwise.scala 72:15]
    node sum_hi_lo_hi = mux(_sum_T_13, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_14 = bits(_sum_T_6, 0, 0) @[Bitwise.scala 72:15]
    node sum_hi_hi_lo = mux(_sum_T_14, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node _sum_T_15 = bits(_sum_T_7, 0, 0) @[Bitwise.scala 72:15]
    node sum_hi_hi_hi = mux(_sum_T_15, UInt<8>("hff"), UInt<8>("h0")) @[Bitwise.scala 72:12]
    node sum_lo_lo = cat(sum_lo_lo_hi, sum_lo_lo_lo) @[Cat.scala 30:58]
    node sum_lo_hi = cat(sum_lo_hi_hi, sum_lo_hi_lo) @[Cat.scala 30:58]
    node sum_lo = cat(sum_lo_hi, sum_lo_lo) @[Cat.scala 30:58]
    node sum_hi_lo = cat(sum_hi_lo_hi, sum_hi_lo_lo) @[Cat.scala 30:58]
    node sum_hi_hi = cat(sum_hi_hi_hi, sum_hi_hi_lo) @[Cat.scala 30:58]
    node sum_hi = cat(sum_hi_hi, sum_hi_lo) @[Cat.scala 30:58]
    node _sum_T_16 = cat(sum_hi, sum_lo) @[Cat.scala 30:58]
    node _sum_T_17 = and(_sum_T_16, io_a_data) @[Atomics.scala 25:44]
    node _sum_T_18 = add(_sum_T_17, inv_d) @[Atomics.scala 25:57]
    node sum = tail(_sum_T_18, 1) @[Atomics.scala 25:57]
    node _sign_a_T = bits(io_a_data, 0, 0) @[Atomics.scala 26:36]
    node _sign_a_T_1 = bits(io_a_data, 1, 1) @[Atomics.scala 26:36]
    node _sign_a_T_2 = bits(io_a_data, 2, 2) @[Atomics.scala 26:36]
    node _sign_a_T_3 = bits(io_a_data, 3, 3) @[Atomics.scala 26:36]
    node _sign_a_T_4 = bits(io_a_data, 4, 4) @[Atomics.scala 26:36]
    node _sign_a_T_5 = bits(io_a_data, 5, 5) @[Atomics.scala 26:36]
    node _sign_a_T_6 = bits(io_a_data, 6, 6) @[Atomics.scala 26:36]
    node sign_a_lo_lo_lo = bits(io_a_data, 7, 7) @[Atomics.scala 26:36]
    node _sign_a_T_7 = bits(io_a_data, 8, 8) @[Atomics.scala 26:36]
    node _sign_a_T_8 = bits(io_a_data, 9, 9) @[Atomics.scala 26:36]
    node _sign_a_T_9 = bits(io_a_data, 10, 10) @[Atomics.scala 26:36]
    node _sign_a_T_10 = bits(io_a_data, 11, 11) @[Atomics.scala 26:36]
    node _sign_a_T_11 = bits(io_a_data, 12, 12) @[Atomics.scala 26:36]
    node _sign_a_T_12 = bits(io_a_data, 13, 13) @[Atomics.scala 26:36]
    node _sign_a_T_13 = bits(io_a_data, 14, 14) @[Atomics.scala 26:36]
    node sign_a_lo_lo_hi = bits(io_a_data, 15, 15) @[Atomics.scala 26:36]
    node _sign_a_T_14 = bits(io_a_data, 16, 16) @[Atomics.scala 26:36]
    node _sign_a_T_15 = bits(io_a_data, 17, 17) @[Atomics.scala 26:36]
    node _sign_a_T_16 = bits(io_a_data, 18, 18) @[Atomics.scala 26:36]
    node _sign_a_T_17 = bits(io_a_data, 19, 19) @[Atomics.scala 26:36]
    node _sign_a_T_18 = bits(io_a_data, 20, 20) @[Atomics.scala 26:36]
    node _sign_a_T_19 = bits(io_a_data, 21, 21) @[Atomics.scala 26:36]
    node _sign_a_T_20 = bits(io_a_data, 22, 22) @[Atomics.scala 26:36]
    node sign_a_lo_hi_lo = bits(io_a_data, 23, 23) @[Atomics.scala 26:36]
    node _sign_a_T_21 = bits(io_a_data, 24, 24) @[Atomics.scala 26:36]
    node _sign_a_T_22 = bits(io_a_data, 25, 25) @[Atomics.scala 26:36]
    node _sign_a_T_23 = bits(io_a_data, 26, 26) @[Atomics.scala 26:36]
    node _sign_a_T_24 = bits(io_a_data, 27, 27) @[Atomics.scala 26:36]
    node _sign_a_T_25 = bits(io_a_data, 28, 28) @[Atomics.scala 26:36]
    node _sign_a_T_26 = bits(io_a_data, 29, 29) @[Atomics.scala 26:36]
    node _sign_a_T_27 = bits(io_a_data, 30, 30) @[Atomics.scala 26:36]
    node sign_a_lo_hi_hi = bits(io_a_data, 31, 31) @[Atomics.scala 26:36]
    node _sign_a_T_28 = bits(io_a_data, 32, 32) @[Atomics.scala 26:36]
    node _sign_a_T_29 = bits(io_a_data, 33, 33) @[Atomics.scala 26:36]
    node _sign_a_T_30 = bits(io_a_data, 34, 34) @[Atomics.scala 26:36]
    node _sign_a_T_31 = bits(io_a_data, 35, 35) @[Atomics.scala 26:36]
    node _sign_a_T_32 = bits(io_a_data, 36, 36) @[Atomics.scala 26:36]
    node _sign_a_T_33 = bits(io_a_data, 37, 37) @[Atomics.scala 26:36]
    node _sign_a_T_34 = bits(io_a_data, 38, 38) @[Atomics.scala 26:36]
    node sign_a_hi_lo_lo = bits(io_a_data, 39, 39) @[Atomics.scala 26:36]
    node _sign_a_T_35 = bits(io_a_data, 40, 40) @[Atomics.scala 26:36]
    node _sign_a_T_36 = bits(io_a_data, 41, 41) @[Atomics.scala 26:36]
    node _sign_a_T_37 = bits(io_a_data, 42, 42) @[Atomics.scala 26:36]
    node _sign_a_T_38 = bits(io_a_data, 43, 43) @[Atomics.scala 26:36]
    node _sign_a_T_39 = bits(io_a_data, 44, 44) @[Atomics.scala 26:36]
    node _sign_a_T_40 = bits(io_a_data, 45, 45) @[Atomics.scala 26:36]
    node _sign_a_T_41 = bits(io_a_data, 46, 46) @[Atomics.scala 26:36]
    node sign_a_hi_lo_hi = bits(io_a_data, 47, 47) @[Atomics.scala 26:36]
    node _sign_a_T_42 = bits(io_a_data, 48, 48) @[Atomics.scala 26:36]
    node _sign_a_T_43 = bits(io_a_data, 49, 49) @[Atomics.scala 26:36]
    node _sign_a_T_44 = bits(io_a_data, 50, 50) @[Atomics.scala 26:36]
    node _sign_a_T_45 = bits(io_a_data, 51, 51) @[Atomics.scala 26:36]
    node _sign_a_T_46 = bits(io_a_data, 52, 52) @[Atomics.scala 26:36]
    node _sign_a_T_47 = bits(io_a_data, 53, 53) @[Atomics.scala 26:36]
    node _sign_a_T_48 = bits(io_a_data, 54, 54) @[Atomics.scala 26:36]
    node sign_a_hi_hi_lo = bits(io_a_data, 55, 55) @[Atomics.scala 26:36]
    node _sign_a_T_49 = bits(io_a_data, 56, 56) @[Atomics.scala 26:36]
    node _sign_a_T_50 = bits(io_a_data, 57, 57) @[Atomics.scala 26:36]
    node _sign_a_T_51 = bits(io_a_data, 58, 58) @[Atomics.scala 26:36]
    node _sign_a_T_52 = bits(io_a_data, 59, 59) @[Atomics.scala 26:36]
    node _sign_a_T_53 = bits(io_a_data, 60, 60) @[Atomics.scala 26:36]
    node _sign_a_T_54 = bits(io_a_data, 61, 61) @[Atomics.scala 26:36]
    node _sign_a_T_55 = bits(io_a_data, 62, 62) @[Atomics.scala 26:36]
    node sign_a_hi_hi_hi = bits(io_a_data, 63, 63) @[Atomics.scala 26:36]
    node sign_a_lo_lo = cat(sign_a_lo_lo_hi, sign_a_lo_lo_lo) @[Cat.scala 30:58]
    node sign_a_lo_hi = cat(sign_a_lo_hi_hi, sign_a_lo_hi_lo) @[Cat.scala 30:58]
    node sign_a_lo = cat(sign_a_lo_hi, sign_a_lo_lo) @[Cat.scala 30:58]
    node sign_a_hi_lo = cat(sign_a_hi_lo_hi, sign_a_hi_lo_lo) @[Cat.scala 30:58]
    node sign_a_hi_hi = cat(sign_a_hi_hi_hi, sign_a_hi_hi_lo) @[Cat.scala 30:58]
    node sign_a_hi = cat(sign_a_hi_hi, sign_a_hi_lo) @[Cat.scala 30:58]
    node _sign_a_T_56 = cat(sign_a_hi, sign_a_lo) @[Cat.scala 30:58]
    node _sign_a_T_57 = and(_sign_a_T_56, signBit) @[Atomics.scala 26:83]
    node sign_a = orr(_sign_a_T_57) @[Atomics.scala 26:97]
    node _sign_d_T = bits(io_data_in, 0, 0) @[Atomics.scala 26:36]
    node _sign_d_T_1 = bits(io_data_in, 1, 1) @[Atomics.scala 26:36]
    node _sign_d_T_2 = bits(io_data_in, 2, 2) @[Atomics.scala 26:36]
    node _sign_d_T_3 = bits(io_data_in, 3, 3) @[Atomics.scala 26:36]
    node _sign_d_T_4 = bits(io_data_in, 4, 4) @[Atomics.scala 26:36]
    node _sign_d_T_5 = bits(io_data_in, 5, 5) @[Atomics.scala 26:36]
    node _sign_d_T_6 = bits(io_data_in, 6, 6) @[Atomics.scala 26:36]
    node sign_d_lo_lo_lo = bits(io_data_in, 7, 7) @[Atomics.scala 26:36]
    node _sign_d_T_7 = bits(io_data_in, 8, 8) @[Atomics.scala 26:36]
    node _sign_d_T_8 = bits(io_data_in, 9, 9) @[Atomics.scala 26:36]
    node _sign_d_T_9 = bits(io_data_in, 10, 10) @[Atomics.scala 26:36]
    node _sign_d_T_10 = bits(io_data_in, 11, 11) @[Atomics.scala 26:36]
    node _sign_d_T_11 = bits(io_data_in, 12, 12) @[Atomics.scala 26:36]
    node _sign_d_T_12 = bits(io_data_in, 13, 13) @[Atomics.scala 26:36]
    node _sign_d_T_13 = bits(io_data_in, 14, 14) @[Atomics.scala 26:36]
    node sign_d_lo_lo_hi = bits(io_data_in, 15, 15) @[Atomics.scala 26:36]
    node _sign_d_T_14 = bits(io_data_in, 16, 16) @[Atomics.scala 26:36]
    node _sign_d_T_15 = bits(io_data_in, 17, 17) @[Atomics.scala 26:36]
    node _sign_d_T_16 = bits(io_data_in, 18, 18) @[Atomics.scala 26:36]
    node _sign_d_T_17 = bits(io_data_in, 19, 19) @[Atomics.scala 26:36]
    node _sign_d_T_18 = bits(io_data_in, 20, 20) @[Atomics.scala 26:36]
    node _sign_d_T_19 = bits(io_data_in, 21, 21) @[Atomics.scala 26:36]
    node _sign_d_T_20 = bits(io_data_in, 22, 22) @[Atomics.scala 26:36]
    node sign_d_lo_hi_lo = bits(io_data_in, 23, 23) @[Atomics.scala 26:36]
    node _sign_d_T_21 = bits(io_data_in, 24, 24) @[Atomics.scala 26:36]
    node _sign_d_T_22 = bits(io_data_in, 25, 25) @[Atomics.scala 26:36]
    node _sign_d_T_23 = bits(io_data_in, 26, 26) @[Atomics.scala 26:36]
    node _sign_d_T_24 = bits(io_data_in, 27, 27) @[Atomics.scala 26:36]
    node _sign_d_T_25 = bits(io_data_in, 28, 28) @[Atomics.scala 26:36]
    node _sign_d_T_26 = bits(io_data_in, 29, 29) @[Atomics.scala 26:36]
    node _sign_d_T_27 = bits(io_data_in, 30, 30) @[Atomics.scala 26:36]
    node sign_d_lo_hi_hi = bits(io_data_in, 31, 31) @[Atomics.scala 26:36]
    node _sign_d_T_28 = bits(io_data_in, 32, 32) @[Atomics.scala 26:36]
    node _sign_d_T_29 = bits(io_data_in, 33, 33) @[Atomics.scala 26:36]
    node _sign_d_T_30 = bits(io_data_in, 34, 34) @[Atomics.scala 26:36]
    node _sign_d_T_31 = bits(io_data_in, 35, 35) @[Atomics.scala 26:36]
    node _sign_d_T_32 = bits(io_data_in, 36, 36) @[Atomics.scala 26:36]
    node _sign_d_T_33 = bits(io_data_in, 37, 37) @[Atomics.scala 26:36]
    node _sign_d_T_34 = bits(io_data_in, 38, 38) @[Atomics.scala 26:36]
    node sign_d_hi_lo_lo = bits(io_data_in, 39, 39) @[Atomics.scala 26:36]
    node _sign_d_T_35 = bits(io_data_in, 40, 40) @[Atomics.scala 26:36]
    node _sign_d_T_36 = bits(io_data_in, 41, 41) @[Atomics.scala 26:36]
    node _sign_d_T_37 = bits(io_data_in, 42, 42) @[Atomics.scala 26:36]
    node _sign_d_T_38 = bits(io_data_in, 43, 43) @[Atomics.scala 26:36]
    node _sign_d_T_39 = bits(io_data_in, 44, 44) @[Atomics.scala 26:36]
    node _sign_d_T_40 = bits(io_data_in, 45, 45) @[Atomics.scala 26:36]
    node _sign_d_T_41 = bits(io_data_in, 46, 46) @[Atomics.scala 26:36]
    node sign_d_hi_lo_hi = bits(io_data_in, 47, 47) @[Atomics.scala 26:36]
    node _sign_d_T_42 = bits(io_data_in, 48, 48) @[Atomics.scala 26:36]
    node _sign_d_T_43 = bits(io_data_in, 49, 49) @[Atomics.scala 26:36]
    node _sign_d_T_44 = bits(io_data_in, 50, 50) @[Atomics.scala 26:36]
    node _sign_d_T_45 = bits(io_data_in, 51, 51) @[Atomics.scala 26:36]
    node _sign_d_T_46 = bits(io_data_in, 52, 52) @[Atomics.scala 26:36]
    node _sign_d_T_47 = bits(io_data_in, 53, 53) @[Atomics.scala 26:36]
    node _sign_d_T_48 = bits(io_data_in, 54, 54) @[Atomics.scala 26:36]
    node sign_d_hi_hi_lo = bits(io_data_in, 55, 55) @[Atomics.scala 26:36]
    node _sign_d_T_49 = bits(io_data_in, 56, 56) @[Atomics.scala 26:36]
    node _sign_d_T_50 = bits(io_data_in, 57, 57) @[Atomics.scala 26:36]
    node _sign_d_T_51 = bits(io_data_in, 58, 58) @[Atomics.scala 26:36]
    node _sign_d_T_52 = bits(io_data_in, 59, 59) @[Atomics.scala 26:36]
    node _sign_d_T_53 = bits(io_data_in, 60, 60) @[Atomics.scala 26:36]
    node _sign_d_T_54 = bits(io_data_in, 61, 61) @[Atomics.scala 26:36]
    node _sign_d_T_55 = bits(io_data_in, 62, 62) @[Atomics.scala 26:36]
    node sign_d_hi_hi_hi = bits(io_data_in, 63, 63) @[Atomics.scala 26:36]
    node sign_d_lo_lo = cat(sign_d_lo_lo_hi, sign_d_lo_lo_lo) @[Cat.scala 30:58]
    node sign_d_lo_hi = cat(sign_d_lo_hi_hi, sign_d_lo_hi_lo) @[Cat.scala 30:58]
    node sign_d_lo = cat(sign_d_lo_hi, sign_d_lo_lo) @[Cat.scala 30:58]
    node sign_d_hi_lo = cat(sign_d_hi_lo_hi, sign_d_hi_lo_lo) @[Cat.scala 30:58]
    node sign_d_hi_hi = cat(sign_d_hi_hi_hi, sign_d_hi_hi_lo) @[Cat.scala 30:58]
    node sign_d_hi = cat(sign_d_hi_hi, sign_d_hi_lo) @[Cat.scala 30:58]
    node _sign_d_T_56 = cat(sign_d_hi, sign_d_lo) @[Cat.scala 30:58]
    node _sign_d_T_57 = and(_sign_d_T_56, signBit) @[Atomics.scala 26:83]
    node sign_d = orr(_sign_d_T_57) @[Atomics.scala 26:97]
    node _sign_s_T = bits(sum, 0, 0) @[Atomics.scala 26:36]
    node _sign_s_T_1 = bits(sum, 1, 1) @[Atomics.scala 26:36]
    node _sign_s_T_2 = bits(sum, 2, 2) @[Atomics.scala 26:36]
    node _sign_s_T_3 = bits(sum, 3, 3) @[Atomics.scala 26:36]
    node _sign_s_T_4 = bits(sum, 4, 4) @[Atomics.scala 26:36]
    node _sign_s_T_5 = bits(sum, 5, 5) @[Atomics.scala 26:36]
    node _sign_s_T_6 = bits(sum, 6, 6) @[Atomics.scala 26:36]
    node sign_s_lo_lo_lo = bits(sum, 7, 7) @[Atomics.scala 26:36]
    node _sign_s_T_7 = bits(sum, 8, 8) @[Atomics.scala 26:36]
    node _sign_s_T_8 = bits(sum, 9, 9) @[Atomics.scala 26:36]
    node _sign_s_T_9 = bits(sum, 10, 10) @[Atomics.scala 26:36]
    node _sign_s_T_10 = bits(sum, 11, 11) @[Atomics.scala 26:36]
    node _sign_s_T_11 = bits(sum, 12, 12) @[Atomics.scala 26:36]
    node _sign_s_T_12 = bits(sum, 13, 13) @[Atomics.scala 26:36]
    node _sign_s_T_13 = bits(sum, 14, 14) @[Atomics.scala 26:36]
    node sign_s_lo_lo_hi = bits(sum, 15, 15) @[Atomics.scala 26:36]
    node _sign_s_T_14 = bits(sum, 16, 16) @[Atomics.scala 26:36]
    node _sign_s_T_15 = bits(sum, 17, 17) @[Atomics.scala 26:36]
    node _sign_s_T_16 = bits(sum, 18, 18) @[Atomics.scala 26:36]
    node _sign_s_T_17 = bits(sum, 19, 19) @[Atomics.scala 26:36]
    node _sign_s_T_18 = bits(sum, 20, 20) @[Atomics.scala 26:36]
    node _sign_s_T_19 = bits(sum, 21, 21) @[Atomics.scala 26:36]
    node _sign_s_T_20 = bits(sum, 22, 22) @[Atomics.scala 26:36]
    node sign_s_lo_hi_lo = bits(sum, 23, 23) @[Atomics.scala 26:36]
    node _sign_s_T_21 = bits(sum, 24, 24) @[Atomics.scala 26:36]
    node _sign_s_T_22 = bits(sum, 25, 25) @[Atomics.scala 26:36]
    node _sign_s_T_23 = bits(sum, 26, 26) @[Atomics.scala 26:36]
    node _sign_s_T_24 = bits(sum, 27, 27) @[Atomics.scala 26:36]
    node _sign_s_T_25 = bits(sum, 28, 28) @[Atomics.scala 26:36]
    node _sign_s_T_26 = bits(sum, 29, 29) @[Atomics.scala 26:36]
    node _sign_s_T_27 = bits(sum, 30, 30) @[Atomics.scala 26:36]
    node sign_s_lo_hi_hi = bits(sum, 31, 31) @[Atomics.scala 26:36]
    node _sign_s_T_28 = bits(sum, 32, 32) @[Atomics.scala 26:36]
    node _sign_s_T_29 = bits(sum, 33, 33) @[Atomics.scala 26:36]
    node _sign_s_T_30 = bits(sum, 34, 34) @[Atomics.scala 26:36]
    node _sign_s_T_31 = bits(sum, 35, 35) @[Atomics.scala 26:36]
    node _sign_s_T_32 = bits(sum, 36, 36) @[Atomics.scala 26:36]
    node _sign_s_T_33 = bits(sum, 37, 37) @[Atomics.scala 26:36]
    node _sign_s_T_34 = bits(sum, 38, 38) @[Atomics.scala 26:36]
    node sign_s_hi_lo_lo = bits(sum, 39, 39) @[Atomics.scala 26:36]
    node _sign_s_T_35 = bits(sum, 40, 40) @[Atomics.scala 26:36]
    node _sign_s_T_36 = bits(sum, 41, 41) @[Atomics.scala 26:36]
    node _sign_s_T_37 = bits(sum, 42, 42) @[Atomics.scala 26:36]
    node _sign_s_T_38 = bits(sum, 43, 43) @[Atomics.scala 26:36]
    node _sign_s_T_39 = bits(sum, 44, 44) @[Atomics.scala 26:36]
    node _sign_s_T_40 = bits(sum, 45, 45) @[Atomics.scala 26:36]
    node _sign_s_T_41 = bits(sum, 46, 46) @[Atomics.scala 26:36]
    node sign_s_hi_lo_hi = bits(sum, 47, 47) @[Atomics.scala 26:36]
    node _sign_s_T_42 = bits(sum, 48, 48) @[Atomics.scala 26:36]
    node _sign_s_T_43 = bits(sum, 49, 49) @[Atomics.scala 26:36]
    node _sign_s_T_44 = bits(sum, 50, 50) @[Atomics.scala 26:36]
    node _sign_s_T_45 = bits(sum, 51, 51) @[Atomics.scala 26:36]
    node _sign_s_T_46 = bits(sum, 52, 52) @[Atomics.scala 26:36]
    node _sign_s_T_47 = bits(sum, 53, 53) @[Atomics.scala 26:36]
    node _sign_s_T_48 = bits(sum, 54, 54) @[Atomics.scala 26:36]
    node sign_s_hi_hi_lo = bits(sum, 55, 55) @[Atomics.scala 26:36]
    node _sign_s_T_49 = bits(sum, 56, 56) @[Atomics.scala 26:36]
    node _sign_s_T_50 = bits(sum, 57, 57) @[Atomics.scala 26:36]
    node _sign_s_T_51 = bits(sum, 58, 58) @[Atomics.scala 26:36]
    node _sign_s_T_52 = bits(sum, 59, 59) @[Atomics.scala 26:36]
    node _sign_s_T_53 = bits(sum, 60, 60) @[Atomics.scala 26:36]
    node _sign_s_T_54 = bits(sum, 61, 61) @[Atomics.scala 26:36]
    node _sign_s_T_55 = bits(sum, 62, 62) @[Atomics.scala 26:36]
    node sign_s_hi_hi_hi = bits(sum, 63, 63) @[Atomics.scala 26:36]
    node sign_s_lo_lo = cat(sign_s_lo_lo_hi, sign_s_lo_lo_lo) @[Cat.scala 30:58]
    node sign_s_lo_hi = cat(sign_s_lo_hi_hi, sign_s_lo_hi_lo) @[Cat.scala 30:58]
    node sign_s_lo = cat(sign_s_lo_hi, sign_s_lo_lo) @[Cat.scala 30:58]
    node sign_s_hi_lo = cat(sign_s_hi_lo_hi, sign_s_hi_lo_lo) @[Cat.scala 30:58]
    node sign_s_hi_hi = cat(sign_s_hi_hi_hi, sign_s_hi_hi_lo) @[Cat.scala 30:58]
    node sign_s_hi = cat(sign_s_hi_hi, sign_s_hi_lo) @[Cat.scala 30:58]
    node _sign_s_T_56 = cat(sign_s_hi, sign_s_lo) @[Cat.scala 30:58]
    node _sign_s_T_57 = and(_sign_s_T_56, signBit) @[Atomics.scala 26:83]
    node sign_s = orr(_sign_s_T_57) @[Atomics.scala 26:97]
    node a_bigger_uneq = eq(unsigned, sign_a) @[Atomics.scala 30:32]
    node _a_bigger_T = eq(sign_a, sign_d) @[Atomics.scala 31:29]
    node _a_bigger_T_1 = eq(sign_s, UInt<1>("h0")) @[Atomics.scala 31:41]
    node a_bigger = mux(_a_bigger_T, _a_bigger_T_1, a_bigger_uneq) @[Atomics.scala 31:21]
    node pick_a = eq(take_max, a_bigger) @[Atomics.scala 32:25]
    node _lut_T = bits(io_a_param, 1, 0) @[Atomics.scala 40:15]
    node logical_hi = bits(io_a_data, 0, 0) @[Atomics.scala 41:32]
    node logical_hi_1 = bits(io_a_data, 1, 1) @[Atomics.scala 41:32]
    node logical_hi_2 = bits(io_a_data, 2, 2) @[Atomics.scala 41:32]
    node logical_hi_3 = bits(io_a_data, 3, 3) @[Atomics.scala 41:32]
    node logical_hi_4 = bits(io_a_data, 4, 4) @[Atomics.scala 41:32]
    node logical_hi_5 = bits(io_a_data, 5, 5) @[Atomics.scala 41:32]
    node logical_hi_6 = bits(io_a_data, 6, 6) @[Atomics.scala 41:32]
    node logical_hi_7 = bits(io_a_data, 7, 7) @[Atomics.scala 41:32]
    node logical_hi_8 = bits(io_a_data, 8, 8) @[Atomics.scala 41:32]
    node logical_hi_9 = bits(io_a_data, 9, 9) @[Atomics.scala 41:32]
    node logical_hi_10 = bits(io_a_data, 10, 10) @[Atomics.scala 41:32]
    node logical_hi_11 = bits(io_a_data, 11, 11) @[Atomics.scala 41:32]
    node logical_hi_12 = bits(io_a_data, 12, 12) @[Atomics.scala 41:32]
    node logical_hi_13 = bits(io_a_data, 13, 13) @[Atomics.scala 41:32]
    node logical_hi_14 = bits(io_a_data, 14, 14) @[Atomics.scala 41:32]
    node logical_hi_15 = bits(io_a_data, 15, 15) @[Atomics.scala 41:32]
    node logical_hi_16 = bits(io_a_data, 16, 16) @[Atomics.scala 41:32]
    node logical_hi_17 = bits(io_a_data, 17, 17) @[Atomics.scala 41:32]
    node logical_hi_18 = bits(io_a_data, 18, 18) @[Atomics.scala 41:32]
    node logical_hi_19 = bits(io_a_data, 19, 19) @[Atomics.scala 41:32]
    node logical_hi_20 = bits(io_a_data, 20, 20) @[Atomics.scala 41:32]
    node logical_hi_21 = bits(io_a_data, 21, 21) @[Atomics.scala 41:32]
    node logical_hi_22 = bits(io_a_data, 22, 22) @[Atomics.scala 41:32]
    node logical_hi_23 = bits(io_a_data, 23, 23) @[Atomics.scala 41:32]
    node logical_hi_24 = bits(io_a_data, 24, 24) @[Atomics.scala 41:32]
    node logical_hi_25 = bits(io_a_data, 25, 25) @[Atomics.scala 41:32]
    node logical_hi_26 = bits(io_a_data, 26, 26) @[Atomics.scala 41:32]
    node logical_hi_27 = bits(io_a_data, 27, 27) @[Atomics.scala 41:32]
    node logical_hi_28 = bits(io_a_data, 28, 28) @[Atomics.scala 41:32]
    node logical_hi_29 = bits(io_a_data, 29, 29) @[Atomics.scala 41:32]
    node logical_hi_30 = bits(io_a_data, 30, 30) @[Atomics.scala 41:32]
    node logical_hi_31 = bits(io_a_data, 31, 31) @[Atomics.scala 41:32]
    node logical_hi_32 = bits(io_a_data, 32, 32) @[Atomics.scala 41:32]
    node logical_hi_33 = bits(io_a_data, 33, 33) @[Atomics.scala 41:32]
    node logical_hi_34 = bits(io_a_data, 34, 34) @[Atomics.scala 41:32]
    node logical_hi_35 = bits(io_a_data, 35, 35) @[Atomics.scala 41:32]
    node logical_hi_36 = bits(io_a_data, 36, 36) @[Atomics.scala 41:32]
    node logical_hi_37 = bits(io_a_data, 37, 37) @[Atomics.scala 41:32]
    node logical_hi_38 = bits(io_a_data, 38, 38) @[Atomics.scala 41:32]
    node logical_hi_39 = bits(io_a_data, 39, 39) @[Atomics.scala 41:32]
    node logical_hi_40 = bits(io_a_data, 40, 40) @[Atomics.scala 41:32]
    node logical_hi_41 = bits(io_a_data, 41, 41) @[Atomics.scala 41:32]
    node logical_hi_42 = bits(io_a_data, 42, 42) @[Atomics.scala 41:32]
    node logical_hi_43 = bits(io_a_data, 43, 43) @[Atomics.scala 41:32]
    node logical_hi_44 = bits(io_a_data, 44, 44) @[Atomics.scala 41:32]
    node logical_hi_45 = bits(io_a_data, 45, 45) @[Atomics.scala 41:32]
    node logical_hi_46 = bits(io_a_data, 46, 46) @[Atomics.scala 41:32]
    node logical_hi_47 = bits(io_a_data, 47, 47) @[Atomics.scala 41:32]
    node logical_hi_48 = bits(io_a_data, 48, 48) @[Atomics.scala 41:32]
    node logical_hi_49 = bits(io_a_data, 49, 49) @[Atomics.scala 41:32]
    node logical_hi_50 = bits(io_a_data, 50, 50) @[Atomics.scala 41:32]
    node logical_hi_51 = bits(io_a_data, 51, 51) @[Atomics.scala 41:32]
    node logical_hi_52 = bits(io_a_data, 52, 52) @[Atomics.scala 41:32]
    node logical_hi_53 = bits(io_a_data, 53, 53) @[Atomics.scala 41:32]
    node logical_hi_54 = bits(io_a_data, 54, 54) @[Atomics.scala 41:32]
    node logical_hi_55 = bits(io_a_data, 55, 55) @[Atomics.scala 41:32]
    node logical_hi_56 = bits(io_a_data, 56, 56) @[Atomics.scala 41:32]
    node logical_hi_57 = bits(io_a_data, 57, 57) @[Atomics.scala 41:32]
    node logical_hi_58 = bits(io_a_data, 58, 58) @[Atomics.scala 41:32]
    node logical_hi_59 = bits(io_a_data, 59, 59) @[Atomics.scala 41:32]
    node logical_hi_60 = bits(io_a_data, 60, 60) @[Atomics.scala 41:32]
    node logical_hi_61 = bits(io_a_data, 61, 61) @[Atomics.scala 41:32]
    node logical_hi_62 = bits(io_a_data, 62, 62) @[Atomics.scala 41:32]
    node logical_hi_63 = bits(io_a_data, 63, 63) @[Atomics.scala 41:32]
    node logical_lo = bits(io_data_in, 0, 0) @[Atomics.scala 41:55]
    node logical_lo_1 = bits(io_data_in, 1, 1) @[Atomics.scala 41:55]
    node logical_lo_2 = bits(io_data_in, 2, 2) @[Atomics.scala 41:55]
    node logical_lo_3 = bits(io_data_in, 3, 3) @[Atomics.scala 41:55]
    node logical_lo_4 = bits(io_data_in, 4, 4) @[Atomics.scala 41:55]
    node logical_lo_5 = bits(io_data_in, 5, 5) @[Atomics.scala 41:55]
    node logical_lo_6 = bits(io_data_in, 6, 6) @[Atomics.scala 41:55]
    node logical_lo_7 = bits(io_data_in, 7, 7) @[Atomics.scala 41:55]
    node logical_lo_8 = bits(io_data_in, 8, 8) @[Atomics.scala 41:55]
    node logical_lo_9 = bits(io_data_in, 9, 9) @[Atomics.scala 41:55]
    node logical_lo_10 = bits(io_data_in, 10, 10) @[Atomics.scala 41:55]
    node logical_lo_11 = bits(io_data_in, 11, 11) @[Atomics.scala 41:55]
    node logical_lo_12 = bits(io_data_in, 12, 12) @[Atomics.scala 41:55]
    node logical_lo_13 = bits(io_data_in, 13, 13) @[Atomics.scala 41:55]
    node logical_lo_14 = bits(io_data_in, 14, 14) @[Atomics.scala 41:55]
    node logical_lo_15 = bits(io_data_in, 15, 15) @[Atomics.scala 41:55]
    node logical_lo_16 = bits(io_data_in, 16, 16) @[Atomics.scala 41:55]
    node logical_lo_17 = bits(io_data_in, 17, 17) @[Atomics.scala 41:55]
    node logical_lo_18 = bits(io_data_in, 18, 18) @[Atomics.scala 41:55]
    node logical_lo_19 = bits(io_data_in, 19, 19) @[Atomics.scala 41:55]
    node logical_lo_20 = bits(io_data_in, 20, 20) @[Atomics.scala 41:55]
    node logical_lo_21 = bits(io_data_in, 21, 21) @[Atomics.scala 41:55]
    node logical_lo_22 = bits(io_data_in, 22, 22) @[Atomics.scala 41:55]
    node logical_lo_23 = bits(io_data_in, 23, 23) @[Atomics.scala 41:55]
    node logical_lo_24 = bits(io_data_in, 24, 24) @[Atomics.scala 41:55]
    node logical_lo_25 = bits(io_data_in, 25, 25) @[Atomics.scala 41:55]
    node logical_lo_26 = bits(io_data_in, 26, 26) @[Atomics.scala 41:55]
    node logical_lo_27 = bits(io_data_in, 27, 27) @[Atomics.scala 41:55]
    node logical_lo_28 = bits(io_data_in, 28, 28) @[Atomics.scala 41:55]
    node logical_lo_29 = bits(io_data_in, 29, 29) @[Atomics.scala 41:55]
    node logical_lo_30 = bits(io_data_in, 30, 30) @[Atomics.scala 41:55]
    node logical_lo_31 = bits(io_data_in, 31, 31) @[Atomics.scala 41:55]
    node logical_lo_32 = bits(io_data_in, 32, 32) @[Atomics.scala 41:55]
    node logical_lo_33 = bits(io_data_in, 33, 33) @[Atomics.scala 41:55]
    node logical_lo_34 = bits(io_data_in, 34, 34) @[Atomics.scala 41:55]
    node logical_lo_35 = bits(io_data_in, 35, 35) @[Atomics.scala 41:55]
    node logical_lo_36 = bits(io_data_in, 36, 36) @[Atomics.scala 41:55]
    node logical_lo_37 = bits(io_data_in, 37, 37) @[Atomics.scala 41:55]
    node logical_lo_38 = bits(io_data_in, 38, 38) @[Atomics.scala 41:55]
    node logical_lo_39 = bits(io_data_in, 39, 39) @[Atomics.scala 41:55]
    node logical_lo_40 = bits(io_data_in, 40, 40) @[Atomics.scala 41:55]
    node logical_lo_41 = bits(io_data_in, 41, 41) @[Atomics.scala 41:55]
    node logical_lo_42 = bits(io_data_in, 42, 42) @[Atomics.scala 41:55]
    node logical_lo_43 = bits(io_data_in, 43, 43) @[Atomics.scala 41:55]
    node logical_lo_44 = bits(io_data_in, 44, 44) @[Atomics.scala 41:55]
    node logical_lo_45 = bits(io_data_in, 45, 45) @[Atomics.scala 41:55]
    node logical_lo_46 = bits(io_data_in, 46, 46) @[Atomics.scala 41:55]
    node logical_lo_47 = bits(io_data_in, 47, 47) @[Atomics.scala 41:55]
    node logical_lo_48 = bits(io_data_in, 48, 48) @[Atomics.scala 41:55]
    node logical_lo_49 = bits(io_data_in, 49, 49) @[Atomics.scala 41:55]
    node logical_lo_50 = bits(io_data_in, 50, 50) @[Atomics.scala 41:55]
    node logical_lo_51 = bits(io_data_in, 51, 51) @[Atomics.scala 41:55]
    node logical_lo_52 = bits(io_data_in, 52, 52) @[Atomics.scala 41:55]
    node logical_lo_53 = bits(io_data_in, 53, 53) @[Atomics.scala 41:55]
    node logical_lo_54 = bits(io_data_in, 54, 54) @[Atomics.scala 41:55]
    node logical_lo_55 = bits(io_data_in, 55, 55) @[Atomics.scala 41:55]
    node logical_lo_56 = bits(io_data_in, 56, 56) @[Atomics.scala 41:55]
    node logical_lo_57 = bits(io_data_in, 57, 57) @[Atomics.scala 41:55]
    node logical_lo_58 = bits(io_data_in, 58, 58) @[Atomics.scala 41:55]
    node logical_lo_59 = bits(io_data_in, 59, 59) @[Atomics.scala 41:55]
    node logical_lo_60 = bits(io_data_in, 60, 60) @[Atomics.scala 41:55]
    node logical_lo_61 = bits(io_data_in, 61, 61) @[Atomics.scala 41:55]
    node logical_lo_62 = bits(io_data_in, 62, 62) @[Atomics.scala 41:55]
    node logical_lo_63 = bits(io_data_in, 63, 63) @[Atomics.scala 41:55]
    node _logical_T = cat(logical_hi, logical_lo) @[Cat.scala 30:58]
    node _lut_WIRE_0 = pad(UInt<3>("h6"), 4) @[Atomics.scala 35:16 Atomics.scala 35:16]
    node _GEN_0 = validif(eq(UInt<1>("h0"), _lut_T), _lut_WIRE_0) @[Atomics.scala 42:8 Atomics.scala 42:8]
    node _lut_WIRE_1 = UInt<4>("he") @[Atomics.scala 35:16 Atomics.scala 35:16]
    node _GEN_1 = mux(eq(UInt<1>("h1"), _lut_T), _lut_WIRE_1, _GEN_0) @[Atomics.scala 42:8 Atomics.scala 42:8]
    node _lut_WIRE_2 = UInt<4>("h8") @[Atomics.scala 35:16 Atomics.scala 35:16]
    node _GEN_2 = mux(eq(UInt<2>("h2"), _lut_T), _lut_WIRE_2, _GEN_1) @[Atomics.scala 42:8 Atomics.scala 42:8]
    node _lut_WIRE_3 = UInt<4>("hc") @[Atomics.scala 35:16 Atomics.scala 35:16]
    node _GEN_3 = mux(eq(UInt<2>("h3"), _lut_T), _lut_WIRE_3, _GEN_2) @[Atomics.scala 42:8 Atomics.scala 42:8]
    node _lut_WIRE_lut_T = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_1 = dshr(_lut_WIRE_lut_T, _logical_T) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_lo_lo_lo = bits(_logical_T_1, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_2 = cat(logical_hi_1, logical_lo_1) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_0 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_3 = dshr(_lut_WIRE_lut_T_0, _logical_T_2) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_lo_lo_hi = bits(_logical_T_3, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_4 = cat(logical_hi_2, logical_lo_2) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_1 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_5 = dshr(_lut_WIRE_lut_T_1, _logical_T_4) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_lo_hi_lo = bits(_logical_T_5, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_6 = cat(logical_hi_3, logical_lo_3) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_2 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_7 = dshr(_lut_WIRE_lut_T_2, _logical_T_6) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_lo_hi_hi = bits(_logical_T_7, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_8 = cat(logical_hi_4, logical_lo_4) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_3 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_9 = dshr(_lut_WIRE_lut_T_3, _logical_T_8) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_hi_lo_lo = bits(_logical_T_9, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_10 = cat(logical_hi_5, logical_lo_5) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_4 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_11 = dshr(_lut_WIRE_lut_T_4, _logical_T_10) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_hi_lo_hi = bits(_logical_T_11, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_12 = cat(logical_hi_6, logical_lo_6) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_5 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_13 = dshr(_lut_WIRE_lut_T_5, _logical_T_12) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_hi_hi_lo = bits(_logical_T_13, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_14 = cat(logical_hi_7, logical_lo_7) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_6 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_15 = dshr(_lut_WIRE_lut_T_6, _logical_T_14) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_hi_hi_hi = bits(_logical_T_15, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_16 = cat(logical_hi_8, logical_lo_8) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_7 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_17 = dshr(_lut_WIRE_lut_T_7, _logical_T_16) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_lo_lo_lo = bits(_logical_T_17, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_18 = cat(logical_hi_9, logical_lo_9) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_8 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_19 = dshr(_lut_WIRE_lut_T_8, _logical_T_18) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_lo_lo_hi = bits(_logical_T_19, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_20 = cat(logical_hi_10, logical_lo_10) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_9 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_21 = dshr(_lut_WIRE_lut_T_9, _logical_T_20) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_lo_hi_lo = bits(_logical_T_21, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_22 = cat(logical_hi_11, logical_lo_11) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_10 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_23 = dshr(_lut_WIRE_lut_T_10, _logical_T_22) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_lo_hi_hi = bits(_logical_T_23, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_24 = cat(logical_hi_12, logical_lo_12) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_11 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_25 = dshr(_lut_WIRE_lut_T_11, _logical_T_24) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_hi_lo_lo = bits(_logical_T_25, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_26 = cat(logical_hi_13, logical_lo_13) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_12 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_27 = dshr(_lut_WIRE_lut_T_12, _logical_T_26) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_hi_lo_hi = bits(_logical_T_27, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_28 = cat(logical_hi_14, logical_lo_14) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_13 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_29 = dshr(_lut_WIRE_lut_T_13, _logical_T_28) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_hi_hi_lo = bits(_logical_T_29, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_30 = cat(logical_hi_15, logical_lo_15) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_14 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_31 = dshr(_lut_WIRE_lut_T_14, _logical_T_30) @[Atomics.scala 42:8]
    node logical_lo_lo_hi_hi_hi_hi = bits(_logical_T_31, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_32 = cat(logical_hi_16, logical_lo_16) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_15 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_33 = dshr(_lut_WIRE_lut_T_15, _logical_T_32) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_lo_lo_lo = bits(_logical_T_33, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_34 = cat(logical_hi_17, logical_lo_17) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_16 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_35 = dshr(_lut_WIRE_lut_T_16, _logical_T_34) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_lo_lo_hi = bits(_logical_T_35, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_36 = cat(logical_hi_18, logical_lo_18) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_17 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_37 = dshr(_lut_WIRE_lut_T_17, _logical_T_36) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_lo_hi_lo = bits(_logical_T_37, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_38 = cat(logical_hi_19, logical_lo_19) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_18 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_39 = dshr(_lut_WIRE_lut_T_18, _logical_T_38) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_lo_hi_hi = bits(_logical_T_39, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_40 = cat(logical_hi_20, logical_lo_20) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_19 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_41 = dshr(_lut_WIRE_lut_T_19, _logical_T_40) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_hi_lo_lo = bits(_logical_T_41, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_42 = cat(logical_hi_21, logical_lo_21) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_20 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_43 = dshr(_lut_WIRE_lut_T_20, _logical_T_42) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_hi_lo_hi = bits(_logical_T_43, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_44 = cat(logical_hi_22, logical_lo_22) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_21 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_45 = dshr(_lut_WIRE_lut_T_21, _logical_T_44) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_hi_hi_lo = bits(_logical_T_45, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_46 = cat(logical_hi_23, logical_lo_23) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_22 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_47 = dshr(_lut_WIRE_lut_T_22, _logical_T_46) @[Atomics.scala 42:8]
    node logical_lo_hi_lo_hi_hi_hi = bits(_logical_T_47, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_48 = cat(logical_hi_24, logical_lo_24) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_23 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_49 = dshr(_lut_WIRE_lut_T_23, _logical_T_48) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_lo_lo_lo = bits(_logical_T_49, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_50 = cat(logical_hi_25, logical_lo_25) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_24 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_51 = dshr(_lut_WIRE_lut_T_24, _logical_T_50) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_lo_lo_hi = bits(_logical_T_51, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_52 = cat(logical_hi_26, logical_lo_26) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_25 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_53 = dshr(_lut_WIRE_lut_T_25, _logical_T_52) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_lo_hi_lo = bits(_logical_T_53, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_54 = cat(logical_hi_27, logical_lo_27) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_26 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_55 = dshr(_lut_WIRE_lut_T_26, _logical_T_54) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_lo_hi_hi = bits(_logical_T_55, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_56 = cat(logical_hi_28, logical_lo_28) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_27 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_57 = dshr(_lut_WIRE_lut_T_27, _logical_T_56) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_hi_lo_lo = bits(_logical_T_57, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_58 = cat(logical_hi_29, logical_lo_29) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_28 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_59 = dshr(_lut_WIRE_lut_T_28, _logical_T_58) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_hi_lo_hi = bits(_logical_T_59, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_60 = cat(logical_hi_30, logical_lo_30) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_29 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_61 = dshr(_lut_WIRE_lut_T_29, _logical_T_60) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_hi_hi_lo = bits(_logical_T_61, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_62 = cat(logical_hi_31, logical_lo_31) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_30 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_63 = dshr(_lut_WIRE_lut_T_30, _logical_T_62) @[Atomics.scala 42:8]
    node logical_lo_hi_hi_hi_hi_hi = bits(_logical_T_63, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_64 = cat(logical_hi_32, logical_lo_32) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_31 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_65 = dshr(_lut_WIRE_lut_T_31, _logical_T_64) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_lo_lo_lo = bits(_logical_T_65, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_66 = cat(logical_hi_33, logical_lo_33) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_32 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_67 = dshr(_lut_WIRE_lut_T_32, _logical_T_66) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_lo_lo_hi = bits(_logical_T_67, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_68 = cat(logical_hi_34, logical_lo_34) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_33 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_69 = dshr(_lut_WIRE_lut_T_33, _logical_T_68) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_lo_hi_lo = bits(_logical_T_69, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_70 = cat(logical_hi_35, logical_lo_35) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_34 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_71 = dshr(_lut_WIRE_lut_T_34, _logical_T_70) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_lo_hi_hi = bits(_logical_T_71, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_72 = cat(logical_hi_36, logical_lo_36) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_35 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_73 = dshr(_lut_WIRE_lut_T_35, _logical_T_72) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_hi_lo_lo = bits(_logical_T_73, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_74 = cat(logical_hi_37, logical_lo_37) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_36 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_75 = dshr(_lut_WIRE_lut_T_36, _logical_T_74) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_hi_lo_hi = bits(_logical_T_75, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_76 = cat(logical_hi_38, logical_lo_38) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_37 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_77 = dshr(_lut_WIRE_lut_T_37, _logical_T_76) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_hi_hi_lo = bits(_logical_T_77, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_78 = cat(logical_hi_39, logical_lo_39) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_38 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_79 = dshr(_lut_WIRE_lut_T_38, _logical_T_78) @[Atomics.scala 42:8]
    node logical_hi_lo_lo_hi_hi_hi = bits(_logical_T_79, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_80 = cat(logical_hi_40, logical_lo_40) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_39 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_81 = dshr(_lut_WIRE_lut_T_39, _logical_T_80) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_lo_lo_lo = bits(_logical_T_81, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_82 = cat(logical_hi_41, logical_lo_41) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_40 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_83 = dshr(_lut_WIRE_lut_T_40, _logical_T_82) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_lo_lo_hi = bits(_logical_T_83, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_84 = cat(logical_hi_42, logical_lo_42) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_41 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_85 = dshr(_lut_WIRE_lut_T_41, _logical_T_84) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_lo_hi_lo = bits(_logical_T_85, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_86 = cat(logical_hi_43, logical_lo_43) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_42 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_87 = dshr(_lut_WIRE_lut_T_42, _logical_T_86) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_lo_hi_hi = bits(_logical_T_87, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_88 = cat(logical_hi_44, logical_lo_44) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_43 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_89 = dshr(_lut_WIRE_lut_T_43, _logical_T_88) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_hi_lo_lo = bits(_logical_T_89, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_90 = cat(logical_hi_45, logical_lo_45) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_44 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_91 = dshr(_lut_WIRE_lut_T_44, _logical_T_90) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_hi_lo_hi = bits(_logical_T_91, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_92 = cat(logical_hi_46, logical_lo_46) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_45 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_93 = dshr(_lut_WIRE_lut_T_45, _logical_T_92) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_hi_hi_lo = bits(_logical_T_93, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_94 = cat(logical_hi_47, logical_lo_47) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_46 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_95 = dshr(_lut_WIRE_lut_T_46, _logical_T_94) @[Atomics.scala 42:8]
    node logical_hi_lo_hi_hi_hi_hi = bits(_logical_T_95, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_96 = cat(logical_hi_48, logical_lo_48) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_47 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_97 = dshr(_lut_WIRE_lut_T_47, _logical_T_96) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_lo_lo_lo = bits(_logical_T_97, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_98 = cat(logical_hi_49, logical_lo_49) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_48 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_99 = dshr(_lut_WIRE_lut_T_48, _logical_T_98) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_lo_lo_hi = bits(_logical_T_99, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_100 = cat(logical_hi_50, logical_lo_50) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_49 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_101 = dshr(_lut_WIRE_lut_T_49, _logical_T_100) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_lo_hi_lo = bits(_logical_T_101, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_102 = cat(logical_hi_51, logical_lo_51) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_50 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_103 = dshr(_lut_WIRE_lut_T_50, _logical_T_102) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_lo_hi_hi = bits(_logical_T_103, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_104 = cat(logical_hi_52, logical_lo_52) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_51 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_105 = dshr(_lut_WIRE_lut_T_51, _logical_T_104) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_hi_lo_lo = bits(_logical_T_105, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_106 = cat(logical_hi_53, logical_lo_53) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_52 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_107 = dshr(_lut_WIRE_lut_T_52, _logical_T_106) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_hi_lo_hi = bits(_logical_T_107, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_108 = cat(logical_hi_54, logical_lo_54) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_53 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_109 = dshr(_lut_WIRE_lut_T_53, _logical_T_108) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_hi_hi_lo = bits(_logical_T_109, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_110 = cat(logical_hi_55, logical_lo_55) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_54 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_111 = dshr(_lut_WIRE_lut_T_54, _logical_T_110) @[Atomics.scala 42:8]
    node logical_hi_hi_lo_hi_hi_hi = bits(_logical_T_111, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_112 = cat(logical_hi_56, logical_lo_56) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_55 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_113 = dshr(_lut_WIRE_lut_T_55, _logical_T_112) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_lo_lo_lo = bits(_logical_T_113, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_114 = cat(logical_hi_57, logical_lo_57) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_56 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_115 = dshr(_lut_WIRE_lut_T_56, _logical_T_114) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_lo_lo_hi = bits(_logical_T_115, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_116 = cat(logical_hi_58, logical_lo_58) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_57 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_117 = dshr(_lut_WIRE_lut_T_57, _logical_T_116) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_lo_hi_lo = bits(_logical_T_117, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_118 = cat(logical_hi_59, logical_lo_59) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_58 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_119 = dshr(_lut_WIRE_lut_T_58, _logical_T_118) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_lo_hi_hi = bits(_logical_T_119, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_120 = cat(logical_hi_60, logical_lo_60) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_59 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_121 = dshr(_lut_WIRE_lut_T_59, _logical_T_120) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_hi_lo_lo = bits(_logical_T_121, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_122 = cat(logical_hi_61, logical_lo_61) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_60 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_123 = dshr(_lut_WIRE_lut_T_60, _logical_T_122) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_hi_lo_hi = bits(_logical_T_123, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_124 = cat(logical_hi_62, logical_lo_62) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_61 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_125 = dshr(_lut_WIRE_lut_T_61, _logical_T_124) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_hi_hi_lo = bits(_logical_T_125, 0, 0) @[Atomics.scala 42:8]
    node _logical_T_126 = cat(logical_hi_63, logical_lo_63) @[Cat.scala 30:58]
    node _lut_WIRE_lut_T_62 = _GEN_3 @[Atomics.scala 42:8]
    node _logical_T_127 = dshr(_lut_WIRE_lut_T_62, _logical_T_126) @[Atomics.scala 42:8]
    node logical_hi_hi_hi_hi_hi_hi = bits(_logical_T_127, 0, 0) @[Atomics.scala 42:8]
    node logical_lo_lo_lo_lo_lo = cat(logical_lo_lo_lo_lo_lo_hi, logical_lo_lo_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_lo_lo_hi = cat(logical_lo_lo_lo_lo_hi_hi, logical_lo_lo_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo_lo_lo = cat(logical_lo_lo_lo_lo_hi, logical_lo_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_lo_hi_lo = cat(logical_lo_lo_lo_hi_lo_hi, logical_lo_lo_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_lo_hi_hi = cat(logical_lo_lo_lo_hi_hi_hi, logical_lo_lo_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo_lo_hi = cat(logical_lo_lo_lo_hi_hi, logical_lo_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo_lo = cat(logical_lo_lo_lo_hi, logical_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi_lo_lo = cat(logical_lo_lo_hi_lo_lo_hi, logical_lo_lo_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi_lo_hi = cat(logical_lo_lo_hi_lo_hi_hi, logical_lo_lo_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi_lo = cat(logical_lo_lo_hi_lo_hi, logical_lo_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi_hi_lo = cat(logical_lo_lo_hi_hi_lo_hi, logical_lo_lo_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi_hi_hi = cat(logical_lo_lo_hi_hi_hi_hi, logical_lo_lo_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi_hi = cat(logical_lo_lo_hi_hi_hi, logical_lo_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo_hi = cat(logical_lo_lo_hi_hi, logical_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_lo = cat(logical_lo_lo_hi, logical_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo_lo_lo = cat(logical_lo_hi_lo_lo_lo_hi, logical_lo_hi_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo_lo_hi = cat(logical_lo_hi_lo_lo_hi_hi, logical_lo_hi_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo_lo = cat(logical_lo_hi_lo_lo_hi, logical_lo_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo_hi_lo = cat(logical_lo_hi_lo_hi_lo_hi, logical_lo_hi_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo_hi_hi = cat(logical_lo_hi_lo_hi_hi_hi, logical_lo_hi_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo_hi = cat(logical_lo_hi_lo_hi_hi, logical_lo_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi_lo = cat(logical_lo_hi_lo_hi, logical_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi_lo_lo = cat(logical_lo_hi_hi_lo_lo_hi, logical_lo_hi_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi_lo_hi = cat(logical_lo_hi_hi_lo_hi_hi, logical_lo_hi_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi_lo = cat(logical_lo_hi_hi_lo_hi, logical_lo_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi_hi_lo = cat(logical_lo_hi_hi_hi_lo_hi, logical_lo_hi_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi_hi_hi = cat(logical_lo_hi_hi_hi_hi_hi, logical_lo_hi_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi_hi = cat(logical_lo_hi_hi_hi_hi, logical_lo_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi_hi = cat(logical_lo_hi_hi_hi, logical_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_lo_hi = cat(logical_lo_hi_hi, logical_lo_hi_lo) @[Cat.scala 30:58]
    node logical_lo_64 = cat(logical_lo_hi, logical_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo_lo_lo = cat(logical_hi_lo_lo_lo_lo_hi, logical_hi_lo_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo_lo_hi = cat(logical_hi_lo_lo_lo_hi_hi, logical_hi_lo_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo_lo = cat(logical_hi_lo_lo_lo_hi, logical_hi_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo_hi_lo = cat(logical_hi_lo_lo_hi_lo_hi, logical_hi_lo_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo_hi_hi = cat(logical_hi_lo_lo_hi_hi_hi, logical_hi_lo_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo_hi = cat(logical_hi_lo_lo_hi_hi, logical_hi_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo_lo = cat(logical_hi_lo_lo_hi, logical_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi_lo_lo = cat(logical_hi_lo_hi_lo_lo_hi, logical_hi_lo_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi_lo_hi = cat(logical_hi_lo_hi_lo_hi_hi, logical_hi_lo_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi_lo = cat(logical_hi_lo_hi_lo_hi, logical_hi_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi_hi_lo = cat(logical_hi_lo_hi_hi_lo_hi, logical_hi_lo_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi_hi_hi = cat(logical_hi_lo_hi_hi_hi_hi, logical_hi_lo_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi_hi = cat(logical_hi_lo_hi_hi_hi, logical_hi_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo_hi = cat(logical_hi_lo_hi_hi, logical_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_lo = cat(logical_hi_lo_hi, logical_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo_lo_lo = cat(logical_hi_hi_lo_lo_lo_hi, logical_hi_hi_lo_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo_lo_hi = cat(logical_hi_hi_lo_lo_hi_hi, logical_hi_hi_lo_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo_lo = cat(logical_hi_hi_lo_lo_hi, logical_hi_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo_hi_lo = cat(logical_hi_hi_lo_hi_lo_hi, logical_hi_hi_lo_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo_hi_hi = cat(logical_hi_hi_lo_hi_hi_hi, logical_hi_hi_lo_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo_hi = cat(logical_hi_hi_lo_hi_hi, logical_hi_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi_lo = cat(logical_hi_hi_lo_hi, logical_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi_lo_lo = cat(logical_hi_hi_hi_lo_lo_hi, logical_hi_hi_hi_lo_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi_lo_hi = cat(logical_hi_hi_hi_lo_hi_hi, logical_hi_hi_hi_lo_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi_lo = cat(logical_hi_hi_hi_lo_hi, logical_hi_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi_hi_lo = cat(logical_hi_hi_hi_hi_lo_hi, logical_hi_hi_hi_hi_lo_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi_hi_hi = cat(logical_hi_hi_hi_hi_hi_hi, logical_hi_hi_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi_hi = cat(logical_hi_hi_hi_hi_hi, logical_hi_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi_hi = cat(logical_hi_hi_hi_hi, logical_hi_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_hi = cat(logical_hi_hi_hi, logical_hi_hi_lo) @[Cat.scala 30:58]
    node logical_hi_64 = cat(logical_hi_hi, logical_hi_lo) @[Cat.scala 30:58]
    node logical = cat(logical_hi_64, logical_lo_64) @[Cat.scala 30:58]
    node _select_T = mux(pick_a, UInt<1>("h1"), UInt<1>("h0")) @[Atomics.scala 49:28]
    node _select_T_1 = mux(adder, UInt<2>("h2"), _select_T) @[Atomics.scala 49:8]
    node _select_WIRE_0 = pad(UInt<1>("h1"), 2) @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_4 = validif(eq(UInt<1>("h0"), io_a_opcode), _select_WIRE_0) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_1 = pad(UInt<1>("h1"), 2) @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_5 = mux(eq(UInt<1>("h1"), io_a_opcode), _select_WIRE_1, _GEN_4) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_2 = _select_T_1 @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_6 = mux(eq(UInt<2>("h2"), io_a_opcode), _select_WIRE_2, _GEN_5) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_3 = UInt<2>("h3") @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_7 = mux(eq(UInt<2>("h3"), io_a_opcode), _select_WIRE_3, _GEN_6) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_4 = pad(UInt<1>("h0"), 2) @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_8 = mux(eq(UInt<3>("h4"), io_a_opcode), _select_WIRE_4, _GEN_7) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_5 = pad(UInt<1>("h0"), 2) @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_9 = mux(eq(UInt<3>("h5"), io_a_opcode), _select_WIRE_5, _GEN_8) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_6 = pad(UInt<1>("h0"), 2) @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_10 = mux(eq(UInt<3>("h6"), io_a_opcode), _select_WIRE_6, _GEN_9) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_7 = pad(UInt<1>("h0"), 2) @[Atomics.scala 46:42 Atomics.scala 46:42]
    node _GEN_11 = mux(eq(UInt<3>("h7"), io_a_opcode), _select_WIRE_7, _GEN_10) @[Atomics.scala 46:19 Atomics.scala 46:19]
    node _select_WIRE_io_a_opcode = _GEN_11 @[Atomics.scala 46:19]
    node select = mux(io_write, UInt<1>("h1"), _select_WIRE_io_a_opcode) @[Atomics.scala 46:19]
    node _selects_T = bits(io_a_mask, 0, 0) @[Atomics.scala 58:27]
    node _selects_T_1 = bits(io_a_mask, 1, 1) @[Atomics.scala 58:27]
    node _selects_T_2 = bits(io_a_mask, 2, 2) @[Atomics.scala 58:27]
    node _selects_T_3 = bits(io_a_mask, 3, 3) @[Atomics.scala 58:27]
    node _selects_T_4 = bits(io_a_mask, 4, 4) @[Atomics.scala 58:27]
    node _selects_T_5 = bits(io_a_mask, 5, 5) @[Atomics.scala 58:27]
    node _selects_T_6 = bits(io_a_mask, 6, 6) @[Atomics.scala 58:27]
    node _selects_T_7 = bits(io_a_mask, 7, 7) @[Atomics.scala 58:27]
    node selects_0 = mux(_selects_T, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_1 = mux(_selects_T_1, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_2 = mux(_selects_T_2, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_3 = mux(_selects_T_3, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_4 = mux(_selects_T_4, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_5 = mux(_selects_T_5, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_6 = mux(_selects_T_6, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node selects_7 = mux(_selects_T_7, select, UInt<1>("h0")) @[Atomics.scala 58:47]
    node _io_data_out_T = bits(io_data_in, 7, 0) @[Atomics.scala 60:55]
    node _io_data_out_T_1 = bits(io_a_data, 7, 0) @[Atomics.scala 60:55]
    node _io_data_out_T_2 = bits(sum, 7, 0) @[Atomics.scala 60:55]
    node _io_data_out_T_3 = bits(logical, 7, 0) @[Atomics.scala 60:55]
    node _io_data_out_T_4 = bits(io_data_in, 15, 8) @[Atomics.scala 60:55]
    node _io_data_out_T_5 = bits(io_a_data, 15, 8) @[Atomics.scala 60:55]
    node _io_data_out_T_6 = bits(sum, 15, 8) @[Atomics.scala 60:55]
    node _io_data_out_T_7 = bits(logical, 15, 8) @[Atomics.scala 60:55]
    node _io_data_out_T_8 = bits(io_data_in, 23, 16) @[Atomics.scala 60:55]
    node _io_data_out_T_9 = bits(io_a_data, 23, 16) @[Atomics.scala 60:55]
    node _io_data_out_T_10 = bits(sum, 23, 16) @[Atomics.scala 60:55]
    node _io_data_out_T_11 = bits(logical, 23, 16) @[Atomics.scala 60:55]
    node _io_data_out_T_12 = bits(io_data_in, 31, 24) @[Atomics.scala 60:55]
    node _io_data_out_T_13 = bits(io_a_data, 31, 24) @[Atomics.scala 60:55]
    node _io_data_out_T_14 = bits(sum, 31, 24) @[Atomics.scala 60:55]
    node _io_data_out_T_15 = bits(logical, 31, 24) @[Atomics.scala 60:55]
    node _io_data_out_T_16 = bits(io_data_in, 39, 32) @[Atomics.scala 60:55]
    node _io_data_out_T_17 = bits(io_a_data, 39, 32) @[Atomics.scala 60:55]
    node _io_data_out_T_18 = bits(sum, 39, 32) @[Atomics.scala 60:55]
    node _io_data_out_T_19 = bits(logical, 39, 32) @[Atomics.scala 60:55]
    node _io_data_out_T_20 = bits(io_data_in, 47, 40) @[Atomics.scala 60:55]
    node _io_data_out_T_21 = bits(io_a_data, 47, 40) @[Atomics.scala 60:55]
    node _io_data_out_T_22 = bits(sum, 47, 40) @[Atomics.scala 60:55]
    node _io_data_out_T_23 = bits(logical, 47, 40) @[Atomics.scala 60:55]
    node _io_data_out_T_24 = bits(io_data_in, 55, 48) @[Atomics.scala 60:55]
    node _io_data_out_T_25 = bits(io_a_data, 55, 48) @[Atomics.scala 60:55]
    node _io_data_out_T_26 = bits(sum, 55, 48) @[Atomics.scala 60:55]
    node _io_data_out_T_27 = bits(logical, 55, 48) @[Atomics.scala 60:55]
    node _io_data_out_T_28 = bits(io_data_in, 63, 56) @[Atomics.scala 60:55]
    node _io_data_out_T_29 = bits(io_a_data, 63, 56) @[Atomics.scala 60:55]
    node _io_data_out_T_30 = bits(sum, 63, 56) @[Atomics.scala 60:55]
    node _io_data_out_T_31 = bits(logical, 63, 56) @[Atomics.scala 60:55]
    node _io_data_out_WIRE_1_0 = _io_data_out_T_4 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_12 = validif(eq(UInt<1>("h0"), selects_1), _io_data_out_WIRE_1_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_1_1 = _io_data_out_T_5 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_13 = mux(eq(UInt<1>("h1"), selects_1), _io_data_out_WIRE_1_1, _GEN_12) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_1_2 = _io_data_out_T_6 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_14 = mux(eq(UInt<2>("h2"), selects_1), _io_data_out_WIRE_1_2, _GEN_13) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_1_3 = _io_data_out_T_7 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_15 = mux(eq(UInt<2>("h3"), selects_1), _io_data_out_WIRE_1_3, _GEN_14) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE__0 = _io_data_out_T @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_16 = validif(eq(UInt<1>("h0"), selects_0), _io_data_out_WIRE__0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE__1 = _io_data_out_T_1 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_17 = mux(eq(UInt<1>("h1"), selects_0), _io_data_out_WIRE__1, _GEN_16) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE__2 = _io_data_out_T_2 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_18 = mux(eq(UInt<2>("h2"), selects_0), _io_data_out_WIRE__2, _GEN_17) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE__3 = _io_data_out_T_3 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_19 = mux(eq(UInt<2>("h3"), selects_0), _io_data_out_WIRE__3, _GEN_18) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_1_selects_1 = _GEN_15 @[Cat.scala 30:58]
    node _io_data_out_WIRE_selects_0 = _GEN_19 @[Cat.scala 30:58]
    node io_data_out_lo_lo = cat(_io_data_out_WIRE_1_selects_1, _io_data_out_WIRE_selects_0) @[Cat.scala 30:58]
    node _io_data_out_WIRE_3_0 = _io_data_out_T_12 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_20 = validif(eq(UInt<1>("h0"), selects_3), _io_data_out_WIRE_3_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_3_1 = _io_data_out_T_13 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_21 = mux(eq(UInt<1>("h1"), selects_3), _io_data_out_WIRE_3_1, _GEN_20) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_3_2 = _io_data_out_T_14 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_22 = mux(eq(UInt<2>("h2"), selects_3), _io_data_out_WIRE_3_2, _GEN_21) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_3_3 = _io_data_out_T_15 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_23 = mux(eq(UInt<2>("h3"), selects_3), _io_data_out_WIRE_3_3, _GEN_22) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_2_0 = _io_data_out_T_8 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_24 = validif(eq(UInt<1>("h0"), selects_2), _io_data_out_WIRE_2_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_2_1 = _io_data_out_T_9 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_25 = mux(eq(UInt<1>("h1"), selects_2), _io_data_out_WIRE_2_1, _GEN_24) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_2_2 = _io_data_out_T_10 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_26 = mux(eq(UInt<2>("h2"), selects_2), _io_data_out_WIRE_2_2, _GEN_25) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_2_3 = _io_data_out_T_11 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_27 = mux(eq(UInt<2>("h3"), selects_2), _io_data_out_WIRE_2_3, _GEN_26) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_3_selects_3 = _GEN_23 @[Cat.scala 30:58]
    node _io_data_out_WIRE_2_selects_2 = _GEN_27 @[Cat.scala 30:58]
    node io_data_out_lo_hi = cat(_io_data_out_WIRE_3_selects_3, _io_data_out_WIRE_2_selects_2) @[Cat.scala 30:58]
    node io_data_out_lo = cat(io_data_out_lo_hi, io_data_out_lo_lo) @[Cat.scala 30:58]
    node _io_data_out_WIRE_5_0 = _io_data_out_T_20 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_28 = validif(eq(UInt<1>("h0"), selects_5), _io_data_out_WIRE_5_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_5_1 = _io_data_out_T_21 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_29 = mux(eq(UInt<1>("h1"), selects_5), _io_data_out_WIRE_5_1, _GEN_28) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_5_2 = _io_data_out_T_22 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_30 = mux(eq(UInt<2>("h2"), selects_5), _io_data_out_WIRE_5_2, _GEN_29) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_5_3 = _io_data_out_T_23 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_31 = mux(eq(UInt<2>("h3"), selects_5), _io_data_out_WIRE_5_3, _GEN_30) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_4_0 = _io_data_out_T_16 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_32 = validif(eq(UInt<1>("h0"), selects_4), _io_data_out_WIRE_4_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_4_1 = _io_data_out_T_17 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_33 = mux(eq(UInt<1>("h1"), selects_4), _io_data_out_WIRE_4_1, _GEN_32) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_4_2 = _io_data_out_T_18 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_34 = mux(eq(UInt<2>("h2"), selects_4), _io_data_out_WIRE_4_2, _GEN_33) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_4_3 = _io_data_out_T_19 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_35 = mux(eq(UInt<2>("h3"), selects_4), _io_data_out_WIRE_4_3, _GEN_34) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_5_selects_5 = _GEN_31 @[Cat.scala 30:58]
    node _io_data_out_WIRE_4_selects_4 = _GEN_35 @[Cat.scala 30:58]
    node io_data_out_hi_lo = cat(_io_data_out_WIRE_5_selects_5, _io_data_out_WIRE_4_selects_4) @[Cat.scala 30:58]
    node _io_data_out_WIRE_7_0 = _io_data_out_T_28 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_36 = validif(eq(UInt<1>("h0"), selects_7), _io_data_out_WIRE_7_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_7_1 = _io_data_out_T_29 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_37 = mux(eq(UInt<1>("h1"), selects_7), _io_data_out_WIRE_7_1, _GEN_36) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_7_2 = _io_data_out_T_30 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_38 = mux(eq(UInt<2>("h2"), selects_7), _io_data_out_WIRE_7_2, _GEN_37) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_7_3 = _io_data_out_T_31 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_39 = mux(eq(UInt<2>("h3"), selects_7), _io_data_out_WIRE_7_3, _GEN_38) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_6_0 = _io_data_out_T_24 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_40 = validif(eq(UInt<1>("h0"), selects_6), _io_data_out_WIRE_6_0) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_6_1 = _io_data_out_T_25 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_41 = mux(eq(UInt<1>("h1"), selects_6), _io_data_out_WIRE_6_1, _GEN_40) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_6_2 = _io_data_out_T_26 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_42 = mux(eq(UInt<2>("h2"), selects_6), _io_data_out_WIRE_6_2, _GEN_41) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_6_3 = _io_data_out_T_27 @[Atomics.scala 60:8 Atomics.scala 60:8]
    node _GEN_43 = mux(eq(UInt<2>("h3"), selects_6), _io_data_out_WIRE_6_3, _GEN_42) @[Cat.scala 30:58 Cat.scala 30:58]
    node _io_data_out_WIRE_7_selects_7 = _GEN_39 @[Cat.scala 30:58]
    node _io_data_out_WIRE_6_selects_6 = _GEN_43 @[Cat.scala 30:58]
    node io_data_out_hi_hi = cat(_io_data_out_WIRE_7_selects_7, _io_data_out_WIRE_6_selects_6) @[Cat.scala 30:58]
    node io_data_out_hi = cat(io_data_out_hi_hi, io_data_out_hi_lo) @[Cat.scala 30:58]
    node _io_data_out_T_32 = cat(io_data_out_hi, io_data_out_lo) @[Cat.scala 30:58]
    io_data_out <= _io_data_out_T_32 @[Atomics.scala 59:15]

  module TLRAM :
    input clock : Clock
    input reset : UInt<1>
    output auto_in_a_ready : UInt<1>
    input auto_in_a_valid : UInt<1>
    input auto_in_a_bits_opcode : UInt<3>
    input auto_in_a_bits_param : UInt<3>
    input auto_in_a_bits_size : UInt<2>
    input auto_in_a_bits_source : UInt<3>
    input auto_in_a_bits_address : UInt<9>
    input auto_in_a_bits_mask : UInt<8>
    input auto_in_a_bits_data : UInt<64>
    input auto_in_a_bits_corrupt : UInt<1>
    input auto_in_d_ready : UInt<1>
    output auto_in_d_valid : UInt<1>
    output auto_in_d_bits_opcode : UInt<3>
    output auto_in_d_bits_param : UInt<2>
    output auto_in_d_bits_size : UInt<2>
    output auto_in_d_bits_source : UInt<3>
    output auto_in_d_bits_sink : UInt<1>
    output auto_in_d_bits_denied : UInt<1>
    output auto_in_d_bits_data : UInt<64>
    output auto_in_d_bits_corrupt : UInt<1>

    mem mem_0 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_1 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_2 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_3 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_4 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_5 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_6 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    mem mem_7 : @[DescribedSRAM.scala 19:26]
      data-type => UInt<8>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => MPORT
      writer => MPORT_1
      read-under-write => undefined
    inst d_updated_alu of Atomics @[SRAM.scala 184:23]
    reg d_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), d_full) @[SRAM.scala 118:30]
    reg d_respond : UInt<1>, clock with :
      reset => (UInt<1>("h0"), d_respond) @[SRAM.scala 119:26]
    reg d_opcode : UInt<3>, clock with :
      reset => (UInt<1>("h0"), d_opcode) @[SRAM.scala 120:26]
    reg d_param : UInt<3>, clock with :
      reset => (UInt<1>("h0"), d_param) @[SRAM.scala 121:26]
    reg d_size : UInt<2>, clock with :
      reset => (UInt<1>("h0"), d_size) @[SRAM.scala 122:26]
    reg d_source : UInt<3>, clock with :
      reset => (UInt<1>("h0"), d_source) @[SRAM.scala 123:26]
    reg d_read : UInt<1>, clock with :
      reset => (UInt<1>("h0"), d_read) @[SRAM.scala 124:26]
    reg d_atomic : UInt<1>, clock with :
      reset => (UInt<1>("h0"), d_atomic) @[SRAM.scala 125:26]
    reg d_sublane : UInt<1>, clock with :
      reset => (UInt<1>("h0"), d_sublane) @[SRAM.scala 126:26]
    reg d_address : UInt<9>, clock with :
      reset => (UInt<1>("h0"), d_address) @[SRAM.scala 127:26]
    reg d_mask : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_mask) @[SRAM.scala 128:26]
    reg d_rmw_data : UInt<64>, clock with :
      reset => (UInt<1>("h0"), d_rmw_data) @[SRAM.scala 129:26]
    reg d_poison : UInt<1>, clock with :
      reset => (UInt<1>("h0"), d_poison) @[SRAM.scala 130:26]
    reg d_raw_data_0 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_0) @[SRAM.scala 131:26]
    reg d_raw_data_1 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_1) @[SRAM.scala 131:26]
    reg d_raw_data_2 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_2) @[SRAM.scala 131:26]
    reg d_raw_data_3 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_3) @[SRAM.scala 131:26]
    reg d_raw_data_4 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_4) @[SRAM.scala 131:26]
    reg d_raw_data_5 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_5) @[SRAM.scala 131:26]
    reg d_raw_data_6 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_6) @[SRAM.scala 131:26]
    reg d_raw_data_7 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), d_raw_data_7) @[SRAM.scala 131:26]
    reg r_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_full) @[SRAM.scala 134:30]
    reg r_opcode : UInt<3>, clock with :
      reset => (UInt<1>("h0"), r_opcode) @[SRAM.scala 135:26]
    reg r_param : UInt<3>, clock with :
      reset => (UInt<1>("h0"), r_param) @[SRAM.scala 136:26]
    reg r_size : UInt<2>, clock with :
      reset => (UInt<1>("h0"), r_size) @[SRAM.scala 137:26]
    reg r_source : UInt<3>, clock with :
      reset => (UInt<1>("h0"), r_source) @[SRAM.scala 138:26]
    reg r_read : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_read) @[SRAM.scala 139:26]
    reg r_atomic : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_atomic) @[SRAM.scala 140:26]
    reg r_sublane : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_sublane) @[SRAM.scala 141:26]
    reg r_address : UInt<9>, clock with :
      reset => (UInt<1>("h0"), r_address) @[SRAM.scala 142:26]
    reg r_mask : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_mask) @[SRAM.scala 143:26]
    reg r_rmw_data : UInt<64>, clock with :
      reset => (UInt<1>("h0"), r_rmw_data) @[SRAM.scala 144:26]
    reg r_poison : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_poison) @[SRAM.scala 145:26]
    node d_corrected_lo_lo = cat(d_raw_data_1, d_raw_data_0) @[Cat.scala 30:58]
    node d_corrected_lo_hi = cat(d_raw_data_3, d_raw_data_2) @[Cat.scala 30:58]
    node d_corrected_lo = cat(d_corrected_lo_hi, d_corrected_lo_lo) @[Cat.scala 30:58]
    node d_corrected_hi_lo = cat(d_raw_data_5, d_raw_data_4) @[Cat.scala 30:58]
    node d_corrected_hi_hi = cat(d_raw_data_7, d_raw_data_6) @[Cat.scala 30:58]
    node d_corrected_hi = cat(d_corrected_hi_hi, d_corrected_hi_lo) @[Cat.scala 30:58]
    node d_corrected = cat(d_corrected_hi, d_corrected_lo) @[Cat.scala 30:58]
    node d_uncorrected_lo_lo = cat(d_raw_data_1, d_raw_data_0) @[Cat.scala 30:58]
    node d_uncorrected_lo_hi = cat(d_raw_data_3, d_raw_data_2) @[Cat.scala 30:58]
    node d_uncorrected_lo = cat(d_uncorrected_lo_hi, d_uncorrected_lo_lo) @[Cat.scala 30:58]
    node d_uncorrected_hi_lo = cat(d_raw_data_5, d_raw_data_4) @[Cat.scala 30:58]
    node d_uncorrected_hi_hi = cat(d_raw_data_7, d_raw_data_6) @[Cat.scala 30:58]
    node d_uncorrected_hi = cat(d_uncorrected_hi_hi, d_uncorrected_hi_lo) @[Cat.scala 30:58]
    node d_uncorrected = cat(d_uncorrected_hi, d_uncorrected_lo) @[Cat.scala 30:58]
    node _d_need_fix_T = or(UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 154:50]
    node _d_need_fix_T_1 = or(_d_need_fix_T, UInt<1>("h0")) @[SRAM.scala 154:50]
    node _d_need_fix_T_2 = or(_d_need_fix_T_1, UInt<1>("h0")) @[SRAM.scala 154:50]
    node _d_need_fix_T_3 = or(_d_need_fix_T_2, UInt<1>("h0")) @[SRAM.scala 154:50]
    node _d_need_fix_T_4 = or(_d_need_fix_T_3, UInt<1>("h0")) @[SRAM.scala 154:50]
    node _d_need_fix_T_5 = or(_d_need_fix_T_4, UInt<1>("h0")) @[SRAM.scala 154:50]
    node d_need_fix = or(_d_need_fix_T_5, UInt<1>("h0")) @[SRAM.scala 154:50]
    node _d_lanes_T = bits(d_mask, 0, 0) @[SRAM.scala 155:64]
    node d_lanes_lo_lo_lo = orr(_d_lanes_T) @[SRAM.scala 155:95]
    node _d_lanes_T_1 = bits(d_mask, 1, 1) @[SRAM.scala 155:64]
    node d_lanes_lo_lo_hi = orr(_d_lanes_T_1) @[SRAM.scala 155:95]
    node _d_lanes_T_2 = bits(d_mask, 2, 2) @[SRAM.scala 155:64]
    node d_lanes_lo_hi_lo = orr(_d_lanes_T_2) @[SRAM.scala 155:95]
    node _d_lanes_T_3 = bits(d_mask, 3, 3) @[SRAM.scala 155:64]
    node d_lanes_lo_hi_hi = orr(_d_lanes_T_3) @[SRAM.scala 155:95]
    node _d_lanes_T_4 = bits(d_mask, 4, 4) @[SRAM.scala 155:64]
    node d_lanes_hi_lo_lo = orr(_d_lanes_T_4) @[SRAM.scala 155:95]
    node _d_lanes_T_5 = bits(d_mask, 5, 5) @[SRAM.scala 155:64]
    node d_lanes_hi_lo_hi = orr(_d_lanes_T_5) @[SRAM.scala 155:95]
    node _d_lanes_T_6 = bits(d_mask, 6, 6) @[SRAM.scala 155:64]
    node d_lanes_hi_hi_lo = orr(_d_lanes_T_6) @[SRAM.scala 155:95]
    node _d_lanes_T_7 = bits(d_mask, 7, 7) @[SRAM.scala 155:64]
    node d_lanes_hi_hi_hi = orr(_d_lanes_T_7) @[SRAM.scala 155:95]
    node d_lanes_lo_lo = cat(d_lanes_lo_lo_hi, d_lanes_lo_lo_lo) @[Cat.scala 30:58]
    node d_lanes_lo_hi = cat(d_lanes_lo_hi_hi, d_lanes_lo_hi_lo) @[Cat.scala 30:58]
    node d_lanes_lo = cat(d_lanes_lo_hi, d_lanes_lo_lo) @[Cat.scala 30:58]
    node d_lanes_hi_lo = cat(d_lanes_hi_lo_hi, d_lanes_hi_lo_lo) @[Cat.scala 30:58]
    node d_lanes_hi_hi = cat(d_lanes_hi_hi_hi, d_lanes_hi_hi_lo) @[Cat.scala 30:58]
    node d_lanes_hi = cat(d_lanes_hi_hi, d_lanes_hi_lo) @[Cat.scala 30:58]
    node d_lanes = cat(d_lanes_hi, d_lanes_lo) @[Cat.scala 30:58]
    node d_lane_error_lo_lo = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node d_lane_error_lo_hi = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node d_lane_error_lo = cat(d_lane_error_lo_hi, d_lane_error_lo_lo) @[Cat.scala 30:58]
    node d_lane_error_hi_lo = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node d_lane_error_hi_hi = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node d_lane_error_hi = cat(d_lane_error_hi_hi, d_lane_error_hi_lo) @[Cat.scala 30:58]
    node _d_lane_error_T = cat(d_lane_error_hi, d_lane_error_lo) @[Cat.scala 30:58]
    node d_lane_error = and(_d_lane_error_T, d_lanes) @[SRAM.scala 156:56]
    node d_error = orr(d_lane_error) @[SRAM.scala 157:40]
    reg REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), REG) @[SRAM.scala 321:58]
    reg r_1 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    node _T_22_1 = mux(REG, mem_1.MPORT.data, r_1) @[package.scala 79:42]
    node r_raw_data_1 = _T_22_1 @[SRAM.scala 146:27 SRAM.scala 321:16]
    reg r_0 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_0) @[Reg.scala 15:16]
    node _T_22_0 = mux(REG, mem_0.MPORT.data, r_0) @[package.scala 79:42]
    node r_raw_data_0 = _T_22_0 @[SRAM.scala 146:27 SRAM.scala 321:16]
    node r_corrected_lo_lo = cat(r_raw_data_1, r_raw_data_0) @[Cat.scala 30:58]
    reg r_3 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    node _T_22_3 = mux(REG, mem_3.MPORT.data, r_3) @[package.scala 79:42]
    node r_raw_data_3 = _T_22_3 @[SRAM.scala 146:27 SRAM.scala 321:16]
    reg r_2 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    node _T_22_2 = mux(REG, mem_2.MPORT.data, r_2) @[package.scala 79:42]
    node r_raw_data_2 = _T_22_2 @[SRAM.scala 146:27 SRAM.scala 321:16]
    node r_corrected_lo_hi = cat(r_raw_data_3, r_raw_data_2) @[Cat.scala 30:58]
    node r_corrected_lo = cat(r_corrected_lo_hi, r_corrected_lo_lo) @[Cat.scala 30:58]
    reg r_5 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_5) @[Reg.scala 15:16]
    node _T_22_5 = mux(REG, mem_5.MPORT.data, r_5) @[package.scala 79:42]
    node r_raw_data_5 = _T_22_5 @[SRAM.scala 146:27 SRAM.scala 321:16]
    reg r_4 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_4) @[Reg.scala 15:16]
    node _T_22_4 = mux(REG, mem_4.MPORT.data, r_4) @[package.scala 79:42]
    node r_raw_data_4 = _T_22_4 @[SRAM.scala 146:27 SRAM.scala 321:16]
    node r_corrected_hi_lo = cat(r_raw_data_5, r_raw_data_4) @[Cat.scala 30:58]
    reg r_7 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_7) @[Reg.scala 15:16]
    node _T_22_7 = mux(REG, mem_7.MPORT.data, r_7) @[package.scala 79:42]
    node r_raw_data_7 = _T_22_7 @[SRAM.scala 146:27 SRAM.scala 321:16]
    reg r_6 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_6) @[Reg.scala 15:16]
    node _T_22_6 = mux(REG, mem_6.MPORT.data, r_6) @[package.scala 79:42]
    node r_raw_data_6 = _T_22_6 @[SRAM.scala 146:27 SRAM.scala 321:16]
    node r_corrected_hi_hi = cat(r_raw_data_7, r_raw_data_6) @[Cat.scala 30:58]
    node r_corrected_hi = cat(r_corrected_hi_hi, r_corrected_hi_lo) @[Cat.scala 30:58]
    node r_corrected = cat(r_corrected_hi, r_corrected_lo) @[Cat.scala 30:58]
    node r_uncorrected_lo_lo = cat(r_raw_data_1, r_raw_data_0) @[Cat.scala 30:58]
    node r_uncorrected_lo_hi = cat(r_raw_data_3, r_raw_data_2) @[Cat.scala 30:58]
    node r_uncorrected_lo = cat(r_uncorrected_lo_hi, r_uncorrected_lo_lo) @[Cat.scala 30:58]
    node r_uncorrected_hi_lo = cat(r_raw_data_5, r_raw_data_4) @[Cat.scala 30:58]
    node r_uncorrected_hi_hi = cat(r_raw_data_7, r_raw_data_6) @[Cat.scala 30:58]
    node r_uncorrected_hi = cat(r_uncorrected_hi_hi, r_uncorrected_hi_lo) @[Cat.scala 30:58]
    node r_uncorrected = cat(r_uncorrected_hi, r_uncorrected_lo) @[Cat.scala 30:58]
    node _r_need_fix_T = or(UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 164:50]
    node _r_need_fix_T_1 = or(_r_need_fix_T, UInt<1>("h0")) @[SRAM.scala 164:50]
    node _r_need_fix_T_2 = or(_r_need_fix_T_1, UInt<1>("h0")) @[SRAM.scala 164:50]
    node _r_need_fix_T_3 = or(_r_need_fix_T_2, UInt<1>("h0")) @[SRAM.scala 164:50]
    node _r_need_fix_T_4 = or(_r_need_fix_T_3, UInt<1>("h0")) @[SRAM.scala 164:50]
    node _r_need_fix_T_5 = or(_r_need_fix_T_4, UInt<1>("h0")) @[SRAM.scala 164:50]
    node r_need_fix = or(_r_need_fix_T_5, UInt<1>("h0")) @[SRAM.scala 164:50]
    node _r_lanes_T = bits(r_mask, 0, 0) @[SRAM.scala 165:64]
    node r_lanes_lo_lo_lo = orr(_r_lanes_T) @[SRAM.scala 165:95]
    node _r_lanes_T_1 = bits(r_mask, 1, 1) @[SRAM.scala 165:64]
    node r_lanes_lo_lo_hi = orr(_r_lanes_T_1) @[SRAM.scala 165:95]
    node _r_lanes_T_2 = bits(r_mask, 2, 2) @[SRAM.scala 165:64]
    node r_lanes_lo_hi_lo = orr(_r_lanes_T_2) @[SRAM.scala 165:95]
    node _r_lanes_T_3 = bits(r_mask, 3, 3) @[SRAM.scala 165:64]
    node r_lanes_lo_hi_hi = orr(_r_lanes_T_3) @[SRAM.scala 165:95]
    node _r_lanes_T_4 = bits(r_mask, 4, 4) @[SRAM.scala 165:64]
    node r_lanes_hi_lo_lo = orr(_r_lanes_T_4) @[SRAM.scala 165:95]
    node _r_lanes_T_5 = bits(r_mask, 5, 5) @[SRAM.scala 165:64]
    node r_lanes_hi_lo_hi = orr(_r_lanes_T_5) @[SRAM.scala 165:95]
    node _r_lanes_T_6 = bits(r_mask, 6, 6) @[SRAM.scala 165:64]
    node r_lanes_hi_hi_lo = orr(_r_lanes_T_6) @[SRAM.scala 165:95]
    node _r_lanes_T_7 = bits(r_mask, 7, 7) @[SRAM.scala 165:64]
    node r_lanes_hi_hi_hi = orr(_r_lanes_T_7) @[SRAM.scala 165:95]
    node r_lanes_lo_lo = cat(r_lanes_lo_lo_hi, r_lanes_lo_lo_lo) @[Cat.scala 30:58]
    node r_lanes_lo_hi = cat(r_lanes_lo_hi_hi, r_lanes_lo_hi_lo) @[Cat.scala 30:58]
    node r_lanes_lo = cat(r_lanes_lo_hi, r_lanes_lo_lo) @[Cat.scala 30:58]
    node r_lanes_hi_lo = cat(r_lanes_hi_lo_hi, r_lanes_hi_lo_lo) @[Cat.scala 30:58]
    node r_lanes_hi_hi = cat(r_lanes_hi_hi_hi, r_lanes_hi_hi_lo) @[Cat.scala 30:58]
    node r_lanes_hi = cat(r_lanes_hi_hi, r_lanes_hi_lo) @[Cat.scala 30:58]
    node r_lanes = cat(r_lanes_hi, r_lanes_lo) @[Cat.scala 30:58]
    node r_lane_error_lo_lo = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node r_lane_error_lo_hi = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node r_lane_error_lo = cat(r_lane_error_lo_hi, r_lane_error_lo_lo) @[Cat.scala 30:58]
    node r_lane_error_hi_lo = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node r_lane_error_hi_hi = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node r_lane_error_hi = cat(r_lane_error_hi_hi, r_lane_error_hi_lo) @[Cat.scala 30:58]
    node _r_lane_error_T = cat(r_lane_error_hi, r_lane_error_lo) @[Cat.scala 30:58]
    node r_lane_error = and(_r_lane_error_T, r_lanes) @[SRAM.scala 166:56]
    node r_error = orr(r_lane_error) @[SRAM.scala 167:40]
    node d_mux = and(d_full, d_respond) @[SRAM.scala 206:24]
    node _out_aad_T = or(d_read, d_atomic) @[SRAM.scala 208:37]
    node _out_aad_T_1 = or(r_read, r_atomic) @[SRAM.scala 208:57]
    node out_aad = mux(d_mux, _out_aad_T, _out_aad_T_1) @[SRAM.scala 208:22]
    node _bundleIn_0_d_bits_opcode_T = mux(out_aad, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 209:29]
    node _bundleIn_0_d_bits_size_T = mux(d_mux, d_size, r_size) @[SRAM.scala 211:29]
    node _bundleIn_0_d_bits_source_T = mux(d_mux, d_source, r_source) @[SRAM.scala 212:29]
    node _bundleIn_0_d_bits_data_T = mux(d_mux, d_corrected, r_uncorrected) @[SRAM.scala 215:29]
    node _bundleIn_0_d_bits_corrupt_T = mux(d_mux, d_error, r_error) @[SRAM.scala 216:29]
    node _bundleIn_0_d_bits_corrupt_T_1 = and(_bundleIn_0_d_bits_corrupt_T, out_aad) @[SRAM.scala 216:55]
    node _T = eq(d_need_fix, UInt<1>("h0")) @[SRAM.scala 220:20]
    node _T_1 = eq(d_error, UInt<1>("h0")) @[SRAM.scala 220:35]
    node _T_2 = and(_T, _T_1) @[SRAM.scala 220:32]
    node in_d_bits_corrupt = _bundleIn_0_d_bits_corrupt_T_1 @[Nodes.scala 1210:84 SRAM.scala 216:23]
    node _T_3 = eq(in_d_bits_corrupt, UInt<1>("h0")) @[SRAM.scala 221:34]
    node _T_4 = and(d_need_fix, _T_3) @[SRAM.scala 221:31]
    node _T_5 = and(d_error, in_d_bits_corrupt) @[SRAM.scala 222:28]
    node _bundleIn_0_d_valid_T = and(d_full, d_respond) @[SRAM.scala 240:27]
    node _r_respond_T = eq(UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 232:21]
    node _r_respond_T_1 = eq(r_need_fix, UInt<1>("h0")) @[SRAM.scala 232:36]
    node _r_respond_T_2 = or(r_read, r_atomic) @[SRAM.scala 232:60]
    node _r_respond_T_3 = eq(_r_respond_T_2, UInt<1>("h0")) @[SRAM.scala 232:51]
    node _r_respond_T_4 = or(_r_respond_T_1, _r_respond_T_3) @[SRAM.scala 232:48]
    node r_respond = and(_r_respond_T, _r_respond_T_4) @[SRAM.scala 232:32]
    node _bundleIn_0_d_valid_T_1 = and(r_full, r_respond) @[SRAM.scala 240:52]
    node _d_wb_T = or(d_sublane, d_atomic) @[SRAM.scala 229:37]
    node _d_wb_T_1 = and(d_read, d_need_fix) @[SRAM.scala 229:60]
    node _d_wb_T_2 = or(_d_wb_T, _d_wb_T_1) @[SRAM.scala 229:49]
    node d_wb = and(d_full, _d_wb_T_2) @[SRAM.scala 229:23]
    node _bundleIn_0_d_valid_T_2 = eq(d_wb, UInt<1>("h0")) @[SRAM.scala 240:68]
    node _bundleIn_0_d_valid_T_3 = and(_bundleIn_0_d_valid_T_1, _bundleIn_0_d_valid_T_2) @[SRAM.scala 240:65]
    reg r_replay : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_replay) @[SRAM.scala 235:27]
    node _bundleIn_0_d_valid_T_4 = eq(r_replay, UInt<1>("h0")) @[SRAM.scala 240:77]
    node _bundleIn_0_d_valid_T_5 = and(_bundleIn_0_d_valid_T_3, _bundleIn_0_d_valid_T_4) @[SRAM.scala 240:74]
    node _bundleIn_0_d_valid_T_6 = or(_bundleIn_0_d_valid_T, _bundleIn_0_d_valid_T_5) @[SRAM.scala 240:41]
    node in_d_valid = _bundleIn_0_d_valid_T_6 @[Nodes.scala 1210:84 SRAM.scala 240:16]
    node _T_6 = and(in_d_valid, _T_2) @[Property.scala 81:34]
    node _T_7 = and(in_d_valid, _T_4) @[Property.scala 81:34]
    node _T_8 = and(in_d_valid, _T_5) @[Property.scala 81:34]
    node _r_replay_T = and(r_full, d_full) @[SRAM.scala 235:35]
    node _r_replay_T_1 = and(_r_replay_T, d_read) @[SRAM.scala 235:45]
    node _r_replay_T_2 = and(_r_replay_T_1, d_need_fix) @[SRAM.scala 235:55]
    node _T_9 = and(r_full, d_wb) @[SRAM.scala 237:22]
    node _T_10 = eq(_T_9, UInt<1>("h0")) @[SRAM.scala 237:13]
    node _T_11 = and(d_full, d_read) @[SRAM.scala 237:42]
    node _T_12 = and(_T_11, d_need_fix) @[SRAM.scala 237:52]
    node _T_13 = or(_T_10, _T_12) @[SRAM.scala 237:31]
    node _T_14 = asUInt(reset) @[SRAM.scala 237:12]
    node _T_15 = or(_T_13, _T_14) @[SRAM.scala 237:12]
    node _T_16 = eq(_T_15, UInt<1>("h0")) @[SRAM.scala 237:12]
    node _d_ready_T = eq(d_respond, UInt<1>("h0")) @[SRAM.scala 241:19]
    node in_d_ready = auto_in_d_ready @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node d_ready = or(_d_ready_T, in_d_ready) @[SRAM.scala 241:30]
    node _r_ready_T = eq(d_wb, UInt<1>("h0")) @[SRAM.scala 242:19]
    node _r_ready_T_1 = eq(r_replay, UInt<1>("h0")) @[SRAM.scala 242:28]
    node _r_ready_T_2 = and(_r_ready_T, _r_ready_T_1) @[SRAM.scala 242:25]
    node _r_ready_T_3 = eq(d_full, UInt<1>("h0")) @[SRAM.scala 242:42]
    node _r_ready_T_4 = or(_r_ready_T_3, d_ready) @[SRAM.scala 242:50]
    node _r_ready_T_5 = and(_r_ready_T_2, _r_ready_T_4) @[SRAM.scala 242:38]
    node _r_ready_T_6 = eq(r_respond, UInt<1>("h0")) @[SRAM.scala 242:66]
    node _r_ready_T_7 = eq(d_mux, UInt<1>("h0")) @[SRAM.scala 242:81]
    node _r_ready_T_8 = and(_r_ready_T_7, in_d_ready) @[SRAM.scala 242:88]
    node _r_ready_T_9 = or(_r_ready_T_6, _r_ready_T_8) @[SRAM.scala 242:77]
    node r_ready = and(_r_ready_T_5, _r_ready_T_9) @[SRAM.scala 242:62]
    node _bundleIn_0_a_ready_T = and(d_full, d_wb) @[SRAM.scala 243:28]
    node _bundleIn_0_a_ready_T_1 = eq(_bundleIn_0_a_ready_T, UInt<1>("h0")) @[SRAM.scala 243:19]
    node _bundleIn_0_a_ready_T_2 = eq(r_full, UInt<1>("h0")) @[SRAM.scala 243:41]
    node _bundleIn_0_a_ready_T_3 = or(_bundleIn_0_a_ready_T_2, r_ready) @[SRAM.scala 243:49]
    node _bundleIn_0_a_ready_T_4 = and(_bundleIn_0_a_ready_T_1, _bundleIn_0_a_ready_T_3) @[SRAM.scala 243:37]
    node _bundleIn_0_a_ready_T_5 = eq(r_full, UInt<1>("h0")) @[SRAM.scala 243:65]
    node _bundleIn_0_a_ready_T_6 = or(r_atomic, r_sublane) @[SRAM.scala 243:87]
    node _bundleIn_0_a_ready_T_7 = eq(_bundleIn_0_a_ready_T_6, UInt<1>("h0")) @[SRAM.scala 243:76]
    node _bundleIn_0_a_ready_T_8 = or(_bundleIn_0_a_ready_T_5, _bundleIn_0_a_ready_T_7) @[SRAM.scala 243:73]
    node _bundleIn_0_a_ready_T_9 = and(_bundleIn_0_a_ready_T_4, _bundleIn_0_a_ready_T_8) @[SRAM.scala 243:61]
    node in_a_bits_opcode = auto_in_a_bits_opcode @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _a_atomic_T = eq(in_a_bits_opcode, UInt<2>("h2")) @[SRAM.scala 249:24]
    node _a_atomic_T_1 = eq(in_a_bits_opcode, UInt<2>("h3")) @[SRAM.scala 250:24]
    node a_atomic = or(_a_atomic_T, _a_atomic_T_1) @[SRAM.scala 249:54]
    node a_read = eq(in_a_bits_opcode, UInt<3>("h4")) @[SRAM.scala 251:35]
    node _GEN_0 = mux(d_ready, UInt<1>("h0"), d_full) @[SRAM.scala 254:20 SRAM.scala 254:29 SRAM.scala 118:30]
    node _T_17 = and(r_full, r_ready) @[SRAM.scala 255:18]
    node _d_respond_T = eq(r_respond, UInt<1>("h0")) @[SRAM.scala 257:21]
    node _GEN_1 = mux(_T_17, UInt<1>("h1"), _GEN_0) @[SRAM.scala 255:30 SRAM.scala 256:18]
    node _GEN_2 = mux(_T_17, _d_respond_T, d_respond) @[SRAM.scala 255:30 SRAM.scala 257:18 SRAM.scala 119:26]
    node _GEN_3 = mux(_T_17, r_opcode, d_opcode) @[SRAM.scala 255:30 SRAM.scala 258:18 SRAM.scala 120:26]
    node _GEN_4 = mux(_T_17, r_param, d_param) @[SRAM.scala 255:30 SRAM.scala 259:18 SRAM.scala 121:26]
    node _GEN_5 = mux(_T_17, r_size, d_size) @[SRAM.scala 255:30 SRAM.scala 260:18 SRAM.scala 122:26]
    node _GEN_6 = mux(_T_17, r_source, d_source) @[SRAM.scala 255:30 SRAM.scala 261:18 SRAM.scala 123:26]
    node _GEN_7 = mux(_T_17, r_read, d_read) @[SRAM.scala 255:30 SRAM.scala 262:18 SRAM.scala 124:26]
    node _GEN_8 = mux(_T_17, r_atomic, d_atomic) @[SRAM.scala 255:30 SRAM.scala 263:18 SRAM.scala 125:26]
    node _GEN_9 = mux(_T_17, r_sublane, d_sublane) @[SRAM.scala 255:30 SRAM.scala 264:18 SRAM.scala 126:26]
    node _GEN_10 = mux(_T_17, r_address, d_address) @[SRAM.scala 255:30 SRAM.scala 265:18 SRAM.scala 127:26]
    node _GEN_11 = mux(_T_17, r_mask, d_mask) @[SRAM.scala 255:30 SRAM.scala 266:18 SRAM.scala 128:26]
    node _GEN_12 = mux(_T_17, r_rmw_data, d_rmw_data) @[SRAM.scala 255:30 SRAM.scala 267:18 SRAM.scala 129:26]
    node _GEN_13 = mux(_T_17, r_poison, d_poison) @[SRAM.scala 255:30 SRAM.scala 268:18 SRAM.scala 130:26]
    node _GEN_14 = mux(_T_17, r_raw_data_0, d_raw_data_0) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_15 = mux(_T_17, r_raw_data_1, d_raw_data_1) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_16 = mux(_T_17, r_raw_data_2, d_raw_data_2) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_17 = mux(_T_17, r_raw_data_3, d_raw_data_3) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_18 = mux(_T_17, r_raw_data_4, d_raw_data_4) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_19 = mux(_T_17, r_raw_data_5, d_raw_data_5) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_20 = mux(_T_17, r_raw_data_6, d_raw_data_6) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_21 = mux(_T_17, r_raw_data_7, d_raw_data_7) @[SRAM.scala 255:30 SRAM.scala 269:18 SRAM.scala 131:26]
    node _GEN_22 = mux(r_ready, UInt<1>("h0"), r_full) @[SRAM.scala 273:20 SRAM.scala 273:29 SRAM.scala 134:30]
    node in_a_ready = _bundleIn_0_a_ready_T_9 @[Nodes.scala 1210:84 SRAM.scala 243:16]
    node in_a_valid = auto_in_a_valid @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _T_18 = and(in_a_ready, in_a_valid) @[Decoupled.scala 40:37]
    node _T_19 = eq(a_read, UInt<1>("h0")) @[SRAM.scala 287:13]
    node in_a_bits_data = auto_in_a_bits_data @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_23 = mux(_T_19, in_a_bits_data, r_rmw_data) @[SRAM.scala 287:22 SRAM.scala 287:35 SRAM.scala 144:26]
    node _GEN_24 = mux(_T_18, UInt<1>("h1"), _GEN_22) @[SRAM.scala 274:24 SRAM.scala 275:18]
    node _GEN_25 = mux(_T_18, UInt<1>("h0"), r_sublane) @[SRAM.scala 274:24 SRAM.scala 283:18 SRAM.scala 141:26]
    node _GEN_26 = mux(_T_18, in_a_bits_opcode, r_opcode) @[SRAM.scala 274:24 SRAM.scala 277:18 SRAM.scala 135:26]
    node in_a_bits_param = auto_in_a_bits_param @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_27 = mux(_T_18, in_a_bits_param, r_param) @[SRAM.scala 274:24 SRAM.scala 278:18 SRAM.scala 136:26]
    node in_a_bits_size = auto_in_a_bits_size @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_28 = mux(_T_18, in_a_bits_size, r_size) @[SRAM.scala 274:24 SRAM.scala 279:18 SRAM.scala 137:26]
    node in_a_bits_source = auto_in_a_bits_source @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_29 = mux(_T_18, in_a_bits_source, r_source) @[SRAM.scala 274:24 SRAM.scala 280:18 SRAM.scala 138:26]
    node _GEN_30 = mux(_T_18, a_read, r_read) @[SRAM.scala 274:24 SRAM.scala 281:18 SRAM.scala 139:26]
    node _GEN_31 = mux(_T_18, a_atomic, r_atomic) @[SRAM.scala 274:24 SRAM.scala 282:18 SRAM.scala 140:26]
    node in_a_bits_address = auto_in_a_bits_address @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_32 = mux(_T_18, in_a_bits_address, r_address) @[SRAM.scala 274:24 SRAM.scala 284:18 SRAM.scala 142:26]
    node in_a_bits_corrupt = auto_in_a_bits_corrupt @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_33 = mux(_T_18, in_a_bits_corrupt, r_poison) @[SRAM.scala 274:24 SRAM.scala 285:18 SRAM.scala 145:26]
    node in_a_bits_mask = auto_in_a_bits_mask @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _GEN_34 = mux(_T_18, in_a_bits_mask, r_mask) @[SRAM.scala 274:24 SRAM.scala 286:18 SRAM.scala 143:26]
    node _GEN_35 = mux(_T_18, _GEN_23, r_rmw_data) @[SRAM.scala 274:24 SRAM.scala 144:26]
    node _a_data_T = bits(in_a_bits_data, 7, 0) @[SRAM.scala 291:67]
    node _a_data_T_1 = bits(in_a_bits_data, 15, 8) @[SRAM.scala 291:67]
    node _a_data_T_2 = bits(in_a_bits_data, 23, 16) @[SRAM.scala 291:67]
    node _a_data_T_3 = bits(in_a_bits_data, 31, 24) @[SRAM.scala 291:67]
    node _a_data_T_4 = bits(in_a_bits_data, 39, 32) @[SRAM.scala 291:67]
    node _a_data_T_5 = bits(in_a_bits_data, 47, 40) @[SRAM.scala 291:67]
    node _a_data_T_6 = bits(in_a_bits_data, 55, 48) @[SRAM.scala 291:67]
    node _a_data_T_7 = bits(in_a_bits_data, 63, 56) @[SRAM.scala 291:67]
    node _r_data_T = bits(r_rmw_data, 7, 0) @[SRAM.scala 292:63]
    node _r_data_T_1 = bits(r_rmw_data, 15, 8) @[SRAM.scala 292:63]
    node _r_data_T_2 = bits(r_rmw_data, 23, 16) @[SRAM.scala 292:63]
    node _r_data_T_3 = bits(r_rmw_data, 31, 24) @[SRAM.scala 292:63]
    node _r_data_T_4 = bits(r_rmw_data, 39, 32) @[SRAM.scala 292:63]
    node _r_data_T_5 = bits(r_rmw_data, 47, 40) @[SRAM.scala 292:63]
    node _r_data_T_6 = bits(r_rmw_data, 55, 48) @[SRAM.scala 292:63]
    node _r_data_T_7 = bits(r_rmw_data, 63, 56) @[SRAM.scala 292:63]
    node _d_data_T = bits(d_updated_alu.io_data_out, 7, 0) @[SRAM.scala 293:62]
    node _d_data_T_1 = bits(d_updated_alu.io_data_out, 15, 8) @[SRAM.scala 293:62]
    node _d_data_T_2 = bits(d_updated_alu.io_data_out, 23, 16) @[SRAM.scala 293:62]
    node _d_data_T_3 = bits(d_updated_alu.io_data_out, 31, 24) @[SRAM.scala 293:62]
    node _d_data_T_4 = bits(d_updated_alu.io_data_out, 39, 32) @[SRAM.scala 293:62]
    node _d_data_T_5 = bits(d_updated_alu.io_data_out, 47, 40) @[SRAM.scala 293:62]
    node _d_data_T_6 = bits(d_updated_alu.io_data_out, 55, 48) @[SRAM.scala 293:62]
    node _d_data_T_7 = bits(d_updated_alu.io_data_out, 63, 56) @[SRAM.scala 293:62]
    node d_poisonv_upd = bits(d_mask, 0, 0) @[SRAM.scala 299:23]
    node _d_poisonv_T = andr(d_poisonv_upd) @[SRAM.scala 300:13]
    node _d_poisonv_T_1 = eq(_d_poisonv_T, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_2 = and(_d_poisonv_T_1, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_3 = or(_d_poisonv_T_2, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_1 = bits(d_mask, 1, 1) @[SRAM.scala 299:23]
    node _d_poisonv_T_4 = andr(d_poisonv_upd_1) @[SRAM.scala 300:13]
    node _d_poisonv_T_5 = eq(_d_poisonv_T_4, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_6 = and(_d_poisonv_T_5, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_7 = or(_d_poisonv_T_6, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_2 = bits(d_mask, 2, 2) @[SRAM.scala 299:23]
    node _d_poisonv_T_8 = andr(d_poisonv_upd_2) @[SRAM.scala 300:13]
    node _d_poisonv_T_9 = eq(_d_poisonv_T_8, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_10 = and(_d_poisonv_T_9, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_11 = or(_d_poisonv_T_10, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_3 = bits(d_mask, 3, 3) @[SRAM.scala 299:23]
    node _d_poisonv_T_12 = andr(d_poisonv_upd_3) @[SRAM.scala 300:13]
    node _d_poisonv_T_13 = eq(_d_poisonv_T_12, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_14 = and(_d_poisonv_T_13, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_15 = or(_d_poisonv_T_14, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_4 = bits(d_mask, 4, 4) @[SRAM.scala 299:23]
    node _d_poisonv_T_16 = andr(d_poisonv_upd_4) @[SRAM.scala 300:13]
    node _d_poisonv_T_17 = eq(_d_poisonv_T_16, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_18 = and(_d_poisonv_T_17, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_19 = or(_d_poisonv_T_18, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_5 = bits(d_mask, 5, 5) @[SRAM.scala 299:23]
    node _d_poisonv_T_20 = andr(d_poisonv_upd_5) @[SRAM.scala 300:13]
    node _d_poisonv_T_21 = eq(_d_poisonv_T_20, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_22 = and(_d_poisonv_T_21, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_23 = or(_d_poisonv_T_22, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_6 = bits(d_mask, 6, 6) @[SRAM.scala 299:23]
    node _d_poisonv_T_24 = andr(d_poisonv_upd_6) @[SRAM.scala 300:13]
    node _d_poisonv_T_25 = eq(_d_poisonv_T_24, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_26 = and(_d_poisonv_T_25, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_27 = or(_d_poisonv_T_26, d_poison) @[SRAM.scala 300:41]
    node d_poisonv_upd_7 = bits(d_mask, 7, 7) @[SRAM.scala 299:23]
    node _d_poisonv_T_28 = andr(d_poisonv_upd_7) @[SRAM.scala 300:13]
    node _d_poisonv_T_29 = eq(_d_poisonv_T_28, UInt<1>("h0")) @[SRAM.scala 300:8]
    node _d_poisonv_T_30 = and(_d_poisonv_T_29, UInt<1>("h0")) @[SRAM.scala 300:18]
    node _d_poisonv_T_31 = or(_d_poisonv_T_30, d_poison) @[SRAM.scala 300:41]
    node _a_lanes_T = bits(in_a_bits_mask, 0, 0) @[SRAM.scala 303:64]
    node a_lanes_lo_lo_lo = orr(_a_lanes_T) @[SRAM.scala 303:95]
    node _a_lanes_T_1 = bits(in_a_bits_mask, 1, 1) @[SRAM.scala 303:64]
    node a_lanes_lo_lo_hi = orr(_a_lanes_T_1) @[SRAM.scala 303:95]
    node _a_lanes_T_2 = bits(in_a_bits_mask, 2, 2) @[SRAM.scala 303:64]
    node a_lanes_lo_hi_lo = orr(_a_lanes_T_2) @[SRAM.scala 303:95]
    node _a_lanes_T_3 = bits(in_a_bits_mask, 3, 3) @[SRAM.scala 303:64]
    node a_lanes_lo_hi_hi = orr(_a_lanes_T_3) @[SRAM.scala 303:95]
    node _a_lanes_T_4 = bits(in_a_bits_mask, 4, 4) @[SRAM.scala 303:64]
    node a_lanes_hi_lo_lo = orr(_a_lanes_T_4) @[SRAM.scala 303:95]
    node _a_lanes_T_5 = bits(in_a_bits_mask, 5, 5) @[SRAM.scala 303:64]
    node a_lanes_hi_lo_hi = orr(_a_lanes_T_5) @[SRAM.scala 303:95]
    node _a_lanes_T_6 = bits(in_a_bits_mask, 6, 6) @[SRAM.scala 303:64]
    node a_lanes_hi_hi_lo = orr(_a_lanes_T_6) @[SRAM.scala 303:95]
    node _a_lanes_T_7 = bits(in_a_bits_mask, 7, 7) @[SRAM.scala 303:64]
    node a_lanes_hi_hi_hi = orr(_a_lanes_T_7) @[SRAM.scala 303:95]
    node a_lanes_lo_lo = cat(a_lanes_lo_lo_hi, a_lanes_lo_lo_lo) @[Cat.scala 30:58]
    node a_lanes_lo_hi = cat(a_lanes_lo_hi_hi, a_lanes_lo_hi_lo) @[Cat.scala 30:58]
    node a_lanes_lo = cat(a_lanes_lo_hi, a_lanes_lo_lo) @[Cat.scala 30:58]
    node a_lanes_hi_lo = cat(a_lanes_hi_lo_hi, a_lanes_hi_lo_lo) @[Cat.scala 30:58]
    node a_lanes_hi_hi = cat(a_lanes_hi_hi_hi, a_lanes_hi_hi_lo) @[Cat.scala 30:58]
    node a_lanes_hi = cat(a_lanes_hi_hi, a_lanes_hi_lo) @[Cat.scala 30:58]
    node a_lanes = cat(a_lanes_hi, a_lanes_lo) @[Cat.scala 30:58]
    node a_fire = and(in_a_ready, in_a_valid) @[Decoupled.scala 40:37]
    node _a_ren_T = or(a_read, a_atomic) @[SRAM.scala 307:24]
    node a_ren = or(_a_ren_T, UInt<1>("h0")) @[SRAM.scala 307:36]
    node _r_ren_T = or(r_read, r_atomic) @[SRAM.scala 308:24]
    node r_ren = or(_r_ren_T, r_sublane) @[SRAM.scala 308:36]
    node _wen_T = eq(r_ren, UInt<1>("h0")) @[SRAM.scala 309:37]
    node _wen_T_1 = eq(a_ren, UInt<1>("h0")) @[SRAM.scala 309:55]
    node _wen_T_2 = and(a_fire, _wen_T_1) @[SRAM.scala 309:52]
    node _wen_T_3 = mux(r_replay, _wen_T, _wen_T_2) @[SRAM.scala 309:26]
    node wen = or(d_wb, _wen_T_3) @[SRAM.scala 309:20]
    node _ren_T = eq(wen, UInt<1>("h0")) @[SRAM.scala 310:15]
    node _ren_T_1 = or(a_fire, r_replay) @[SRAM.scala 310:31]
    node ren = and(_ren_T, _ren_T_1) @[SRAM.scala 310:20]
    node _addr_T = mux(r_replay, r_address, in_a_bits_address) @[SRAM.scala 312:42]
    node addr = mux(d_wb, d_address, _addr_T) @[SRAM.scala 312:21]
    node _sel_T = mux(r_replay, r_lanes, a_lanes) @[SRAM.scala 313:42]
    node sel = mux(d_wb, d_lanes, _sel_T) @[SRAM.scala 313:21]
    node r_data_0 = _r_data_T @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_0 = _a_data_T @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_0 = mux(r_replay, r_data_0, a_data_0) @[SRAM.scala 314:42]
    node r_data_1 = _r_data_T_1 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_1 = _a_data_T_1 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_1 = mux(r_replay, r_data_1, a_data_1) @[SRAM.scala 314:42]
    node r_data_2 = _r_data_T_2 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_2 = _a_data_T_2 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_2 = mux(r_replay, r_data_2, a_data_2) @[SRAM.scala 314:42]
    node r_data_3 = _r_data_T_3 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_3 = _a_data_T_3 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_3 = mux(r_replay, r_data_3, a_data_3) @[SRAM.scala 314:42]
    node r_data_4 = _r_data_T_4 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_4 = _a_data_T_4 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_4 = mux(r_replay, r_data_4, a_data_4) @[SRAM.scala 314:42]
    node r_data_5 = _r_data_T_5 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_5 = _a_data_T_5 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_5 = mux(r_replay, r_data_5, a_data_5) @[SRAM.scala 314:42]
    node r_data_6 = _r_data_T_6 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_6 = _a_data_T_6 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_6 = mux(r_replay, r_data_6, a_data_6) @[SRAM.scala 314:42]
    node r_data_7 = _r_data_T_7 @[SRAM.scala 292:25 SRAM.scala 292:25]
    node a_data_7 = _a_data_T_7 @[SRAM.scala 291:25 SRAM.scala 291:25]
    node _dat_T_7 = mux(r_replay, r_data_7, a_data_7) @[SRAM.scala 314:42]
    node d_data_0 = _d_data_T @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_0 = mux(d_wb, d_data_0, _dat_T_0) @[SRAM.scala 314:21]
    node d_data_1 = _d_data_T_1 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_1 = mux(d_wb, d_data_1, _dat_T_1) @[SRAM.scala 314:21]
    node d_data_2 = _d_data_T_2 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_2 = mux(d_wb, d_data_2, _dat_T_2) @[SRAM.scala 314:21]
    node d_data_3 = _d_data_T_3 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_3 = mux(d_wb, d_data_3, _dat_T_3) @[SRAM.scala 314:21]
    node d_data_4 = _d_data_T_4 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_4 = mux(d_wb, d_data_4, _dat_T_4) @[SRAM.scala 314:21]
    node d_data_5 = _d_data_T_5 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_5 = mux(d_wb, d_data_5, _dat_T_5) @[SRAM.scala 314:21]
    node d_data_6 = _d_data_T_6 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_6 = mux(d_wb, d_data_6, _dat_T_6) @[SRAM.scala 314:21]
    node d_data_7 = _d_data_T_7 @[SRAM.scala 293:25 SRAM.scala 293:25]
    node dat_7 = mux(d_wb, d_data_7, _dat_T_7) @[SRAM.scala 314:21]
    node r_poisonv_0 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_0 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_0 = mux(r_replay, r_poisonv_0, a_poisonv_0) @[SRAM.scala 315:42]
    node r_poisonv_1 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_1 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_1 = mux(r_replay, r_poisonv_1, a_poisonv_1) @[SRAM.scala 315:42]
    node r_poisonv_2 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_2 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_2 = mux(r_replay, r_poisonv_2, a_poisonv_2) @[SRAM.scala 315:42]
    node r_poisonv_3 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_3 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_3 = mux(r_replay, r_poisonv_3, a_poisonv_3) @[SRAM.scala 315:42]
    node r_poisonv_4 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_4 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_4 = mux(r_replay, r_poisonv_4, a_poisonv_4) @[SRAM.scala 315:42]
    node r_poisonv_5 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_5 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_5 = mux(r_replay, r_poisonv_5, a_poisonv_5) @[SRAM.scala 315:42]
    node r_poisonv_6 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_6 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_6 = mux(r_replay, r_poisonv_6, a_poisonv_6) @[SRAM.scala 315:42]
    node r_poisonv_7 = r_poison @[SRAM.scala 297:28 SRAM.scala 297:28]
    node a_poisonv_7 = in_a_bits_corrupt @[SRAM.scala 296:28 SRAM.scala 296:28]
    node _poison_T_7 = mux(r_replay, r_poisonv_7, a_poisonv_7) @[SRAM.scala 315:42]
    node d_poisonv_0 = _d_poisonv_T_3 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_0 = mux(d_wb, d_poisonv_0, _poison_T_0) @[SRAM.scala 315:21]
    node d_poisonv_1 = _d_poisonv_T_7 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_1 = mux(d_wb, d_poisonv_1, _poison_T_1) @[SRAM.scala 315:21]
    node d_poisonv_2 = _d_poisonv_T_11 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_2 = mux(d_wb, d_poisonv_2, _poison_T_2) @[SRAM.scala 315:21]
    node d_poisonv_3 = _d_poisonv_T_15 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_3 = mux(d_wb, d_poisonv_3, _poison_T_3) @[SRAM.scala 315:21]
    node d_poisonv_4 = _d_poisonv_T_19 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_4 = mux(d_wb, d_poisonv_4, _poison_T_4) @[SRAM.scala 315:21]
    node d_poisonv_5 = _d_poisonv_T_23 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_5 = mux(d_wb, d_poisonv_5, _poison_T_5) @[SRAM.scala 315:21]
    node d_poisonv_6 = _d_poisonv_T_27 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_6 = mux(d_wb, d_poisonv_6, _poison_T_6) @[SRAM.scala 315:21]
    node d_poisonv_7 = _d_poisonv_T_31 @[SRAM.scala 298:28 SRAM.scala 298:28]
    node poison_7 = mux(d_wb, d_poisonv_7, _poison_T_7) @[SRAM.scala 315:21]
    node _index_T = shr(addr, 3) @[SRAM.scala 320:36]
    node index_lo_lo = bits(_index_T, 0, 0) @[SRAM.scala 320:60]
    node index_lo_hi_lo = bits(_index_T, 1, 1) @[SRAM.scala 320:60]
    node index_lo_hi_hi = bits(_index_T, 2, 2) @[SRAM.scala 320:60]
    node index_hi_lo = bits(_index_T, 3, 3) @[SRAM.scala 320:60]
    node index_hi_hi_lo = bits(_index_T, 4, 4) @[SRAM.scala 320:60]
    node index_hi_hi_hi = bits(_index_T, 5, 5) @[SRAM.scala 320:60]
    node index_lo_hi = cat(index_lo_hi_hi, index_lo_hi_lo) @[Cat.scala 30:58]
    node index_lo = cat(index_lo_hi, index_lo_lo) @[Cat.scala 30:58]
    node index_hi_hi = cat(index_hi_hi_hi, index_hi_hi_lo) @[Cat.scala 30:58]
    node index_hi = cat(index_hi_hi, index_hi_lo) @[Cat.scala 30:58]
    node index = cat(index_hi, index_lo) @[Cat.scala 30:58]
    node _GEN_36 = validif(ren, index) @[SRAM.scala 321:27 SRAM.scala 321:27]
    node _WIRE = _GEN_36 @[SRAM.scala 321:27]
    node _T_20 = or(_WIRE, UInt<6>("h0")) @[SRAM.scala 321:27]
    node _T_21 = bits(_T_20, 5, 0) @[SRAM.scala 321:27]
    node _GEN_37 = mux(ren, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 321:27 SRAM.scala 321:27 DescribedSRAM.scala 19:26]
    node _GEN_38 = validif(ren, _T_21) @[SRAM.scala 321:27 SRAM.scala 321:27]
    node _GEN_39 = validif(ren, clock) @[SRAM.scala 321:27 SRAM.scala 321:27]
    node _GEN_40 = mux(REG, mem_0.MPORT.data, r_0) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_41 = mux(REG, mem_1.MPORT.data, r_1) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_42 = mux(REG, mem_2.MPORT.data, r_2) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_43 = mux(REG, mem_3.MPORT.data, r_3) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_44 = mux(REG, mem_4.MPORT.data, r_4) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_45 = mux(REG, mem_5.MPORT.data, r_5) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_46 = mux(REG, mem_6.MPORT.data, r_6) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _GEN_47 = mux(REG, mem_7.MPORT.data, r_7) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _T_23 = bits(sel, 0, 0) @[SRAM.scala 322:46]
    node _T_24 = bits(sel, 1, 1) @[SRAM.scala 322:46]
    node _T_25 = bits(sel, 2, 2) @[SRAM.scala 322:46]
    node _T_26 = bits(sel, 3, 3) @[SRAM.scala 322:46]
    node _T_27 = bits(sel, 4, 4) @[SRAM.scala 322:46]
    node _T_28 = bits(sel, 5, 5) @[SRAM.scala 322:46]
    node _T_29 = bits(sel, 6, 6) @[SRAM.scala 322:46]
    node _T_30 = bits(sel, 7, 7) @[SRAM.scala 322:46]
    node coded_0 = dat_0 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_48 = validif(_T_23, coded_0)
    node _GEN_49 = mux(_T_23, UInt<1>("h1"), UInt<1>("h0"))
    node coded_1 = dat_1 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_50 = validif(_T_24, coded_1)
    node _GEN_51 = mux(_T_24, UInt<1>("h1"), UInt<1>("h0"))
    node coded_2 = dat_2 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_52 = validif(_T_25, coded_2)
    node _GEN_53 = mux(_T_25, UInt<1>("h1"), UInt<1>("h0"))
    node coded_3 = dat_3 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_54 = validif(_T_26, coded_3)
    node _GEN_55 = mux(_T_26, UInt<1>("h1"), UInt<1>("h0"))
    node coded_4 = dat_4 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_56 = validif(_T_27, coded_4)
    node _GEN_57 = mux(_T_27, UInt<1>("h1"), UInt<1>("h0"))
    node coded_5 = dat_5 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_58 = validif(_T_28, coded_5)
    node _GEN_59 = mux(_T_28, UInt<1>("h1"), UInt<1>("h0"))
    node coded_6 = dat_6 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_60 = validif(_T_29, coded_6)
    node _GEN_61 = mux(_T_29, UInt<1>("h1"), UInt<1>("h0"))
    node coded_7 = dat_7 @[SRAM.scala 316:25 SRAM.scala 316:25]
    node _GEN_62 = validif(_T_30, coded_7)
    node _GEN_63 = mux(_T_30, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_64 = validif(wen, index) @[SRAM.scala 322:16]
    node _GEN_65 = validif(wen, clock) @[SRAM.scala 322:16]
    node _GEN_66 = mux(wen, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 322:16 DescribedSRAM.scala 19:26]
    node _GEN_67 = validif(wen, _GEN_49) @[SRAM.scala 322:16]
    node _GEN_68 = validif(wen, _GEN_51) @[SRAM.scala 322:16]
    node _GEN_69 = validif(wen, _GEN_53) @[SRAM.scala 322:16]
    node _GEN_70 = validif(wen, _GEN_55) @[SRAM.scala 322:16]
    node _GEN_71 = validif(wen, _GEN_57) @[SRAM.scala 322:16]
    node _GEN_72 = validif(wen, _GEN_59) @[SRAM.scala 322:16]
    node _GEN_73 = validif(wen, _GEN_61) @[SRAM.scala 322:16]
    node _GEN_74 = validif(wen, _GEN_63) @[SRAM.scala 322:16]
    node _GEN_75 = validif(wen, _GEN_48) @[SRAM.scala 322:16]
    node _GEN_76 = validif(wen, _GEN_50) @[SRAM.scala 322:16]
    node _GEN_77 = validif(wen, _GEN_52) @[SRAM.scala 322:16]
    node _GEN_78 = validif(wen, _GEN_54) @[SRAM.scala 322:16]
    node _GEN_79 = validif(wen, _GEN_56) @[SRAM.scala 322:16]
    node _GEN_80 = validif(wen, _GEN_58) @[SRAM.scala 322:16]
    node _GEN_81 = validif(wen, _GEN_60) @[SRAM.scala 322:16]
    node _GEN_82 = validif(wen, _GEN_62) @[SRAM.scala 322:16]
    node in_d_bits_opcode = pad(_bundleIn_0_d_bits_opcode_T, 3) @[Nodes.scala 1210:84 SRAM.scala 209:23]
    node in_d_bits_param = pad(UInt<1>("h0"), 2) @[Nodes.scala 1210:84 SRAM.scala 210:23]
    node in_d_bits_size = _bundleIn_0_d_bits_size_T @[Nodes.scala 1210:84 SRAM.scala 211:23]
    node in_d_bits_source = _bundleIn_0_d_bits_source_T @[Nodes.scala 1210:84 SRAM.scala 212:23]
    node in_d_bits_sink = UInt<1>("h0") @[Nodes.scala 1210:84 SRAM.scala 213:23]
    node in_d_bits_denied = UInt<1>("h0") @[Nodes.scala 1210:84 SRAM.scala 214:23]
    node in_d_bits_data = _bundleIn_0_d_bits_data_T @[Nodes.scala 1210:84 SRAM.scala 215:23]
    node _WIRE_1_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_valid = UInt<1>("h0") @[Bundles.scala 256:54 SRAM.scala 325:16]
    node _WIRE_1_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_param = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_1_bits_size = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_1_bits_source = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_1_bits_mask = validif(UInt<1>("h0"), UInt<8>("h0"))
    node _WIRE_1_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_1_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_2_ready = UInt<1>("h1") @[Bundles.scala 257:54 SRAM.scala 326:16]
    node _WIRE_2_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_2_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_2_bits_param = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_2_bits_size = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_2_bits_source = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_2_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_2_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_2_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_ready = UInt<1>("h1") @[Bundles.scala 259:54 SRAM.scala 327:16]
    node _WIRE_3_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_bits_sink = validif(UInt<1>("h0"), UInt<1>("h0"))
    auto_in_a_ready <= in_a_ready @[LazyModule.scala 309:16]
    auto_in_d_valid <= in_d_valid @[LazyModule.scala 309:16]
    auto_in_d_bits_opcode <= in_d_bits_opcode @[LazyModule.scala 309:16]
    auto_in_d_bits_param <= in_d_bits_param @[LazyModule.scala 309:16]
    auto_in_d_bits_size <= in_d_bits_size @[LazyModule.scala 309:16]
    auto_in_d_bits_source <= in_d_bits_source @[LazyModule.scala 309:16]
    auto_in_d_bits_sink <= in_d_bits_sink @[LazyModule.scala 309:16]
    auto_in_d_bits_denied <= in_d_bits_denied @[LazyModule.scala 309:16]
    auto_in_d_bits_data <= in_d_bits_data @[LazyModule.scala 309:16]
    auto_in_d_bits_corrupt <= in_d_bits_corrupt @[LazyModule.scala 309:16]
    mem_0.MPORT.addr <= _GEN_38
    mem_1.MPORT.addr <= _GEN_38
    mem_2.MPORT.addr <= _GEN_38
    mem_3.MPORT.addr <= _GEN_38
    mem_4.MPORT.addr <= _GEN_38
    mem_5.MPORT.addr <= _GEN_38
    mem_6.MPORT.addr <= _GEN_38
    mem_7.MPORT.addr <= _GEN_38
    mem_0.MPORT.en <= _GEN_37
    mem_1.MPORT.en <= _GEN_37
    mem_2.MPORT.en <= _GEN_37
    mem_3.MPORT.en <= _GEN_37
    mem_4.MPORT.en <= _GEN_37
    mem_5.MPORT.en <= _GEN_37
    mem_6.MPORT.en <= _GEN_37
    mem_7.MPORT.en <= _GEN_37
    mem_0.MPORT.clk <= _GEN_39
    mem_1.MPORT.clk <= _GEN_39
    mem_2.MPORT.clk <= _GEN_39
    mem_3.MPORT.clk <= _GEN_39
    mem_4.MPORT.clk <= _GEN_39
    mem_5.MPORT.clk <= _GEN_39
    mem_6.MPORT.clk <= _GEN_39
    mem_7.MPORT.clk <= _GEN_39
    mem_0.MPORT_1.addr <= _GEN_64
    mem_1.MPORT_1.addr <= _GEN_64
    mem_2.MPORT_1.addr <= _GEN_64
    mem_3.MPORT_1.addr <= _GEN_64
    mem_4.MPORT_1.addr <= _GEN_64
    mem_5.MPORT_1.addr <= _GEN_64
    mem_6.MPORT_1.addr <= _GEN_64
    mem_7.MPORT_1.addr <= _GEN_64
    mem_0.MPORT_1.en <= _GEN_66
    mem_1.MPORT_1.en <= _GEN_66
    mem_2.MPORT_1.en <= _GEN_66
    mem_3.MPORT_1.en <= _GEN_66
    mem_4.MPORT_1.en <= _GEN_66
    mem_5.MPORT_1.en <= _GEN_66
    mem_6.MPORT_1.en <= _GEN_66
    mem_7.MPORT_1.en <= _GEN_66
    mem_0.MPORT_1.clk <= _GEN_65
    mem_1.MPORT_1.clk <= _GEN_65
    mem_2.MPORT_1.clk <= _GEN_65
    mem_3.MPORT_1.clk <= _GEN_65
    mem_4.MPORT_1.clk <= _GEN_65
    mem_5.MPORT_1.clk <= _GEN_65
    mem_6.MPORT_1.clk <= _GEN_65
    mem_7.MPORT_1.clk <= _GEN_65
    mem_0.MPORT_1.data <= _GEN_75
    mem_1.MPORT_1.data <= _GEN_76
    mem_2.MPORT_1.data <= _GEN_77
    mem_3.MPORT_1.data <= _GEN_78
    mem_4.MPORT_1.data <= _GEN_79
    mem_5.MPORT_1.data <= _GEN_80
    mem_6.MPORT_1.data <= _GEN_81
    mem_7.MPORT_1.data <= _GEN_82
    mem_0.MPORT_1.mask <= _GEN_67
    mem_1.MPORT_1.mask <= _GEN_68
    mem_2.MPORT_1.mask <= _GEN_69
    mem_3.MPORT_1.mask <= _GEN_70
    mem_4.MPORT_1.mask <= _GEN_71
    mem_5.MPORT_1.mask <= _GEN_72
    mem_6.MPORT_1.mask <= _GEN_73
    mem_7.MPORT_1.mask <= _GEN_74
    d_full <= mux(reset, UInt<1>("h0"), _GEN_1) @[SRAM.scala 118:30 SRAM.scala 118:30]
    d_respond <= _GEN_2
    d_opcode <= _GEN_3
    d_param <= _GEN_4
    d_size <= _GEN_5
    d_source <= _GEN_6
    d_read <= _GEN_7
    d_atomic <= _GEN_8
    d_sublane <= _GEN_9
    d_address <= _GEN_10
    d_mask <= _GEN_11
    d_rmw_data <= _GEN_12
    d_poison <= _GEN_13
    d_raw_data_0 <= _GEN_14
    d_raw_data_1 <= _GEN_15
    d_raw_data_2 <= _GEN_16
    d_raw_data_3 <= _GEN_17
    d_raw_data_4 <= _GEN_18
    d_raw_data_5 <= _GEN_19
    d_raw_data_6 <= _GEN_20
    d_raw_data_7 <= _GEN_21
    r_full <= mux(reset, UInt<1>("h0"), _GEN_24) @[SRAM.scala 134:30 SRAM.scala 134:30]
    r_opcode <= _GEN_26
    r_param <= _GEN_27
    r_size <= _GEN_28
    r_source <= _GEN_29
    r_read <= _GEN_30
    r_atomic <= _GEN_31
    r_sublane <= _GEN_25
    r_address <= _GEN_32
    r_mask <= _GEN_34
    r_rmw_data <= _GEN_35
    r_poison <= _GEN_33
    d_updated_alu.clock <= clock
    d_updated_alu.reset <= reset
    d_updated_alu.io_write <= UInt<1>("h0") @[SRAM.scala 185:24]
    d_updated_alu.io_a_opcode <= d_opcode @[SRAM.scala 186:24]
    d_updated_alu.io_a_param <= d_param @[SRAM.scala 187:24]
    d_updated_alu.io_a_size <= d_size @[SRAM.scala 188:24]
    d_updated_alu.io_a_source <= UInt<1>("h0") @[SRAM.scala 189:24]
    d_updated_alu.io_a_address <= UInt<1>("h0") @[SRAM.scala 190:24]
    d_updated_alu.io_a_mask <= d_mask @[SRAM.scala 192:24]
    d_updated_alu.io_a_data <= d_rmw_data @[SRAM.scala 191:24]
    d_updated_alu.io_a_corrupt <= UInt<1>("h0") @[SRAM.scala 193:24]
    d_updated_alu.io_data_in <= d_corrected @[SRAM.scala 194:24]
    r_replay <= _r_replay_T_2 @[SRAM.scala 235:27]
    REG <= ren @[SRAM.scala 321:58]
    r_0 <= _GEN_40
    r_1 <= _GEN_41
    r_2 <= _GEN_42
    r_3 <= _GEN_43
    r_4 <= _GEN_44
    r_5 <= _GEN_45
    r_6 <= _GEN_46
    r_7 <= _GEN_47
    printf(clock, and(and(UInt<1>("h1"), _T_16), UInt<1>("h1")), "Assertion failed\n    at SRAM.scala:237 assert (!(r_full && d_wb) || (d_full && d_read && d_need_fix))\n") @[SRAM.scala 237:12]
    stop(clock, and(and(UInt<1>("h1"), _T_16), UInt<1>("h1")), 1) @[SRAM.scala 237:12]

  module Repeater :
    input clock : Clock
    input reset : UInt<1>
    input io_repeat : UInt<1>
    output io_full : UInt<1>
    output io_enq_ready : UInt<1>
    input io_enq_valid : UInt<1>
    input io_enq_bits_opcode : UInt<3>
    input io_enq_bits_param : UInt<3>
    input io_enq_bits_size : UInt<3>
    input io_enq_bits_source : UInt<1>
    input io_enq_bits_address : UInt<9>
    input io_enq_bits_mask : UInt<8>
    input io_enq_bits_data : UInt<64>
    input io_enq_bits_corrupt : UInt<1>
    input io_deq_ready : UInt<1>
    output io_deq_valid : UInt<1>
    output io_deq_bits_opcode : UInt<3>
    output io_deq_bits_param : UInt<3>
    output io_deq_bits_size : UInt<3>
    output io_deq_bits_source : UInt<1>
    output io_deq_bits_address : UInt<9>
    output io_deq_bits_mask : UInt<8>
    output io_deq_bits_data : UInt<64>
    output io_deq_bits_corrupt : UInt<1>

    reg full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), full) @[Repeater.scala 19:21]
    reg saved_opcode : UInt<3>, clock with :
      reset => (UInt<1>("h0"), saved_opcode) @[Repeater.scala 20:18]
    reg saved_param : UInt<3>, clock with :
      reset => (UInt<1>("h0"), saved_param) @[Repeater.scala 20:18]
    reg saved_size : UInt<3>, clock with :
      reset => (UInt<1>("h0"), saved_size) @[Repeater.scala 20:18]
    reg saved_source : UInt<1>, clock with :
      reset => (UInt<1>("h0"), saved_source) @[Repeater.scala 20:18]
    reg saved_address : UInt<9>, clock with :
      reset => (UInt<1>("h0"), saved_address) @[Repeater.scala 20:18]
    reg saved_mask : UInt<8>, clock with :
      reset => (UInt<1>("h0"), saved_mask) @[Repeater.scala 20:18]
    reg saved_data : UInt<64>, clock with :
      reset => (UInt<1>("h0"), saved_data) @[Repeater.scala 20:18]
    reg saved_corrupt : UInt<1>, clock with :
      reset => (UInt<1>("h0"), saved_corrupt) @[Repeater.scala 20:18]
    node _io_deq_valid_T = or(io_enq_valid, full) @[Repeater.scala 23:32]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Repeater.scala 24:35]
    node _io_enq_ready_T_1 = and(io_deq_ready, _io_enq_ready_T) @[Repeater.scala 24:32]
    node _io_deq_bits_T_opcode = mux(full, saved_opcode, io_enq_bits_opcode) @[Repeater.scala 25:21]
    node _io_deq_bits_T_param = mux(full, saved_param, io_enq_bits_param) @[Repeater.scala 25:21]
    node _io_deq_bits_T_size = mux(full, saved_size, io_enq_bits_size) @[Repeater.scala 25:21]
    node _io_deq_bits_T_source = mux(full, saved_source, io_enq_bits_source) @[Repeater.scala 25:21]
    node _io_deq_bits_T_address = mux(full, saved_address, io_enq_bits_address) @[Repeater.scala 25:21]
    node _io_deq_bits_T_mask = mux(full, saved_mask, io_enq_bits_mask) @[Repeater.scala 25:21]
    node _io_deq_bits_T_data = mux(full, saved_data, io_enq_bits_data) @[Repeater.scala 25:21]
    node _io_deq_bits_T_corrupt = mux(full, saved_corrupt, io_enq_bits_corrupt) @[Repeater.scala 25:21]
    node _T = and(io_enq_ready, io_enq_valid) @[Decoupled.scala 40:37]
    node _T_1 = and(_T, io_repeat) @[Repeater.scala 28:23]
    node _GEN_0 = mux(_T_1, UInt<1>("h1"), full) @[Repeater.scala 28:38 Repeater.scala 28:45 Repeater.scala 19:21]
    node _GEN_1 = mux(_T_1, io_enq_bits_corrupt, saved_corrupt) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_2 = mux(_T_1, io_enq_bits_data, saved_data) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_3 = mux(_T_1, io_enq_bits_mask, saved_mask) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_4 = mux(_T_1, io_enq_bits_address, saved_address) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_5 = mux(_T_1, io_enq_bits_source, saved_source) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_6 = mux(_T_1, io_enq_bits_size, saved_size) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_7 = mux(_T_1, io_enq_bits_param, saved_param) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _GEN_8 = mux(_T_1, io_enq_bits_opcode, saved_opcode) @[Repeater.scala 28:38 Repeater.scala 28:62 Repeater.scala 20:18]
    node _T_2 = and(io_deq_ready, io_deq_valid) @[Decoupled.scala 40:37]
    node _T_3 = eq(io_repeat, UInt<1>("h0")) @[Repeater.scala 29:26]
    node _T_4 = and(_T_2, _T_3) @[Repeater.scala 29:23]
    node _GEN_9 = mux(_T_4, UInt<1>("h0"), _GEN_0) @[Repeater.scala 29:38 Repeater.scala 29:45]
    io_full <= full @[Repeater.scala 26:11]
    io_enq_ready <= _io_enq_ready_T_1 @[Repeater.scala 24:16]
    io_deq_valid <= _io_deq_valid_T @[Repeater.scala 23:16]
    io_deq_bits_opcode <= _io_deq_bits_T_opcode @[Repeater.scala 25:15]
    io_deq_bits_param <= _io_deq_bits_T_param @[Repeater.scala 25:15]
    io_deq_bits_size <= _io_deq_bits_T_size @[Repeater.scala 25:15]
    io_deq_bits_source <= _io_deq_bits_T_source @[Repeater.scala 25:15]
    io_deq_bits_address <= _io_deq_bits_T_address @[Repeater.scala 25:15]
    io_deq_bits_mask <= _io_deq_bits_T_mask @[Repeater.scala 25:15]
    io_deq_bits_data <= _io_deq_bits_T_data @[Repeater.scala 25:15]
    io_deq_bits_corrupt <= _io_deq_bits_T_corrupt @[Repeater.scala 25:15]
    full <= mux(reset, UInt<1>("h0"), _GEN_9) @[Repeater.scala 19:21 Repeater.scala 19:21]
    saved_opcode <= _GEN_8
    saved_param <= _GEN_7
    saved_size <= _GEN_6
    saved_source <= _GEN_5
    saved_address <= _GEN_4
    saved_mask <= _GEN_3
    saved_data <= _GEN_2
    saved_corrupt <= _GEN_1

  module TLFragmenter :
    input clock : Clock
    input reset : UInt<1>
    output auto_in_a_ready : UInt<1>
    input auto_in_a_valid : UInt<1>
    input auto_in_a_bits_opcode : UInt<3>
    input auto_in_a_bits_param : UInt<3>
    input auto_in_a_bits_size : UInt<3>
    input auto_in_a_bits_source : UInt<1>
    input auto_in_a_bits_address : UInt<9>
    input auto_in_a_bits_mask : UInt<8>
    input auto_in_a_bits_data : UInt<64>
    input auto_in_a_bits_corrupt : UInt<1>
    input auto_in_d_ready : UInt<1>
    output auto_in_d_valid : UInt<1>
    output auto_in_d_bits_opcode : UInt<3>
    output auto_in_d_bits_param : UInt<2>
    output auto_in_d_bits_size : UInt<3>
    output auto_in_d_bits_source : UInt<1>
    output auto_in_d_bits_sink : UInt<1>
    output auto_in_d_bits_denied : UInt<1>
    output auto_in_d_bits_data : UInt<64>
    output auto_in_d_bits_corrupt : UInt<1>
    input auto_out_a_ready : UInt<1>
    output auto_out_a_valid : UInt<1>
    output auto_out_a_bits_opcode : UInt<3>
    output auto_out_a_bits_param : UInt<3>
    output auto_out_a_bits_size : UInt<2>
    output auto_out_a_bits_source : UInt<3>
    output auto_out_a_bits_address : UInt<9>
    output auto_out_a_bits_mask : UInt<8>
    output auto_out_a_bits_data : UInt<64>
    output auto_out_a_bits_corrupt : UInt<1>
    output auto_out_d_ready : UInt<1>
    input auto_out_d_valid : UInt<1>
    input auto_out_d_bits_opcode : UInt<3>
    input auto_out_d_bits_param : UInt<2>
    input auto_out_d_bits_size : UInt<2>
    input auto_out_d_bits_source : UInt<3>
    input auto_out_d_bits_sink : UInt<1>
    input auto_out_d_bits_denied : UInt<1>
    input auto_out_d_bits_data : UInt<64>
    input auto_out_d_bits_corrupt : UInt<1>

    inst repeater of Repeater @[Fragmenter.scala 262:30]
    reg acknum : UInt<2>, clock with :
      reset => (UInt<1>("h0"), acknum) @[Fragmenter.scala 189:29]
    reg dOrig : UInt<3>, clock with :
      reset => (UInt<1>("h0"), dOrig) @[Fragmenter.scala 190:24]
    reg dToggle : UInt<1>, clock with :
      reset => (UInt<1>("h0"), dToggle) @[Fragmenter.scala 191:30]
    node bundleOut_0_d_bits_source = auto_out_d_bits_source @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node dFragnum = bits(bundleOut_0_d_bits_source, 1, 0) @[Fragmenter.scala 192:41]
    node dFirst = eq(acknum, UInt<1>("h0")) @[Fragmenter.scala 193:29]
    node dLast = eq(dFragnum, UInt<1>("h0")) @[Fragmenter.scala 194:30]
    node bundleOut_0_d_bits_size = auto_out_d_bits_size @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node dsizeOH_shiftAmount = bits(bundleOut_0_d_bits_size, 1, 0) @[OneHot.scala 64:49]
    node _dsizeOH_T = dshl(UInt<1>("h1"), dsizeOH_shiftAmount) @[OneHot.scala 65:12]
    node dsizeOH = bits(_dsizeOH_T, 3, 0) @[OneHot.scala 65:27]
    node _dsizeOH1_T = asUInt(asSInt(UInt<3>("h7"))) @[package.scala 234:70]
    node _dsizeOH1_T_1 = dshl(_dsizeOH1_T, bundleOut_0_d_bits_size) @[package.scala 234:77]
    node _dsizeOH1_T_2 = bits(_dsizeOH1_T_1, 2, 0) @[package.scala 234:82]
    node dsizeOH1 = not(_dsizeOH1_T_2) @[package.scala 234:46]
    node bundleOut_0_d_bits_opcode = auto_out_d_bits_opcode @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node dHasData = bits(bundleOut_0_d_bits_opcode, 0, 0) @[Edges.scala 105:36]
    node acknum_fragment = shl(dFragnum, 0) @[Fragmenter.scala 200:40]
    node acknum_size = UInt<1>("h0") @[Fragmenter.scala 201:36]
    node bundleOut_0_d_valid = auto_out_d_valid @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node _T = eq(bundleOut_0_d_valid, UInt<1>("h0")) @[Fragmenter.scala 202:17]
    node _T_1 = and(acknum_fragment, acknum_size) @[Fragmenter.scala 202:50]
    node _T_2 = eq(_T_1, UInt<1>("h0")) @[Fragmenter.scala 202:65]
    node _T_3 = or(_T, _T_2) @[Fragmenter.scala 202:30]
    node _T_4 = asUInt(reset) @[Fragmenter.scala 202:16]
    node _T_5 = or(_T_3, _T_4) @[Fragmenter.scala 202:16]
    node _T_6 = eq(_T_5, UInt<1>("h0")) @[Fragmenter.scala 202:16]
    node _dFirst_acknum_T = mux(dHasData, acknum_size, UInt<1>("h0")) @[Fragmenter.scala 203:50]
    node dFirst_acknum = or(acknum_fragment, _dFirst_acknum_T) @[Fragmenter.scala 203:45]
    node _ack_decrement_T = shr(dsizeOH, 3) @[Fragmenter.scala 204:60]
    node ack_decrement = mux(dHasData, UInt<1>("h1"), _ack_decrement_T) @[Fragmenter.scala 204:32]
    node _dFirst_size_T = shl(dFragnum, 3) @[Fragmenter.scala 206:47]
    node dFirst_size_lo = or(_dFirst_size_T, dsizeOH1) @[Fragmenter.scala 206:69]
    node _dFirst_size_T_1 = shl(dFirst_size_lo, 1) @[package.scala 232:35]
    node _dFirst_size_T_2 = or(_dFirst_size_T_1, UInt<1>("h1")) @[package.scala 232:40]
    node _dFirst_size_T_3 = cat(UInt<1>("h0"), dFirst_size_lo) @[Cat.scala 30:58]
    node _dFirst_size_T_4 = not(_dFirst_size_T_3) @[package.scala 232:53]
    node _dFirst_size_T_5 = and(_dFirst_size_T_2, _dFirst_size_T_4) @[package.scala 232:51]
    node dFirst_size_hi = bits(_dFirst_size_T_5, 5, 4) @[OneHot.scala 30:18]
    node dFirst_size_lo_1 = bits(_dFirst_size_T_5, 3, 0) @[OneHot.scala 31:18]
    node dFirst_size_hi_1 = orr(dFirst_size_hi) @[OneHot.scala 32:14]
    node _dFirst_size_T_6 = or(dFirst_size_hi, dFirst_size_lo_1) @[OneHot.scala 32:28]
    node dFirst_size_hi_2 = bits(_dFirst_size_T_6, 3, 2) @[OneHot.scala 30:18]
    node dFirst_size_lo_2 = bits(_dFirst_size_T_6, 1, 0) @[OneHot.scala 31:18]
    node dFirst_size_hi_3 = orr(dFirst_size_hi_2) @[OneHot.scala 32:14]
    node _dFirst_size_T_7 = or(dFirst_size_hi_2, dFirst_size_lo_2) @[OneHot.scala 32:28]
    node dFirst_size_lo_3 = bits(_dFirst_size_T_7, 1, 1) @[CircuitMath.scala 30:8]
    node dFirst_size_lo_4 = cat(dFirst_size_hi_3, dFirst_size_lo_3) @[Cat.scala 30:58]
    node dFirst_size = cat(dFirst_size_hi_1, dFirst_size_lo_4) @[Cat.scala 30:58]
    node bundleIn_0_d_ready = auto_in_d_ready @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _drop_T = eq(dHasData, UInt<1>("h0")) @[Fragmenter.scala 222:20]
    node _drop_T_1 = mux(UInt<1>("h0"), dFirst, dLast) @[Fragmenter.scala 222:37]
    node _drop_T_2 = eq(_drop_T_1, UInt<1>("h0")) @[Fragmenter.scala 222:33]
    node drop = and(_drop_T, _drop_T_2) @[Fragmenter.scala 222:30]
    node _bundleOut_0_d_ready_T = or(bundleIn_0_d_ready, drop) @[Fragmenter.scala 223:35]
    node bundleOut_0_d_ready = _bundleOut_0_d_ready_T @[Nodes.scala 1207:84 Fragmenter.scala 223:21]
    node _T_7 = and(bundleOut_0_d_ready, bundleOut_0_d_valid) @[Decoupled.scala 40:37]
    node _acknum_T = sub(acknum, ack_decrement) @[Fragmenter.scala 209:55]
    node _acknum_T_1 = tail(_acknum_T, 1) @[Fragmenter.scala 209:55]
    node _acknum_T_2 = mux(dFirst, dFirst_acknum, _acknum_T_1) @[Fragmenter.scala 209:24]
    node _dToggle_T = bits(bundleOut_0_d_bits_source, 2, 2) @[Fragmenter.scala 212:41]
    node _GEN_0 = mux(dFirst, dFirst_size, dOrig) @[Fragmenter.scala 210:25 Fragmenter.scala 211:19 Fragmenter.scala 190:24]
    node _GEN_1 = mux(dFirst, _dToggle_T, dToggle) @[Fragmenter.scala 210:25 Fragmenter.scala 212:21 Fragmenter.scala 191:30]
    node _GEN_2 = mux(_T_7, _acknum_T_2, acknum) @[Fragmenter.scala 208:29 Fragmenter.scala 209:18 Fragmenter.scala 189:29]
    node _GEN_3 = mux(_T_7, _GEN_0, dOrig) @[Fragmenter.scala 208:29 Fragmenter.scala 190:24]
    node _GEN_4 = mux(_T_7, _GEN_1, dToggle) @[Fragmenter.scala 208:29 Fragmenter.scala 191:30]
    node _bundleIn_0_d_valid_T = eq(drop, UInt<1>("h0")) @[Fragmenter.scala 224:39]
    node _bundleIn_0_d_valid_T_1 = and(bundleOut_0_d_valid, _bundleIn_0_d_valid_T) @[Fragmenter.scala 224:36]
    node _bundleIn_0_d_bits_source_T = UInt<1>("h0") @[Fragmenter.scala 226:47]
    node _bundleIn_0_d_bits_size_T = mux(dFirst, dFirst_size, dOrig) @[Fragmenter.scala 227:32]
    node _find_T = xor(repeater.io_deq_bits_address, UInt<1>("h0")) @[Parameters.scala 137:31]
    node _find_T_1 = cvt(_find_T) @[Parameters.scala 137:49]
    node _find_T_2 = and(_find_T_1, asSInt(UInt<1>("h0"))) @[Parameters.scala 137:52]
    node _find_T_3 = asSInt(_find_T_2) @[Parameters.scala 137:52]
    node _find_T_4 = eq(_find_T_3, asSInt(UInt<1>("h0"))) @[Parameters.scala 137:67]
    node _limit_T = eq(UInt<1>("h0"), repeater.io_deq_bits_opcode) @[Mux.scala 80:60]
    node _limit_T_1 = mux(_limit_T, UInt<2>("h3"), UInt<2>("h3")) @[Mux.scala 80:57]
    node _limit_T_2 = eq(UInt<1>("h1"), repeater.io_deq_bits_opcode) @[Mux.scala 80:60]
    node _limit_T_3 = mux(_limit_T_2, UInt<2>("h3"), _limit_T_1) @[Mux.scala 80:57]
    node _limit_T_4 = eq(UInt<2>("h2"), repeater.io_deq_bits_opcode) @[Mux.scala 80:60]
    node _limit_T_5 = mux(_limit_T_4, UInt<2>("h3"), _limit_T_3) @[Mux.scala 80:57]
    node _limit_T_6 = eq(UInt<2>("h3"), repeater.io_deq_bits_opcode) @[Mux.scala 80:60]
    node _limit_T_7 = mux(_limit_T_6, UInt<2>("h3"), _limit_T_5) @[Mux.scala 80:57]
    node _limit_T_8 = eq(UInt<3>("h4"), repeater.io_deq_bits_opcode) @[Mux.scala 80:60]
    node _limit_T_9 = mux(_limit_T_8, UInt<2>("h3"), _limit_T_7) @[Mux.scala 80:57]
    node _limit_T_10 = eq(UInt<3>("h5"), repeater.io_deq_bits_opcode) @[Mux.scala 80:60]
    node limit = mux(_limit_T_10, UInt<2>("h3"), _limit_T_9) @[Mux.scala 80:57]
    node _aFrag_T = gt(repeater.io_deq_bits_size, limit) @[Fragmenter.scala 285:31]
    node aFrag = mux(_aFrag_T, limit, repeater.io_deq_bits_size) @[Fragmenter.scala 285:24]
    node _aOrigOH1_T = asUInt(asSInt(UInt<5>("h1f"))) @[package.scala 234:70]
    node _aOrigOH1_T_1 = dshl(_aOrigOH1_T, repeater.io_deq_bits_size) @[package.scala 234:77]
    node _aOrigOH1_T_2 = bits(_aOrigOH1_T_1, 4, 0) @[package.scala 234:82]
    node aOrigOH1 = not(_aOrigOH1_T_2) @[package.scala 234:46]
    node _aFragOH1_T = asUInt(asSInt(UInt<3>("h7"))) @[package.scala 234:70]
    node _aFragOH1_T_1 = dshl(_aFragOH1_T, aFrag) @[package.scala 234:77]
    node _aFragOH1_T_2 = bits(_aFragOH1_T_1, 2, 0) @[package.scala 234:82]
    node aFragOH1 = not(_aFragOH1_T_2) @[package.scala 234:46]
    node _aHasData_opdata_T = bits(repeater.io_deq_bits_opcode, 2, 2) @[Edges.scala 91:37]
    node aHasData = eq(_aHasData_opdata_T, UInt<1>("h0")) @[Edges.scala 91:28]
    node aMask = mux(aHasData, UInt<1>("h0"), aFragOH1) @[Fragmenter.scala 289:24]
    reg gennum : UInt<2>, clock with :
      reset => (UInt<1>("h0"), gennum) @[Fragmenter.scala 291:29]
    node aFirst = eq(gennum, UInt<1>("h0")) @[Fragmenter.scala 292:29]
    node _old_gennum1_T = shr(aOrigOH1, 3) @[Fragmenter.scala 293:48]
    node _old_gennum1_T_1 = sub(gennum, UInt<1>("h1")) @[Fragmenter.scala 293:79]
    node _old_gennum1_T_2 = tail(_old_gennum1_T_1, 1) @[Fragmenter.scala 293:79]
    node old_gennum1 = mux(aFirst, _old_gennum1_T, _old_gennum1_T_2) @[Fragmenter.scala 293:30]
    node _new_gennum_T = not(old_gennum1) @[Fragmenter.scala 294:28]
    node _new_gennum_T_1 = UInt<1>("h0") @[Fragmenter.scala 294:50]
    node _new_gennum_T_2 = or(_new_gennum_T, _new_gennum_T_1) @[Fragmenter.scala 294:41]
    node new_gennum = not(_new_gennum_T_2) @[Fragmenter.scala 294:26]
    node _aFragnum_T = shr(old_gennum1, 0) @[Fragmenter.scala 295:40]
    node _aFragnum_T_1 = not(_aFragnum_T) @[Fragmenter.scala 295:26]
    node _aFragnum_T_2 = UInt<1>("h0") @[Fragmenter.scala 295:84]
    node _aFragnum_T_3 = or(_aFragnum_T_1, _aFragnum_T_2) @[Fragmenter.scala 295:72]
    node bundleOut_0_a_bits_source_lo = not(_aFragnum_T_3) @[Fragmenter.scala 295:24]
    node aLast = eq(bundleOut_0_a_bits_source_lo, UInt<1>("h0")) @[Fragmenter.scala 296:30]
    reg aToggle_r : UInt<1>, clock with :
      reset => (UInt<1>("h0"), aToggle_r) @[Reg.scala 15:16]
    node _GEN_5 = mux(aFirst, dToggle, aToggle_r) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    node _aToggle_T = mux(aFirst, dToggle, aToggle_r) @[Fragmenter.scala 297:27]
    node bundleOut_0_a_bits_source_hi_lo = eq(_aToggle_T, UInt<1>("h0")) @[Fragmenter.scala 297:23]
    node bundleOut_0_a_ready = auto_out_a_ready @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_a_valid = repeater.io_deq_valid @[Nodes.scala 1207:84 Fragmenter.scala 303:15]
    node _T_8 = and(bundleOut_0_a_ready, bundleOut_0_a_valid) @[Decoupled.scala 40:37]
    node _GEN_6 = mux(_T_8, new_gennum, gennum) @[Fragmenter.scala 300:29 Fragmenter.scala 300:38 Fragmenter.scala 291:29]
    node _repeater_io_repeat_T = eq(aHasData, UInt<1>("h0")) @[Fragmenter.scala 302:31]
    node _repeater_io_repeat_T_1 = neq(bundleOut_0_a_bits_source_lo, UInt<1>("h0")) @[Fragmenter.scala 302:53]
    node _repeater_io_repeat_T_2 = and(_repeater_io_repeat_T, _repeater_io_repeat_T_1) @[Fragmenter.scala 302:41]
    node _bundleOut_0_a_bits_address_T = shl(old_gennum1, 3) @[Fragmenter.scala 304:65]
    node _bundleOut_0_a_bits_address_T_1 = not(aOrigOH1) @[Fragmenter.scala 304:90]
    node _bundleOut_0_a_bits_address_T_2 = or(_bundleOut_0_a_bits_address_T, _bundleOut_0_a_bits_address_T_1) @[Fragmenter.scala 304:88]
    node _bundleOut_0_a_bits_address_T_3 = or(_bundleOut_0_a_bits_address_T_2, aFragOH1) @[Fragmenter.scala 304:100]
    node _bundleOut_0_a_bits_address_T_4 = or(_bundleOut_0_a_bits_address_T_3, UInt<3>("h7")) @[Fragmenter.scala 304:111]
    node _bundleOut_0_a_bits_address_T_5 = not(_bundleOut_0_a_bits_address_T_4) @[Fragmenter.scala 304:51]
    node _bundleOut_0_a_bits_address_T_6 = or(repeater.io_deq_bits_address, _bundleOut_0_a_bits_address_T_5) @[Fragmenter.scala 304:49]
    node bundleOut_0_a_bits_source_hi = cat(repeater.io_deq_bits_source, bundleOut_0_a_bits_source_hi_lo) @[Cat.scala 30:58]
    node _bundleOut_0_a_bits_source_T = cat(bundleOut_0_a_bits_source_hi, bundleOut_0_a_bits_source_lo) @[Cat.scala 30:58]
    node _T_9 = eq(repeater.io_full, UInt<1>("h0")) @[Fragmenter.scala 309:17]
    node _T_10 = eq(aHasData, UInt<1>("h0")) @[Fragmenter.scala 309:38]
    node _T_11 = or(_T_9, _T_10) @[Fragmenter.scala 309:35]
    node _T_12 = asUInt(reset) @[Fragmenter.scala 309:16]
    node _T_13 = or(_T_11, _T_12) @[Fragmenter.scala 309:16]
    node _T_14 = eq(_T_13, UInt<1>("h0")) @[Fragmenter.scala 309:16]
    node _T_15 = eq(repeater.io_full, UInt<1>("h0")) @[Fragmenter.scala 312:17]
    node _T_16 = eq(repeater.io_deq_bits_mask, UInt<8>("hff")) @[Fragmenter.scala 312:53]
    node _T_17 = or(_T_15, _T_16) @[Fragmenter.scala 312:35]
    node _T_18 = asUInt(reset) @[Fragmenter.scala 312:16]
    node _T_19 = or(_T_17, _T_18) @[Fragmenter.scala 312:16]
    node _T_20 = eq(_T_19, UInt<1>("h0")) @[Fragmenter.scala 312:16]
    node bundleIn_0_a_bits_mask = auto_in_a_bits_mask @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node _bundleOut_0_a_bits_mask_T = mux(repeater.io_full, UInt<8>("hff"), bundleIn_0_a_bits_mask) @[Fragmenter.scala 313:31]
    node bundleIn_0_a_ready = repeater.io_enq_ready @[Nodes.scala 1210:84 Fragmenter.scala 263:25]
    node bundleIn_0_a_valid = auto_in_a_valid @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_opcode = auto_in_a_bits_opcode @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_param = auto_in_a_bits_param @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_size = auto_in_a_bits_size @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_source = auto_in_a_bits_source @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_address = auto_in_a_bits_address @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_data = auto_in_a_bits_data @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_corrupt = auto_in_a_bits_corrupt @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_d_valid = _bundleIn_0_d_valid_T_1 @[Nodes.scala 1210:84 Fragmenter.scala 224:21]
    node bundleIn_0_d_bits_opcode = bundleOut_0_d_bits_opcode @[Nodes.scala 1210:84 Fragmenter.scala 225:21]
    node bundleOut_0_d_bits_param = auto_out_d_bits_param @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_param = bundleOut_0_d_bits_param @[Nodes.scala 1210:84 Fragmenter.scala 225:21]
    node bundleIn_0_d_bits_size = _bundleIn_0_d_bits_size_T @[Nodes.scala 1210:84 Fragmenter.scala 227:26]
    node bundleIn_0_d_bits_source = _bundleIn_0_d_bits_source_T @[Nodes.scala 1210:84 Fragmenter.scala 226:26]
    node bundleOut_0_d_bits_sink = auto_out_d_bits_sink @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_sink = bundleOut_0_d_bits_sink @[Nodes.scala 1210:84 Fragmenter.scala 225:21]
    node bundleOut_0_d_bits_denied = auto_out_d_bits_denied @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_denied = bundleOut_0_d_bits_denied @[Nodes.scala 1210:84 Fragmenter.scala 225:21]
    node bundleOut_0_d_bits_data = auto_out_d_bits_data @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_data = bundleOut_0_d_bits_data @[Nodes.scala 1210:84 Fragmenter.scala 225:21]
    node bundleOut_0_d_bits_corrupt = auto_out_d_bits_corrupt @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_corrupt = bundleOut_0_d_bits_corrupt @[Nodes.scala 1210:84 Fragmenter.scala 225:21]
    node bundleOut_0_a_bits_opcode = repeater.io_deq_bits_opcode @[Nodes.scala 1207:84 Fragmenter.scala 303:15]
    node bundleOut_0_a_bits_param = repeater.io_deq_bits_param @[Nodes.scala 1207:84 Fragmenter.scala 303:15]
    node bundleOut_0_a_bits_size = bits(aFrag, 1, 0) @[Nodes.scala 1207:84 Fragmenter.scala 306:25]
    node bundleOut_0_a_bits_source = bits(_bundleOut_0_a_bits_source_T, 2, 0) @[Nodes.scala 1207:84 Fragmenter.scala 305:27]
    node bundleOut_0_a_bits_address = _bundleOut_0_a_bits_address_T_6 @[Nodes.scala 1207:84 Fragmenter.scala 304:28]
    node bundleOut_0_a_bits_mask = _bundleOut_0_a_bits_mask_T @[Nodes.scala 1207:84 Fragmenter.scala 313:25]
    node bundleOut_0_a_bits_data = bundleIn_0_a_bits_data @[Nodes.scala 1207:84 Fragmenter.scala 310:25]
    node bundleOut_0_a_bits_corrupt = repeater.io_deq_bits_corrupt @[Nodes.scala 1207:84 Fragmenter.scala 303:15]
    node find_0 = _find_T_4 @[Parameters.scala 602:8 Parameters.scala 602:8]
    node _WIRE_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_valid = UInt<1>("h0") @[Bundles.scala 256:54 Fragmenter.scala 317:20]
    node _WIRE_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_bits_param = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_bits_size = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_bits_source = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_bits_mask = validif(UInt<1>("h0"), UInt<8>("h0"))
    node _WIRE_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_ready = UInt<1>("h1") @[Bundles.scala 257:54 Fragmenter.scala 318:20]
    node _WIRE_1_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_param = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_size = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_source = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_1_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_1_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_2_ready = UInt<1>("h1") @[Bundles.scala 259:54 Fragmenter.scala 319:20]
    node _WIRE_2_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_2_bits_sink = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_ready = UInt<1>("h1") @[Bundles.scala 256:54 Fragmenter.scala 320:21]
    node _WIRE_3_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_3_bits_param = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_3_bits_size = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_3_bits_source = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_3_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_3_bits_mask = validif(UInt<1>("h0"), UInt<8>("h0"))
    node _WIRE_3_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_3_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_4_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_4_valid = UInt<1>("h0") @[Bundles.scala 257:54 Fragmenter.scala 321:21]
    node _WIRE_4_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_4_bits_param = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_4_bits_size = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_4_bits_source = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_4_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_4_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_4_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_5_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_5_valid = UInt<1>("h0") @[Bundles.scala 259:54 Fragmenter.scala 322:21]
    node _WIRE_5_bits_sink = validif(UInt<1>("h0"), UInt<1>("h0"))
    auto_in_a_ready <= bundleIn_0_a_ready @[LazyModule.scala 309:16]
    auto_in_d_valid <= bundleIn_0_d_valid @[LazyModule.scala 309:16]
    auto_in_d_bits_opcode <= bundleIn_0_d_bits_opcode @[LazyModule.scala 309:16]
    auto_in_d_bits_param <= bundleIn_0_d_bits_param @[LazyModule.scala 309:16]
    auto_in_d_bits_size <= bundleIn_0_d_bits_size @[LazyModule.scala 309:16]
    auto_in_d_bits_source <= bundleIn_0_d_bits_source @[LazyModule.scala 309:16]
    auto_in_d_bits_sink <= bundleIn_0_d_bits_sink @[LazyModule.scala 309:16]
    auto_in_d_bits_denied <= bundleIn_0_d_bits_denied @[LazyModule.scala 309:16]
    auto_in_d_bits_data <= bundleIn_0_d_bits_data @[LazyModule.scala 309:16]
    auto_in_d_bits_corrupt <= bundleIn_0_d_bits_corrupt @[LazyModule.scala 309:16]
    auto_out_a_valid <= bundleOut_0_a_valid @[LazyModule.scala 311:12]
    auto_out_a_bits_opcode <= bundleOut_0_a_bits_opcode @[LazyModule.scala 311:12]
    auto_out_a_bits_param <= bundleOut_0_a_bits_param @[LazyModule.scala 311:12]
    auto_out_a_bits_size <= bundleOut_0_a_bits_size @[LazyModule.scala 311:12]
    auto_out_a_bits_source <= bundleOut_0_a_bits_source @[LazyModule.scala 311:12]
    auto_out_a_bits_address <= bundleOut_0_a_bits_address @[LazyModule.scala 311:12]
    auto_out_a_bits_mask <= bundleOut_0_a_bits_mask @[LazyModule.scala 311:12]
    auto_out_a_bits_data <= bundleOut_0_a_bits_data @[LazyModule.scala 311:12]
    auto_out_a_bits_corrupt <= bundleOut_0_a_bits_corrupt @[LazyModule.scala 311:12]
    auto_out_d_ready <= bundleOut_0_d_ready @[LazyModule.scala 311:12]
    acknum <= mux(reset, UInt<2>("h0"), _GEN_2) @[Fragmenter.scala 189:29 Fragmenter.scala 189:29]
    dOrig <= _GEN_3
    dToggle <= mux(reset, UInt<1>("h0"), _GEN_4) @[Fragmenter.scala 191:30 Fragmenter.scala 191:30]
    repeater.clock <= clock
    repeater.reset <= reset
    repeater.io_repeat <= _repeater_io_repeat_T_2 @[Fragmenter.scala 302:28]
    repeater.io_enq_valid <= bundleIn_0_a_valid @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_opcode <= bundleIn_0_a_bits_opcode @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_param <= bundleIn_0_a_bits_param @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_size <= bundleIn_0_a_bits_size @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_source <= bundleIn_0_a_bits_source @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_address <= bundleIn_0_a_bits_address @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_mask <= bundleIn_0_a_bits_mask @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_data <= bundleIn_0_a_bits_data @[Fragmenter.scala 263:25]
    repeater.io_enq_bits_corrupt <= bundleIn_0_a_bits_corrupt @[Fragmenter.scala 263:25]
    repeater.io_deq_ready <= bundleOut_0_a_ready @[Fragmenter.scala 303:15]
    gennum <= mux(reset, UInt<2>("h0"), _GEN_6) @[Fragmenter.scala 291:29 Fragmenter.scala 291:29]
    aToggle_r <= _GEN_5
    printf(clock, and(and(UInt<1>("h1"), _T_6), UInt<1>("h1")), "Assertion failed\n    at Fragmenter.scala:202 assert (!out.d.valid || (acknum_fragment & acknum_size) === UInt(0))\n") @[Fragmenter.scala 202:16]
    stop(clock, and(and(UInt<1>("h1"), _T_6), UInt<1>("h1")), 1) @[Fragmenter.scala 202:16]
    printf(clock, and(and(UInt<1>("h1"), _T_14), UInt<1>("h1")), "Assertion failed\n    at Fragmenter.scala:309 assert (!repeater.io.full || !aHasData)\n") @[Fragmenter.scala 309:16]
    stop(clock, and(and(UInt<1>("h1"), _T_14), UInt<1>("h1")), 1) @[Fragmenter.scala 309:16]
    printf(clock, and(and(UInt<1>("h1"), _T_20), UInt<1>("h1")), "Assertion failed\n    at Fragmenter.scala:312 assert (!repeater.io.full || in_a.bits.mask === fullMask)\n") @[Fragmenter.scala 312:16]
    stop(clock, and(and(UInt<1>("h1"), _T_20), UInt<1>("h1")), 1) @[Fragmenter.scala 312:16]

  module Queue :
    input clock : Clock
    input reset : UInt<1>
    output io_enq_ready : UInt<1>
    input io_enq_valid : UInt<1>
    input io_enq_bits_opcode : UInt<3>
    input io_enq_bits_param : UInt<3>
    input io_enq_bits_size : UInt<3>
    input io_enq_bits_source : UInt<1>
    input io_enq_bits_address : UInt<9>
    input io_enq_bits_mask : UInt<8>
    input io_enq_bits_data : UInt<64>
    input io_enq_bits_corrupt : UInt<1>
    input io_deq_ready : UInt<1>
    output io_deq_valid : UInt<1>
    output io_deq_bits_opcode : UInt<3>
    output io_deq_bits_param : UInt<3>
    output io_deq_bits_size : UInt<3>
    output io_deq_bits_source : UInt<1>
    output io_deq_bits_address : UInt<9>
    output io_deq_bits_mask : UInt<8>
    output io_deq_bits_data : UInt<64>
    output io_deq_bits_corrupt : UInt<1>
    output io_count : UInt<2>

    mem ram_opcode : @[Decoupled.scala 218:16]
      data-type => UInt<3>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_param : @[Decoupled.scala 218:16]
      data-type => UInt<3>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_size : @[Decoupled.scala 218:16]
      data-type => UInt<3>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_source : @[Decoupled.scala 218:16]
      data-type => UInt<1>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_address : @[Decoupled.scala 218:16]
      data-type => UInt<9>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_mask : @[Decoupled.scala 218:16]
      data-type => UInt<8>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_data : @[Decoupled.scala 218:16]
      data-type => UInt<64>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_corrupt : @[Decoupled.scala 218:16]
      data-type => UInt<1>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    reg value : UInt<1>, clock with :
      reset => (UInt<1>("h0"), value) @[Counter.scala 60:40]
    reg value_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), value_1) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maybe_full) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io_enq_ready, io_enq_valid) @[Decoupled.scala 40:37]
    node _do_deq_T = and(io_deq_ready, io_deq_valid) @[Decoupled.scala 40:37]
    node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 72:24]
    node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
    node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
    node do_enq = _do_enq_T
    node _GEN_0 = validif(do_enq, value) @[Decoupled.scala 229:17 Decoupled.scala 230:8]
    node _GEN_1 = validif(do_enq, clock) @[Decoupled.scala 229:17 Decoupled.scala 230:8]
    node _GEN_2 = mux(do_enq, UInt<1>("h1"), UInt<1>("h0")) @[Decoupled.scala 229:17 Decoupled.scala 230:8 Decoupled.scala 218:16]
    node _GEN_3 = validif(do_enq, UInt<1>("h1")) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_4 = validif(do_enq, io_enq_bits_corrupt) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_5 = validif(do_enq, io_enq_bits_data) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_6 = validif(do_enq, io_enq_bits_mask) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_7 = validif(do_enq, io_enq_bits_address) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_8 = validif(do_enq, io_enq_bits_source) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_9 = validif(do_enq, io_enq_bits_size) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_10 = validif(do_enq, io_enq_bits_param) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_11 = validif(do_enq, io_enq_bits_opcode) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_12 = mux(do_enq, _value_T_1, value) @[Decoupled.scala 229:17 Counter.scala 76:15 Counter.scala 60:40]
    node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 72:24]
    node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
    node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
    node do_deq = _do_deq_T
    node _GEN_13 = mux(do_deq, _value_T_3, value_1) @[Decoupled.scala 233:17 Counter.scala 76:15 Counter.scala 60:40]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    node _GEN_14 = mux(_T, do_enq, maybe_full) @[Decoupled.scala 236:28 Decoupled.scala 237:16 Decoupled.scala 221:27]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 259:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 259:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 259:62]
    io_enq_ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    io_deq_valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    io_deq_bits_opcode <= ram_opcode.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_param <= ram_param.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_size <= ram_size.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_source <= ram_source.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_address <= ram_address.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_mask <= ram_mask.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_data <= ram_data.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_corrupt <= ram_corrupt.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_count <= _io_count_T_2 @[Decoupled.scala 259:14]
    ram_opcode.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_param.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_size.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_source.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_address.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_mask.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_corrupt.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_opcode.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_param.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_size.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_source.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_address.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_mask.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_corrupt.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_opcode.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_param.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_size.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_source.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_address.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_mask.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_corrupt.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_opcode.MPORT.addr <= _GEN_0
    ram_param.MPORT.addr <= _GEN_0
    ram_size.MPORT.addr <= _GEN_0
    ram_source.MPORT.addr <= _GEN_0
    ram_address.MPORT.addr <= _GEN_0
    ram_mask.MPORT.addr <= _GEN_0
    ram_data.MPORT.addr <= _GEN_0
    ram_corrupt.MPORT.addr <= _GEN_0
    ram_opcode.MPORT.en <= _GEN_2
    ram_param.MPORT.en <= _GEN_2
    ram_size.MPORT.en <= _GEN_2
    ram_source.MPORT.en <= _GEN_2
    ram_address.MPORT.en <= _GEN_2
    ram_mask.MPORT.en <= _GEN_2
    ram_data.MPORT.en <= _GEN_2
    ram_corrupt.MPORT.en <= _GEN_2
    ram_opcode.MPORT.clk <= _GEN_1
    ram_param.MPORT.clk <= _GEN_1
    ram_size.MPORT.clk <= _GEN_1
    ram_source.MPORT.clk <= _GEN_1
    ram_address.MPORT.clk <= _GEN_1
    ram_mask.MPORT.clk <= _GEN_1
    ram_data.MPORT.clk <= _GEN_1
    ram_corrupt.MPORT.clk <= _GEN_1
    ram_opcode.MPORT.data <= _GEN_11
    ram_param.MPORT.data <= _GEN_10
    ram_size.MPORT.data <= _GEN_9
    ram_source.MPORT.data <= _GEN_8
    ram_address.MPORT.data <= _GEN_7
    ram_mask.MPORT.data <= _GEN_6
    ram_data.MPORT.data <= _GEN_5
    ram_corrupt.MPORT.data <= _GEN_4
    ram_opcode.MPORT.mask <= _GEN_3
    ram_param.MPORT.mask <= _GEN_3
    ram_size.MPORT.mask <= _GEN_3
    ram_source.MPORT.mask <= _GEN_3
    ram_address.MPORT.mask <= _GEN_3
    ram_mask.MPORT.mask <= _GEN_3
    ram_data.MPORT.mask <= _GEN_3
    ram_corrupt.MPORT.mask <= _GEN_3
    value <= mux(reset, UInt<1>("h0"), _GEN_12) @[Counter.scala 60:40 Counter.scala 60:40]
    value_1 <= mux(reset, UInt<1>("h0"), _GEN_13) @[Counter.scala 60:40 Counter.scala 60:40]
    maybe_full <= mux(reset, UInt<1>("h0"), _GEN_14) @[Decoupled.scala 221:27 Decoupled.scala 221:27]

  module Queue_1 :
    input clock : Clock
    input reset : UInt<1>
    output io_enq_ready : UInt<1>
    input io_enq_valid : UInt<1>
    input io_enq_bits_opcode : UInt<3>
    input io_enq_bits_param : UInt<2>
    input io_enq_bits_size : UInt<3>
    input io_enq_bits_source : UInt<1>
    input io_enq_bits_sink : UInt<1>
    input io_enq_bits_denied : UInt<1>
    input io_enq_bits_data : UInt<64>
    input io_enq_bits_corrupt : UInt<1>
    input io_deq_ready : UInt<1>
    output io_deq_valid : UInt<1>
    output io_deq_bits_opcode : UInt<3>
    output io_deq_bits_param : UInt<2>
    output io_deq_bits_size : UInt<3>
    output io_deq_bits_source : UInt<1>
    output io_deq_bits_sink : UInt<1>
    output io_deq_bits_denied : UInt<1>
    output io_deq_bits_data : UInt<64>
    output io_deq_bits_corrupt : UInt<1>
    output io_count : UInt<2>

    mem ram_opcode : @[Decoupled.scala 218:16]
      data-type => UInt<3>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_param : @[Decoupled.scala 218:16]
      data-type => UInt<2>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_size : @[Decoupled.scala 218:16]
      data-type => UInt<3>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_source : @[Decoupled.scala 218:16]
      data-type => UInt<1>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_sink : @[Decoupled.scala 218:16]
      data-type => UInt<1>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_denied : @[Decoupled.scala 218:16]
      data-type => UInt<1>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_data : @[Decoupled.scala 218:16]
      data-type => UInt<64>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_corrupt : @[Decoupled.scala 218:16]
      data-type => UInt<1>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    reg value : UInt<1>, clock with :
      reset => (UInt<1>("h0"), value) @[Counter.scala 60:40]
    reg value_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), value_1) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maybe_full) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io_enq_ready, io_enq_valid) @[Decoupled.scala 40:37]
    node _do_deq_T = and(io_deq_ready, io_deq_valid) @[Decoupled.scala 40:37]
    node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 72:24]
    node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
    node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
    node do_enq = _do_enq_T
    node _GEN_0 = validif(do_enq, value) @[Decoupled.scala 229:17 Decoupled.scala 230:8]
    node _GEN_1 = validif(do_enq, clock) @[Decoupled.scala 229:17 Decoupled.scala 230:8]
    node _GEN_2 = mux(do_enq, UInt<1>("h1"), UInt<1>("h0")) @[Decoupled.scala 229:17 Decoupled.scala 230:8 Decoupled.scala 218:16]
    node _GEN_3 = validif(do_enq, UInt<1>("h1")) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_4 = validif(do_enq, io_enq_bits_corrupt) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_5 = validif(do_enq, io_enq_bits_data) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_6 = validif(do_enq, io_enq_bits_denied) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_7 = validif(do_enq, io_enq_bits_sink) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_8 = validif(do_enq, io_enq_bits_source) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_9 = validif(do_enq, io_enq_bits_size) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_10 = validif(do_enq, io_enq_bits_param) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_11 = validif(do_enq, io_enq_bits_opcode) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_12 = mux(do_enq, _value_T_1, value) @[Decoupled.scala 229:17 Counter.scala 76:15 Counter.scala 60:40]
    node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 72:24]
    node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
    node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
    node do_deq = _do_deq_T
    node _GEN_13 = mux(do_deq, _value_T_3, value_1) @[Decoupled.scala 233:17 Counter.scala 76:15 Counter.scala 60:40]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    node _GEN_14 = mux(_T, do_enq, maybe_full) @[Decoupled.scala 236:28 Decoupled.scala 237:16 Decoupled.scala 221:27]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 259:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 259:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 259:62]
    io_enq_ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    io_deq_valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    io_deq_bits_opcode <= ram_opcode.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_param <= ram_param.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_size <= ram_size.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_source <= ram_source.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_sink <= ram_sink.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_denied <= ram_denied.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_data <= ram_data.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_corrupt <= ram_corrupt.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_count <= _io_count_T_2 @[Decoupled.scala 259:14]
    ram_opcode.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_param.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_size.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_source.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_sink.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_denied.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_corrupt.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_opcode.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_param.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_size.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_source.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_sink.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_denied.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_corrupt.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_opcode.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_param.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_size.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_source.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_sink.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_denied.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_corrupt.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_opcode.MPORT.addr <= _GEN_0
    ram_param.MPORT.addr <= _GEN_0
    ram_size.MPORT.addr <= _GEN_0
    ram_source.MPORT.addr <= _GEN_0
    ram_sink.MPORT.addr <= _GEN_0
    ram_denied.MPORT.addr <= _GEN_0
    ram_data.MPORT.addr <= _GEN_0
    ram_corrupt.MPORT.addr <= _GEN_0
    ram_opcode.MPORT.en <= _GEN_2
    ram_param.MPORT.en <= _GEN_2
    ram_size.MPORT.en <= _GEN_2
    ram_source.MPORT.en <= _GEN_2
    ram_sink.MPORT.en <= _GEN_2
    ram_denied.MPORT.en <= _GEN_2
    ram_data.MPORT.en <= _GEN_2
    ram_corrupt.MPORT.en <= _GEN_2
    ram_opcode.MPORT.clk <= _GEN_1
    ram_param.MPORT.clk <= _GEN_1
    ram_size.MPORT.clk <= _GEN_1
    ram_source.MPORT.clk <= _GEN_1
    ram_sink.MPORT.clk <= _GEN_1
    ram_denied.MPORT.clk <= _GEN_1
    ram_data.MPORT.clk <= _GEN_1
    ram_corrupt.MPORT.clk <= _GEN_1
    ram_opcode.MPORT.data <= _GEN_11
    ram_param.MPORT.data <= _GEN_10
    ram_size.MPORT.data <= _GEN_9
    ram_source.MPORT.data <= _GEN_8
    ram_sink.MPORT.data <= _GEN_7
    ram_denied.MPORT.data <= _GEN_6
    ram_data.MPORT.data <= _GEN_5
    ram_corrupt.MPORT.data <= _GEN_4
    ram_opcode.MPORT.mask <= _GEN_3
    ram_param.MPORT.mask <= _GEN_3
    ram_size.MPORT.mask <= _GEN_3
    ram_source.MPORT.mask <= _GEN_3
    ram_sink.MPORT.mask <= _GEN_3
    ram_denied.MPORT.mask <= _GEN_3
    ram_data.MPORT.mask <= _GEN_3
    ram_corrupt.MPORT.mask <= _GEN_3
    value <= mux(reset, UInt<1>("h0"), _GEN_12) @[Counter.scala 60:40 Counter.scala 60:40]
    value_1 <= mux(reset, UInt<1>("h0"), _GEN_13) @[Counter.scala 60:40 Counter.scala 60:40]
    maybe_full <= mux(reset, UInt<1>("h0"), _GEN_14) @[Decoupled.scala 221:27 Decoupled.scala 221:27]

  module TLBuffer :
    input clock : Clock
    input reset : UInt<1>
    output auto_in_a_ready : UInt<1>
    input auto_in_a_valid : UInt<1>
    input auto_in_a_bits_opcode : UInt<3>
    input auto_in_a_bits_param : UInt<3>
    input auto_in_a_bits_size : UInt<3>
    input auto_in_a_bits_source : UInt<1>
    input auto_in_a_bits_address : UInt<9>
    input auto_in_a_bits_mask : UInt<8>
    input auto_in_a_bits_data : UInt<64>
    input auto_in_a_bits_corrupt : UInt<1>
    input auto_in_d_ready : UInt<1>
    output auto_in_d_valid : UInt<1>
    output auto_in_d_bits_opcode : UInt<3>
    output auto_in_d_bits_param : UInt<2>
    output auto_in_d_bits_size : UInt<3>
    output auto_in_d_bits_source : UInt<1>
    output auto_in_d_bits_sink : UInt<1>
    output auto_in_d_bits_denied : UInt<1>
    output auto_in_d_bits_data : UInt<64>
    output auto_in_d_bits_corrupt : UInt<1>
    input auto_out_a_ready : UInt<1>
    output auto_out_a_valid : UInt<1>
    output auto_out_a_bits_opcode : UInt<3>
    output auto_out_a_bits_param : UInt<3>
    output auto_out_a_bits_size : UInt<3>
    output auto_out_a_bits_source : UInt<1>
    output auto_out_a_bits_address : UInt<9>
    output auto_out_a_bits_mask : UInt<8>
    output auto_out_a_bits_data : UInt<64>
    output auto_out_a_bits_corrupt : UInt<1>
    output auto_out_d_ready : UInt<1>
    input auto_out_d_valid : UInt<1>
    input auto_out_d_bits_opcode : UInt<3>
    input auto_out_d_bits_param : UInt<2>
    input auto_out_d_bits_size : UInt<3>
    input auto_out_d_bits_source : UInt<1>
    input auto_out_d_bits_sink : UInt<1>
    input auto_out_d_bits_denied : UInt<1>
    input auto_out_d_bits_data : UInt<64>
    input auto_out_d_bits_corrupt : UInt<1>

    inst bundleOut_0_a_q of Queue @[Decoupled.scala 296:21]
    inst bundleIn_0_d_q of Queue_1 @[Decoupled.scala 296:21]
    node bundleIn_0_a_ready = bundleOut_0_a_q.io_enq_ready @[Nodes.scala 1210:84 Decoupled.scala 299:17]
    node bundleIn_0_a_valid = auto_in_a_valid @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_opcode = auto_in_a_bits_opcode @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_param = auto_in_a_bits_param @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_size = auto_in_a_bits_size @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_source = auto_in_a_bits_source @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_address = auto_in_a_bits_address @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_mask = auto_in_a_bits_mask @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_data = auto_in_a_bits_data @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_corrupt = auto_in_a_bits_corrupt @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_d_ready = auto_in_d_ready @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_d_valid = bundleIn_0_d_q.io_deq_valid @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_opcode = bundleIn_0_d_q.io_deq_bits_opcode @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_param = bundleIn_0_d_q.io_deq_bits_param @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_size = bundleIn_0_d_q.io_deq_bits_size @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_source = bundleIn_0_d_q.io_deq_bits_source @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_sink = bundleIn_0_d_q.io_deq_bits_sink @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_denied = bundleIn_0_d_q.io_deq_bits_denied @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_data = bundleIn_0_d_q.io_deq_bits_data @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleIn_0_d_bits_corrupt = bundleIn_0_d_q.io_deq_bits_corrupt @[Nodes.scala 1210:84 Buffer.scala 38:13]
    node bundleOut_0_a_ready = auto_out_a_ready @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_a_valid = bundleOut_0_a_q.io_deq_valid @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_opcode = bundleOut_0_a_q.io_deq_bits_opcode @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_param = bundleOut_0_a_q.io_deq_bits_param @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_size = bundleOut_0_a_q.io_deq_bits_size @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_source = bundleOut_0_a_q.io_deq_bits_source @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_address = bundleOut_0_a_q.io_deq_bits_address @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_mask = bundleOut_0_a_q.io_deq_bits_mask @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_data = bundleOut_0_a_q.io_deq_bits_data @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_a_bits_corrupt = bundleOut_0_a_q.io_deq_bits_corrupt @[Nodes.scala 1207:84 Buffer.scala 37:13]
    node bundleOut_0_d_ready = bundleIn_0_d_q.io_enq_ready @[Nodes.scala 1207:84 Decoupled.scala 299:17]
    node bundleOut_0_d_valid = auto_out_d_valid @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_opcode = auto_out_d_bits_opcode @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_param = auto_out_d_bits_param @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_size = auto_out_d_bits_size @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_source = auto_out_d_bits_source @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_sink = auto_out_d_bits_sink @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_denied = auto_out_d_bits_denied @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_data = auto_out_d_bits_data @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleOut_0_d_bits_corrupt = auto_out_d_bits_corrupt @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node _WIRE_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_valid = UInt<1>("h0") @[Bundles.scala 256:54 Buffer.scala 45:20]
    node _WIRE_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_bits_param = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_bits_size = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_bits_source = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_bits_mask = validif(UInt<1>("h0"), UInt<8>("h0"))
    node _WIRE_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_ready = UInt<1>("h1") @[Bundles.scala 257:54 Buffer.scala 46:20]
    node _WIRE_1_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_param = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_size = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_1_bits_source = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_1_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_1_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_1_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_2_ready = UInt<1>("h1") @[Bundles.scala 259:54 Buffer.scala 47:20]
    node _WIRE_2_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_2_bits_sink = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_ready = UInt<1>("h1") @[Bundles.scala 256:54 Buffer.scala 48:21]
    node _WIRE_3_valid = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_3_bits_param = validif(UInt<1>("h0"), UInt<2>("h0"))
    node _WIRE_3_bits_size = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_3_bits_source = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_3_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_3_bits_mask = validif(UInt<1>("h0"), UInt<8>("h0"))
    node _WIRE_3_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_3_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_4_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_4_valid = UInt<1>("h0") @[Bundles.scala 257:54 Buffer.scala 49:21]
    node _WIRE_4_bits_opcode = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_4_bits_param = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_4_bits_size = validif(UInt<1>("h0"), UInt<3>("h0"))
    node _WIRE_4_bits_source = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_4_bits_address = validif(UInt<1>("h0"), UInt<9>("h0"))
    node _WIRE_4_bits_data = validif(UInt<1>("h0"), UInt<64>("h0"))
    node _WIRE_4_bits_corrupt = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_5_ready = validif(UInt<1>("h0"), UInt<1>("h0"))
    node _WIRE_5_valid = UInt<1>("h0") @[Bundles.scala 259:54 Buffer.scala 50:21]
    node _WIRE_5_bits_sink = validif(UInt<1>("h0"), UInt<1>("h0"))
    auto_in_a_ready <= bundleIn_0_a_ready @[LazyModule.scala 309:16]
    auto_in_d_valid <= bundleIn_0_d_valid @[LazyModule.scala 309:16]
    auto_in_d_bits_opcode <= bundleIn_0_d_bits_opcode @[LazyModule.scala 309:16]
    auto_in_d_bits_param <= bundleIn_0_d_bits_param @[LazyModule.scala 309:16]
    auto_in_d_bits_size <= bundleIn_0_d_bits_size @[LazyModule.scala 309:16]
    auto_in_d_bits_source <= bundleIn_0_d_bits_source @[LazyModule.scala 309:16]
    auto_in_d_bits_sink <= bundleIn_0_d_bits_sink @[LazyModule.scala 309:16]
    auto_in_d_bits_denied <= bundleIn_0_d_bits_denied @[LazyModule.scala 309:16]
    auto_in_d_bits_data <= bundleIn_0_d_bits_data @[LazyModule.scala 309:16]
    auto_in_d_bits_corrupt <= bundleIn_0_d_bits_corrupt @[LazyModule.scala 309:16]
    auto_out_a_valid <= bundleOut_0_a_valid @[LazyModule.scala 311:12]
    auto_out_a_bits_opcode <= bundleOut_0_a_bits_opcode @[LazyModule.scala 311:12]
    auto_out_a_bits_param <= bundleOut_0_a_bits_param @[LazyModule.scala 311:12]
    auto_out_a_bits_size <= bundleOut_0_a_bits_size @[LazyModule.scala 311:12]
    auto_out_a_bits_source <= bundleOut_0_a_bits_source @[LazyModule.scala 311:12]
    auto_out_a_bits_address <= bundleOut_0_a_bits_address @[LazyModule.scala 311:12]
    auto_out_a_bits_mask <= bundleOut_0_a_bits_mask @[LazyModule.scala 311:12]
    auto_out_a_bits_data <= bundleOut_0_a_bits_data @[LazyModule.scala 311:12]
    auto_out_a_bits_corrupt <= bundleOut_0_a_bits_corrupt @[LazyModule.scala 311:12]
    auto_out_d_ready <= bundleOut_0_d_ready @[LazyModule.scala 311:12]
    bundleOut_0_a_q.clock <= clock
    bundleOut_0_a_q.reset <= reset
    bundleOut_0_a_q.io_enq_valid <= bundleIn_0_a_valid @[Decoupled.scala 297:22]
    bundleOut_0_a_q.io_enq_bits_opcode <= bundleIn_0_a_bits_opcode @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_param <= bundleIn_0_a_bits_param @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_size <= bundleIn_0_a_bits_size @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_source <= bundleIn_0_a_bits_source @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_address <= bundleIn_0_a_bits_address @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_mask <= bundleIn_0_a_bits_mask @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_data <= bundleIn_0_a_bits_data @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_enq_bits_corrupt <= bundleIn_0_a_bits_corrupt @[Decoupled.scala 298:21]
    bundleOut_0_a_q.io_deq_ready <= bundleOut_0_a_ready @[Buffer.scala 37:13]
    bundleIn_0_d_q.clock <= clock
    bundleIn_0_d_q.reset <= reset
    bundleIn_0_d_q.io_enq_valid <= bundleOut_0_d_valid @[Decoupled.scala 297:22]
    bundleIn_0_d_q.io_enq_bits_opcode <= bundleOut_0_d_bits_opcode @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_param <= bundleOut_0_d_bits_param @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_size <= bundleOut_0_d_bits_size @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_source <= bundleOut_0_d_bits_source @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_sink <= bundleOut_0_d_bits_sink @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_denied <= bundleOut_0_d_bits_denied @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_data <= bundleOut_0_d_bits_data @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_enq_bits_corrupt <= bundleOut_0_d_bits_corrupt @[Decoupled.scala 298:21]
    bundleIn_0_d_q.io_deq_ready <= bundleIn_0_d_ready @[Buffer.scala 38:13]

  module BundleBridgeToTL :
    input clock : Clock
    input reset : UInt<1>
    output auto_in_a_ready : UInt<1>
    input auto_in_a_valid : UInt<1>
    input auto_in_a_bits_opcode : UInt<3>
    input auto_in_a_bits_param : UInt<3>
    input auto_in_a_bits_size : UInt<3>
    input auto_in_a_bits_source : UInt<1>
    input auto_in_a_bits_address : UInt<9>
    input auto_in_a_bits_mask : UInt<8>
    input auto_in_a_bits_data : UInt<64>
    input auto_in_a_bits_corrupt : UInt<1>
    input auto_in_d_ready : UInt<1>
    output auto_in_d_valid : UInt<1>
    output auto_in_d_bits_opcode : UInt<3>
    output auto_in_d_bits_param : UInt<2>
    output auto_in_d_bits_size : UInt<3>
    output auto_in_d_bits_source : UInt<1>
    output auto_in_d_bits_sink : UInt<1>
    output auto_in_d_bits_denied : UInt<1>
    output auto_in_d_bits_data : UInt<64>
    output auto_in_d_bits_corrupt : UInt<1>
    input auto_out_a_ready : UInt<1>
    output auto_out_a_valid : UInt<1>
    output auto_out_a_bits_opcode : UInt<3>
    output auto_out_a_bits_param : UInt<3>
    output auto_out_a_bits_size : UInt<3>
    output auto_out_a_bits_source : UInt<1>
    output auto_out_a_bits_address : UInt<9>
    output auto_out_a_bits_mask : UInt<8>
    output auto_out_a_bits_data : UInt<64>
    output auto_out_a_bits_corrupt : UInt<1>
    output auto_out_d_ready : UInt<1>
    input auto_out_d_valid : UInt<1>
    input auto_out_d_bits_opcode : UInt<3>
    input auto_out_d_bits_param : UInt<2>
    input auto_out_d_bits_size : UInt<3>
    input auto_out_d_bits_source : UInt<1>
    input auto_out_d_bits_sink : UInt<1>
    input auto_out_d_bits_denied : UInt<1>
    input auto_out_d_bits_data : UInt<64>
    input auto_out_d_bits_corrupt : UInt<1>

    node bundleOut_0_a_ready = auto_out_a_ready @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_a_ready = bundleOut_0_a_ready @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleIn_0_a_valid = auto_in_a_valid @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_opcode = auto_in_a_bits_opcode @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_param = auto_in_a_bits_param @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_size = auto_in_a_bits_size @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_source = auto_in_a_bits_source @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_address = auto_in_a_bits_address @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_mask = auto_in_a_bits_mask @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_data = auto_in_a_bits_data @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_a_bits_corrupt = auto_in_a_bits_corrupt @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleIn_0_d_ready = auto_in_d_ready @[Nodes.scala 1210:84 LazyModule.scala 309:16]
    node bundleOut_0_d_valid = auto_out_d_valid @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_valid = bundleOut_0_d_valid @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_opcode = auto_out_d_bits_opcode @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_opcode = bundleOut_0_d_bits_opcode @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_param = auto_out_d_bits_param @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_param = bundleOut_0_d_bits_param @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_size = auto_out_d_bits_size @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_size = bundleOut_0_d_bits_size @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_source = auto_out_d_bits_source @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_source = bundleOut_0_d_bits_source @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_sink = auto_out_d_bits_sink @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_sink = bundleOut_0_d_bits_sink @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_denied = auto_out_d_bits_denied @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_denied = bundleOut_0_d_bits_denied @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_data = auto_out_d_bits_data @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_data = bundleOut_0_d_bits_data @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_d_bits_corrupt = auto_out_d_bits_corrupt @[Nodes.scala 1207:84 LazyModule.scala 311:12]
    node bundleIn_0_d_bits_corrupt = bundleOut_0_d_bits_corrupt @[Nodes.scala 1210:84 Node.scala 60:11]
    node bundleOut_0_a_valid = bundleIn_0_a_valid @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_opcode = bundleIn_0_a_bits_opcode @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_param = bundleIn_0_a_bits_param @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_size = bundleIn_0_a_bits_size @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_source = bundleIn_0_a_bits_source @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_address = bundleIn_0_a_bits_address @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_mask = bundleIn_0_a_bits_mask @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_data = bundleIn_0_a_bits_data @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_a_bits_corrupt = bundleIn_0_a_bits_corrupt @[Nodes.scala 1207:84 Node.scala 60:11]
    node bundleOut_0_d_ready = bundleIn_0_d_ready @[Nodes.scala 1207:84 Node.scala 60:11]
    auto_in_a_ready <= bundleIn_0_a_ready @[LazyModule.scala 309:16]
    auto_in_d_valid <= bundleIn_0_d_valid @[LazyModule.scala 309:16]
    auto_in_d_bits_opcode <= bundleIn_0_d_bits_opcode @[LazyModule.scala 309:16]
    auto_in_d_bits_param <= bundleIn_0_d_bits_param @[LazyModule.scala 309:16]
    auto_in_d_bits_size <= bundleIn_0_d_bits_size @[LazyModule.scala 309:16]
    auto_in_d_bits_source <= bundleIn_0_d_bits_source @[LazyModule.scala 309:16]
    auto_in_d_bits_sink <= bundleIn_0_d_bits_sink @[LazyModule.scala 309:16]
    auto_in_d_bits_denied <= bundleIn_0_d_bits_denied @[LazyModule.scala 309:16]
    auto_in_d_bits_data <= bundleIn_0_d_bits_data @[LazyModule.scala 309:16]
    auto_in_d_bits_corrupt <= bundleIn_0_d_bits_corrupt @[LazyModule.scala 309:16]
    auto_out_a_valid <= bundleOut_0_a_valid @[LazyModule.scala 311:12]
    auto_out_a_bits_opcode <= bundleOut_0_a_bits_opcode @[LazyModule.scala 311:12]
    auto_out_a_bits_param <= bundleOut_0_a_bits_param @[LazyModule.scala 311:12]
    auto_out_a_bits_size <= bundleOut_0_a_bits_size @[LazyModule.scala 311:12]
    auto_out_a_bits_source <= bundleOut_0_a_bits_source @[LazyModule.scala 311:12]
    auto_out_a_bits_address <= bundleOut_0_a_bits_address @[LazyModule.scala 311:12]
    auto_out_a_bits_mask <= bundleOut_0_a_bits_mask @[LazyModule.scala 311:12]
    auto_out_a_bits_data <= bundleOut_0_a_bits_data @[LazyModule.scala 311:12]
    auto_out_a_bits_corrupt <= bundleOut_0_a_bits_corrupt @[LazyModule.scala 311:12]
    auto_out_d_ready <= bundleOut_0_d_ready @[LazyModule.scala 311:12]

  module TLRAMStandalone :
    input clock : Clock
    input reset : UInt<1>
    output in_a_ready : UInt<1>
    input in_a_valid : UInt<1>
    input in_a_bits_opcode : UInt<3>
    input in_a_bits_param : UInt<3>
    input in_a_bits_size : UInt<3>
    input in_a_bits_source : UInt<1>
    input in_a_bits_address : UInt<9>
    input in_a_bits_mask : UInt<8>
    input in_a_bits_data : UInt<64>
    input in_a_bits_corrupt : UInt<1>
    input in_d_ready : UInt<1>
    output in_d_valid : UInt<1>
    output in_d_bits_opcode : UInt<3>
    output in_d_bits_param : UInt<2>
    output in_d_bits_size : UInt<3>
    output in_d_bits_source : UInt<1>
    output in_d_bits_sink : UInt<1>
    output in_d_bits_denied : UInt<1>
    output in_d_bits_data : UInt<64>
    output in_d_bits_corrupt : UInt<1>

    inst ram of TLRAM @[StandaloneBlocks.scala 126:24]
    inst fragmenter of TLFragmenter @[Fragmenter.scala 333:34]
    inst buffer of TLBuffer @[Buffer.scala 68:28]
    inst converter of BundleBridgeToTL @[Node.scala 67:31]
    node bundleOut_0_a_ready = converter.auto_in_a_ready @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_a_valid = in_a_valid @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_opcode = in_a_bits_opcode @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_param = in_a_bits_param @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_size = in_a_bits_size @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_source = in_a_bits_source @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_address = in_a_bits_address @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_mask = in_a_bits_mask @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_data = in_a_bits_data @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_a_bits_corrupt = in_a_bits_corrupt @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_d_ready = in_d_ready @[Nodes.scala 1207:84 BundleBridge.scala 77:12]
    node bundleOut_0_d_valid = converter.auto_in_d_valid @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_opcode = converter.auto_in_d_bits_opcode @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_param = converter.auto_in_d_bits_param @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_size = converter.auto_in_d_bits_size @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_source = converter.auto_in_d_bits_source @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_sink = converter.auto_in_d_bits_sink @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_denied = converter.auto_in_d_bits_denied @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_data = converter.auto_in_d_bits_data @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    node bundleOut_0_d_bits_corrupt = converter.auto_in_d_bits_corrupt @[Nodes.scala 1207:84 LazyModule.scala 298:16]
    in_a_ready <= bundleOut_0_a_ready @[BundleBridge.scala 77:12]
    in_d_valid <= bundleOut_0_d_valid @[BundleBridge.scala 77:12]
    in_d_bits_opcode <= bundleOut_0_d_bits_opcode @[BundleBridge.scala 77:12]
    in_d_bits_param <= bundleOut_0_d_bits_param @[BundleBridge.scala 77:12]
    in_d_bits_size <= bundleOut_0_d_bits_size @[BundleBridge.scala 77:12]
    in_d_bits_source <= bundleOut_0_d_bits_source @[BundleBridge.scala 77:12]
    in_d_bits_sink <= bundleOut_0_d_bits_sink @[BundleBridge.scala 77:12]
    in_d_bits_denied <= bundleOut_0_d_bits_denied @[BundleBridge.scala 77:12]
    in_d_bits_data <= bundleOut_0_d_bits_data @[BundleBridge.scala 77:12]
    in_d_bits_corrupt <= bundleOut_0_d_bits_corrupt @[BundleBridge.scala 77:12]
    ram.clock <= clock
    ram.reset <= reset
    ram.auto_in_a_valid <= fragmenter.auto_out_a_valid @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_opcode <= fragmenter.auto_out_a_bits_opcode @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_param <= fragmenter.auto_out_a_bits_param @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_size <= fragmenter.auto_out_a_bits_size @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_source <= fragmenter.auto_out_a_bits_source @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_address <= fragmenter.auto_out_a_bits_address @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_mask <= fragmenter.auto_out_a_bits_mask @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_data <= fragmenter.auto_out_a_bits_data @[LazyModule.scala 296:16]
    ram.auto_in_a_bits_corrupt <= fragmenter.auto_out_a_bits_corrupt @[LazyModule.scala 296:16]
    ram.auto_in_d_ready <= fragmenter.auto_out_d_ready @[LazyModule.scala 296:16]
    fragmenter.clock <= clock
    fragmenter.reset <= reset
    fragmenter.auto_in_a_valid <= buffer.auto_out_a_valid @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_opcode <= buffer.auto_out_a_bits_opcode @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_param <= buffer.auto_out_a_bits_param @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_size <= buffer.auto_out_a_bits_size @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_source <= buffer.auto_out_a_bits_source @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_address <= buffer.auto_out_a_bits_address @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_mask <= buffer.auto_out_a_bits_mask @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_data <= buffer.auto_out_a_bits_data @[LazyModule.scala 296:16]
    fragmenter.auto_in_a_bits_corrupt <= buffer.auto_out_a_bits_corrupt @[LazyModule.scala 296:16]
    fragmenter.auto_in_d_ready <= buffer.auto_out_d_ready @[LazyModule.scala 296:16]
    fragmenter.auto_out_a_ready <= ram.auto_in_a_ready @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_valid <= ram.auto_in_d_valid @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_opcode <= ram.auto_in_d_bits_opcode @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_param <= ram.auto_in_d_bits_param @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_size <= ram.auto_in_d_bits_size @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_source <= ram.auto_in_d_bits_source @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_sink <= ram.auto_in_d_bits_sink @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_denied <= ram.auto_in_d_bits_denied @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_data <= ram.auto_in_d_bits_data @[LazyModule.scala 296:16]
    fragmenter.auto_out_d_bits_corrupt <= ram.auto_in_d_bits_corrupt @[LazyModule.scala 296:16]
    buffer.clock <= clock
    buffer.reset <= reset
    buffer.auto_in_a_valid <= converter.auto_out_a_valid @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_opcode <= converter.auto_out_a_bits_opcode @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_param <= converter.auto_out_a_bits_param @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_size <= converter.auto_out_a_bits_size @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_source <= converter.auto_out_a_bits_source @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_address <= converter.auto_out_a_bits_address @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_mask <= converter.auto_out_a_bits_mask @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_data <= converter.auto_out_a_bits_data @[LazyModule.scala 296:16]
    buffer.auto_in_a_bits_corrupt <= converter.auto_out_a_bits_corrupt @[LazyModule.scala 296:16]
    buffer.auto_in_d_ready <= converter.auto_out_d_ready @[LazyModule.scala 296:16]
    buffer.auto_out_a_ready <= fragmenter.auto_in_a_ready @[LazyModule.scala 296:16]
    buffer.auto_out_d_valid <= fragmenter.auto_in_d_valid @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_opcode <= fragmenter.auto_in_d_bits_opcode @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_param <= fragmenter.auto_in_d_bits_param @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_size <= fragmenter.auto_in_d_bits_size @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_source <= fragmenter.auto_in_d_bits_source @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_sink <= fragmenter.auto_in_d_bits_sink @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_denied <= fragmenter.auto_in_d_bits_denied @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_data <= fragmenter.auto_in_d_bits_data @[LazyModule.scala 296:16]
    buffer.auto_out_d_bits_corrupt <= fragmenter.auto_in_d_bits_corrupt @[LazyModule.scala 296:16]
    converter.clock <= clock
    converter.reset <= reset
    converter.auto_in_a_valid <= bundleOut_0_a_valid @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_opcode <= bundleOut_0_a_bits_opcode @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_param <= bundleOut_0_a_bits_param @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_size <= bundleOut_0_a_bits_size @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_source <= bundleOut_0_a_bits_source @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_address <= bundleOut_0_a_bits_address @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_mask <= bundleOut_0_a_bits_mask @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_data <= bundleOut_0_a_bits_data @[LazyModule.scala 298:16]
    converter.auto_in_a_bits_corrupt <= bundleOut_0_a_bits_corrupt @[LazyModule.scala 298:16]
    converter.auto_in_d_ready <= bundleOut_0_d_ready @[LazyModule.scala 298:16]
    converter.auto_out_a_ready <= buffer.auto_in_a_ready @[LazyModule.scala 296:16]
    converter.auto_out_d_valid <= buffer.auto_in_d_valid @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_opcode <= buffer.auto_in_d_bits_opcode @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_param <= buffer.auto_in_d_bits_param @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_size <= buffer.auto_in_d_bits_size @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_source <= buffer.auto_in_d_bits_source @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_sink <= buffer.auto_in_d_bits_sink @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_denied <= buffer.auto_in_d_bits_denied @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_data <= buffer.auto_in_d_bits_data @[LazyModule.scala 296:16]
    converter.auto_out_d_bits_corrupt <= buffer.auto_in_d_bits_corrupt @[LazyModule.scala 296:16]
