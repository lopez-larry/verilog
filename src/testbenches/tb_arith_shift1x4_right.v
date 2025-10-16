`timescale 1ns/1ps
module tb_arith_shift1x4_right;
    reg signed [3:0] a;
    wire signed [3:0] y;

    // Instantiate the shifter
    arith_shift1x4_right uut (.a(a), .y(y));

    initial begin
        // Enable waveform dump
        $dumpfile("tb_arith_shift1x4_right.vcd");
        $dumpvars(0, tb_arith_shift1x4_right);

        $monitor("time=%0t a=%0d (bin=%b) y=%0d (bin=%b)",
                  $time, a, a, y, y);

        // Test values
        a = 4'b0111; #5;   // +7 (expect +3)
        a = 4'b1000; #5;   // -8 (expect -4)
        a = 4'b1100; #5;   // -4 (expect -2)
        a = 4'b0010; #5;   // +2 (expect +1)

        $finish;
    end
endmodule
