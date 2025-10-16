module div4 (
    input  [3:0] a,    // dividend
    input  [3:0] b,    // divisor
    output [3:0] quot, // quotient
    output [3:0] rem   // remainder
);
    assign quot = (b != 0) ? (a / b) : 4'b0000;
    assign rem  = (b != 0) ? (a % b) : a; // if divide by 0, return dividend
endmodule