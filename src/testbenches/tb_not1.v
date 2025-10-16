`timescale 1ns/1ps
module tb_not1;
  reg a;
  wire y;

  not1 uut (.a(a), .y(y));

  initial begin
    $dumpfile("tb_not1.vcd");   // VCD output file
    $dumpvars(0, tb_not1);      // record all signals inside tb_not1

    $monitor("time=%0t a=%b y=%b", $time, a, y);

    a = 0; #5;
    a = 1; #5;
    a = 0; #5;

    $finish;
  end
endmodule
