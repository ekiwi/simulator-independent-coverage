
#include "Vtest.h"
#include "verilated.h"
#include <stdint.h>
#if VM_TRACE
# include <verilated_vcd_c.h>	// Trace file format header
#endif

#define TOP_TYPE Vtest

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
	top->a = 0;
	top->b = 0;
	uint64_t count = 0;
	while (!Verilated::gotFinish() && count < 200) {
		top->clock = !top->clock;
		top->eval();
		#if VM_TRACE
		if (tfp) { tfp->dump(count); }
		#endif
		top->a = count % 8;
		top->b = (count + 3) % 8;
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

