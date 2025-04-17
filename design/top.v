`include "defines.v" 


module top(
	input 	wire					clk,
	input 	wire					rst,
	
	input 	wire	[`InstBus]			inst_i,
	
	input 	wire 	[`DataBus]			load_data_in,
	output  wire		[31:0]			addr_out,
	output 	wire 						we_out,
	output 	wire		[`DataBus]		store_data_out,

	output  wire		[`DataBus]		pc,
	output  wire 					ce
);

// outports wire
wire       					PC_en;
wire       					ID_en;
wire       					EX_en;
wire       					MEM_en;
wire       					WB_en;
wire       					Jump_en;
wire       					imm_en;
wire       					EXPC_en;
wire       					L_or_S;
wire 		[ 1:0 ] 			WB_Ctrl;
wire 		[ 31:0] 			pc_plus_4;
wire    	                		reg1_read_o;
wire    	                		reg2_read_o;
wire    	[ 4:0 ]   			reg1_addr_o;
wire    	[ 4:0 ]   			reg2_addr_o;
wire    	[ 2:0 ]     			aluop_o;    
wire    	[ 6:0 ]    			alusel_o;   
wire    	[ 31:0]       			reg1_o;
wire    	[ 31:0]       			reg2_o;
wire    	[ 4:0 ]   			wd_o;
wire    	[ 31:0]       			imm_o;
wire 		[ 31:0] 			alu_result;
wire 		[ 31:0] 			rdata1;
wire 		[ 31:0] 			rdata2;
wire 		[ 31:0] 			WB_Data;
wire 		[ 31:0] 			load_data_out;
wire 		[ 31:0] 			gpio_out;

Control_Uint #(
	.PC   	( 000  ),
	.ID   	( 001  ),
	.EX   	( 010  ),
	.MEM  	( 011  ),
	.WB   	( 100  ),
	.Jump 	( 100  ))
u_Control_Uint(
	.clk     			( clk      		),
	.rst     			( rst      		),
	.ALUSEL  			( alusel_o 		),

	.PC_en   			( PC_en    		),
	.ID_en   			( ID_en    		),
	.EX_en   			( EX_en    		),
	.MEM_en  			( MEM_en   		),
	.WB_en   			( WB_en    		),
	.Jump_en 			( Jump_en  		),
	.imm_en  			( imm_en   		),
	.EXPC_en 			( EXPC_en  		),
	.L_or_S  			( L_or_S   		),
	.WB_Ctrl 			( WB_Ctrl  		)
);

pc u_pc(
	.rst     			( rst      		),
	.pc_en   			( PC_en    		),
	.branch  			( alu_result	),
	.branch_en  			( Jump_en  		),

	.ce      			( ce       		),
	.pc      			( pc       		),
	.pc_plus_4  			( pc_plus_4		)
);		

id u_id(		
	.rst     			( rst      	  	),
	.inst_i   			( inst_i      	),
	.reg1_data_i			( rdata1	  	),
	.reg2_data_i			( rdata2	  	),
	.id_en    			( ID_en       	),

	.reg1_read_o			( reg1_read_o 	),
	.reg2_read_o			( reg2_read_o 	),
	.reg1_addr_o			( reg1_addr_o 	),
	.reg2_addr_o			( reg2_addr_o 	),
	.aluop_o  			( aluop_o     	),
	.alusel_o 			( alusel_o    	),
	.reg1_o   			( reg1_o      	),
	.reg2_o   			( reg2_o      	),
	.wd_o     			( wd_o        	),
	.imm_o    			( imm_o       	)
);

regfile u_regfile(
	.clk     			( clk    	  	),
	.rst     			( rst    	  	),
	.we      			( WB_en  	  	),
	.waddr   			( wd_o   	  	),
	.wdata   			( WB_Data	  	),
	.re1     			( reg1_read_o 	),
	.raddr1  			( reg1_addr_o 	),
	.rdata1  			( rdata1 	  	),
	.re2     			( reg2_read_o 	),
	.raddr2  			( reg2_addr_o 	),
	.rdata2  			( rdata2 	  	)
);			

ex u_ex(			
	.rst     			( rst         	),
	.en      			( EX_en       	),
	.pc_en   			( EXPC_en     	),
	.imm_en  			( imm_en      	),
	.pc      			( pc          	),
	.reg_1   			( reg1_o      	),
	.reg_2   			( reg2_o      	),
	.imm     			( imm_o       	),
	.aluop   			( aluop_o     	),

	.alu_result 			( alu_result  	)
);

mem u_mem(
    // input
    .rst				( rst			),           
    .mem_en				( MEM_en		),        
    .mem_addr_i				( alu_result	),    
    .reg2_i				( reg2_o		),        
    .l_or_s				( L_or_S		),        
    .load_data_in			( load_data_in	),  
 
    // output	 
    .addr_out				( addr_out		),      
    .store_data_out			( store_data_out),
    .we_out				( we_out		),        
    .load_data_out			( load_data_out	) 
);

WB u_WB(
	.RAM_Data 			( load_data_out ),
	.PC_Plus4 			( pc_plus_4  	),
	.EX_Data  			( alu_result   	),
	.WB_Ctrl  			( WB_Ctrl   	),
	.WB_Data  			( WB_Data   	)
);

endmodule