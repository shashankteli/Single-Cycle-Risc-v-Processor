`timescale 1ns / 1ps
module Mux(a, b, c, d, s, y);
   input [31:0] a, b, c, d;
   output reg [31:0] y;
   input [1:0] s;

   always @(*) begin
       case(s)
          2'b00: y = a;
          2'b01: y = b;
          2'b10: y = c;
          2'b11: y = d;
          default: y = 32'b0;  // optional default case
       endcase
   end
endmodule

