
#include <verilated.h>
#include <stdint.h>
#include <stdio.h>
#include <iostream>
#include "VNeuromorphicProcessor.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

#define TOP_TYPE VNeuromorphicProcessor

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
    uint64_t io_uartRx = 0;    

    top->reset = reset;
    top->io_uartRx = io_uartRx;

    // load data from file
    FILE* pFile = fopen("NeuromorphicProcessor_inputs.txt", "r");
    if(pFile == nullptr) {
        std::cerr << "Could not open NeuromorphicProcessor_inputs.txt" << std::endl;
    }

    uint64_t cycles = 0;

    while (!Verilated::gotFinish() && !feof(pFile)) {
        main_time++;
        top->clock = !top->clock;
        if (!top->clock) { // after negative edge
            cycles += 1;
            fscanf(pFile, "%x %x\n", &reset, &io_uartRx);
            top->reset = reset;
            top->io_uartRx = io_uartRx;

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

    std::cout << cycles << " cycles" << std::endl;

    delete top;
    exit(0);
}

