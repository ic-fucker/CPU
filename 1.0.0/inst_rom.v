`include "define.v"
module inst_rom 
(
    input wire ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus] inst
);
//define a array which size is InstMemNum,the width is InstBus
reg[`InstBus] inst_mem[0:`InstMemNum - 1];
// use file inst_rom.data to intialize the data reg
initial begin
    inst_mem[0]  = 32'h02000193;// 0000 0010 0000 0000 0000 0001 1001 0011
    inst_mem[1]  = 32'h04000213;// 0000 0100 0000 0000 0000 0010 0001 0011
    inst_mem[2]  = 32'h02118193;// 0000 0010 0001 0001 1000 0001 1001 0011;
    inst_mem[3]  = 32'h04018213;// 0000 0100 0000 0001 1000 0010 0001 0011;

    // $readmemh("E:\FPGA_vivado\MIPS32\rtl\inst_rom.data",inst_mem);
end
always @(*) begin
    if(ce == `ChipDisable) begin
        inst <= `ZeroWord;
    end else begin
        inst <= inst_mem[addr[`InstMemNumLog2+1: 2]];
    end
end
    
endmodule

