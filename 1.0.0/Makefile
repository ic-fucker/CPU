BUILD = .\build\\

HEAD = $(DEFINE)

DEFINE = define.v
VERILOG = iverilog -I$(HEAD) -o
OUTPUT = $(BUILD)a.out

$(OUTPUT):	./*.v
	$(VERILOG) $(OUTPUT) ./*.v 


sim:	$(OUTPUT)
	vvp -n $(OUTPUT) -lxt2
clean:
	del $(BUILD)*.*
