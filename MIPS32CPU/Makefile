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

#command

pc_reg:
	make pc_reg.out

tb_pc_reg:		
	$(VERILOG) $(BUILD)a.out $(DESIGN)pc_reg.v $(SIM)tb_pc_reg.v
	make sim

if_id:
	make if_id.out

sim:		$(BUILD)a.out Makefile
	vvp -n $(BUILD)a.out
	gtkwave $(BUILD)wave.vcd

clean:
	del build\*.out
	del build\*.vcd
