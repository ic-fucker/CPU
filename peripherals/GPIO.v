`define RstEnable 1'b0
`define RstDisable 1'b1
`define ChipDisable 1'b0
`define ChipEnable  1'b1
`define GPIO_PORT_ADDRESS  32'h0000_8004

module GPIO(
    // clock and reset
    input wire clk,
    input wire rst,

    // data bus interface
    input wire  [31:0]  addr,
    
    // write/read control, 0 for gpio_write, 1 for gpio_read
    input wire  w_r,

    // communicate with CPU
    input wire  [31:0]  wr_data,
    output reg  [31:0]  rd_data,

    // communicate with GPIO pins
    input wire  [31:0]  gpio_in,
    output reg  [31:0]  gpio_out
);

always @(negedge clk or negedge rst) begin
    if(!rst)   begin
        rd_data <= 32'b0;
        gpio_out <= 32'b0;
    end
    else    begin
        if(addr == `GPIO_PORT_ADDRESS)  begin   // CPU select GPIO_Port, communication begins
            if(w_r == 1'b0) begin   // CPU write gpio
                gpio_out <= wr_data;
            end
            else    begin   // read gpio
                rd_data <= gpio_in;
            end
        end
        else    begin   //CPU not select GPIO_PORT, communication ends
            rd_data <= 32'hZZZZZZZZ;
        end
    end
    
end

endmodule