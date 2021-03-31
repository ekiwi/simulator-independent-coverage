#include "V${TOP}.h"
#include "verilated.h"
#include <stdint.h>
#if VM_TRACE
# include <verilated_vcd_c.h>	// Trace file format header
#endif

#define TOP_TYPE V${TOP}

vluint64_t main_time = 0;       // Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus.  This is in units of the timeprecision
// used in Verilog (or from --timescale-override)

double sc_time_stamp () {       // Called by $time in Verilog
    return main_time;           // converts to double, to match what SystemC does
}


int main(int argc, char **argv, char **env)
{
	Verilated::commandArgs(argc, argv);
	TOP_TYPE* top = new TOP_TYPE;

	// If verilator was invoked with --trace
#if VM_TRACE
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	tfp->open ("dump.vcd");
#endif

	top->clock = 0;
	top->reset = 1;
	top->clock = !top->clock;
	main_time = 1;

	top->eval();
	top->clock = !top->clock;
	main_time = 2;

	top->reset = 0;
	top->eval();

	uint64_t count = 0;
	while (!Verilated::gotFinish() && count < 20000) {
		top->clock = !top->clock;
		main_time++;
		top->eval();
		#if VM_TRACE
		if (tfp) { tfp->dump(count); }
		#endif
		count++;
	}

#if VM_COVERAGE
    VerilatedCov::write("coverage.dat");
#endif
#if VM_TRACE
	if (tfp) { tfp->close(); }
#endif

	delete top;
	exit(0);
}

