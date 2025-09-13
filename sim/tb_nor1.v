`timescale 1ns/1ps
module tb_nor1;
  reg a,b; wire y;
  nor1 dut(.a(a), .b(b), .y(y));
  integer i;
  initial begin
    $dumpfile("tb_nor1.vcd"); $dumpvars(0, tb_nor1);
    {a,b}=0;
    for (i=0;i<4;i=i+1) begin {a,b}=i[1:0]; #5; end
    $finish;
  end
endmodule
