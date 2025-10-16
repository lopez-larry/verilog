`timescale 1ns/1ps
module tb_nor1;
    reg a, b;
    wire y;

    // Instantiate the NOR gate
    nor1 uut (.a(a), .b(b), .y(y));

    initial begin
        // Set up waveform dump
        $dumpfile("tb_nor1.vcd");
        $dumpvars(0, tb_nor1);

        $monitor("time=%0t a=%b b=%b y=%b", $time, a, b, y);

        // Test all input combinations
        a = 0; b = 0; #5;
        a = 0; b = 1; #5;
        a = 1; b = 0; #5;
        a = 1; b = 1; #5;

        $finish;
    end
endmodule
