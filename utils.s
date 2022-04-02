.text
# a0 x, a1 n -> a0 (x%n)
modulo:
#! a0 a1
#! manage_ra 

loop_modulo_1:
bge a0, zero, loop_modulo_2
add a0, a0, a1
j loop_modulo_1

loop_modulo_2:
blt a0, a1, end_modulo
sub a0, a0, a1
j loop_modulo_2

end_modulo:
#! end

# a0 stringa (ptr) -> a0 len
str_len:
#! a0 t0 t1 t2
#! manage_ra
li t1, 0

loop_str_len:
add t2, a0, t1
lb t0, 0(t2)
beq t0, zero, end_str_len
addi t1, t1, 1
j loop_str_len

end_str_len:
addi a0, t1, 0
#! end

# a0 stringa, a1 char -> a0 boolean (char in stringa) (0 f, 1 t)
check_char_in_string:
#! a0 a1 t0 t1 t2
#! manage_ra
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
#! end

# a0 x, a1 y -> a0 (x*y)
mult: 
#! a0 a1 t0 t1
#! manage_ra
li t0, 0
li t1, 0
loop_mult:
bge t0, a1, fine_loop_mult
add t1, t1, a0
addi t0, t0, 1
j loop_mult

fine_loop_mult:
add a0, t1, zero
#! end

# a0 numero -> a0 k cifre
conta_cifre: 
#! a0 a1 t0 t1 t2
#! manage_ra
li t0, 1 # contatore
li a1, 10 # base

loop_conta_cifre:
blt a0, a1, end_loop_conta_cifre

slli t1, a1, 3
slli t2, a1, 1
add a1, t1, t2 # a1*10

addi t0, t0, 1
j loop_conta_cifre
end_loop_conta_cifre:

addi a0, t0, 0
#! end