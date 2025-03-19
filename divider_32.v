`timescale 1ns / 1ps


module divider_32bit (
    input  [31:0] dividend,
    input  [31:0] divisor,
    input  signed_op,         // 0 for unsigned, 1 for signed operation
    output reg [31:0] quotient,
    output reg [31:0] remainder
);

    reg [31:0] abs_dividend;
    reg [31:0] abs_divisor;
    reg [31:0] abs_quotient;
    reg [31:0] abs_remainder;
    reg sign_quotient;
    reg sign_remainder;

    always @(*) begin
        // Initialize quotient and remainder to 0
        quotient = 0;
        remainder = 0;

        // Get absolute values for signed division
        if (signed_op) begin
            abs_dividend = (dividend[31]) ? (~dividend + 1) : dividend;
            abs_divisor  = (divisor[31])  ? (~divisor + 1)  : divisor;
        end else begin
            abs_dividend = dividend;
            abs_divisor  = divisor;
        end

        // Perform the division if divisor is not zero
        if (divisor != 0) begin
            abs_quotient = abs_dividend / abs_divisor;
            abs_remainder = abs_dividend % abs_divisor;
        end else begin
            abs_quotient = 0;          // Division by 0 results in undefined quotient
            abs_remainder = abs_dividend; // The remainder will be the dividend
        end

        // Determine the sign of the quotient
        if (signed_op) begin
            sign_quotient = dividend[31] ^ divisor[31]; // Quotient sign based on dividend/divisor sign mismatch
            sign_remainder = dividend[31];              // Remainder sign follows the dividend
        end else begin
            sign_quotient = 0;
            sign_remainder = 0;
        end

        // Set the quotient and remainder with proper sign
        quotient = (sign_quotient) ? (~abs_quotient + 1) : abs_quotient;
        remainder = (sign_remainder) ? (~abs_remainder + 1) : abs_remainder;
    end
endmodule

