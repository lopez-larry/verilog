`timescale 1ns/1ps
module tb_nand1;
  reg a,b; wire y;
  nand1 dut(.a(a), .b(b), .y(y));
  integer i;
  initial begin
    $dumpfile("tb_nand1.vcd"); $dumpvars(0, tb_nand1);
    {a,b}=0;
    for (i=0;i<4;i=i+1) begin {a,b}=i[1:0]; #5; end
    $finish;
  end
endmodule
