.data
K_cesare: .word -2
.text
# a0 stringa (ptr), a1 K -> (in place)
cesare_crypt: 
#! a0 a1 a2 a3 a4 t0 t1
#! manage_ra
li a2, 0 # indice for stringa

loop_cesare_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_crypt

li t1, 122
bgt a4, t1, cesare_crypt_next_check
li t1, 97
bge a4, t1, cesare_crypt_preparation

cesare_crypt_next_check:
li t1, 90
bgt a4, t1, cesare_crypt_incr
li t1, 65
bge a4, t1, cesare_crypt_preparation
j cesare_crypt_incr

cesare_crypt_preparation:
sub a4, a4, t1

cesare_crypt_save:
#! precall(modulo)
add a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
#! postcall(modulo)
add t0, t0, t1
sb t0, 0(a3)

cesare_crypt_incr:
addi a2, a2, 1
j loop_cesare_crypt
end_loop_cesare_crypt:
#! end

# a0 stringa (ptr), a1 K -> (in place)
cesare_decrypt: 
#! a0 a1 a2 a3 a4 t0 t1
#! manage_ra
li a2, 0 # indice for stringa

loop_cesare_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_decrypt

li t1, 122
bgt a4, t1, cesare_decrypt_next_check
li t1, 97
bge a4, t1, cesare_decrypt_preparation

cesare_decrypt_next_check:
li t1, 90
bgt a4, t1, cesare_decrypt_incr
li t1, 65
bge a4, t1, cesare_decrypt_preparation
j cesare_decrypt_incr

cesare_decrypt_preparation:
sub a4, a4, t1

cesare_decrypt_save:
#! precall(modulo)
sub a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
#! postcall(modulo)
add t0, t0, t1
sb t0, 0(a3)

cesare_decrypt_incr:
addi a2, a2, 1
j loop_cesare_decrypt
end_loop_cesare_decrypt:
#! end