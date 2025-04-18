`timescale 1ns/1ns
module top_tb ();
`include "defines.v"



// module top(
// 	input 	wire						clk,
// 	input 	wire						rst,
	
// 	input 	wire	[`InstBus]			inst_i,
	
// 	input 	wire 	[`DataBus]			load_data_in,
// 	output  reg		[`RegAddrBus]		addr_out,
// 	output 	reg 						we_out,
// 	output 	reg		[`DataBus]			store_data_out,

// 	output  reg		[`DataBus]			pc,
// 	output  reg 						ce
// );

reg                     clk;
reg                     rst;
wire    [`InstBus]	inst_i;
wire    [`DataBus]	load_data_in;

wire    [31:0]		addr_out;
wire 			we_out;
wire    [`DataBus]	store_data_out;
wire    [`DataBus]	pc;
wire 			ce;
wire	[31:0] 		rd_data;


initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,top_tb );
end

initial begin
    clk = 0;
    forever begin
        #7
        clk = ~clk;
    end
end

initial begin
    rst = 0;
    #101
    rst = 1;
    #1000
    $finish;
end






RAM u_RAM(
	.clk		( clk		),
	.rst     	( rst      ),
	.addr    	( addr_out     ),
	.w_r     	( we_out      ),
	.wr_data 	( store_data_out  ),
	.rd_data 	( load_data_in  )
);

inst_rom u_inst_rom(
    .ce(ce),
    .addr(pc),
    .inst(inst_i)
);

top u_top(
	.clk(clk),
	.rst(rst),
	.inst_i(inst_i),
	.load_data_in(load_data_in),
	.addr_out(addr_out),
	.we_out(we_out),
	.store_data_out(store_data_out),
	.pc(pc),
	.ce(ce)
);

endmodule
