module mem_peripheral_top(
    input  wire             clk,            // clock signal
    input  wire             rst,            // reset signal
    input  wire             mem_en,         // enable signal, from ctrl unit
    input  wire     [31:0]  mem_addr_i,     // the address of the target peripheral
    input  wire     [31:0]  reg2_i,         // the data to be stored to the target peripheral
    input  wire             l_or_s,         // indentifying whether load or store, 0 for store, 1 for load
    input  wire     [31:0]  gpio_in,        // input from GPIO

    output  wire    [31:0]  load_data_out,  // the data loaded from the peripheral
    output  wire    [31:0]  gpio_out        // output to GPIO
);

//  input
wire [31:0]  load_data_in;

//  output
wire [31:0]  addr_out;     
wire [31:0]  store_data_out;
wire         we_out;

mem mem_inst(
    // input
    .rst(rst),           
    .mem_en(mem_en),        
    .mem_addr_i(mem_addr_i),    
    .reg2_i(reg2_i),        
    .l_or_s(l_or_s),        
    .load_data_in(load_data_in),  

    // output
    .addr_out(addr_out),      
    .store_data_out(store_data_out),
    .we_out(we_out),        
    .load_data_out(load_data_out) 
);

RAM    RAM_inst(
    .clk(clk),
    .rst(rst),

    .addr(addr_out),

    .w_r(l_or_s),

    .wr_data(store_data_out),
    .rd_data(load_data_in)  // output to CPU
);

GPIO    GPIO_inst(
    .clk(clk),
    .rst(rst),

    .addr(addr_out),

    .w_r(l_or_s),

    .wr_data(store_data_out),
    .rd_data(load_data_in), // output to CPU

    .gpio_in(gpio_in),
    .gpio_out(gpio_out)
);

Timer    timer_inst(
    .clk(clk),
    .rst(rst),

    .addr(addr_out),

    .w_r(l_or_s),

    .timer_config(store_data_out),

    .time_out(load_data_in) // output to CPU
);

endmodule
