#include <verilated.h>
#include <stdint.h>
#include "VTileTester.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

#define TOP_TYPE VTileTester

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

    top->clock = 0;
    top->reset = 0;
    while (!Verilated::gotFinish()) { // no timeout
        main_time++;
        top->clock = !top->clock;
        if (!top->clock) { // after negative edge
            if (main_time > 1 && main_time < 10) {
                top->reset = 1;  // Assert reset
            } else {
                top->reset = 0;  // Deassert reset
            }
        }
        top->eval();
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

