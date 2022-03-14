.data
 n: .word 6
.text
j main

# sei un coglione, questo è semplicemente
# un for ricorsivo 

### START HEADERS ###

## (utils.s)
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

## (utils2.s)
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

### END HEADERS ###

main:
li s1, 1
lw a0, n

jal fattoriale

li a7, 1
ecall