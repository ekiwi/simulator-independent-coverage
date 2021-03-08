module test(
  input        clock,
  input  [7:0] a,
  input  [7:0] b
);
  wire [8:0] _GEN_0 = a + b;
  TestPropery: cover property (@(posedge clock) _GEN_0 == 9'h0);
  NotTestPropery: cover property (@(posedge clock) !(_GEN_0 == 9'h0));
endmodule
