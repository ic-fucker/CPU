`timescale 1ns/1ps
`include "define.v"
module id_ex (
    input wire                  clk,
    input wire                  rst,
    //message from decode   
    input wire[`AluOpBus]       id_aluop,
    input wire[`AluFunct3Bus]   id_alufunct3,
    input wire[`RegBus]         id_reg1,
    input wire[`RegBus]         id_reg2,
    input wire[`RegAddrBus]     id_wd,
    input wire id_wreg,
    //output to execute stage
    output reg[`AluOpBus]       ex_aluop,
    output reg[`AluFunct3Bus]   ex_alufunct3,
    output reg[`RegBus]         ex_reg1,
    output reg[`RegBus]         ex_reg2,
    output reg[`RegAddrBus]     ex_wd,
    output reg                  ex_wreg
);

always @(posedge clk) begin
    if(rst == `RstEnable) begin
        ex_aluop <= `EXE_I_TYPE_OP;
        ex_alufunct3 <= `EXE_NOP_FUNCT3;
        ex_reg1 <= `ZeroWord;
        ex_reg2 <= `ZeroWord;
        ex_wd <= `NOPRegAddr;
        ex_wreg <= `WriteDisable;
    end else begin
        ex_aluop <= id_aluop;
        ex_alufunct3 <= id_alufunct3;     
        ex_reg1 <= id_reg1;
        ex_reg2 <= id_reg2;
        ex_wd <= id_wd;
        ex_wreg <= id_wreg;           
    end
end
    
endmodule
