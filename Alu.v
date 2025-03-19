`timescale 1ns / 1ps
 
 
 module Alu (
    input  [31:0] A,           // First operand
    input  [31:0] B,           // Second operand
    input  [3:0] alucontrol,   // ALU control signal
    output reg [31:0] out_rslt,// ALU result
    output reg Carry,          // Carry out
    output reg OverFlow,       // Overflow flag
    output reg Zero,           // Zero flag
    output reg Negative,       // Negative flag
    output reg Positive,        // Positive flag
    output reg signed_op        //division signed 
);

wire [31:0] B_inv;
wire [31:0] Sum,quotient,remainder;
wire Cout;
wire slt_out_rslt;
wire [63:0]mul;


wire [31:0] abs_A, abs_B;  // Absolute values of A and B
wire sign_A, sign_B;       // Sign bits of A and B

// Use B directly for ADD, and 2's complement of B for SUB
assign B_inv = (alucontrol == 4'b0001) ? ~B + 1 : B;  // Subtract if alucontrol indicates subtraction

// Perform addition or subtraction
assign {Cout, Sum} = A + B_inv;

// Perform SLT (Set Less Than)
assign slt_out_rslt = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

// Get absolute values and signs of A and B
assign sign_A = A[31];  // Sign bit of A
assign sign_B = B[31];  // Sign bit of B
assign abs_A = (sign_A) ? (~A + 1) : A;  // Absolute value of A
assign abs_B = (sign_B) ? (~B + 1) : B;  // Absolute value of B

integer_multiply_32bit multiply(
    .a(A), 
    .b(B),
    .mul(mul)
);

 divider_32bit division(
    .dividend(A),
    .divisor(B),
    .signed_op(signed_op),         // 0 for unsigned, 1 for signed operation
    .quotient(quotient),
    .remainder(remainder)
);

always @(*) begin
    // Compute the ALU result based on alucontrol
    case (alucontrol)
        4'b0000: 
         begin 
           // Compare magnitudes of A and B, and retain the sign of the operand with greater magnitude
            if (abs_A > abs_B) begin
                // If A has a greater magnitude, retain A's sign
                out_rslt = (sign_A) ? (~Sum + 1) : Sum;
            end else begin
                // If B has a greater magnitude, retain B's sign
                out_rslt = (sign_B) ? (~Sum + 1) : Sum;
            end //add
        end
        4'b0001: begin //sub
           out_rslt = Sum; 
        end
        4'b0010: out_rslt = A & B;         // AND
        4'b0011: out_rslt = A | B;         // OR
        4'b0100: out_rslt = slt_out_rslt;  // SLT
        4'b0101: out_rslt = A ^ B;         // XOR
        4'b0110: out_rslt = A << B;        // Shift left logical
        4'b1000: out_rslt = A >> B;        // Shift right logical
        4'b1001: out_rslt = $signed(A) >>> B;  // Shift right arithmetic
        4'b1010: out_rslt = A < B;         // Set less than (unsigned)
        4'b1011: out_rslt = mul[31:0];   // MUL (lower 32 bits)
        4'b1100: out_rslt = mul[63:32];  // MULH (upper 32 bits)
        4'b1101: out_rslt = quotient;    // division
        4'b1110: out_rslt = remainder;   //remainder
        default: out_rslt = 32'd0;         // Default case
    endcase

    // Set the Zero flag
    Zero = (out_rslt == 32'd0);

    // Set the Negative flag
    Negative = out_rslt[31];
    Positive = ~out_rslt[31];

    // Set the Carry flag (relevant for ADD only)
    Carry = (alucontrol == 4'b0000) ? Cout : 1'b0;

    // Set the Overflow flag for ADD and SUB
    OverFlow = ((alucontrol == 4'b0000 || alucontrol == 4'b0001) &&
                ((A[31] & B_inv[31] & ~Sum[31]) | (~A[31] & ~B_inv[31] & Sum[31])));
end

endmodule

