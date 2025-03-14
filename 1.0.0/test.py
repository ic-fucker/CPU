from riscv_assembler.convert import *
cnv = AssemblyConverter ('p',True, True)
# print ("addi t0 s0 32")
result = cnv.convert("./test1.s");
