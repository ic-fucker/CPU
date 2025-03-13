`include "define.v"
module regfile (
    input wire                  clk,
    input wire                  rst,

    input wire                  we,
    input wire[`RegAddrBus]     waddr,
    input wire[`RegBus]         wdata,

    input wire                  re1,
    input wire[`RegAddrBus]     raddr1,
    output reg[`RegBus]         rdata1,

    input wire                  re2,
    input wire[`RegAddrBus]     raddr2,
    output reg[`RegBus]         rdata2


);

    reg[`RegBus] regs[0:`RegNum-1];

    always @ (posedge clk) begin
        if (rst == `RstDisable) begin
            if (we == `WriteEnable && waddr != `NOPRegAddr) begin
                regs[waddr] <= wdata;
            end
        end
    end

    always @ (*) begin
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if (re1 == `ReadEnable) begin
            if (raddr1 == waddr && we == `WriteEnable) begin
                rdata1 <= wdata;
            end else if (raddr1 == `NOPRegAddr) begin
                rdata1 <= `ZeroWord;
            end else begin
                rdata1 <= regs[raddr1];
            end
        end else begin
            rdata1 <= `ZeroWord;
        end
    end

    always @ (*) begin
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if (re2 == `ReadEnable) begin
            if (raddr2 == waddr && we == `WriteEnable) begin
                rdata2 <= wdata;
            end else if (raddr2 == `ZeroWord) begin
                rdata2 <= `ZeroWord;
            end else begin
                rdata2 <= regs[raddr2];
            end
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
    
    initial begin
        $monitor("x3: %d, x4: %d", regs[3], regs[4]);
    end
    endmodule
