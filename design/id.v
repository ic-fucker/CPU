`include "defines.v"
module id(
    input wire                  rst,
    input wire  [`InstBus]      inst_i,   
    //read the value of Regfile
    input wire  [`RegBus]       reg1_data_i,//the data from reg1
    input wire  [`RegBus]       reg2_data_i,//the data from reg2

    input wire                  id_en,      //the enable signal come from if_id module
    //output to Regfile
    output reg                  reg1_read_o,
    output reg                  reg2_read_o,
    output reg  [`RegAddrBus]   reg1_addr_o,
    output reg  [`RegAddrBus]   reg2_addr_o,
    //output to execute stage
    output reg  [`AluOpBus]     aluop_o,    // the specifical operate signal
    output reg  [`AluSelBus]    alusel_o,   // the operation type
    output reg  [`RegBus]       reg1_o,
    output reg  [`RegBus]       reg2_o,
    output reg  [4:0]           wd_o,
    output reg  [`RegBus]       imm_o
);

//getting the operation code and func3 and func7
wire [6:0]         op1=inst_i[6:0];          //opcode
wire [2:0]         op2=inst_i[14:12];        //func3 or part of imm
wire [6:0]         op3=inst_i[31:25];        //func7

//conserve the instruction needed imm
    //output to execute stage
reg  [`AluOpBus]     aluop;    // the specifical operate signal
reg  [`AluSelBus]    alusel;   // the operation type
reg  [`RegBus]       reg1;
reg  [`RegBus]       reg2;
reg  [4:0]           wd;
reg  [`RegBus]       imm;







//********************************************************//
//************************main code***********************//
//********************************************************//
//stage one : decode
always @(*) begin
if(rst ==`RstEnable) begin
        aluop = `EXE_NOP_OP  ;
        alusel = `EXE_RES_NOP;     
        wd = `NOPRegAddr;
        reg1_read_o = 1'b0;
        reg2_read_o = 1'b0;
        reg1_addr_o = `NOPRegAddr;
        reg2_addr_o = `NOPRegAddr;
        imm = 32'h0;
end 
else begin
        aluop = `EXE_NOP_OP  ;
        alusel = `EXE_RES_NOP;
        wd = `NOPRegAddr;
        reg1_read_o= 1'b0;
        reg2_read_o= 1'b0;
        reg1_addr_o= inst_i[19:15];//default read from regfile pole one
        reg2_addr_o = inst_i[25:21];//default read from regfile pole two
        imm = `ZeroWord;       
    case (op1)
        `EXE_R_OP:   begin   //R type opcode
		alusel= `EXE_RES_R;
		reg1_read_o=1'b1;
        reg2_read_o=1'b1;
        imm=32'h0;
        wd=inst_i[11:7];
        	case (op2)
            3'b000: begin
                case(op3)
                    `EXE_ADD: begin
                        aluop = `EXE_ADD_OP;
				    end
                                 
                    `EXE_SUB: begin
                        aluop = `EXE_SUB_OP;
                    end

                    default: begin
                    end
                endcase //op3
            end //3'b000
                      
            `EXE_OR: begin
                aluop= `EXE_OR_OP;
            end
                      
            `EXE_AND: begin
                aluop = `EXE_AND_OP;
            end
                      
            `EXE_XOR: begin
                aluop= `EXE_XOR_OP;
            end
            default: begin
            end
            endcase //op2
        end//EXE_R_OP
        
        `EXE_I_OP:  begin//I_TYPE
		alusel= `EXE_RES_I;
		reg1_read_o=1'b1;
        reg2_read_o=1'b0;
		imm = { {20{inst_i[31]}}, inst_i[31:20] };
		wd=inst_i[11:7];
                
		    case(op2)
            `EXE_ANDI: begin
                aluop = `EXE_AND_OP;
            end
                    
            `EXE_ORI: begin
                aluop = `EXE_OR_OP;
            end
                    
            `EXE_ADDI: begin
                aluop = `EXE_ADD_OP;
            end
                   
            `EXE_XORI: begin
                aluop = `EXE_XOR_OP;
            end

            default: begin
            end
            endcase//op2
         
        end//EXE_I_OP
        
        `EXE_B_OP:begin//B_TYPE
		reg1_read_o=1'b1;
        reg2_read_o=1'b1;
        imm={{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
		wd=`NOPRegAddr;

		    case(op2)
                    
            `EXE_BEQ: begin
                aluop = `EXE_BEQ_OP;
                if($signed(reg1) == $signed(reg2))begin
                    alusel=`EXE_RES_B;
                end
                else begin
                    alusel=`EXE_RES_NB;
                end
            end
                    
            `EXE_BNE: begin
                aluop = `EXE_BNE_OP;
                if($signed(reg1) != $signed(reg2))begin
                    alusel=`EXE_RES_B;
                end
                else begin
                    alusel=`EXE_RES_NB;
                end
            end
                    
            `EXE_BLT: begin
                aluop = `EXE_BLT_OP;
                if($signed(reg1) < $signed(reg2))begin
                    alusel=`EXE_RES_B;
                end
                else begin
                    alusel=`EXE_RES_NB;
                end
            end
                    
            `EXE_BGE: begin
                aluop = `EXE_BGE_OP;
                if($signed(reg1) >= $signed(reg2))begin
                    alusel=`EXE_RES_B;
                end
                else begin
                    alusel=`EXE_RES_NB;
                end
            end
                    
            `EXE_BLTU: begin
                aluop = `EXE_BLTU_OP;
                if($unsigned(reg1) < $unsigned(reg2))begin
                    alusel=`EXE_RES_B;
                end
                else begin
                    alusel=`EXE_RES_NB;
                end
            end
                    
            `EXE_BGEU: begin
                aluop = `EXE_BGEU_OP;
                if($unsigned(reg1) >= $unsigned(reg2))begin
                    alusel=`EXE_RES_B;
                end
                else begin
                    alusel=`EXE_RES_NB;
                end
            end
                    
            default: begin
                end
            endcase          
        end//EXE_B_OP
        
        `EXE_LW_OP: begin//I_TYPE_INSTR
            aluop = `EXE_LW_OP;
            alusel=`EXE_RES_LW;
            reg1_read_o=1'b1;
            reg2_read_o=1'b0;
            imm = {{20{inst_i[31]}}, inst_i[31:20]};
            wd=inst_i[11:7];
        end //EXE_LW_OP
        
        `EXE_SW_OP: begin
            aluop = `EXE_SW_OP;
            alusel=`EXE_RES_SW;
            reg1_read_o=1'b1;
            reg2_read_o=1'b1;
            imm = {{20{ inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
            wd=`NOPRegAddr;                                    
        end //EXE_SW_OP
        
        `EXE_JAL_OP:begin
            aluop = `EXE_JAL_OP;
            alusel = `EXE_RES_JAL;
            reg1_read_o = 1'b0;
            reg2_read_o = 1'b0;
            imm = {{12{ inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            wd = inst_i[11:7];
        end //EXE_JAL_OP
        
        `EXE_JALR_OP :begin
            aluop = `EXE_JALR_OP;
            alusel=`EXE_RES_JALR;
            reg1_read_o=1'b1;
            reg2_read_o=1'b0;
            imm = {{20{ inst_i[31]}}, inst_i[31:20]}; 
            wd = inst_i[11:7];
        end //EXE_JALR_OP 
        
        default:begin
        end
    endcase//op1    
end//else     
end//always       
        

always@(*)begin
    if(rst ==`RstEnable)begin
        reg1=`ZeroWord;
    end
    else if(reg1_read_o==1'b1)begin
        reg1=reg1_data_i;
    end
    else if(reg1_read_o==1'b0)begin
        reg1=imm;
    end
    else begin
        reg1=`ZeroWord;
    end
end    

always@(*)begin
    if(rst ==`RstEnable)begin
        reg2=`ZeroWord;
    end
    else if(reg2_read_o==1'b1)begin
        reg2=reg2_data_i;
    end
    else if(reg2_read_o==1'b0)begin
        reg2=imm;
    end
    else begin
        reg2=`ZeroWord;
    end
end    
always@(posedge id_en)begin
    if(rst==`RstEnable)begin
        aluop_o <= `EXE_NOP_OP  ;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= `NOPRegAddr;
        reg1_o <= `ZeroWord;
        reg2_o <= `ZeroWord;
        imm_o <= 32'h0;
    end
    else begin
        aluop_o <= aluop;
        alusel_o <= alusel;
        wd_o <= wd;
        reg1_o <= reg1;
        reg2_o <= reg2;
        imm_o <= imm;
    end
end
endmodule

