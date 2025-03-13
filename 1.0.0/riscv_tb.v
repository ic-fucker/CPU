`timescale 1ns/1ps
`include "define.v"
module riscv_tb();

    reg sys_clk;
    reg sys_rst_n;
//every 10 ns reverse clock
    initial begin
        sys_clk = 1'b0;
        forever #10 sys_clk = ~sys_clk;
    end

    initial begin
        sys_rst_n =`RstEnable;
        #195 sys_rst_n = `RstDisable;
        #1000  $finish;
    end

    wire [`RegBus]   rom_addr;
    wire [`RegBus]   rom_data;
    wire rom_ce;


    RISC_V_TOP RISC_V_TOP_u
    (
        .clk        (sys_clk),
        .rst        (sys_rst_n),
        .rom_data_i (rom_data),

        .rom_addr_o (rom_addr),
        .rom_ce_o   (rom_ce)
    );

    inst_rom inst_rom_u
    (
        .ce     (rom_ce),
        .addr   (rom_addr),

        .inst   (rom_data)
    );
    initial begin
        $monitor("inst: %h", rom_data);
    end
    initial begin            
		$dumpfile("./build/wave.vcd"); //生成的vcd文件名称
		$dumpvars(0, riscv_tb);    //tb模块名称
    end

 endmodule
