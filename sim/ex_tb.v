module ex_tb();

reg         rst, en,pc_en, imm_en;
reg  [31:0] pc, reg_1, reg_2, imm;
reg  [2:0]  aluop;
wire [31:0] alu_result;

initial begin 
    en = 0;
    forever begin
        #10
        en = ~en;
    end
end

initial begin
    aluop = 3;
    reg_1 = 10;
    reg_2 = 20;
    pc_en = 0;
    imm_en = 0;
    rst = 0;
    #100
    rst = 1;
    #1000
    $finish;
end
ex ex_u(
    .rst(rst),
    .en(en),
    .pc_en(pc_en),
    .imm_en(imm_en),
    .pc(pc),
    .reg_1(reg_1),
    .reg_2(reg_2),
    .imm(imm),
    .aluop(aluop),
    .alu_result(alu_result)
);

initial begin
    $monitor("result: %d", alu_result);
    $dumpfile("wave.vcd");
    $dumpvars(0, ex_tb);
end

endmodule
