`define RstEnable   1'b0
`define MemEnable   1'b1

module mem(
    input  wire             clk,            // clock signal
    input  wire             rst,            // reset signal
    input  wire             mem_en,         // enable signal, from ctrl unit
    input  wire     [31:0]  mem_addr_i,     // the address of the target peripheral
    input  wire     [31:0]  reg2_i,         // the data to be stored to the target peripheral
    input  wire             l_or_s,         // indentifying whether load or store, 0 for store, 1 for load
    input  wire     [31:0]  load_data_in,    // the data loaded from the peripheral

    output  reg     [31:0]  addr_out,       // the address of the target peripheral
    output  reg     [31:0]  store_data_out, // the data to be stored to the target peripheral
    output  reg             we_out,         // read/write control bus, determined by l_or_s
    output  reg     [31:0]  load_data_out   // the data loaded from the peripheral
);

always @(*) begin
    if(!rst)   begin
        addr_out <= 32'b0;  
        store_data_out <= 32'b0;
        we_out <= 1'b0;      
        load_data_out <= 32'b0;        
    end
    else if(mem_en == `MemEnable)   begin
        addr_out <= mem_addr_i;  
        store_data_out <= reg2_i;
        we_out <= l_or_s;      
        load_data_out <= load_data_in;      
    end
    else    begin
        addr_out <= addr_out;  
        store_data_out <= store_data_out;
        we_out <= we_out;
        load_data_out <= load_data_out;      
    end
end


endmodule
