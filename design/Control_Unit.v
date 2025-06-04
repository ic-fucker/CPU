module Control_Uint(
    input        clk,
    input        rst,
    input  [6:0] ALUSEL,

    output reg  PC_en,
    output reg  ID_en,
    output reg  EX_en,
    output reg  MEM_en,
    output reg  WB_en,

    output reg          Jump_en,
    output reg          imm_en,
    output reg          EXPC_en,
    output reg          L_or_S,
    output reg  [1:0]   WB_Ctrl
);

parameter [2:0] PC  = 3'b000;
parameter [2:0] ID  = 3'b001;
parameter [2:0] EX  = 3'b010;
parameter [2:0] MEM = 3'b011;
parameter [2:0] WB  = 3'b100;

reg [2:0]   st_cur;
reg [2:0]   st_nxt;

    always @(posedge clk or negedge rst)
begin
    if(!rst)
        begin
            PC_en   <= 0;
            ID_en   <= 0;
            EX_en   <= 0;
            MEM_en  <= 0;
            WB_en   <= 0;
            Jump_en <= 0;
            imm_en  <= 0;
            L_or_S  <= 0;
            WB_Ctrl <= 0;

            st_cur  <= PC;
        end
    else
        begin
            st_cur  <=  st_nxt;
        end
end

always @(*) begin
    case (st_cur)
        PC: 
            begin
                PC_en   = 1;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 0;
                st_nxt = ID;
            end
        ID:
            begin
                Jump_en = ALUSEL[6];
		imm_en  = ALUSEL[5];
                EXPC_en = ALUSEL[2:1] == 2'b01 ? 1 : 0;
                L_or_S  = ALUSEL[4];
                WB_Ctrl = ALUSEL[2:1];
                PC_en   = 0;
                ID_en   = 1;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 0;                
                st_nxt = EX;
            end
        EX:
            begin
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 1;
                MEM_en  = 0;
                WB_en   = 0; 
                st_nxt = ALUSEL[0] ? (ALUSEL[3] ? MEM : WB) : PC;
            end
        MEM:
            begin
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 1;
                WB_en   = 0; 
                st_nxt = ALUSEL[4] ? PC : WB;
            end
        WB:
            begin
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 1; 
                st_nxt = PC;
            end
        default: 
            begin
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 0;
                Jump_en = 0;
                imm_en  = 0;
                L_or_S  = 0;
                WB_Ctrl = 0;
                st_nxt = PC;
            end
    endcase
end

endmodule
