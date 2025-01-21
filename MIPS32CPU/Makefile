BUILD = ./build/
SOURCE = ./source/
HEAD = ./head/

DEFINE = $(HEAD)defines.v
DESIGN = $(SOURCE)design/
SIM = $(SOURCE)sim/
VERILOG = iverilog -I$(HEAD) -o

#files

pc_reg.out:		$(DESIGN)pc_reg.v $(DEFINE) Makefile
	$(VERILOG) $(BUILD)pc_reg.out $(DESIGN)pc_reg.v 

if_id.out:		$(DESIGN)if_id.v $(DEFINE) Makefile
	$(VERILOG) $(BUILD)if_id.out $(DESIGN)if_id.v 

regfile.out:	$(DESIGN)regfile.v $(DEFINE) Makefile
	$(VERILOG) $(BUILD)regfile.out $(DESIGN)regfile.v

#command

pc_reg:
	make pc_reg.out

tb_pc_reg:		
	$(VERILOG) $(BUILD)a.out $(DESIGN)pc_reg.v $(SIM)tb_pc_reg.v
	make sim

if_id:
	make if_id.out

regfile:
	make regfile.out

tb_regfile:
	$(VERILOG) $(BUILD)a.out $(DESIGN)regfile.v $(SIM)tb_regfile.v
	make sim

sim:		$(BUILD)a.out Makefile
	vvp -n $(BUILD)a.out -lxt2
	gtkwave $(BUILD)wave.vcd

clean:
	del build\*.out
	del build\*.vcd
