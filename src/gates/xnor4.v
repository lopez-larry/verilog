module xnor4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = ~(a ^ b);   // bitwise XNOR
endmodule