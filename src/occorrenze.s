#!header
#define procedures.s

occorrenze_crypt: # a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> a0 cyper_text (ptr) (in place)
# Registri: a0, a1, a2, t0
#! push_ra
li a2, 20000 # ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza

addi sp, sp, -12
sw a1, 8(sp) # push a1
sw a2, 4(sp) # push a2
sw t0, 0(sp) # push t0

addi a1, a2, 0
jal trova_occorrenze_caratteri

lw t0, 0(sp) # pop t0
lw a2, 4(sp) # pop a2
lw a1, 8(sp) # pop a1
addi sp, sp, 12

li t1, 0 # indice for caratteri_univoci
li t5, 0 # indice cypher_text
for_esterno:
add t2, a2, t1
lb a3, 0(t2) # a3 = caratteri_univoci[t1]
beq a3, zero, end_for_esterno

add t2, a1, t5
sb a3, 0(t2) # inserisco nel cypher text il carattere corrente
addi t5, t5, 1

li t3, 0 # indice for_interno (ovvero la posizione nella stringa in chiaro)
for_interno:
add t4, a0, t3
lb a4, 0(t4) # a4 = stringa_in_chiaro[t3]
beq a4, zero, end_for_interno
bne a4, a3, continue_for_interno

add t2, a1, t5
li t0, 45 # codice ascii '-'
sb t0, 0(t2) # inserisco -

addi sp, sp, -16
sw a0, 12(sp) # push a0
sw a1, 8(sp) # push a1
sw t0, 4(sp) # push t0
sw t1, 0(sp) # push t1

addi a0, t3, 0
jal conta_cifre
addi t2, a0, 0 # numero di cifre di t3 (pos del carattere)

lw t1, 0(sp)
lw t0, 4(sp)
lw a1, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16

addi sp, sp, -8
sw t3, 4(sp)
sw t2, 0(sp)

loop_posizione_modulo:
beq t2, zero, end_loop_posizione_modulo

addi sp, sp, -8
sw a0, 4(sp) # push a0
sw a1, 0(sp) # push a1

addi a0, t3, 0
li a1, 10

jal modulo
addi t0, a0, 0 # t0 = ultima cifra

lw a1, 0(sp) # pop a1
lw a0, 4(sp) # pop a0
addi sp, sp, 8

sub t3, t3, t0 # sottraggo l'ultima cifra
li t4, 10
divu t3, t3, t4 # divido per 10

add t4, a1, t5
add t4, t4, t2
addi t0, t0, 48 # normalizzazione tabella ascii cifre
sb t0, 0(t4)

addi t2, t2, -1
j loop_posizione_modulo

end_loop_posizione_modulo:
lw t2, 0(sp)
lw t3, 4(sp)
addi sp, sp, 8

addi t2, t2, 1
add t5, t5, t2

continue_for_interno:
addi t3, t3, 1
j for_interno
end_for_interno:
li t0, 32 # ascii for space
addi t5, t5, 1
add t4, a1, t5
sb t0, 0(t4)

addi t1, t1, 1
j for_esterno
end_for_esterno:

li t0, 0 
addi t5, t5, 1
add t4, a1, t5
sb t0, 0(t4)

addi a0, a1, 0
#! pop_ra
jr ra


occorrenze_decrypt: # a0 stringa in chiaro (dest) (ptr), a1 cyper_text (source) (ptr) -> a0 stringa in chiaro (ptr) (in place)
# Registri:
#! push_ra

# TODO

#! pop_ra
jr ra

trova_occorrenze_caratteri: # a0 stringa, a1, appoggio -> (in place)
# Registri: a0, a1, a2, t0, t1, t2
#! push_ra
li t0, 0 # indice for stringa
li t1, 0 # indice array di appoggio (numero di caratteri univoci presenti nella stringa)

loop_occorrenze_crypt:
add a2, a0, t0
lb a2, 0(a2) # a2 = stringa[t0]
beq a2, zero, end_loop_occorrenze_crypt # (while stringa[t0] != 0)

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
j loop_occorrenze_crypt

end_loop_occorrenze_crypt:
add t2, a1, t1
sb zero, 0(t2)
#! pop_ra
jr ra