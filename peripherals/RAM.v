`define RstEnable 1'b0
`define RstDisable 1'b1
`define ChipDisable 1'b0
`define ChipEnable  1'b1

module RAM(
    // clock and reset
    input wire clk,
    input wire rst,

    // data bus interface
    input wire  [31:0]  addr,
    
    // write/read control, 0 for ram_write, 1 for ram_read
    input wire  w_r,

    // communicate with CPU
    input wire  [31:0]  wr_data,
    output reg  [31:0]  rd_data
);

reg [31:0] ram_reg [0:99];

always @(negedge clk or negedge rst) begin
    if(!rst)   begin
        rd_data = 32'b0;
    end
    else    begin
        if((addr >= 32'h00000000) && (addr <= 32'h00000063))  begin   // CPU select GPIO_Port, communication begins
            if(w_r == 1'b0) begin   // CPU write RAM
                ram_reg[addr] = wr_data;
            end
            else    begin   // CPU read RAM
                rd_data = ram_reg[addr];
            end
        end
        else    begin   //CPU not select GPIO_PORT, communication ends
            rd_data = 32'hZZZZZZZZ;
        end
    end
    
end

endmodule
