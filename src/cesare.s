#!header

cesare_crypt: # a0 stringa (ptr), a1 K -> (in place)
# registri: a0, a1, a2, a3, a4, t0
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa

loop_cesare_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_crypt

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

add a0, a4, a1
li a1, 256
jal modulo
addi t0, a0, 0

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

sb t0, 0(a3)
addi a2, a2, 1
j loop_cesare_crypt
end_loop_cesare_crypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

cesare_decrypt: # a0 stringa (ptr), a1 K -> (in place)
# registri: a0, a1, a2, a3, a4, t0
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa

loop_cesare_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_decrypt

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

sub a0, a4, a1
li a1, 256
jal modulo
addi t0, a0, 0

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

sb t0, 0(a3)
addi a2, a2, 1
j loop_cesare_decrypt
end_loop_cesare_decrypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra