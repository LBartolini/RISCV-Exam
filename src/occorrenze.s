#!header
#define procedures.s

occorrenze_cyper: # a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> a0 cyper_text (ptr) (in place)
# Registri: a0, a1, a2, t0
#! push_ra
li t0, 45 # codice ascii '-'
li a2, 4000 # ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza

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
#! pop_ra
jr ra


occorrenze_decyper: # a0 stringa in chiaro (dest) (ptr), a1 cyper_text (source) (ptr) -> a0 stringa in chiaro (ptr) (in place)
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
#! pop_ra
jr ra