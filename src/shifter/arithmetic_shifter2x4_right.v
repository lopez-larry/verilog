// 2x4-bit Arithmetic Shifter
module shifter2x4 (
    input  [3:0] a,
    input  [3:0] b,
    input        dir,    // 0=left, 1=right
    input        arith,  // only used when dir=1
    output [3:0] ya,
    output [3:0] yb
);
    wire [3:0] a_sll = {a[2:0], 1'b0};
    wire [3:0] b_sll = {b[2:0], 1'b0};
    wire [3:0] a_srl = {1'b0, a[3:1]};
    wire [3:0] b_srl = {1'b0, b[3:1]};
    wire [3:0] a_sra = {a[3], a[3:1]};
    wire [3:0] b_sra = {b[3], b[3:1]};

    assign ya = (dir == 1'b0) ? a_sll : (arith ? a_sra : a_srl);
    assign yb = (dir == 1'b0) ? b_sll : (arith ? b_sra : b_srl);
endmodule
