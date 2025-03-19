`timescale 1ns / 1ps
`timescale 1ns / 1ps

`include "pc.v"
`include "Instruction_mem.v"
`include "reg_file.v"
`include "sign_ext.v"
`include "Mux_4to1.v"
`include "pc_adder.v"
`include "Alu.v"
`include "data_mem.v"
`include "control_unit.v"
`include "and_or_block.v"


module single_cycle_top (clk,rst, Rd_instr, Result,pc_w,nextpc,Alu_cntrl,Regwrite,memwrite,memread,pcsrc,jump,branch,resultsrc,alusrc,zeroflag,negative,positive,
Rd1_w,Rd2_w,RS2,alu_out,readdata,pc_add1,pcadd_2,extended_imm,immsrc_w);
input clk,rst;
output [31:0]pc_w,Rd_instr, Result;
output [31:0]Rd1_w,Rd2_w,RS2,alu_out,readdata,pc_add1,pcadd_2,extended_imm,nextpc;
output Regwrite,memwrite,memread,zeroflag,negative,positive;
output [3:0]Alu_cntrl;
output [2:0]immsrc_w;
output [1:0]pcsrc,jump,branch,resultsrc,alusrc;
wire signed_op;

 Pc Program_counter(
 .clk(clk),
 .rst(rst),
 .PC(pc_w),
 .PC_Next(nextpc));
 
 Instr_Mem Instruction_memory(
 .rst(rst),
 .A(pc_w),
 .RD(Rd_instr));
 
 Reg_File Register_file( 
 .clk(clk),
 .rst(rst),
 .WE3(Regwrite),
 .WD3(Result),
 .A1(Rd_instr[19:15]),
 .A2(Rd_instr[24:20]),
 .A3(Rd_instr[11:7]),
 .RD1(Rd1_w),
 .RD2(Rd2_w));
 
 sign_ext sign_extension(
 .In(Rd_instr[31:7]),
 .Imm_Ext(extended_imm),
 .ImmSrc(immsrc_w));
 
 pc_add pc_adder(
 .a(pc_w),
 .b(32'd4),
 .c(pc_add1));
 
 pc_add pc_target(
 .a(pc_w),
 .b(extended_imm),
 .c(pcadd_2));
 
 Mux reg_to_alu_mux(
 .a(Rd2_w),
 .b(extended_imm),
 .c(pcadd_2),
 .d(32'd0),
 .s(alusrc),
 .y(RS2));
 
 Mux pc_input_mux(
 .a(pc_add1),
 .b(pcadd_2),
 .c({alu_out[30:0],1'b0}),
 .d(32'd0),
 .s(pcsrc),
 .y(nextpc));
 
 Mux write_back_mux(
 .a(alu_out),
 .b(readdata),
 .c(pc_add1),
 .d(RS2),
 .s(resultsrc),
 .y(Result));
 
 Alu ALU(
 .A(Rd1_w),          
 .B(RS2),          
 .alucontrol(Alu_cntrl),  
 .out_rslt(alu_out),      
 .Zero(zeroflag),         
 .Negative(negative),
 .Positive(positive),
 .signed_op(signed_op)      
);

data_Mem Data_memory(
.clk(clk),
.rst(rst),
.WE(memwrite),
.RE(memread),
.WD(Rd2_w),
.A(alu_out),
.funct3(Rd_instr[14:12]),
.RD(readdata));

control_unit controlunit(
.opcode(Rd_instr[6:0]),
.funct3(Rd_instr[14:12]),
.funct7(Rd_instr[31:25]),
.branch(branch),
.jump(jump),
.memRead(memread),
.result_src(resultsrc),
.alucontrol(Alu_cntrl),
.memWrite(memwrite),
.aluSrc(alusrc),
.regWrite(Regwrite),
.signed_op(signed_op),
.immsrc(immsrc_w));

and_or AndOrblock(
.a(jump),
.b(branch),
.c(zeroflag),
.d(negative),
.e(positive),
.y(pcsrc));

endmodule
