.text 
.globl dec_disp
dec_disp:	# void dec_disp( int num int gpio_addr) a2 a3
	add t1 a2 a2
	add t1 t1 t1
	add t1 t1 t1
	addi t1 t1 %lo(pinset)
	jalr t0 t1 0
	sw t2 (a3)
#return
	jalr ra
pinset:
	addi t2 x0 0	#0
	jalr x0 t0 0
	addi t2 x0 1	#1
	jalr x0 t0 0
	addi t2 x0 2	#2
	jalr x0 t0 0
	addi t2 x0 3	#3
	jalr x0 t0 0
	addi t2 x0 4	#4
	jalr x0 t0 0
	addi t2 x0 5	#5
	jalr x0 t0 0
	addi t2 x0 6	#6
	jalr x0 t0 0
	addi t2 x0 7	#7
	jalr x0 t0 0
	addi t2 x0 8	#8
	jalr x0 t0 0
	addi t2 x0 9	#9
	jalr x0 t0 0
