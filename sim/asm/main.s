.text
.globl main
main:
	addi a2 x0 1145
	lui a3 %hi(a)
	addi a3 a3 0x0
# div
	jal ms
# display
	addi t3 x0 4
	lui t2 %hi(dlcnt)
	addi t2 t2 %lo(dlcnt)
	sw t3 0(t2)
display_loop:
	lui t1 %hi(dlcnt)
	addi t1 t1 %lo(dlcnt)
	lw t2 0(t1)
	lui t1 %hi(a)
	addi t1 t1 %lo(a)
	addi t2 t2 -1
	add t2 t2 t2
	add t2 t2 t2
	add t1 t1 t2
	lw a2 0(t1)
	ebreak 
	lui a3 %hi(gpio)
	addi a3 a3 %lo(gpio)
	jal dec_disp
	ebreak 
	lui t1 %hi(dlcnt)
	addi t1 t1 %lo(dlcnt)
	lw t2 0(t1) 
	addi t2 t2 -1
	sw t2 0(t1)
	blt x0 t2 display_loop
	
next:	
	ebreak 
.include "div.s"
.include "disp.s"
.data 
a: .word 0, 0, 0, 0
gpio: .word 0
dlcnt: .word 0