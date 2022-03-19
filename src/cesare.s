.data
K_cesare: .word 1
.text
# a0 stringa (ptr), a1 K -> (in place)
cesare_crypt: 
#! a0 a1 a2 a3 a4 t0
#! manage_ra
li a2, 0 # indice for stringa

loop_cesare_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_crypt

#! precall(modulo)
add a0, a4, a1
li a1, 256
jal modulo
addi t0, a0, 0
#! postcall(modulo)


sb t0, 0(a3)
addi a2, a2, 1
j loop_cesare_crypt
end_loop_cesare_crypt:
#! end

# a0 stringa (ptr), a1 K -> (in place)
cesare_decrypt: 
#! a0 a1 a2 a3 a4 t0
#! manage_ra
li a2, 0 # indice for stringa

loop_cesare_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_decrypt

#! precall(modulo)
sub a0, a4, a1
li a1, 256
jal modulo
addi t0, a0, 0
#! postcall(modulo)

sb t0, 0(a3)
addi a2, a2, 1
j loop_cesare_decrypt
end_loop_cesare_decrypt:
#! end