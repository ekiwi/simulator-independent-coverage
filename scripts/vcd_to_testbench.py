#!/usr/bin/env python3
import os
import argparse
import vcdvcd

class VCDParser(vcdvcd.StreamParserCallbacks):
    def __init__(self, inputs, top, inputs_file):
        super().__init__()
        self.inputs = inputs
        self.top = top
        self.id_to_index = {}
        self.out = open(inputs_file, "w")
        self.values = [0 for _ in self.inputs]
        self.last_write = -1

    def write_to_file(self, time):
        while time > self.last_write:
            self.last_write += 2
            line = " ".join(f"{v:02X}" for v in self.values)
            self.out.write(line + "\n")

    def enddefinitions(self, vcd, signals, cur_sig_vals):
        # find our inputs
        index = 0
        for ii in self.inputs:
            # we do a fuzzy match since e.g. verilator might add some hierarchy above the module we care about
            candidates = [k for k in vcd.references_to_ids.keys() if ii in k]
            smallest = sorted(candidates, key=lambda e: len(e))[0]
            self.id_to_index[vcd.references_to_ids[smallest]] = index
            index += 1

    def value(self, vcd, time, value, identifier_code, cur_sig_vals):
        self.write_to_file(time)
        if identifier_code in self.id_to_index:
            self.values[self.id_to_index[identifier_code]] = int(value, 2)


VerilogTemplate = """
module {top}TB();
    reg clock = 0;
    always #2 clock <= ~clock;
    {input_regs}

    {top} dut (
.clock(clock),
{connections}
    );

    integer fp;
    initial begin
        fp = $fopen("{input_file}", "r");
        if (fp == 0) begin
          $display("Failed to open input file!");
          $stop;
        end

        while (! $feof(fp)) begin
          $fscanf(fp, {scan});
          @(posedge clock);
        end
        $fclose(fp);
    end
endmodule
"""

def make_verilog_testbench(filename, top, inputs):
    input_file = "inputs.txt"
    input_regs = "\n".join(f"reg [{w-1}:0] {n};" for n,w in inputs)
    connections = "\n".join(f".{n}({n})," for n,w in inputs)
    scan_str = '"' + " ".join("%x" for _ in inputs) + '", '
    scan = scan_str + ", ".join(n for n,_ in inputs)

    with open(filename, "w") as f:
        f.write(VerilogTemplate.format(
            top=top, input_file=input_file, input_regs=input_regs,
            connections=connections, scan=scan
        ))

VerilatorTemplate = """
#include <verilated.h>
#include <stdint.h>
#include <stdio.h>
#include <iostream>
#include "V{top}.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

#define TOP_TYPE V{top}

// Current simulation time
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {{
    return main_time;
}}


int main(int argc, char **argv, char **env) {{
    // Prevent unused variable warnings
    if (false && argc && argv && env) {{}}
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

{input_vars}    

{update}

    // load data from file
    FILE* pFile = fopen("{input_file}", "r");
    if(pFile == nullptr) {{
        std::cerr << "Could not open {input_file}" << std::endl;
    }}

    while (!Verilated::gotFinish() && !feof(pFile)) {{
        main_time++;
        top->clock = !top->clock;
        if (!top->clock) {{ // after negative edge

fscanf(pFile, {scan});
{update}

        }}
        top->eval();
#if VM_TRACE
        if (tfp) tfp->dump(main_time);
#endif
    }}
    top->final();

#if VM_COVERAGE
    VerilatedCov::write("coverage.dat");
#endif
#if VM_TRACE
    if (tfp) {{ tfp->close(); }}
#endif

    delete top;
    exit(0);
}}

"""

def make_verilator_testbench(filename, top, inputs):
    input_file = "inputs.txt"
    input_vars = "\n".join(f"uint64_t {n} = 0;" for n,_ in inputs)
    update = "\n".join(f"top->{n} = {n};" for n,_ in inputs)
    scan_str = '"' + " ".join("%x" for _ in inputs) + '\\n", '
    scan = scan_str + ", ".join(f"&{n}" for n,_ in inputs)

    with open(filename, "w") as f:
        f.write(VerilatorTemplate.format(
            top=top, input_file=input_file, input_vars=input_vars,
            update=update, scan=scan
        ))


def tpe_to_width(tpe: str) -> int:
    tpe = tpe.strip()
    if tpe == "Reset": return 1
    if tpe == "Clock": return 1
    if tpe.startswith("UInt<"):
        return int(tpe[len("UInt<"):-1])
    if tpe.startswith("SInt<"):
        return int(tpe[len("SInt<"):-1])
    raise RuntimeError(f"Unexpected tpe string: {tpe}")

def parse_firrtl(filename: str):
    circuit = None
    in_top = False
    inputs = []
    with open(filename, 'r') as ff:
       for line in ff:
         line = line.strip()
         if line.startswith('circuit'):
           circuit = line[len('circuit'):-1].strip()
         elif line.startswith('module'):
            module = line[len('module'):-1].strip()
            in_top = module == circuit
         elif line.startswith('input') and in_top:
            name, tpe = line[len('input'):].strip().split(':')
            if tpe.strip() != 'Clock':
              inputs.append((name.strip(), tpe_to_width(tpe)))
    return inputs, circuit



def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--vcd', help="input vcd", required=True)
    parser.add_argument('-f', '--firrtl', help="firrtl of the design in the VCD")
    parser.add_argument('--tbv', help="filename for the verilog testbench")
    parser.add_argument('--tbcc', help="filename for the verilator C++ testbench")
    parser.add_argument('--inputs', help="filename for inputs.txt stimuli file")
    args =  parser.parse_args()

    if args.vcd is not None:
      if not os.path.isfile(args.vcd):
        raise RuntimeError(f"Wasn't able to find VCD {args.vcd}")

    if not os.path.isfile(args.firrtl):
        raise RuntimeError(f"Wasn't able to find FIRRTL {args.firrtl}")

    return args.vcd, args.firrtl, args.tbv, args.tbcc, args.inputs



def main():
    vcdfile, firrtlfile, tbv, tbcc, inputs_file = parse_args()
    inputs, top = parse_firrtl(firrtlfile)
    if tbv is not None:
        make_verilog_testbench(tbv, top, inputs)
    if tbcc is not None:
        make_verilator_testbench(tbcc, top, inputs)
    if inputs_file is not None:
        assert vcdfile is not None, f"Need to provide a VCD file to generate an inputs file!"
        vcdvcd.VCDVCD(vcdfile, callbacks=VCDParser([i[0] for i in inputs], top, inputs_file), store_tvs=False)

if __name__ == '__main__':
    main()