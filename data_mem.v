`timescale 1ns / 1ps
module data_Mem (
    input  clk, rst, WE, RE,
    input  [31:0] WD,      // Write Data
    input  [31:0] A,       // Address input
    input  [2:0] funct3,   // funct3 from the instruction
    output [31:0] RD       // Read Data
);

    reg [31:0] mem [1023:0]; // Memory array
    
    // Read operation
    reg [31:0] read_data;
    always @(*) begin
        if (RE)
            read_data = mem[A]; // Read data from memory
        else
            read_data = 32'h0;
    end

    // Write operation
    always @(negedge clk) begin
        if (WE) begin
            case (funct3)
                3'b000: mem[A[31:0]] <= {mem[A[31:0]][31:8], WD[7:0]};       // SB (Store Byte)
                3'b001: mem[A[31:0]] <= {mem[A[31:0]][31:16], WD[15:0]}; // SH (Store Halfword)
                3'b010: mem[A[31:0]] <= WD;                                   // SW (Store Word)
                default: ; // No other store types
            endcase
        end
    end

    // Load extension logic for read operations
    reg [31:0] extended_data;
    always @(*) begin
        case (funct3)
            3'b000: extended_data = {{24{read_data[7]}}, read_data[7:0]};    // LB (Load Byte, sign-extended)
            3'b001: extended_data = {{16{read_data[15]}}, read_data[15:0]};  // LH (Load Halfword, sign-extended)
            3'b010: extended_data = read_data;                              // LW (Load Word, no extension needed)
            3'b100: extended_data = {24'b0, read_data[7:0]};                // LBU (Load Byte Unsigned, zero-extended)
            3'b101: extended_data = {16'b0, read_data[15:0]};               // LHU (Load Halfword Unsigned, zero-extended)
            default: extended_data = 32'b0;                                // Default case, invalid funct3
        endcase
    end

    // Output the extended data
    assign RD = extended_data;

    integer i;
    initial begin
        // Initializing memory to known values
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = i;
        end
    end

endmodule

