`timescale 1ns / 1ps

module sign_ext (In,Imm_Ext,ImmSrc);

    input [31:7]In;
    input [2:0]ImmSrc;
    output reg[31:0]Imm_Ext;

    always @(*) begin
        case (ImmSrc)
            3'b001: Imm_Ext = {{20{In[31]}}, In[31:20]}; // I-type (Immediate arithmetic, Load)
            3'b010: Imm_Ext = {{20{In[31]}}, In[31:25], In[11:7]}; // S-type (Store)
            3'b011: Imm_Ext = {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0}; // B-type (Branch)
            3'b100: Imm_Ext = {{12{In[31]}}, In[19:12], In[20], In[30:21], 1'b0}; // J-type (Jump)
            3'b110: Imm_Ext = {In[31:12], 12'b0}; // U-type (LUI, AUIPC) (Load Upper Immediate)
            3'b111: Imm_Ext = {{27{In[24]}}, In[24:20]}; // I-type (Shift immediate) (Special case for shifts)
            default: Imm_Ext = 32'b0; // Default case, might be an NOP or no operation
        endcase
    end

                                
endmodule