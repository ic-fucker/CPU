module cpu (
    input wire clk,
    input wire rst_n,
    
    // Instruction memory interface
    output wire [31:0] imem_addr,
    input wire [31:0] imem_data,
    
    // Data memory interface
    output wire [31:0] dmem_addr,
    output wire dmem_we,
    output wire [31:0] dmem_wdata,
    input wire [31:0] dmem_rdata
);

    // Program counter
    wire [31:0] pc;
    wire [31:0] pc_next;
    
    // Instruction register
    wire [31:0] instr;
    
    // Control signals
    wire reg_write;
    wire [1:0] alu_src;
    wire [3:0] alu_op;
    wire mem_write;
    wire mem_to_reg;
    wire branch;
    wire jump;
    
    // Datapath signals
    wire [31:0] reg_data1;
    wire [31:0] reg_data2;
    wire [31:0] alu_result;
    wire alu_zero;
    
    // Instantiate program counter
    pc pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .branch_target(pc + 4 + {instr[15:0], 2'b00}),
        .jump_target({pc[31:28], instr[25:0], 2'b00}),
        .branch(branch),
        .jump(jump),
        .pc(pc)
    );
    
    // Instantiate instruction memory
    irom irom_inst (
        .addr(pc),
        .instr(instr)
    );
    
    // Instantiate control unit
    control_unit control_unit_inst (
        .opcode(instr[31:26]),
        .funct(instr[5:0]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump)
    );
    
    // Instantiate register group
    reg_group reg_group_inst (
        .clk(clk),
        .rst_n(rst_n),
        .reg_write(reg_write),
        .read_reg1(instr[25:21]),
        .read_reg2(instr[20:16]),
        .write_reg(instr[15:11]),
        .write_data(mem_to_reg ? dmem_rdata : alu_result),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    // Instantiate ALU
    alu alu_inst (
        .a(reg_data1),
        .b(alu_src[0] ? {16'b0, instr[15:0]} : reg_data2),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );
    
    // Memory access
    assign dmem_addr = alu_result;
    assign dmem_wdata = reg_data2;
    assign dmem_we = mem_write;
    
    // Next PC logic
    assign pc_next = jump ? {pc[31:28], instr[25:0], 2'b00} :
                     branch & alu_zero ? pc + 4 + {instr[15:0], 2'b00} :
                     pc + 4;

endmodule
