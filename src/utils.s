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