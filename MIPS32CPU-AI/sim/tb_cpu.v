`timescale 1ns/1ps

module tb_cpu;

    // Inputs
    reg clk;
    reg rst_n;
    
    // Instruction memory signals
    wire [31:0] imem_data;
    reg [31:0] imem [0:255];
    
    // Data memory signals
    wire [31:0] dmem_rdata;
    reg [31:0] dmem [0:255];
    
    // Load test program
    initial begin
        $readmemh("program.hex", imem);
    end
    
    // Instruction memory
    assign imem_data = imem[cpu_inst.pc[9:2]];
    
    // Data memory
    always @(posedge clk) begin
        if (cpu_inst.dmem_we)
            dmem[cpu_inst.dmem_addr[9:2]] <= cpu_inst.dmem_wdata;
    end
    assign dmem_rdata = dmem[cpu_inst.dmem_addr[9:2]];

    // Instantiate the CPU
    cpu cpu_inst (
        .clk(clk),
        .rst_n(rst_n),
        .imem_addr(),
        .imem_data(imem_data),
        .dmem_addr(),
        .dmem_we(),
        .dmem_wdata(),
        .dmem_rdata(dmem_rdata)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst_n = 0;
        
        // Reset sequence
        #20;
        rst_n = 1;
        
        // Run test
        #1000;
        
        // Finish simulation
        $display("Simulation finished");
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | RegWrite: %b | ALUResult: %h",
                 $time, cpu_inst.pc, cpu_inst.instr, cpu_inst.reg_write, cpu_inst.alu_result);
    end

endmodule
