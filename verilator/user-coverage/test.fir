circuit test:
  module test:
    input clock: Clock
    input a: UInt<8>
    input b: UInt<8>

    cover(clock, UInt(1), eq(add(a, b), UInt(0)), "") : test

    inst c1 of child
    c1.clock <= clock
    c1.a <= a

    inst x2 of child
    x2.clock <= clock
    x2.a <= b


  module child:
    input clock: Clock
    input a: UInt<8>
    cover(clock, UInt(1), gt(a, UInt(0)), "") : gt_0
    cover(clock, UInt(1), gt(a, UInt(1)), "") : gt_1
    cover(clock, UInt(1), gt(a, UInt(2)), "") : gt_2
    cover(clock, UInt(1), gt(a, UInt(3)), "") : gt_3
    cover(clock, UInt(1), gt(a, UInt(4)), "") : gt_4
