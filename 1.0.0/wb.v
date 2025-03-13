module wb(
    input                  rst,
    input                  clk,
    input        [ 4:0]    ex_wreg,
    input        [31:0]    ex_wdata,
    input                  ex_wd,
    
    output  reg  [ 4:0]    wb_wreg,
    output  reg  [31:0]    wb_wdata,
    output  reg            wb_wd
);

always @(posedge clk or negedge rst) begin
    if (rst == `RstEnable) begin
        wb_wd    <= 0;
        wb_wreg  <= 0;
        wb_wdata <= 0;
    end
    else begin
        if(ex_wd) begin
            wb_wd    <= 1;
            wb_wreg  <= ex_wreg;
            wb_wdata <= ex_wdata;
        end
        else begin
            wb_wd    <= 0;
            wb_wreg  <= 0;
            wb_wdata <= 0;
        end
    end
end

endmodule
