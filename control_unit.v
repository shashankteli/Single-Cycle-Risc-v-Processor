`timescale 1ns / 1ps



module control_unit (
    input wire [6:0] opcode,      
    input wire [2:0] funct3,       
    input wire [6:0]funct7,            
    output reg [1:0]branch,
    output reg [1:0]jump,
    output reg memRead,
    output reg [1:0]result_src,
    output reg [3:0] alucontrol,   
    output reg memWrite,
    output reg [1:0]aluSrc,
    output reg regWrite,signed_op,
    output reg [2:0]immsrc
);

always @(*) begin
    // Initialize control signals to default values
    branch    = 2'b00;
    jump      = 2'b00;
    memRead   = 0;
    result_src  = 2'bxx;
    alucontrol = 4'bxxxx;  
    memWrite  = 0;
    aluSrc    = 2'b00;
    regWrite  = 0;
    immsrc     =3'bxxx;

    case (opcode)
        7'b0110011: begin // R-type
            regWrite  = 1;
            result_src = 2'b00;
            case (funct3)
                3'b000: begin 
                 case (funct7)
                       7'b0000000 : alucontrol = 4'b0000; //add
                       7'b0100000 : alucontrol = 4'b0001; //sub
                       7'b0000001 : alucontrol = 4'b1011; //mul
                 endcase
                  end
                3'b111: begin
                  case (funct7)
                       7'b0000000 : alucontrol = 4'b0010; // AND
                       7'b0000001 : begin
                                     alucontrol = 4'b1110; //REMU
                                     signed_op = 1'b0;
                                    end
                  endcase     
                        end
                3'b110: begin
                  case (funct7)
                       7'b0000000 : alucontrol = 4'b0011; // OR
                       7'b0000001 : begin
                                     alucontrol = 4'b1110; //REM
                                     signed_op = 1'b1;
                                    end
                  endcase     
                        end
                3'b010: alucontrol = 4'b0100; // SLT
                3'b001: begin
                  case (funct7)
                       7'b0000000 : alucontrol = 4'b0110; // SLL
                       7'b0000001 : alucontrol = 4'b1100; //mulh
                  endcase
                    end
                3'b101: begin
                 case(funct7)
                       7'b0100000 : alucontrol = 4'b1001; // SRA
                       7'b0000000 : alucontrol = 4'b1000; // SRL
                       7'b0000001 : begin
                                     alucontrol = 4'b1101; //DIVU
                                     signed_op = 1'b0;
                                    end
                  endcase
                        end
                         
                3'b100: begin
                 case (funct7)
                       7'b0000000 : alucontrol = 4'b0101;
                       7'b0000001 : begin
                                     alucontrol = 4'b1101;//DIV
                                     signed_op = 1'b1;
                                    end
                 endcase
                       end
                3'b011: alucontrol = 4'b1010;
                default: alucontrol = 4'bxxxx; // Invalid operation
            endcase
        end
       7'b0010011: begin // I-type (ALU immediate)
            aluSrc    = 2'b01;
            regWrite  = 1;
            result_src = 2'b00;

            case (funct3)
                3'b000: begin // ADDI
                  alucontrol = 4'b0000;
                 immsrc     = 3'b001; // General I-type immediate
                end
                3'b111: begin // ANDI
                 alucontrol = 4'b0010;
                 immsrc     = 3'b001; // General I-type immediate
                end
                3'b110: begin // ORI
                 alucontrol = 4'b0011;
                 immsrc     = 3'b001; // General I-type immediate
                end
                3'b010: begin // SLTI
                 alucontrol = 4'b0100;
                 immsrc     = 3'b001; // General I-type immediate
                end
                3'b001: begin // SLLI
                 alucontrol = 4'b0110;
                 immsrc     = 3'b111; // Shift immediate
                end 
                3'b101: begin // SRAI/SRLI
                 alucontrol = funct7[5] ? 4'b1001 : 4'b1000; // SRAI/SRLI
                 immsrc     = 3'b111; // Shift immediate
                end
                3'b100: begin // XORI
                 alucontrol = 4'b0101;
                 immsrc     = 3'b001; // General I-type immediate
                end
                3'b011: begin // SLTIU
                 alucontrol = 4'b1010;
                 immsrc     = 3'b001; // General I-type immediate
                end
        default: begin
            alucontrol = 4'bxxxx; // Invalid operation
            immsrc     = 3'bxxx; // Undefined immediate source
                end
           endcase
        end

        7'b0000011: begin // I-type (Load)
            aluSrc    = 2'b01;
            memRead   = 1;
            immsrc    = 3'b001;
            result_src  = 2'b01;
            alucontrol = 4'b0000; // ADD for address calculation
            regWrite  = 1;
        end
        7'b0100011: begin // S-type (Store)
            aluSrc    = 2'b01;
            memWrite  = 1;
            immsrc    = 3'b010;
            alucontrol = 4'b0000;// ADD for address calculation
        end
        7'b1100011: begin // B-type (Branch)
            branch    = 2'b01;
            immsrc    = 3'b011;    
            alucontrol = 4'b0001; // SUB 
    
        end
        7'b1101111: begin // J-type jal (PCsrc)
            jump     = 2'b01;
            immsrc    = 3'b100;
            result_src  = 2'b10;
            regWrite  = 1; //writeback
        end
        7'b1100111: begin //i type jalr 
            jump     = 2'b10;
            regWrite  = 1;
            immsrc    = 3'b001;
            aluSrc    = 2'b01;
            alucontrol = 4'b0000;
            result_src  = 2'b10;
        end
        7'b0110111: begin //load upper immediate 
            regWrite  = 1;
            immsrc    = 3'b110;
            aluSrc    = 2'b01;
            result_src = 2'b11;
        end
        7'b0010111: begin// add upper immediatte to pc
            regWrite  = 1;
            immsrc    = 3'b110;
            aluSrc    = 2'b10;
            result_src = 2'b11;
             alucontrol = 4'b0000;
        end
        
       
    endcase

end
    

endmodule

