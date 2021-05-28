# Formal Trace Generation for RISC-V Mini with Symbiyosys

```
> ./coverage/utils/bin/firrtl \
    -i benchmarks/riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir \
    -faf benchmarks/riscv-mini/TileTester_ISATestsrv32ui-p-xor/TileTester.fsm.json \
    -E sverilog \
    --random-state-init \
    --add-reset-assumption \
    --fsm-coverage \
    --make-main TileTester:Tile \
    -ll info
> mv TileTester.sv formal/Tile.sv
```
