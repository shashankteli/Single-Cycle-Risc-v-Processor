`timescale 1ns / 1ps
module Instr_Mem(
    input rst,
    input [31:0] A,
    output [31:0] RD
);

    reg [31:0] mem [1023:0]; // Memory array for storing instructions

    // Read operation
    
    assign RD = (rst) ? 32'b0 : mem[A[31:2]]; // Address slicing for word-aligned access

    // Initialize memory
  integer i;
    initial begin
   
  //for (i = 0; i < 1024; i = i + 1)
  //  begin
 
  mem[0] = 32'h0000a103;    // lw    x2, 0(x1)
    mem[1] = 32'h005101b3;    // add   x3, x2, x5
    mem[2] = 32'h00332223;    // sw    x3, 4(x6)
    mem[3] = 32'h40318233;    // sub   x4, x3, x3
    mem[4] = 32'h00020363;    // beq   x4, x0, label (offset 3 instructions)
    mem[5] = 32'h00918433;    // add   x8, x3, x9
    mem[6] = 32'h40b40533;    // sub   x10, x8, x11
    mem[7] = 32'h0020B033;    // sltu x7, x1, x2

   //mem[5] = 32'h00940533;  //srl x8, x1, x2
 // mem[3] = 32'h4020d4b3;    //sra x9, x1, x2
  //mem[7] = 32'h0020e533;    //or x10, x1, x2
   mem[8] = 32'h0020f5b3;    //and x11, x1, x2 
   mem[9] = 32'h02500613;    //addi x12, x0, 0x25
   mem[10] = 32'hffe00693;    //addi x13, x0, -2
  mem[11] = 32'hffe02713;    //slti x14, x0, -2
   // mem[0]= 32'h37b03793;    //sltiu x15, x0, 891
   // mem[0] = 32'hfff0c813;    //xori x16, x1, -1
  // mem[0] = 32'hf0f0e893;    //ori x17, x1, -241 -> sign extended 0xffffff0f
  //mem[0] = 32'hf0f0f913;    //andi x18, x1, -241 -> sign extended 0xffffff0f
   //mem[0] = 32'h00309993;    //slli x19, x1, 3
  //mem[1] = 32'h0030da13;    //srli x20, x1, 3
   //mem[2] = 32'h403f5a93;    //srai x21, x30, 3
    //mem[3] = 32'h00000b03;    //lb x22, 0(x0)
  // mem[4] = 32'h00001b83;    //lh x23, 0(x0)
 // mem[0] = 32'h00002c03;    //lw x24, 0(x0)
   //mem[1] = 32'h00004c83;    //lbu x25, 0(x0)
   //mem[2] = 32'h00005d03;    //lhu x26, 0(x0)
   // mem[0] = 32'h01f00223;    //sb x31, 4(x0)
  //mem[0] = 32'h01f01423;    //sh x31, 8(x0)
   //mem[0] = 32'h01f02623;    //sw x31, 12(x0)
     
        

  end
 //    end
    
    

endmodule

