// MIPS32 Instruction Opcodes
`define OP_RTYPE    6'b000000
`define OP_ADDI     6'b001000
`define OP_ADDIU    6'b001001
`define OP_ANDI     6'b001100
`define OP_ORI      6'b001101
`define OP_XORI     6'b001110
`define OP_LW       6'b100011
`define OP_SW       6'b101011
`define OP_BEQ      6'b000100
`define OP_BNE      6'b000101
`define OP_J        6'b000010
`define OP_JAL      6'b000011

// R-Type Function Codes
`define FUNC_ADD    6'b100000
`define FUNC_ADDU   6'b100001
`define FUNC_SUB    6'b100010
`define FUNC_SUBU   6'b100011
`define FUNC_AND    6'b100100
`define FUNC_OR     6'b100101
`define FUNC_XOR    6'b100110
`define FUNC_NOR    6'b100111
`define FUNC_SLT    6'b101010
`define FUNC_SLTU   6'b101011
`define FUNC_SLL    6'b000000
`define FUNC_SRL    6'b000010
`define FUNC_SRA    6'b000011
`define FUNC_JR     6'b001000
