`timescale 1ns/1ns
`define clock_period 20

module RAM_tb();

//  input
reg         clk;
reg         rst;
reg         w_r;
reg [31:0]  addr;
reg [31:0]  wr_data;

//  output
wire [31:0] rd_data;

initial 
begin
    clk    = 1'b1;
end

always #10 clk = ~clk;

initial 
begin
    rst <= 1'b1;    // check reset
    #20
    rst <= 1'b0;

    #20 // CPU before entering mem       
    w_r <= 1'b1;
    addr <= 32'h1000_0000;
    wr_data <= 32'h0000_0000;

    #20 // CPU enter mem: write test    
    w_r <= 1'b0;
    addr <= 32'h0000_0001;
    wr_data <= 32'h10101010;

    #320 // CPU leaves mem    
    w_r <= 1'b0;
    addr <= 32'h1000_0000;
    wr_data <= 32'h0000_0000;

    #20 // CPU enter mem: write test    
    w_r <= 1'b0;
    addr <= 32'h0000_001F;
    wr_data <= 32'hFFFFFFFF;

    #320 // CPU leaves mem   
    w_r <= 1'b0;
    addr <= 32'h1000_0000;
    wr_data <= 32'h0000_0000;

    #20 // CPU enter mem: read test    
    w_r <= 1'b1;
    addr <= 32'h0000_001F;
    wr_data <= 32'h10101010;

    #40 // CPU enter mem: read test    
    w_r <= 1'b1;
    addr <= 32'h0000_0001;
    wr_data <= 32'h10101010;


    #20 // CPU leaves mem    
    w_r <= 1'b1;
    addr <= 32'h1000_0000;
    wr_data <= 32'h0000_0000;
    
    #20
    $stop;
end

RAM    RAM_inst(
    .clk(clk),
    .rst(rst),

    .addr(addr),

    .w_r(w_r),

    .wr_data(wr_data),
    .rd_data(rd_data)
);

endmodule
