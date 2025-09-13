`timescale 1ns/1ps
module tb_arith_shift1x4_right;
  reg  [3:0] A; wire [3:0] X;
  arith_shift1x4_right dut(.A(A), .X(X));

  task show;
    begin
      $display("t=%0t  A=%b (%0d)  X=%b (%0d)", $time, A, $signed(A), X, $signed(X));
    end
  endtask

  initial begin
    $dumpfile("tb_arith_shift1x4_right.vcd"); $dumpvars(0, tb_arith_shift1x4_right);
    A=4'b0110; #1; show();  // +6 -> +3
    #4; A=4'b1011; #1; show();  // -5 -> -3
    #4; A=4'b1000; #1; show();  // -8 -> -4
    #4; A=4'b0001; #1; show();  // +1 -> 0
    #4; $finish;
  end
endmodule
