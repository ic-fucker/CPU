`timescale 1ns/1ps
`include "define.v"
module id (
    input wire                  rst,
    input wire  [`InstAddrBus]  pc_i,
    input wire  [`InstBus]      inst_i,
    //read the value of Regfile
    input wire  [`RegBus]       reg1_data_i,
    input wire  [`RegBus]       reg2_data_i,
    //output to Regfile
    output reg                  reg1_read_o,
    output reg                  reg2_read_o,
    output reg  [`RegAddrBus]   reg1_addr_o,
    output reg  [`RegAddrBus]   reg2_addr_o,
    //output to execute stage
    output reg  [`AluOpBus]     aluop_o,
    output reg  [`AluFunct3Bus] alufunct3_o,
    output reg  [`RegBus]       reg1_o,
    output reg  [`RegBus]       reg2_o,
    output reg  [`RegAddrBus]   wreg_o,
    output reg                  wd_o
);

// break down the binary code
wire [6:0]  op = inst_i[6:0];
wire [2:0]  funt3 = inst_i[14:12];

// save need imediate num
reg[`RegBus] imm;

//judge vaildable
reg instvaild;

//stage one : decode
always @(*) begin
    if(rst ==`RstEnable) begin
        aluop_o <= `EXE_I_TYPE_OP;
        alufunct3_o <= `EXE_NOP_FUNCT3;
        wreg_o   <= `NOPRegAddr;
        wd_o <= `WriteDisable;
        instvaild <= `InstVaild;
        reg1_read_o <= 1'b0;
        reg2_addr_o <= 1'b0;
        reg1_addr_o <= `NOPRegAddr;
        reg2_addr_o <= `NOPRegAddr;
        imm <= 32'h0;
    end else begin
        aluop_o <= `EXE_I_TYPE_OP;
        alufunct3_o <= `EXE_NOP_FUNCT3;
        wreg_o   <= inst_i[11:7];
        wd_o <= `WriteDisable;
        instvaild <= `InstInvaild;
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        reg1_addr_o <= inst_i[19:15];//default read from regfile pole one
        reg2_addr_o <= inst_i[25:21];//default read from regfile pole two
        imm <= `ZeroWord;       
    case (op)
        `EXE_I_TYPE_OP:   begin   //I-type confirmed   
        case (funt3)
            `EXE_ADDI_FUNCT3:   begin
            wd_o <= `WriteEnable;       
            aluop_o <= `EXE_I_TYPE_OP;        
            alufunct3_o <= `EXE_ADDI_FUNCT3;  
            reg1_read_o <= 1'b1;        
            reg2_read_o <= 1'b0;
            imm <= {4'h0, inst_i[31:20]};
            wreg_o <= inst_i[11:7];
            instvaild <= `InstVaild;
            end

            default:    begin
            end
        endcase //case funct3           
        end 
        
        default: begin           
        end
    endcase// case op
    end //if
end // always

//stage two : confirm source data one
always @(*) begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
    end else if(reg1_read_o == 1'b1) begin
        reg1_o <= reg1_data_i; // Regfile Readone as input
    end else if (reg1_read_o == 1'b0) begin
        reg1_o <= imm; //imediate num
    end else begin
        reg1_read_o <=`ZeroWord;
    end
end

//stage three : confirm source data two
always @(*) begin
    if(rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
    end else if(reg2_read_o == 1'b1) begin
        reg2_o <= reg1_data_i; // Regfile Readone as input
    end else if (reg2_read_o == 1'b0) begin
        reg2_o <= imm; //imediate num
    end else begin
        reg2_read_o <=`ZeroWord;
    end
end
endmodule
