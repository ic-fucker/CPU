`define RstEnable           1'b0
`define AluOpBus            2:0
`define DataBus             31:0
`define AluOpOr             3'h0
`define AluOpAnd            3'h1
`define AluOpXor            3'h2
`define AluOpAdd            3'h3
`define AluOpSub            3'h4

`define DefaultAluResult    32'h00000000

module ex (
    input                            rst,
    input                            en,
    input                            pc_en,
    input                            imm_en,
    input        [`DataBus   ]       pc,
    input        [`DataBus   ]       reg_1,
    input        [`DataBus   ]       reg_2,
    input        [`DataBus   ]       imm,
    input        [`AluOpBus  ]       aluop,
    output  reg  [`DataBus   ]       alu_result
);

wire [`DataBus]  input_1;
wire [`DataBus]  input_2;

assign input_1 = pc_en ? pc : reg_1;
assign input_2 = imm_en ? imm : reg_2;

always @(posedge en or negedge rst) begin
    if (!rst) begin
        alu_result <= `DefaultAluResult;
    end
    else begin
        case (aluop)
            `AluOpOr : alu_result <= input_1 | input_2;
            `AluOpAnd: alu_result <= input_1 & input_2;
            `AluOpXor: alu_result <= input_1 ^ input_2;
            `AluOpAdd: alu_result <= input_1 + input_2;
            `AluOpSub: alu_result <= input_1 - input_2;
            default  : alu_result <= `DefaultAluResult;
        endcase
    end
end
    
endmodule  
