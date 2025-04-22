from riscv_assembler.convert import *
import argparse

# 创建解析器
parser = argparse.ArgumentParser(description="RISCV汇编器")

# 添加参数
parser.add_argument('--input', type=str, required=True, help='输入文件')
parser.add_argument('--output', type=str, help='输出文件')

# 解析参数
args = parser.parse_args()
asm = args.input
cnv = AssemblyConverter ('p', False, True)
result = cnv.convert(asm)
if args.output != None:
    cnv.output_mode='f'
    result = cnv.convert(asm, args.output)
