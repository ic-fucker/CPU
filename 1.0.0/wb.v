module WB(
		input					[31:0]		RAM_Data
    input        [31:0]    PC_Plua4,
    input        [31:0]    EX_Data,
    input        [ 1:0]    WB_Ctrl,
    
    output  reg  [31:0]    WB_Data
);

assign WB_Data = WB_Ctrl[0] == 0 ? (WB_Ctrl[1] == 0 ? RAM_Data : PC_Plus4) : EX_Data

endmodule
