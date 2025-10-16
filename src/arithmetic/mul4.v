module mul4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] prod_low,   // lower 4 bits
    output [3:0] prod_high   // upper 4 bits
);
    wire [7:0] product;
    assign product = a * b;
    assign prod_low  = product[3:0];
    assign prod_high = product[7:4];
endmodule