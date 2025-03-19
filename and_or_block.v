`timescale 1ns / 1ps
module and_or (
    input [1:0] a, b,  // 2-bit inputs a and b
    input       c, d, e, // single-bit inputs
    output [1:0] y      // 2-bit output y
);

    wire [1:0] w1, w2, w3;

    // Perform AND between each bit of b and the control signals c, d, e
    assign w1 = {b[1] & c, b[0] & c}; // Applying c to both bits of b
    assign w2 = {b[1] & d, b[0] & d}; // Applying d to both bits of b
    assign w3 = {b[1] & e, b[0] & e}; // Applying e to both bits of b

    // OR the results of the above AND operations with a
    assign y = a | w1 | w2 | w3;

endmodule

