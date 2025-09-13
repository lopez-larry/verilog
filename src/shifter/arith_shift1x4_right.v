// arith_shift1x4_right.v -- arithmetic right shift
module arith_shift1x4_right(input signed [3:0] a, output signed [3:0] y);
  assign y = a >>> 1;
endmodule
