# Verilog source files
SRC = $(wildcard rtl/*.v)
INCLUDE = -Irtl

# Testbench
TB = sim/tb_cpu.v

# Simulation executable
SIM = tb_cpu

# Compiler
VLOG = iverilog
VVPP = vvp

# Compile and simulate
all: compile simulate

compile:
	$(VLOG) -g2012 $(INCLUDE) -o $(SIM) $(TB) $(SRC)

simulate:
	$(VVPP) $(SIM)

clean:
	rm -f $(SIM) *.vcd

.PHONY: all compile simulate clean
