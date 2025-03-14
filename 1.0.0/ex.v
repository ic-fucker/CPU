`include "define.v"
module ex(

	input wire					  rst,
	
	//送到执行阶段的信�?
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluFunct3Bus]     alufunct3_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wreg_i,
	input wire                    wd_i,

	
	output reg[`RegAddrBus]       wreg_o,
	output reg                    wd_o,
	output reg[`RegBus]		      wdata_o
	
);

	always @ (*) begin
		if(rst == `RstEnable) begin
			wdata_o <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_I_TYPE_OP:			begin
                    case (alufunct3_i)
                        `EXE_ADDI_FUNCT3:           begin
					        wdata_o <= reg1_i + reg2_i;
							// alu deside write back
							// wd_o <= `WriteEnable;
                        end
                    default:    begin
                    end
					endcase
				end
				default:				begin
					wdata_o <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always


 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
 end	

endmodule
