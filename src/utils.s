#!header
#include utils2.s

fattoriale:
    addi a1, a0, -1
fatt:
    addi sp, sp, -4 # push(ra)
    sw ra, 0(sp)
    
    beq a1, s1, fine_fattoriale
    
    jal mult
    addi a1, a1, -1
    
    jal fatt

fine_fattoriale:
    lw ra, 0(sp) # pop(ra)
    addi sp, sp, 4
    jr ra 