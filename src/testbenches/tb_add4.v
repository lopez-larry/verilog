`timescale 1ns/1ps
module tb;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    // Instantiate DUT
    add4 dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $dumpfile("wave.vcd");   // output file for waveforms
        $dumpvars(0, tb);        // dump all signals in tb

        // Monitor values on console
        $monitor("Time=%0t | a=%b b=%b cin=%b | sum=%b cout=%b",
                  $time, a, b, cin, sum, cout);

        // Test vectors
        a = 4'b0001; b = 4'b0010; cin = 0; #10;   // 1 + 2 = 3
        a = 4'b0101; b = 4'b0011; cin = 0; #10;   // 5 + 3 = 8
        a = 4'b1111; b = 4'b0001; cin = 0; #10;   // 15 + 1 = 0, cout=1
        a = 4'b1010; b = 4'b0101; cin = 1; #10;   // 10 + 5 + 1 = 16, cout=1

        $finish;
    end
endmodule
