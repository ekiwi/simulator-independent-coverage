#!/usr/bin/env python3
import os
import argparse
import vcdvcd

class VCDParser(vcdvcd.StreamParserCallbacks):
    def __init__(self, inputs, top):
        super().__init__()
        self.inputs = inputs
        self.top = top
        self.watch = set()

    def enddefinitions(self, vcd, signals, cur_sig_vals):
        # find our inputs
        for ii in self.inputs:
            # we do a fuzzy match since e.g. verilator might add some hierarchy above the module we care about
            candidates = [k for k in vcd.references_to_ids.keys() if ii in k]
            smallest = sorted(candidates, key=lambda e: len(e))[0]
            self.watch.add(vcd.references_to_ids[smallest])


    def value(self, vcd, time, value, identifier_code, cur_sig_vals):
        pass #print('{} {} {}'.format(time, value, identifier_code))


VerilogTemplate = """`timescale 1ns/10ps
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
          $fscan(fp, {scan});
          @(posedge clock);
        end
        $fclose(fp);
    end
endmodule
"""

def make_verilog_testbench(filename, top, inputs):
    input_file = "input.txt"
    input_regs = "\n".join(f"reg [{w-1}:0] {n};" for n,w in inputs)
    connections = "\n".join(f".{n}({n})," for n,w in inputs)
    scan_str = '"' + " ".join("%b" for _ in inputs) + '", '
    scan = scan_str + ", ".join(n for n,_ in inputs)

    with open(filename, "w") as f:
        f.write(VerilogTemplate.format(
            top=top, input_file=input_file, input_regs=input_regs,
            connections=connections, scan=scan
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
    parser.add_argument('-f', '--firrtl', help="firrtl of the design in the VCD", required=True)
    parser.add_argument('--tbv', help="filename for the verilog testbench")
    args =  parser.parse_args()

    if not os.path.isfile(args.vcd):
        raise RuntimeError(f"Wasn't able to find VCD {args.vcd}")

    if not os.path.isfile(args.firrtl):
        raise RuntimeError(f"Wasn't able to find FIRRTL {args.firrtl}")

    return args.vcd, args.firrtl, args.tbv



def main():
    vcdfile, firrtlfile, tbv = parse_args()
    inputs, top = parse_firrtl(firrtlfile)
    if len(tbv) > 0:
        make_verilog_testbench(tbv, top, inputs)
    parsed = vcdvcd.VCDVCD(vcdfile, callbacks=VCDParser([i[0] for i in inputs], top), store_tvs=False)

if __name__ == '__main__':
    main()