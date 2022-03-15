#!header
#define procedures.s

modulo: # a0 x, a1 n -> a0 (x%n)
# registri: a0, a1
#! push_ra

loop_modulo_1:
bge a0, zero, loop_modulo_2
add a0, a0, a1
j loop_modulo_1

loop_modulo_2:
blt a0, a1, end_modulo
sub a0, a0, a1
j loop_modulo_2

end_modulo:
#! pop_ra
jr ra

str_len: # a0 stringa (ptr) -> a0 len
# registri: a0, t0, t1, t2
#! push_ra
li t1, 0

loop_str_len:
add t2, a0, t1
lb t0, 0(t2)
beq t0, zero, end_str_len
addi t1, t1, 1
j loop_str_len

end_str_len:
addi a0, t1, 0
#! pop_ra
jr ra

check_char_in_string: # a0 stringa, a1 char -> a0 boolean (char in stringa) (0 f, 1 t)
# Registri: a0, a1, t0, t1, t2
#! push_ra
li t0, 0 # indice for
li t2, 0 # boolean return value

loop_check_char:
add t1, a0, t0
lb t1, 0(t1)
beq t1, zero, end_loop_check_char
beq t1, a1, found_char
addi t0, t0, 1
j loop_check_char

found_char:
li t2, 1

end_loop_check_char:
addi a0, t2, 0
#! pop_ra
jr ra

mult: # a0 x, a1 y -> a0 (x*y)
# Registri: a0, a1, t0, t1
#! push_ra
li t0, 0
li t1, 0
loop_mult:
bge t0, a1, fine_loop_mult
add t1, t1, a0
addi t0, t0, 1
j loop_mult

fine_loop_mult:
add a0, t1, zero
#! pop_ra
jr ra 