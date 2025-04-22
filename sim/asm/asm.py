from riscv_assembler.convert import *
asm = input("type a file:")
cnv = AssemblyConverter ('p', True, True)
result = cnv.convert(asm)
