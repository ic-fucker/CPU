`include "opcode.vh"

module control_unit (
    input wire [5:0] opcode,
    input wire [5:0] funct,
    
    output reg reg_write,
    output reg [1:0] alu_src,
    output reg [3:0] alu_op,
    output reg mem_write,
    output reg mem_to_reg,
    output reg branch,
    output reg jump
);

    always @(*) begin
        // Default values
        reg_write = 1'b0;
        alu_src = 2'b00;
        alu_op = 4'b0000;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        
        case (opcode)
            `OP_RTYPE: begin
                reg_write = 1'b1;
                case (funct)
                    `FUNC_ADD, `FUNC_ADDU: alu_op = 4'b0010;
                    `FUNC_SUB, `FUNC_SUBU: alu_op = 4'b0110;
                    `FUNC_AND: alu_op = 4'b0000;
                    `FUNC_OR: alu_op = 4'b0001;
                    `FUNC_XOR: alu_op = 4'b0011;
                    `FUNC_NOR: alu_op = 4'b0100;
                    `FUNC_SLT: alu_op = 4'b0111;
                    `FUNC_SLTU: alu_op = 4'b1000;
                    `FUNC_SLL: alu_op = 4'b1001;
                    `FUNC_SRL: alu_op = 4'b1010;
                    `FUNC_SRA: alu_op = 4'b1011;
                    `FUNC_JR: jump = 1'b1;
                endcase
            end
            
            `OP_ADDI, `OP_ADDIU: begin
                reg_write = 1'b1;
                alu_src = 2'b01;
                alu_op = 4'b0010;
            end
            
            `OP_ANDI: begin
                reg_write = 1'b1;
                alu_src = 2'b01;
                alu_op = 4'b0000;
            end
            
            `OP_ORI: begin
                reg_write = 1'b1;
                alu_src = 2'b01;
                alu_op = 4'b0001;
            end
            
            `OP_XORI: begin
                reg_write = 1'b1;
                alu_src = 2'b01;
                alu_op = 4'b0011;
            end
            
            `OP_LW: begin
                reg_write = 1'b1;
                alu_src = 2'b01;
                alu_op = 4'b0010;
                mem_to_reg = 1'b1;
            end
            
            `OP_SW: begin
                alu_src = 2'b01;
                alu_op = 4'b0010;
                mem_write = 1'b1;
            end
            
            `OP_BEQ: begin
                alu_op = 4'b0110;
                branch = 1'b1;
            end
            
            `OP_BNE: begin
                alu_op = 4'b0110;
                branch = 1'b1;
            end
            
            `OP_J, `OP_JAL: begin
                jump = 1'b1;
            end
        endcase
    end

endmodule
