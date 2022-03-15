
.data
K_cesare: .word 1
Key_blocchi: .string "abc"
Cyper_occorrenze: .word 1000
prova: .string ""

plain_text: .string "abcabcabc"
.text
j main

### START HEADERS ###

#####
## (utils.s)

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

str_len: # a0 stringa (ptr) -> a0 len
# registri: a0, t0, t1, t2
addi sp, sp, -4
sw ra, 0(sp)
li t1, 0

loop_str_len:
add t2, a0, t1
lb t0, 0(t2)
beq t0, zero, end_str_len
addi t1, t1, 1
j loop_str_len

end_str_len:
addi a0, t1, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra

check_char_in_string: # a0 stringa, a1 char -> a0 boolean (char in stringa) (0 f, 1 t)
# Registri: a0, a1, t0, t1, t2
addi sp, sp, -4
sw ra, 0(sp)
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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

mult: # a0 x, a1 y -> a0 (x*y)
# Registri: a0, a1, t0, t1
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0
li t1, 0
loop_mult:
bge t0, a1, fine_loop_mult
add t1, t1, a0
addi t0, t0, 1
j loop_mult

fine_loop_mult:
add a0, t1, zero
lw ra, 0(sp)
addi sp, sp, 4
jr ra 

#####
## (cesare.s)

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

#####
## (blocchi.s)

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
addi sp, sp, 4

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
sw a0, 0(sp) # push a0

addi a0, a1, 0
jal str_len
addi t1, a0, 0 # len key

lw a0, 0(sp) # pop a0
addi sp, sp, 4

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

#####
## (occorrenze.s)

occorrenze_cyper: # a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> a0 cyper_text (ptr) (in place)
# Registri: a0, a1, a2, t0
addi sp, sp, -4
sw ra, 0(sp)
li t0, 45 # codice ascii '-'
#li a2, 4000 # ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza
la a2, prova

addi sp, sp, -20
sw a1, 16(sp) # push a1
sw a2, 12(sp) # push a2
sw t0, 8(sp) # push t0
sw t1, 4(sp) # push t1
sw t2, 0(sp) # push t2

addi a1, a2, 0
jal trova_occorrenze_caratteri

lw t2, 0(sp) # pop t2
lw t1, 4(sp) # pop t1
lw t0, 8(sp) # pop t0
lw a2, 12(sp) # pop a2
lw a1, 16(sp) # pop a1
addi sp, sp, 20

# TODO Costruire la stringa cypher facendo un doppio for 
# (esterno caratteri univoci, interno per trovare la posizione di quei caratteri)
# attenzione a stampare nella stringa la posizione con due cifre come due caratteri separati

addi a0, a1, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra

occorrenze_decyper: # a0 stringa in chiaro (dest) (ptr), a1 cyper_text (source) (ptr) -> a0 stringa in chiaro (ptr) (in place)
# Registri:
addi sp, sp, -4
sw ra, 0(sp)

# TODO

lw ra, 0(sp)
addi sp, sp, 4
jr ra

trova_occorrenze_caratteri: # a0 stringa, a1, appoggio -> (in place)
# Registri: a0, a1, a2, t0, t1, t2
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0 # indice for stringa
li t1, 0 # indice array di appoggio (numero di caratteri univoci presenti nella stringa)

loop_occorrenze_cyper:
add a2, a0, t0
lb a2, 0(a2) # a2 = stringa[t0]
beq a2, zero, end_loop_occorrenze_cyper # (while stringa[t0] != 0)

addi sp, sp, -16
sw a0, 12(sp) # push a0
sw a1, 8(sp) # push a1
sw t0, 4(sp) # push t0
sw t1, 0(sp) # push t1

addi a0, a1, 0
addi a1, a2, 0
jal check_char_in_string
addi t2, a0, 0

lw t1, 0(sp) # pop t1
lw t0, 4(sp) # pop t0
lw a1, 8(sp) # pop a1
lw a0, 12(sp) # pop a0
addi sp, sp, 16

bgt t2, zero, continue_loop
add t2, a1, t1
sb a2, 0(t2)
addi t1, t1, 1

continue_loop:
addi t0, t0, 1
j loop_occorrenze_cyper

end_loop_occorrenze_cyper:
add t2, a1, t1
sb zero, 0(t2)
lw ra, 0(sp)
addi sp, sp, 4
jr ra

### END HEADERS ###

main:
la a0, plain_text
lw a1, Cyper_occorrenze

jal occorrenze_cyper
#jal blocchi_decrypt

li a7, 4 # stampa stringa
ecall
