.data
Cypher_occorrenze: .word 25000
app_occorrenze: .word 20000
.text
# a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> (in_place)
occorrenze_crypt: 
#! a0 a1 a2 a3 a4 t0 t1 t2 t3 t4 t5
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

#! precall(conta_cifre)
addi a0, t3, 0
jal conta_cifre
addi t2, a0, 0 # numero di cifre di t3 (pos del carattere)
#! postcall(conta_cifre)

addi sp, sp, -8
sw t3, 4(sp)
sw t2, 0(sp)

loop_posizione_modulo:
beq t2, zero, end_loop_posizione_modulo

#! precall(modulo)
addi a0, t3, 0
li a1, 10
jal modulo
addi t0, a0, 0 # t0 = ultima cifra
#! postcall(modulo)

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


# scorrere il cypher text dalla fine verso l'inizio
# quando si trova un numero lo si mette da parte e si moltiplica per 1 (la prima volta)
# poi si moltiplica l'1 per 10 e il successivo numero lo si moltiplica per 10 e si somma al precedente
# continuare così finchè non si trova un -, in tal caso si pusha sulla stack il numero completo e si incrementa un contatore
# prosegue fino a quando il carattere successivo è uno spazio, in tal caso il carattere attuale è il carattere da posizionare nella stringa in chiaro
# si esegue un for per le volte del contatore, ogni volta si fa il pop dalla stack e si mette il carattere nella posizione a0[pop()]
# finisce il ciclo esterno quando l'indirizzo attuale è l'indirizzo iniziale
# a0 stringa in chiaro (dest) (ptr), a1 cyper_text (source) (ptr) -> (in_place)
occorrenze_decrypt: 
#! a0 a1 a2 a3 a4 a5 t0 t1 t2 t3 t4
#! manage_ra
li t4, 0 # contatore di quanti numeri ho pushato nella stack
li a5, 1

#! precall(str_len)
addi a0, a1, 0
jal str_len
addi a2, a0, 0
#! postcall(str_len)

add a2, a1, a2 # a2 contiene l'indirizzo dell'ultimo carattere del cypher_text
addi a2, a2, -1 # altrimenti comincerebbe dallo 0
addi a1, a1, 1 # così il ciclo sotto si ferma al punto giusto

loop_occorrenze_decrypt:
blt a2, a1, fine_occorrenze_decrypt # ciclo finchè la posizione a sinistra fa parte della stringa
lb a3, 0(a2) # a3 carattere corrente
lb t0, 1(a2) # carattere a destra
lb t1, -1(a2) # carattere a sinistra

li t2, 45 # ascii '-'
li t3, 32 # ascii 'space'
bne t1, t3, pass_occorrenze_decrypt
bne t0, t2, pass_occorrenze_decrypt
# se entro qui significa che ho trovato un carattere 
# e devo inserirlo nella stringa in chiaro
# per farlo fai un ciclo che parte da t4 e finisce a zero
loop_inserimento_numeri_occorrenze:
beq t4, zero, end_inserimento_numeri_occorrenze

lw t2, 0(sp) # pop del numero
addi sp, sp, 4

add t2, t2, a0 # t2 posizione in cui mettere il carattere a3
sb a3, 0(t2)

addi t4, t4, -1
j loop_inserimento_numeri_occorrenze

end_inserimento_numeri_occorrenze:
addi a2, a2, -1 # scorro un carattere in più per saltare lo spazio nel mezzo alle codifiche
j incr_loop_occorrenze_decrypt

pass_occorrenze_decrypt:
beq a3, t2, push_numero_stack_occorrenze # se trovo un '-' devo pushare il numero (a4) nella stack

addi a3, a3, -48 # riconverto la cifra in ascii a decimale

#! precall(mult)
addi a0, a3, 0 # cifra
addi a1, a5, 0 # 1/10/100/...
jal mult
addi t2, a0, 0
#! postcall(mult)

add a4, a4, t2 # incremento la somma parziale

#! precall(mult)
li a0, 10
addi a1, a5, 0 # 1/10/100/...
jal mult # moltiplico per 10 il fattore parziale che moltiplica le cifre
addi a5, a0, 0
#! postcall(mult)

j incr_loop_occorrenze_decrypt

push_numero_stack_occorrenze:
addi sp, sp, -4
sw a4, 0(sp)
addi t4, t4, 1 # incremento il contatore dei numeri nella stack
li a5, 1 # a5 è il valore con cui moltiplico la cifra attuale dei numeri
li a4, 0 # a4 è la somma parziale del numero

incr_loop_occorrenze_decrypt:
addi a2, a2, -1
j loop_occorrenze_decrypt

fine_occorrenze_decrypt:
#! end

# a0 stringa, a1, appoggio -> (in place)
trova_occorrenze_caratteri:
#! a0 a1 a2 t0 t1 t2 t3
#! manage_ra
li t0, 0 # indice for stringa
li t1, 0 # indice array di appoggio (numero di caratteri univoci presenti nella stringa)

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