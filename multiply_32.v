`timescale 1ns / 1ps
module integer_multiply_32bit(
    input [31:0] a, b,
    output wire [63:0] mul
);
  wire [63:0] y;

  // Instantiate the 32x32 bit array multiplier
  mul_array mul_inst(
      .a(a),
      .b(b),
      .y(y)
  );

  // Assign the result to mul
  assign mul = y;
endmodule

module mul_array(
    input [31:0] a, b,
    output reg [63:0] y
);
  wire [31:0] temp[31:0];
  wire [32:0] cy;
  integer j;

  assign cy[0] = 1'b0;
  assign temp[0] = a & {32{b[0]}};

  genvar i;
  generate
    for (i = 0; i < 31; i = i + 1) begin : blk1
      adder adder_inst(
          .a(a & {32{b[i+1]}}),
          .b({cy[i], temp[i][31:1]}), //shifts the previous partial product temp[i] left by 1 bit to align it for the next addition.
          .cin(1'b0),
          .sum(temp[i+1]),
          .cout(cy[i+1])
      );
    end
  endgenerate

  always @(*) begin
    for (j = 0; j < 32; j = j + 1) begin
      y[j] = temp[j][0];
    end
    y[63:32] = temp[31];
  end
endmodule

module adder(
    input [31:0] a, b,
    input cin,
    output [31:0] sum,
    output cout
);
  wire [32:0] cy;

  assign cy[0] = cin;
  assign cout = cy[32];

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : blk
      full_adder fa_inst(
          .a(a[i]),
          .b(b[i]),
          .cin(cy[i]),
          .sum(sum[i]),
          .cout(cy[i+1])
      );
    end
  endgenerate
endmodule

module full_adder(
    input a, b, cin,
    output sum, cout
);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

