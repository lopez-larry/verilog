// design.sv
// Top-level 4-bit ALU integrating your modules

module alu4 (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,        // carry in for add/sub
    input        dir,        // shift direction for shifter
    input        arith,      // arithmetic vs logical shift
    input  [3:0] op,         // operation code
    output reg [3:0] y,      // main 4-bit result
    output reg [3:0] y_hi,   // extra 4 bits (mul/div/shifter overflow)
    output reg       cout,   // carry / borrow / status
    output reg       div_by_zero
);

    // Wires from each sub-module
    wire [3:0] y_and, y_nand, y_or, y_nor, y_xor, y_xnor, y_not;
    wire [3:0] sh_x, sh_y;           // shifter X (main) and Y (overflow)
    wire [3:0] add_sum;
    wire       add_cout;
    wire [3:0] sub_diff;
    wire       sub_bout;
    wire [3:0] mul_low, mul_high;
    wire [3:0] div_quot, div_rem;
    wire       div_zero_flag;

    // Instantiate your existing modules
    and4   u_and  (.a(a), .b(b), .y(y_and));
    nand4  u_nand (.a(a), .b(b), .y(y_nand));
    or4    u_or   (.a(a), .b(b), .y(y_or));
    nor4   u_nor  (.a(a), .b(b), .y(y_nor));
    xor4   u_xor  (.a(a), .b(b), .y(y_xor));
    xnor4  u_xnor (.a(a), .b(b), .y(y_xnor));
    not4   u_not  (.a(a),       .y(y_not));

    // 2x4-bit arithmetic shifter (your Step-2 design)
    shifter2x4 u_shifter (
        .a     (a),
        .b     (b),
        .dir   (dir),
        .arith (arith),
        .ya    (sh_x),
        .yb    (sh_y)
    );

    // Arithmetic units
    add4 u_add (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (add_sum),
        .cout(add_cout)
    );

    sub4 u_sub (
        .a   (a),
        .b   (b),
        .bin (cin),
        .diff(sub_diff),
        .bout(sub_bout)
    );

    mul4 u_mul (
        .a        (a),
        .b        (b),
        .prod_high(mul_high),
        .prod_low (mul_low)
    );

    div4 u_div (
        .a   (a),
        .b   (b),
        .quot(div_quot),
        .rem (div_rem)
    );

    // Simple divide-by-zero flag from your divider (b == 0)
    assign div_zero_flag = (b == 4'b0000);

    // ALU control: select outputs based on op code
    // 0  AND
    // 1  NAND
    // 2  OR
    // 3  NOR
    // 4  XOR
    // 5  XNOR
    // 6  NOT (uses only a)
    // 7  SHIFT (use shifter2x4)
    // 8  ADD
    // 9  SUB
    // 10 MUL
    // 11 DIV

    always @* begin
        // defaults
        y          = 4'b0000;
        y_hi       = 4'b0000;
        cout       = 1'b0;
        div_by_zero = 1'b0;

        case (op)
            4'd0: y = y_and;
            4'd1: y = y_nand;
            4'd2: y = y_or;
            4'd3: y = y_nor;
            4'd4: y = y_xor;
            4'd5: y = y_xnor;
            4'd6: y = y_not;
            4'd7: begin
                y    = sh_x;
                y_hi = sh_y;   // overflow bits
            end
            4'd8: begin
                y    = add_sum;
                cout = add_cout;
            end
            4'd9: begin
                y    = sub_diff;
                cout = sub_bout;  // treat as borrow out
            end
            4'd10: begin
                y    = mul_low;
                y_hi = mul_high;
            end
            4'd11: begin
                y          = div_quot;
                y_hi       = div_rem;
                div_by_zero = div_zero_flag;
            end
            default: begin
                y    = 4'b0000;
                y_hi = 4'b0000;
            end
        endcase
    end

endmodule

// Existing module definitions below:
// and4, nand4, or4, nor4, xor4, xnor4, not4,
// shifter2x4, add4, sub4, mul4, div4
module and4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = a & b;
endmodule

module nand4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = ~(a & b);
endmodule

module or4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = a | b;
endmodule

module nor4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = ~(a | b);
endmodule

module xor4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = a ^ b;
endmodule

module xnor4 (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    assign y = ~(a ^ b);   // bitwise XNOR
endmodule

module not4 (
    input  [3:0] a,
    output [3:0] y
);
    assign y = ~a;
endmodule

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

module add4 (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    assign {cout, sum} = a + b + cin;
endmodule

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

module div4 (
    input  [3:0] a,    // dividend
    input  [3:0] b,    // divisor
    output [3:0] quot, // quotient
    output [3:0] rem   // remainder
);
    assign quot = (b != 0) ? (a / b) : 4'b0000;
    assign rem  = (b != 0) ? (a % b) : a; // if divide by 0, return dividend
endmodule

//missing nor4
