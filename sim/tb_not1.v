`timescale 1ns/1ps
module tb_not1;
  reg a; wire y;
  not1 dut(.a(a), .y(y));
  initial begin
    $dumpfile("tb_not1.vcd"); $dumpvars(0, tb_not1);
    a=0; #5; a=1; #5; a=0; #5; $finish;
  end
endmodule
