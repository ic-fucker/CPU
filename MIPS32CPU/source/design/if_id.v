`include "defines.v"
module if_id (
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] if_addr,
    input wire[`InstBus]     if_data,
    output reg [`InstAddrBus] id_addr,
    output reg [`InstBus]     id_data
);
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            id_addr <= `ZeroWord;
            id_data <= `ZeroWord;
        end else begin
            id_addr <= if_addr;
            id_data <= if_data;
        end
    end
endmodule
