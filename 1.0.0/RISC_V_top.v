`timescale 1ns/1ps
`include "define.v"
module RISC_V_TOP (
    input wire clk,
    input wire rst,
    input wire [`RegBus] rom_data_i,
    output wire[`RegBus] rom_addr_o,
    output wire rom_ce_o
);
// pc
wire pc_wd;
// pc -> if_id;
wire ifid_wd;
//connect if/id to id
wire[`InstAddrBus] pc;
wire[`InstAddrBus] id_pc_i;
wire[`InstBus]     id_inst_i;
wire               id_wd;

//connect id to id/ex

wire[`AluOpBus] id_aluop_o;
wire[`AluFunct3Bus] id_alufunct3_o;
wire[`RegBus] id_reg1_o;
wire[`RegBus] id_reg2_o;
wire id_wd_o;
wire[`RegAddrBus] id_wreg_o;

//id/ex to ex
wire[`AluOpBus] ex_aluop_i;
wire[`AluFunct3Bus] ex_alufunct3_i;
wire[`RegBus] ex_reg1_i;
wire[`RegBus] ex_reg2_i;
wire ex_wd_i;
wire[`RegAddrBus] ex_wreg_i;

//ex to ex/wb
wire ex_wd_o;
wire[`RegAddrBus] ex_wreg_o;
wire[`RegBus] ex_wdata_o;

//ex_wb to wb
wire wb_wd_i;
wire[`RegAddrBus] wb_wreg_i;
wire[`RegBus] wb_wdata_i;

//wb to regfile
wire wb_wd_o;
wire[`RegAddrBus] wb_wreg_o;
wire[`RegBus] wb_wdata_o;

//id to regfile
wire reg1_read;
wire reg2_read;
wire[`RegBus] reg1_data;
wire[`RegBus] reg2_data;
wire[`RegAddrBus] reg1_addr;
wire[`RegAddrBus] reg2_addr;

//pc_reg
pc_reg pc_reg0(
    .clk(clk),
    .rst(rst),
    .pc_wd(pc_wd),

    .pc(pc),
    .ce(rom_ce_o),
    .ifid_wd(ifid_wd)
);

assign rom_addr_o = pc;

//if/id
if_id if_id0(
    .clk(clk),
    .rst(rst),

    .ifid_wd(ifid_wd),
    .if_pc(pc),
    .if_inst(rom_data_i),

    .id_pc(id_pc_i),
    .id_inst(id_inst_i),
    .id_wd(id_wd)
);

//id module
id id0(
    .rst(rst),
    .pc_i(id_pc_i),
    .inst_i(id_inst_i),
    //from regfile input
    .reg1_data_i(reg1_data),
    .reg2_data_i(reg2_data),

    .wd_i(id_wd),
    // output to regfile
    .reg1_read_o(reg1_read),
    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),
    .reg2_addr_o(reg2_addr),
    //output to id/ex
    .aluop_o(id_aluop_o),
    .alufunct3_o(id_alufunct3_o),
    .reg1_o(id_reg1_o),
    .reg2_o(id_reg2_o),
    .wd_o(id_wd_o),
    .wreg_o(id_wreg_o)
    );

regfile regfile1(
    .clk(clk),
    .rst(rst),
    .we(wb_wd_o),
    .waddr(wb_wreg_o),
    .wdata(wb_wdata_o),
    .re1(reg1_read),
    .raddr1(reg1_addr),
    .rdata1(reg1_data),
    .re2(reg2_read),
    .raddr2(reg2_addr),
    .rdata2(reg2_data)
);

//id/ex
id_ex id_ex0(
    .clk(clk),
    .rst(rst),
    //message from id
    .id_aluop(id_aluop_o),
    .id_alufunct3(id_alufunct3_o),
    .id_reg1(id_reg1_o),
    .id_reg2(id_reg2_o),
    .id_wd(id_wd_o),
    .id_wreg(id_wreg_o),
    //message to ex
    .ex_aluop(ex_aluop_i),
    .ex_alufunct3(ex_alufunct3_i),
    .ex_reg1(ex_reg1_i),
    .ex_reg2(ex_reg2_i),
    .ex_wd(ex_wd_i),
    .ex_wreg(ex_wreg_i)
);

//ex model
ex ex0(
    .rst(rst),
    // message from if/ex
    .aluop_i(ex_aluop_i),
    .alufunct3_i(ex_alufunct3_i),
    .reg1_i(ex_reg1_i),
    .reg2_i(ex_reg2_i),
    .wd_i(ex_wd_i),
    .wreg_i(ex_wreg_i),
    // output to ex/mem
    .wd_o(ex_wd_o),
    .wreg_o(ex_wreg_o),
    .wdata_o(ex_wdata_o)
);

//ex/wb
ex_wb ex_wb0(
    .clk(clk),
    .rst(rst),

    //from ex
    .ex_wd(ex_wd_o),
    .ex_wreg(ex_wreg_o),
    .ex_wdata(ex_wdata_o),

     //to wb
    .wb_wd(wb_wd_i),
    .wb_wreg(wb_wreg_i),
    .wb_wdata(wb_wdata_i)
);

wb wb0(
    .rst(rst),
    .clk(clk),
    .ex_wreg(wb_wreg_i),
    .ex_wdata(wb_wdata_i),
    .ex_wd(wb_wd_i),

    .wb_wreg(wb_wreg_o),
    .wb_wdata(wb_wdata_o),
    .wb_wd(wb_wd_o)
);
assign pc_wd = wb_wd_o;
    


endmodule

