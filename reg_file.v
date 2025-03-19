`timescale 1ns / 1ps
module Reg_File(clk, rst, WE3, WD3, A1, A2, A3, RD1, RD2);

    input clk, rst, WE3;
    input [4:0] A1, A2, A3;
    input [31:0] WD3;
    output [31:0] RD1, RD2;

    reg [31:0] Register [31:0];

    // Write logic happens on the positive edge of the clock
    always @(negedge clk ) begin
        if (WE3 && A3 != 5'd0) // Avoid writing to x0
            Register[A3] <= WD3;
    end

    // Read logic happens combinationally, so it's immediate in the same cycle
    assign RD1 = (rst) ? 32'd0 : (A1 == 5'd0) ? 32'd0 : Register[A1]; // Reading x0 always returns 0
    assign RD2 = (rst) ? 32'd0 : (A2 == 5'd0) ? 32'd0 : Register[A2]; // Reading x0 always returns 0
    
    // Initialize registers, where Register[0] = 0 always
    integer i;
    initial begin
        Register[0] = 32'd0;
        for (i = 1; i < 32; i = i + 1)
            Register[i] = i * 10;
    end

endmodule
