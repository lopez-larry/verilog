// 1x4-bit arithmetic right shift by 1 (sign-extend)
module arith_shift1x4_right(
  input  wire [3:0] A,   // 4-bit input (two's complement)
  output wire [3:0] X    // 4-bit output
);
  assign X = {A[3], A[3:1]}; // keep sign, shift right one
endmodule