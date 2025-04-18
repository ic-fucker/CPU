# Riscv-cpu v2.0
推荐使用轻量级工具iverilog进行编译和仿真
## Project Structure
* design        --modules of cpu
* sim           --testbench
* output        --compiled files
* screenshot    --waveform from testbench
* peripherals   --design and sim of peripherals
## Usage
iverilog -Wall -v -o out -I ../include/ -c ./modules.txt ./top_tb.v 
vvp -n out
gtkwave wave.vcd
