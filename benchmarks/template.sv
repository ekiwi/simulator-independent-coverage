`timescale 1ns/10ps
module ${TOP}TB();
    reg clock = 0;
    always #2 clock <= ~clock;
    reg reset = 1;

    ${TOP} dut (
        .clock(clock),
        .reset(reset)
    );

    initial begin
        @(posedge clock); #1;
        reset = 0;
        @(posedge clock);
        forever @(posedge clock);
    end
endmodule
