
#include <verilated.h>
#include <stdint.h>
#include <stdio.h>
#include <iostream>
#include "VServTopWithRam.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

#define TOP_TYPE VServTopWithRam

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
uint64_t io_timerInterrupt = 0;
uint64_t io_ibus_rdt = 0;
uint64_t io_ibus_ack = 0;
uint64_t io_dbus_rdt = 0;
uint64_t io_dbus_ack = 0;    

top->reset = reset;
top->io_timerInterrupt = io_timerInterrupt;
top->io_ibus_rdt = io_ibus_rdt;
top->io_ibus_ack = io_ibus_ack;
top->io_dbus_rdt = io_dbus_rdt;
top->io_dbus_ack = io_dbus_ack;

    // load data from file
    FILE* pFile = fopen("serv_inputs.txt", "r");
    if(pFile == nullptr) {
        std::cerr << "Could not open serv_inputs.txt" << std::endl;
    }

    while (!Verilated::gotFinish() && !feof(pFile)) {
        main_time++;
        top->clock = !top->clock;
        if (!top->clock) { // after negative edge

fscanf(pFile, "%x %x %x %x %x %x\n", &reset, &io_timerInterrupt, &io_ibus_rdt, &io_ibus_ack, &io_dbus_rdt, &io_dbus_ack);
top->reset = reset;
top->io_timerInterrupt = io_timerInterrupt;
top->io_ibus_rdt = io_ibus_rdt;
top->io_ibus_ack = io_ibus_ack;
top->io_dbus_rdt = io_dbus_rdt;
top->io_dbus_ack = io_dbus_ack;

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

