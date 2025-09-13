// nor1.v
module nor1(input a, input b, output y);
  assign y = ~(a | b);
endmodule

