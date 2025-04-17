`timescale 1ns / 1ps
`include "defines.v"
module pc_tb();
reg pc_en;
reg branch_en;
reg [`InstAddrBus] branch;
reg rst;
wire ce;
wire [`RegBus]pc;
wire [`RegBus]pc_plus_4;
initial begin
    rst<='d0;
    #200;
    rst<='d1;
    branch_en<='d0;
    branch<='h00000000;
    #500
    branch_en<='d1;
    branch<='h00000003;
    #1000
    $finish;
end
initial begin
	pc_en<='d0;
	forever begin
		#10
		pc_en = ~pc_en;
	end
end
pc u_pc(
    .rst(rst),
    .pc_en(pc_en),
    .branch_en(branch_en),
    .branch(branch),
    .ce(ce),
    .pc(pc),
    .pc_plus_4(pc_plus_4)
);

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, pc_tb);
end
endmodule