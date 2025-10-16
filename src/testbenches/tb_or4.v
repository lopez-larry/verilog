`timescale 1ns/1ps
module tb;
    reg  [3:0] a, b;
    wire [3:0] y;

    // Instantiate DUT
    or4 dut(.a(a), .b(b), .y(y));

    initial begin
        $dumpfile("wave.vcd");   // output for waveform
        $dumpvars(0, tb);

        // Monitor values
        $monitor("Time=%0t | a=%b b=%b | y=%b", $time, a, b, y);

        // Test cases
        a = 4'b0000; b = 4'b0000; #10;   // expect 0000
        a = 4'b1010; b = 4'b0101; #10;   // expect 1111
        a = 4'b1111; b = 4'b1010; #10;   // expect 1111
        a = 4'b1100; b = 4'b0110; #10;   // expect 1110

        $finish;
    end
endmodule
