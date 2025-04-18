start:
addi x1, x0, -1		# 0
sw   x1, 0(x0)		# 4
lw   x2, 0(x0)		# 8
beq  x1, x2, l1		# c
bne  x1, x2, start	#10
l1:
addi x1, x1, 1		#14
blt  x2, x1, l2		#18
addi x0, x0, 0		#1c
l2:
bltu x1, x2, l3		#20
addi x0, x0, 0		#24
l3:
bge  x1, x2, l4		#28
addi x0, x0, 0		#2c
l4:
bgeu x2, x1, l5		#30
addi x0, x0, 0		#34
l5:
jal  l6			#38
addi x2, x1, 1		#3c
l6:
jalr x1, 0		#40

