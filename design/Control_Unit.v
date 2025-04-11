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

parameter   PC  = 3'b000;
parameter   ID  = 3'b001;
parameter   EX  = 3'b010;
parameter   MEM = 3'b011;
parameter   WB  = 3'b100;

parameter   Jump = 3'b100;

reg [2:0]   st_cur;
reg [2:0]   st_next;

always @(posedge clk or posedge rst)
begin
    if(rst)
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
            st_cur  <=  st_next;
        end
end

always @(*) begin
    case (st_cur)
        PC: 
            begin
                Jump_en = ALUSEL[6];
                PC_en   = 1;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 0;
                st_next = ID;
            end
        ID:
            begin
                PC_en   = 0;
                ID_en   = 1;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 0;                
                st_next = EX;
            end
        EX:
            begin
                imm_en  = ALUSEL[5];
                EXPC_en = ALUSEL[2:1] == 2'b11 ? 1 : 0;
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 1;
                MEM_en  = 0;
                WB_en   = 0; 
                st_next = ALUSEL[0] ? (ALUSEL[3] ? MEM : WB) : PC;
            end
        MEM:
            begin
                L_or_S  = ALUSEL[4];
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 1;
                WB_en   = 0; 
                st_next = ALUSEL[4] ? PC : WB;
            end
        WB:
            begin
                WB_Ctrl = ALUSEL[2:1];
                PC_en   = 0;
                ID_en   = 0;
                EX_en   = 0;
                MEM_en  = 0;
                WB_en   = 1; 
                st_next = PC;
            end
        default: 
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
                st_next = PC;
            end
    endcase
end

endmodule
