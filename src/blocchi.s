#!header

blocchi_crypt: # a0 stringa (ptr), a1 key (ptr) -> (in place)
# registri: a0, a1, a2, a3, a4, a5, t0, t1, t2
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa

addi sp, sp, -4
sw a0, 0(sp)
addi a0, a1, 0
jal str_len
addi t1, a0, 0 # len key
lw a0, 0(sp)
addi sp, sp 4

loop_blocchi_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

add a0, a2, t1
li a1, 256
jal modulo
addi t2, a0, 0

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_crypt

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

add a0, a4, a5
li a1, 256
jal modulo
addi t0, a0, 0

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_crypt
end_loop_blocchi_crypt:

lw ra, 0(sp)
addi sp, sp, 4
jr ra

blocchi_decrypt: # a0 stringa (ptr), a1 key (ptr) -> (in place)
# registri: a0, a1, a2, a3, a4, a5, t0, t1, t2
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa

addi sp, sp, -4
sw a0, 0(sp)
addi a0, a1, 0
jal str_len
addi t1, a0, 0 # len key
lw a0, 0(sp)
addi sp, sp 4

loop_blocchi_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

add a0, a2, t1
li a1, 256
jal modulo
addi t2, a0, 0

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_decrypt

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

sub a0, a4, a5
li a1, 256
jal modulo
addi t0, a0, 0

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_decrypt
end_loop_blocchi_decrypt:

lw ra, 0(sp)
addi sp, sp, 4
jr ra