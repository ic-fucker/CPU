module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] alu_op,
    
    output reg [31:0] result,
    output wire zero
);

    // ALU operations
    localparam ALU_ADD  = 4'b0010;
    localparam ALU_SUB  = 4'b0110;
    localparam ALU_AND  = 4'b0000;
    localparam ALU_OR   = 4'b0001;
    localparam ALU_XOR  = 4'b0011;
    localparam ALU_NOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0111;
    localparam ALU_SLTU = 4'b1000;
    localparam ALU_SLL  = 4'b1001;
    localparam ALU_SRL  = 4'b1010;
    localparam ALU_SRA  = 4'b1011;

    always @(*) begin
        case (alu_op)
            ALU_ADD:  result = a + b;
            ALU_SUB:  result = a - b;
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_XOR:  result = a ^ b;
            ALU_NOR:  result = ~(a | b);
            ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            ALU_SLTU: result = (a < b) ? 32'b1 : 32'b0;
            ALU_SLL:  result = b << a[4:0];
            ALU_SRL:  result = b >> a[4:0];
            ALU_SRA:  result = $signed(b) >>> a[4:0];
            default:  result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule
