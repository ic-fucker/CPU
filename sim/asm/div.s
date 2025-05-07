.text 
.globl divide
.globl ms

divide: # a2 -- num a3 -- *rst void div(int num, int* rst)
addi t0 ra 0
addi t1 a3 0
# thousand
addi a3 x0 1000
jal cnt
sw a0 0(t1)
# hundred
addi a3 x0 100
jal cnt
sw a0 4(t1)
# ten
addi a3 x0 10
jal cnt
sw a0 8(t1)
# one
sw a2 12(t1)
# divret
addi a3 t1 0
addi ra t0 0
jalr ra

ms: # void ms(int num, int* rst)
addi t0 ra 0
addi t1 a3 0
# minutes
addi a3 x0 60
jal cnt
# mindiv
addi t2 a2 0
addi a2 a0 0
addi a3 x0 10
jal cnt
sw a0 0(t1)
sw a2 4(t1)
# secdiv
addi a2 t2 0
jal cnt
sw a0 8(t1)
sw a2 12(t1)
# msret
addi a3 t1 0
jalr t0


cnt: # a2 -- num; a3 -- place. ret: a0 -- cnt; int cnt( int num, int place) => cnt
addi a0 x0 0
cntsub:
blt a2 a3 cntret
sub a2 a2 a3
addi a0 a0 1
beq x0 x0 cntsub
cntret:
jalr ra
