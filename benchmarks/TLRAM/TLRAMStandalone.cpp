
#include <verilated.h>
#include <stdint.h>
#include <stdio.h>
#include <iostream>
#include "VTLRAMStandalone.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

#define TOP_TYPE VTLRAMStandalone

// Current simulation time
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;
}


int main(int argc, char **argv, char **env) {
    // Prevent unused variable warnings
    if (false && argc && argv && env) {}
    Verilated::debug(0);

    Verilated::commandArgs(argc, argv);
    TOP_TYPE* top = new TOP_TYPE;

    // If verilator was invoked with --trace
#if VM_TRACE
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("dump.vcd");
#endif

uint64_t reset = 0;
uint64_t in_a_valid = 0;
uint64_t in_a_bits_opcode = 0;
uint64_t in_a_bits_param = 0;
uint64_t in_a_bits_size = 0;
uint64_t in_a_bits_source = 0;
uint64_t in_a_bits_address = 0;
uint64_t in_a_bits_mask = 0;
uint64_t in_a_bits_data = 0;
uint64_t in_a_bits_corrupt = 0;
uint64_t in_d_ready = 0;    

top->reset = reset;
top->in_a_valid = in_a_valid;
top->in_a_bits_opcode = in_a_bits_opcode;
top->in_a_bits_param = in_a_bits_param;
top->in_a_bits_size = in_a_bits_size;
top->in_a_bits_source = in_a_bits_source;
top->in_a_bits_address = in_a_bits_address;
top->in_a_bits_mask = in_a_bits_mask;
top->in_a_bits_data = in_a_bits_data;
top->in_a_bits_corrupt = in_a_bits_corrupt;
top->in_d_ready = in_d_ready;

    // load data from file
    FILE* pFile = fopen("TLRAM_inputs.txt", "r");
    if(pFile == nullptr) {
        std::cerr << "Could not open TLRAM_inputs.txt" << std::endl;
    }

    while (!Verilated::gotFinish() && !feof(pFile)) {
        main_time++;
        top->clock = !top->clock;
        if (!top->clock) { // after negative edge

fscanf(pFile, "%x %x %x %x %x %x %x %x %x %x %x\n", &reset, &in_a_valid, &in_a_bits_opcode, &in_a_bits_param, &in_a_bits_size, &in_a_bits_source, &in_a_bits_address, &in_a_bits_mask, &in_a_bits_data, &in_a_bits_corrupt, &in_d_ready);
top->reset = reset;
top->in_a_valid = in_a_valid;
top->in_a_bits_opcode = in_a_bits_opcode;
top->in_a_bits_param = in_a_bits_param;
top->in_a_bits_size = in_a_bits_size;
top->in_a_bits_source = in_a_bits_source;
top->in_a_bits_address = in_a_bits_address;
top->in_a_bits_mask = in_a_bits_mask;
top->in_a_bits_data = in_a_bits_data;
top->in_a_bits_corrupt = in_a_bits_corrupt;
top->in_d_ready = in_d_ready;

        }
        top->eval();
#if VM_TRACE
        if (tfp) tfp->dump(main_time);
#endif
    }
    top->final();

#if VM_COVERAGE
    VerilatedCov::write("coverage.dat");
#endif
#if VM_TRACE
    if (tfp) { tfp->close(); }
#endif

    delete top;
    exit(0);
}

