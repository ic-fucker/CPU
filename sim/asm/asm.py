from riscv_assembler.convert import *
cnv = AssemblyConverter ('p', True, True)
result = cnv.convert("./test_sw.s")
