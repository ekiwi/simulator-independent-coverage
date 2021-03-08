module test(
  input        clock,
  input  [7:0] a,
  input  [7:0] b
);
  wire  c1_clock;
  wire [7:0] c1_a;
  wire  x2_clock;
  wire [7:0] x2_a;
  wire [8:0] _GEN_0 = a + b;
  child c1 (
    .clock(c1_clock),
    .a(c1_a)
  );
  child x2 (
    .clock(x2_clock),
    .a(x2_a)
  );
  assign c1_clock = clock;
  assign c1_a = a;
  assign x2_clock = clock;
  assign x2_a = b;
endmodule
module child(
  input        clock,
  input  [7:0] a
);
  TestPropery: cover property (@(posedge clock) a == 8'h0);
endmodule
