.data
new_line: .string "\n"
.text

modulo:
#! a0 a1
#! manage_ra 
# a0 x, a1 n -> a0 (x%n)

# sommo n ad x finchè x non è maggiore di zero
# e poi restituisco come risultato il resto della divisione x/n, ovvero x%n

loop_modulo_1:
bge a0, zero, continue_modulo
add a0, a0, a1
j loop_modulo_1

continue_modulo:
rem a0, a0, a1 # resto divisione x/n

end_modulo:
#! end

str_len:
#! a0 t0 t1 t2
#! manage_ra
# a0 stringa (ptr) -> a0 len

# scorro la stringa finchè non trovo il terminatore (0)
# e conto i singoli caratteri (tramite l'indice)

li t1, 0 # indice (e contatore)

loop_str_len:
add t2, a0, t1
lb t0, 0(t2)
beq t0, zero, end_str_len
addi t1, t1, 1
j loop_str_len

end_str_len:
addi a0, t1, 0
#! end

check_char_in_string:
#! a0 a1 t0 t1 t2
#! manage_ra

# a0 stringa, a1 char -> a0 boolean (char in stringa) (0 f, 1 t)

# scorro la stringa e termino, restituendo il valore 1, quando trovo che il carattere corrente è uguale a quello cercato
# altrimenti restituisco 0

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

conta_cifre: 
#! a0 a1 t0 t1 t2
#! manage_ra

# a0 numero -> a0 k cifre
# controllo se il numero in input sia più piccolo della base, in tal caso restituisco il contatore
# altrimenti moltiplico per 10 (utilizzando degli shift al posto dell'istruzione mul) e incremento il contatore

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

str_copy:
#! a0 a1 t0 t1 t2
#! manage_ra

# a0 ptr (dest), a1 ptr (sorg) -> (in_place)

# effettuo una copia della stringa sorgente (a1) in quella destinazione (a0)
# scorro la stringa sorgente (nb mi basta un solo indice) e copio di volta in volta i caratteri nella stringa destinazione

li t0, 0 # indice che scorre la stringa sorgente

loop_str_copy:
add t1, a1, t0
lb t1, 0(t1) # t1 = sorg[t0]
beq t1, zero, end_str_copy

add t2, t0, a0 # posizione finale
sb t1, 0(t2)

addi t0, t0, 1
j loop_str_copy

end_str_copy:
add t2, a0, t0
sb t1, 0(t2) # inserisco lo 0 in fondo alla stringa dest a0
#! end

stampa_new_line:
#! 
#! manage_ra

# procedura che stampa semplicemente un carattere new_line

addi sp, sp, -8
sw a0, 4(sp)
sw a7, 0(sp)

la a0, new_line
li a7, 4
ecall

lw a7, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
#! end

delete_string:
#! a0 t0 t1
#! manage_ra

# a0 stringa -> (in_place)

# pone a 0 tutti i caratteri della stringa

li t0, 0 # indice

loop_delete_string:
add t1, a0, t0
lb t1, 0(t1)
beq t1, zero, end_delete_string
add t1, a0, t0
sb zero, 0(t1)

addi t0, t0, 1
j loop_delete_string
end_delete_string:
#! end
