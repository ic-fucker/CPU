// global define
`define RstEnable 1'b0
`define RstDisable 1'b1
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus    2:0 //the width of translation aluop_o
`define AluSelBus   6:0 //the width of translation alusel_o
`define InstValid   1'b0 //vaild operator
`define InstInvalid 1'b1 //invaild operator
`define True_v      1'b1//meaning true
`define False_v     1'b0//meaning false
`define ChipDisable 1'b0//chip enable
`define ChipEnable  1'b1//chip ban

//opcode
`define EXE_R_OP          7'b0110011//R type opcode
`define EXE_I_OP          7'b0010011//I type opcode
`define EXE_B_OP          7'b1100011//B type opcode

//special 4 instructions opcode
`define EXE_LW        7'b0000011
`define EXE_SW        7'b0100011
`define EXE_JAL       7'b1101111
`define EXE_JALR      7'b1100111

//func3
`define EXE_OR            3'b110
`define EXE_AND           3'b111
`define EXE_ORI           3'b110
`define EXE_ADDI          3'b000
`define EXE_ANDI          3'b111
`define EXE_BEQ           3'b000
`define EXE_BNE           3'b001 
`define EXE_BLT           3'b100
`define EXE_BGE           3'b101
`define EXE_BLTU          3'b110
`define EXE_BGEU          3'b111
`define EXE_XOR           3'b100
`define EXE_XORI          3'b100

// func7
`define EXE_ADD           7'b0000000 
`define EXE_SUB           7'b0100000

//AluSel
`define EXE_RES_NOP                      7'b0000000
`define EXE_RES_R                        7'b0000101
`define EXE_RES_I                        7'b0100101
`define EXE_RES_LW                       7'b0101001
`define EXE_RES_SW                       7'b0111001
`define EXE_RES_B                        7'b1100010
`define EXE_RES_NB                       7'b0000000
`define EXE_RES_JAL                      7'b1100011
`define EXE_RES_JALR                     7'b1100111

//Aluop
//`define EXE_OR_OP 
//`define EXE_ADD_OP 
`define EXE_NOP_OP        3'b000//0
`define EXE_OR_OP         3'b001//1
`define EXE_AND_OP        3'b010//2
`define EXE_XOR_OP        3'b011//3
                          
`define EXE_ADD_OP        3'b100//4
`define EXE_SUB_OP        3'b101//5
                          
`define EXE_LW_OP         3'b101//4
`define EXE_SW_OP         3'b101//4
                          
`define EXE_BEQ_OP        3'b101//4
`define EXE_BNE_OP        3'b101//4
`define EXE_BLT_OP        3'b101//4
`define EXE_BGE_OP        3'b101//4
`define EXE_BLTU_OP       3'b101//4
`define EXE_BGEU_OP       3'b101//4
                          
`define EXE_JAL_OP        3'b101//4
`define EXE_JALR_OP       3'b101//4

//transer define
`define Branch      1'b1//transer 
`define NotBranch   1'b0//not transfer

//instruction memory about rom
`define ZeroWord    32'h00000000
`define InstAddrBus 31:0  //address
`define InstBus     31:0 //Data
`define InstMemNum  131071 //rom fact size 128K
`define InstMemNumLog2 17     //the real width of rom


//************************ reg total define
`define RegAddrBus  4:0   //regfile addr width
`define RegBus      31:0  //regfile data width
`define RegWidth    32    //in common use reg width
`define DoubleRegwidth 64 // double reg width
`define DoubleRegBus  63:0 //double data width
`define RegNum        32 //the num of reg
`define RegNumLog2    5 //the num of common reg
`define NOPRegAddr    5'b00000
