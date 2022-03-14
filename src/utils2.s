#!header

mult:
    addi sp, sp, -4 # push(ra)
    sw ra, 0(sp)
    li t0, 0
    li t1, 0
loop_mult:
    bge t0, a1, fine_loop
    add t1, t1, a0
    addi t0, t0, 1
    j loop_mult
fine_loop:
    add a0, t1, zero
    
    lw ra, 0(sp) # pop(ra)
    addi sp, sp, 4
    jr ra 