from riscv_assembler.convert import *
cnv = AssemblyConverter ('p', False, True)
result = cnv.convert("./test_sw.s")
print(result)
