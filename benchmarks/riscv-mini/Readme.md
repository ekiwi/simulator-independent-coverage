# Risc-V Mini Benchmark

This directory contains the tests from the [RISC-V Mini repository](https://github.com/ucb-bar/riscv-mini).

The only modification we made was to switch to a realse version
of Chisel and firrtl and to add code to reliable dump the circuit in
Chirrtl format along with its annotations.

The exect code used to produce these benchmarks can be found
on the [master branch of our fork](https://github.com/ekiwi/riscv-mini/tree/master).

To generate the chirrtl, annotations and VCD sources we ran `sbt test`
in the root directory of the repository and then filtered and copied
to contents of the `test_run_dir`.
