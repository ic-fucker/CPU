module pc (
    input wire clk,
    input wire rst_n,
    input wire [31:0] branch_target,
    input wire [31:0] jump_target,
    input wire branch,
    input wire jump,
    
    output reg [31:0] pc
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 32'b0;
        end
        else begin
            if (jump) begin
                pc <= jump_target;
            end
            else if (branch) begin
                pc <= branch_target;
            end
            else begin
                pc <= pc + 32'd4;
            end
        end
    end

endmodule
