// testbench.sv
`timescale 1ns/1ps

module tb;
    reg  [3:0] a, b;
    reg        cin, dir, arith;
    reg  [3:0] op;
    wire [3:0] y, y_hi;
    wire       cout, div_by_zero;

    // Device Under Test
    alu4 dut (
        .a(a), .b(b),
        .cin(cin),
        .dir(dir),
        .arith(arith),
        .op(op),
        .y(y),
        .y_hi(y_hi),
        .cout(cout),
        .div_by_zero(div_by_zero)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);

        $display(" time | op a b | y y_hi cout dz");
        $monitor("%4t | %2d  %h %h | %h %h  %b   %b",
                 $time, op, a, b, y, y_hi, cout, div_by_zero);

        // Example vectors:

        // AND: 3 & 5 = 1
        op = 4'd0; a = 4'd3; b = 4'd5; cin = 0; dir = 0; arith = 0; #10;

        // ADD: 7 + 9 = 0 with carry
        op = 4'd8; a = 4'd7; b = 4'd9; cin = 0; dir = 0; arith = 0; #10;

        // MUL: 3 * 5 = 15 (0000_1111)
        op = 4'd10; a = 4'd3; b = 4'd5; cin = 0; dir = 0; arith = 0; #10;

        // DIV: 7 / 2 = 3 rem 1
        op = 4'd11; a = 4'd7; b = 4'd2; cin = 0; dir = 0; arith = 0; #10;

        $finish;
    end
endmodule
