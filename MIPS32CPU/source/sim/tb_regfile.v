`include "defines.v"
module tb_regfile;
    reg clk, rst;
    reg we, re1, re2;
    reg[`RegAddrBus] waddr, raddr1, raddr2;
    reg[`RegBus] wdata;
    wire[`RegBus] rdata1, rdata2;

    initial begin
        clk <= 1'b0;
        forever #10 clk <= ~clk;
    end

    initial begin
        rst <= `RstEnable;
        #200 rst <= `RstDisable;
        #1000 $stop;
    end

    initial begin
        we = `WriteEnable;
        re1 = `ReadEnable;
        re2 = `ReadEnable;
        waddr = `NOPRegAddr;
        wdata = `RegWidth'h9399;
        raddr1 = `NOPRegAddr;
        raddr2 = `RegNumLog2'd2;
        #20;
        waddr = `RegNumLog2'd2;
        wdata = `RegWidth'h9399;
        #200;
        waddr = `NOPRegAddr;
        wdata = `RegWidth'h9399;
        #100;
        waddr = `RegNumLog2'd2;
        wdata = `RegWidth'h9399;
        #100;
        raddr1 = `RegNumLog2'd31;
        waddr = `RegNumLog2'd31;
        wdata = `RegWidth'h3312;
        raddr2 = `RegNumLog2'd1;
        waddr = `RegNumLog2'd1;
        #100;
        raddr1 = `RegNumLog2'd3;
        raddr2 = `RegNumLog2'd15;
        #100;
        we = `WriteDisable;
        waddr = `RegNumLog2'd3;
        waddr = `RegNumLog2'd15;
        #100;
        re1 = `ReadDisable;
        re2 = `ReadDisable;
    end

    initial begin
        $monitor("we = %b \t waddr = %h \t wdata = %h \t re1 = %b \t raddr1 = %d rdata1 = %h \t re2 = %b \t raddr2 = %d rdata2 = %h \n",we ,waddr ,wdata ,re1 ,raddr1 ,rdata1 ,re2 ,raddr2 ,rdata2);
    end
    
    
	  initial begin            
		    $dumpfile("./build/wave.vcd"); //生成的vcd文件名称
		    $dumpvars(0, tb_regfile);    //tb模块名称
	  end

    regfile inst_regfile(
      .clk(clk),
      .rst(rst),

      .we(we),
      .waddr(waddr),
      .wdata(wdata),
      
      .re1(re1),
      .raddr1(raddr1),
      .rdata1(rdata1),

      .re2(re2),
      .raddr2(raddr2),
      .rdata2(rdata2)
    );
endmodule
