`include "define.v"

module if_id(

	input	wire										clk,
	input wire										rst,
	input wire                                      ifid_wd,

	input wire[`InstAddrBus]			if_pc,
	input wire[`InstBus]          if_inst,
	output reg[`InstAddrBus]      id_pc,
	output reg[`InstBus]          id_inst,
    output reg                    id_wd	
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
			id_wd<=`ZeroWord;
	  end else begin
		  id_pc <= if_pc;
		  id_inst <= if_inst;
		  id_wd	  <=id_wd;
		end
	end

endmodule
