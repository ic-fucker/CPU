`timescale 1ns / 1ps
`include "defines.v"
module pc(
    input   wire                                        rst,
    input   wire                                        pc_en,
    input   wire[`InstAddrBus]                          branch,//transer address
    input   wire                                        branch_en,//jump enable
    
    output                                              ce,
    output  reg  [`RegBus]                              pc,//[31:0]
    output  wire  [`RegBus]                             pc_plus_4
);
//************************* main code *************************//
assign pc_plus_4=pc+'d4;
assign ce= rst;
always@(posedge pc_en or negedge rst)begin
    if(rst==`RstEnable)begin
        pc<=32'h00000000;       //rst to clear out the data
    end
    else if (pc_en)begin         // when pc_en is high for one period,the pc value will upgrade
        if(branch_en==`Branch)begin  
            pc<=branch;
        end
        else begin
            pc<=pc+4;
        end
    end
    else begin
        pc <= pc;
    end
end
//************************************************************//
endmodule
