`timescale 1ns/1ps
module tb;
    reg  [3:0] a, b;
    reg        dir, arith;
    wire [3:0] ya, yb;

    // DUT
    shifter2x4 dut(.a(a), .b(b), .dir(dir), .arith(arith), .ya(ya), .yb(yb));

    initial begin
        $dumpfile("wave.vcd");   // for EPWave
        $dumpvars(0, tb);
        $display(" time  a    b    dir ar  |  ya   yb   (expected)");

        // Case 1: Left logical shift
        a=4'b1010; b=4'b0111; dir=0; arith=0; #10;
        // ya=0100, yb=1110

        // Case 2: Right logical shift
        a=4'b1010; b=4'b0111; dir=1; arith=0; #10;
        // ya=0101, yb=0011

        // Case 3: Right arithmetic shift (sign extend)
        a=4'b1010; b=4'b0111; dir=1; arith=1; #10;
        // ya=1101, yb=0011

        // Case 4: All ones vs zeros
        a=4'b1111; b=4'b0000; dir=0; arith=0; #10;
        // ya=1110, yb=0000

        // Case 5: Edge sign behavior on ASR (negative nibble)
        a=4'b1000; b=4'b1001; dir=1; arith=1; #10;
        // ya=1100, yb=1100

        // Case 6: Edge on SRL
        a=4'b0001; b=4'b1000; dir=1; arith=0; #10;
        // ya=0000, yb=0100

        $finish;
    end

    initial begin
        $monitor(" %4t  %b  %b   %b   %b  |  %b  %b",
                 $time, a, b, dir, arith, ya, yb);
    end
endmodule
