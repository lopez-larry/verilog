`timescale 1ns/1ps
module tb;
    reg  [3:0] a;
    wire [3:0] y;

    not4 dut(.a(a), .y(y));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $monitor("t=%0t | a=%b -> y=%b", $time, a, y);

        a = 4'b0000; #10;   // expect 1111
        a = 4'b1010; #10;   // expect 0101
        a = 4'b1111; #10;   // expect 0000
        a = 4'b1100; #10;   // expect 0011

        $finish;
    end
endmodule
