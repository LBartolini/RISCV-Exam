.data
Cypher_occorrenze: .word 25000
app_occorrenze: .word 20000
.text
# a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> (in_place)
occorrenze_crypt: 
#! a0 a1 a2 a3 a4 t0 t1 t2 t3 t4 t5 t6
#! manage_ra
lw a2, app_occorrenze # ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza

#! precall(trova_occorrenze_caratteri)
addi a1, a2, 0
jal trova_occorrenze_caratteri
#! postcall(trova_occorrenze_caratteri)

li t0, 32 # space
sb t0, 0(a1)

li t1, 0 # indice for caratteri_univoci
li t5, 1 # indice cypher_text
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
addi t3, t3, 1 # per evitare l'errore della posizione zero
sb t3, 1(t2) # inserisco la posizione del carattere come numero puro
addi t5, t5, 2 

continue_for_interno:
addi t3, t3, 1
j for_interno
end_for_interno:
li t0, 32 # ascii for space
add t4, a1, t5
sb t0, 0(t4)
addi t5, t5, 1

addi t1, t1, 1
j for_esterno
end_for_esterno:

li t0, 0
addi t5, t5, -1
add t4, a1, t5
sb t0, 0(t4)
#! end


# a0 stringa in chiaro (dest) (ptr), a1 cypher_text (source) (ptr) -> (in_place)
occorrenze_decrypt: 
#! a0 a1 a2 a3 a4 a5 t0 t1 t2 t3
#! manage_ra
li a2, 2 # indice cypher_text
lb a3, 0(a1) # a3 contiene il carattere corrente (all'inizio il primo carattere)
li a4, 32 # ascii for 'space'

loop_occorrenze_decrypt:
add t0, a1, a2
lb t1, 0(t0) # t1 carattere corrente del cypher_text
lb t2, 1(t0) # t2 carattere successivo, usato per terminare il ciclo
lb t3, -1(t0) # t3 carattere precedente, usato per controllare se cambia il carattere corrente
beq t2, zero, fine_occorrenze_decrypt
beq t3, a4, nuovo_carattere_corrente

addi t1, t1, -1 # per fare pari con il +1 durante il crypt
add a5, a0, t1
sb a3, 0(a5)

j incr_loop_occorrenze_decrypt

nuovo_carattere_corrente:
addi a3, t3, 0

incr_loop_occorrenze_decrypt:
addi a2, a2, 2
j loop_occorrenze_decrypt

fine_occorrenze_decrypt:
#! end

# a0 stringa, a1 appoggio -> (in place)
trova_occorrenze_caratteri:
#! a0 a1 a2 t0 t1 t2 t3
#! manage_ra
li t0, 2 # indice for stringa
li t1, 0 # indice array di appoggio (numero di caratteri univoci presenti nella stringa)

lb t2, 1(a0) # carico in t2 il carattere in posizione 1
sb t2, 0(a1) # lo inserisco in prima posizione dell'appoggio
addi t1, t1, 1

lb t3, 0(a0) # carico in t3 il carattere in pos 0
beq t2, t3, loop_occorrenze_crypt # se è uguale a quello in posizione 0 allora salto al ciclo
sb t3, 1(a1) # altrimenti lo salvo in posizione 1 dell'appoggio
addi t1, t1, 1

loop_occorrenze_crypt:
add a2, a0, t0
lb a2, 0(a2) # a2 = stringa[t0]
beq a2, zero, end_loop_occorrenze_crypt # (while stringa[t0] != 0)

#! precall(check_char_in_string)
addi a0, a1, 0
addi a1, a2, 0
jal check_char_in_string
addi t3, a0, 0
#! postcall(check_char_in_string)

bgt t3, zero, continue_loop
add t3, a1, t1
sb a2, 0(t3)
addi t1, t1, 1

continue_loop:
addi t0, t0, 1
j loop_occorrenze_crypt

end_loop_occorrenze_crypt:
add t2, a1, t1
sb zero, 0(t2)
#! end