`timescale 1ns/1ps
module tb_nand1;
    reg a, b;
    wire y;

    nand1 uut (.a(a), .b(b), .y(y));

    initial begin
        // Waveform dump setup
        $dumpfile("tb_nand1.vcd");
        $dumpvars(0, tb_nand1);

        // Print values to console
        $monitor("time=%0t a=%b b=%b y=%b", $time, a, b, y);

        // Test all input combinations
        a = 0; b = 0; #5;
        a = 0; b = 1; #5;
        a = 1; b = 0; #5;
        a = 1; b = 1; #5;

        $finish;
    end
endmodule
