`timescale 1ns/1ns
module tb_pc_reg;
    reg clk, rst;
    wire[`InstAddrBus] pc;
    wire ce;

    initial begin
      clk = 1'b0;
      forever #10 clk = ~clk;
    end

    initial begin
      rst = `RstEnable;
      #195 rst = `RstDisable;
      #1000 $stop;
    end

    initial begin
      $monitor ("InstAddr = %h\tce = %b" ,pc ,ce );
    end

    initial begin
      $dumpfile ("./build/wave.vcd");
      $dumpvars (0, tb_pc_reg);
    end

    pc_reg inst_pc_reg(
      .clk(clk),
      .rst(rst),
      .pc(pc),
      .ce(ce)
    );

endmodule

