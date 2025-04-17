`timescale 1ns / 1ps
module cu_tb();
    reg clk;
    reg rst;
    reg [6:0] ALUSEL;

    wire PC_en;
    wire ID_en;
    wire EX_en;
    wire MEM_en;
    wire WB_en;

    wire Jump_en;
    wire imm_en;
    wire EXPC_en;
    wire L_or_S;
    wire [1:0] WB_Ctrl;

    Control_Uint CU(
        .clk(clk),
        .rst(rst),
        .ALUSEL(ALUSEL),

        .PC_en(PC_en),
        .ID_en(ID_en),
        .EX_en(EX_en),
        .MEM_en(MEM_en),
        .WB_en(WB_en),

        .Jump_en(Jump_en),
        .imm_en(imm_en),
        .EXPC_en(EXPC_en),
        .L_or_S(L_or_S),
        .WB_Ctrl(WB_Ctrl)
    );

    initial begin
        
        rst = 0;
        ALUSEL = 7'b0000000;

        #5 rst = 1; // Release reset
        #5 ALUSEL = 7'b0000101; // Set ALUSEL to a new value
        #5 ALUSEL = 7'b0100101; // Change ALUSEL again
        #5 rst = 0; // Assert reset again
        #5 rst = 1; // Release reset again

        #1000 $finish; // End simulation
    end
    initial begin
        clk = 0;
        forever begin
        #10
        clk = ~clk;
        end
    end
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cu_tb);
    end
endmodule