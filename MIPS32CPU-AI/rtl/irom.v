module irom (
    input wire [31:0] addr,
    
    output reg [31:0] instr
);

    reg [31:0] rom [0:1023];  // 4KB instruction memory
    
    // Initialize ROM with test program
    initial begin
        $readmemh("program.hex", rom);
    end

    always @(*) begin
        instr = rom[addr[11:2]];  // Word addressing
    end

endmodule
