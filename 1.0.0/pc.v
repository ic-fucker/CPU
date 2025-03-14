`include "define.v"

module pc_reg(

	input	wire										clk,
	input   wire										rst,
	input   wire                                        pc_wd,
	
	output reg[`InstAddrBus]			                pc,//[31:0]
	output reg                                          ce, //the whole ce which is controled by rst
	output reg                                          ifid_wd
);


always @ (posedge clk) begin
	if (ce == `ChipDisable) begin
		pc <= 32'h00000000;
	end 
	else begin
		if(pc_wd)begin
 			pc <= pc + 4'h4;
			ifid_wd <= 1'b1;
		end
		else begin
	    	ifid_wd <= 1'b0;
		end
	end
end

always @(negedge rst) begin
	ifid_wd <= 1'b1;
end


always @ (posedge clk) begin
	if (rst == `RstEnable) begin
		ce <= `ChipDisable;
	end else begin
		ce <= `ChipEnable;
	end
end



endmodule
