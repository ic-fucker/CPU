module WB(
    input   [31:0]  RAM_Data,
    input   [31:0]  PC_Plus4,
    input   [31:0]  EX_Data,
    input   [ 1:0]  WB_Ctrl,
    
    output  [31:0]  WB_Data
);

assign WB_Data = WB_Ctrl[0] ? EX_Data : (WB_Ctrl[1] ? PC_Plus4 : RAM_Data);

endmodule
