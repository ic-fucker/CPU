`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 12:25:04
// Design Name: 
// Module Name: WB_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module WB_tb();

reg clk;
initial begin
    clk = 0;
    forever begin
        #5
        clk = ~clk;
    end
end

reg [31:0]RAM_Data;
reg [31:0]PC_Plus4;
reg [31:0]EX_Data;
reg [1:0] WB_Ctrl;
initial begin
    RAM_Data = 32'd1;
    PC_Plus4 = 32'd2;
    EX_Data  = 32'd3;
    WB_Ctrl  = 2'b00;
    #50
    WB_Ctrl  = 2'b01;
    #50
    WB_Ctrl  = 2'b10;
    #50
    $finish;
    
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, WB_tb);
end

wire [31:0] WB_Data;
WB U_WB(
    .RAM_Data(RAM_Data),
    .PC_Plus4(PC_Plus4),
    .EX_Data(EX_Data),
    .WB_Ctrl(WB_Ctrl),
    .WB_Data(WB_Data)
);

endmodule
