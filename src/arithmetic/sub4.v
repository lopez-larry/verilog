module sub4 (
    input  [3:0] a,
    input  [3:0] b,
    input        bin,       // borrow in
    output [3:0] diff,
    output       bout       // borrow out
);
    // Perform subtraction: a - b - bin
    assign {bout, diff} = {1'b0, a} - {1'b0, b} - bin;
endmodule