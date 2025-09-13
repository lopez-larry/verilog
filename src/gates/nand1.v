// nand1.v
module nand1(input a, input b, output y);
  assign y = ~(a & b);
endmodule