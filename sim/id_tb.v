module id_tb();
    reg rst, en;
    reg [31:0] inst;
    reg [31:0] reg1_data, reg2_data;
    wire [4:0] reg1_addr, reg2_addr, waddr;
    wire [2:0] aluop;
    wire [6:0] alusel;
    wire reg1_en, reg2_en;
    wire [31:0] reg1, reg2, imm;

    id id_u(
        .rst(rst),
        .inst_i(inst),
        .reg1_data_i(reg1_data),
        .reg2_data_i(reg2_data),
        .id_en(en),

        .reg1_read_o(reg1_en),
        .reg2_read_o(reg2_en),
        .reg1_addr_o(reg1_addr),
        .reg2_addr_o(reg2_addr),
        .aluop_o(aluop),
        .alusel_o(alusel),
        .reg1_o(reg1),
        .reg2_o(reg2),
        .wd_o(waddr),
        .imm_o(imm)
    );
    
    initial begin
        rst = 1'b0;
        #20
        rst = 1'b1;
        inst = 32'h02000193;
        reg1_data = 32'h10;
        reg2_data = 32'h20;
	#1000
	$finish;

    end

    initial begin
        en = 1'b0;
        forever begin
            #10
            en = ~en;
        end
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, id_tb);
    end

endmodule
