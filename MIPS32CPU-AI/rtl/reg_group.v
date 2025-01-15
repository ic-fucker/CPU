module reg_group (
    input wire clk,
    input wire rst_n,
    input wire reg_write,
    input wire [4:0] read_reg1,
    input wire [4:0] read_reg2,
    input wire [4:0] write_reg,
    input wire [31:0] write_data,
    
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    logic [31:0] registers [31:0];
    
    // Read ports
    assign read_data1 = (read_reg1 == 5'b0) ? 32'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'b0) ? 32'b0 : registers[read_reg2];
    
    // Write port
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            integer i;
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && write_reg != 5'b0) begin
            registers[write_reg] <= write_data;
        end
    end

endmodule
