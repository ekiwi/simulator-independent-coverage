
/* verilator lint_off UNOPTFLAT */
module ClockBufferBB(input I, input CE, output O);
  reg en_latched /*verilator clock_enable*/;
  always_latch @(*) if (!I) en_latched = CE;
  assign O = en_latched & I;
endmodule
  