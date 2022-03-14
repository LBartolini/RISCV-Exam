#!header

modulo: # a0 x, a1 n -> a0 (x%n)
# registri: a0, a1
addi sp, sp, -4
sw ra, 0(sp)

loop_modulo_1:
bge a0, zero, loop_modulo_2
add a0, a0, a1
j loop_modulo_1

loop_modulo_2:
blt a0, a1, end_modulo
sub a0, a0, a1
j loop_modulo_2

end_modulo:
lw ra, 0(sp)
addi sp, sp, 4
jr ra