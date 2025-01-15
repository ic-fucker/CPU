module datapath (
    input wire clk,
    input wire rst_n,
    input wire [31:0] instr,
    
    // Control signals
    input wire reg_write,
    input wire [1:0] alu_src,
    input wire [3:0] alu_op,
    input wire mem_to_reg,
    
    // Outputs
    output wire [31:0] reg_data1,
    output wire [31:0] reg_data2,
    output wire [31:0] alu_result,
    output wire alu_zero
);

    // Instruction fields
    wire [4:0] rs = instr[25:21];
    wire [4:0] rt = instr[20:16];
    wire [4:0] rd = instr[15:11];
    wire [15:0] imm = instr[15:0];
    
    // Register file signals
    wire [31:0] reg_wdata;
    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;
    
    // ALU signals
    wire [31:0] alu_in2;
    wire [31:0] sign_ext_imm = {{16{imm[15]}}, imm};
    wire [31:0] zero_ext_imm = {16'b0, imm};
    
    // Memory signals
    wire [31:0] mem_rdata;
    
    // Instantiate register file
    reg_group reg_group_inst (
        .clk(clk),
        .rst_n(rst_n),
        .reg_write(reg_write),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(rd),
        .write_data(reg_wdata),
        .read_data1(reg_rdata1),
        .read_data2(reg_rdata2)
    );
    
    // ALU input mux
    assign alu_in2 = (alu_src == 2'b00) ? reg_rdata2 :
                     (alu_src == 2'b01) ? sign_ext_imm :
                     zero_ext_imm;
    
    // Instantiate ALU
    alu alu_inst (
        .a(reg_rdata1),
        .b(alu_in2),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );
    
    // Writeback mux
    assign reg_wdata = mem_to_reg ? mem_rdata : alu_result;
    
    // Output assignments
    assign reg_data1 = reg_rdata1;
    assign reg_data2 = reg_rdata2;

endmodule
