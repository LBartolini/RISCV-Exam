.data
app_occorrenze: .word 200000
app_2_occorrenze: .word 500000
.text

occorrenze_crypt: 
#! a0 a1 a2 a3 a4 a5 t0 t1 t2 t3 t4 t5 t6
#! manage_ra
# a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> (in_place su cypher_text) (restituisce in a0 <- a1)

# inizialmente scorro la stringa (a0) e salvo i caratteri che vi compaiono
# dopodichè scorro la lista dei caratteri univoci che compaiono nella stringa
# e per ogni carattere scorro nuovamente la stringa in chiaro
# e ogni volta che trovo il carattere attuale vado a scomporre il numero che identifica
# la posizione in cifre e le salvo nella stringa di return come caratteri ascii

lw a2, app_occorrenze # ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza
# secondo array di appoggio in cui lavoro per non corrompere la stringa in chiaro
# alla fine dell'algoritmo copierò tutti gli elementi da questo vettore (a5) in quello di destinazione (a1)
# NB: nei commenti all'interno dei due cicli for, il vettore cypher_text è in realtà il vettore di appoggio
# che però svolge il ruolo logico di cypher_text
lw a5, app_2_occorrenze

# memorizzo i caratteri che compaiono nella stringa in chiaro
#! precall(trova_occorrenze_caratteri)
addi a1, a2, 0
jal trova_occorrenze_caratteri
#! postcall(trova_occorrenze_caratteri)

li t1, 0 # indice for caratteri_univoci
li t5, 0 # indice cypher_text (destinazione)
for_esterno: # scorre i caratteri univoci
add t2, a2, t1
lb a3, 0(t2) # a3 = caratteri_univoci[t1]
beq a3, zero, end_for_esterno

add t2, a5, t5
sb a3, 0(t2) # inserisco nel cypher text il carattere corrente
addi t5, t5, 1

li t3, 0 # indice for_interno (ovvero la posizione nella stringa in chiaro)
for_interno: # scorre la stringa in chiaro
add t4, a0, t3
lb a4, 0(t4) # a4 = stringa_in_chiaro[t3]
beq a4, zero, end_for_interno
# se il carattere corrente non è quello cercato vado al prossimo carattere
bne a4, a3, continue_for_interno 

# se arrivo qui è perchè il carattere corrente è il carattere che cerco
# perciò per prima cosa inserisco nella destinazione il carattere '-' come separatore
add t2, a5, t5
li t0, 45 # codice ascii '-'
sb t0, 0(t2) # inserisco -

# conto le cifre della posizone a cui si trova il carattere
# successivamente eseguirò un ciclo a partire da k posizioni in più rispetto alla posizione attuale nel cypher_text
# in cui inserisco ogni cifra della posizione a partire dalle unità poi decine etc etc
# una volta finito il ciclo, l'indice del cypher_text viene posizionato al byte 
# successivo alla cifra delle unità nel cypher_text

#! precall(conta_cifre)
addi a0, t3, 0
jal conta_cifre
addi t6, a0, 0 # numero di cifre di t3 (pos del carattere)
#! postcall(conta_cifre)

# inserisco nella stack per preservarne il valore perchè questi registri verranno modificati sotto
addi sp, sp, -8
sw t3, 4(sp) # indice for interno
sw t6, 0(sp) # cifre di t3

# ciclo che inserisce le singole cifre nella destinazione
loop_posizione_modulo:
beq t6, zero, end_loop_posizione_modulo

# calcolo l'ultima cifra eseguendo il modulo 10
#! precall(modulo)
addi a0, t3, 0
li a1, 10
jal modulo
addi t0, a0, 0 # t0 = ultima cifra
#! postcall(modulo)

li t4, 10
divu t3, t3, t4 # divido per 10

add t4, a5, t5
add t4, t4, t6 # calcolo la posizione corretta in cui effettuare la store
# t4 = dest + indice_dest + posizione_della_cifra
# se la posizione fosse 45, la prima volta t4 = dest + indice_dest + 1(seconda posizione)
# mentre la seconda volta sarebbe t4 = dest + indice_dest + 0(prima posizione)
addi t0, t0, 48 # normalizzazione tabella ascii per le cifre
sb t0, 0(t4)

addi t6, t6, -1
j loop_posizione_modulo

end_loop_posizione_modulo:
lw t2, 0(sp)
lw t3, 4(sp)
addi sp, sp, 8

add t5, t5, t2 # scorro l'indice del cypher_text del numero di cifre del numero appena scomposto
addi t5, t5, 1 # vado alla posizione successiva che è la prima cella libera

continue_for_interno:
addi t3, t3, 1
j for_interno
end_for_interno:
# arrivo qui nel momento in cui ho terminato la scansione ricercando un carattere
# per cui inserisco uno spazio nella destinazione e procedo con la ricerca del successivo carattere
li t0, 32 # ascii for space
add t4, a5, t5
sb t0, 0(t4)
addi t5, t5, 1

addi t1, t1, 1
j for_esterno
end_for_esterno:

li t0, 0
addi t5, t5, -1
add t4, a5, t5
sb t0, 0(t4) # salvo il terminatore di stringa nel vettore di appoggio a5

# copio l'intero vettore in a1 (cypher_text)
#! precall(str_copy)
addi a0, a1, 0
addi a1, a5, 0
jal str_copy
#! postcall(str_copy)

# sovrascrivo ogni cella del vettore che contiene i caratteri univoci
# per prepararlo nel caso venga utilizzato nuovamente l'algoritmo a occorrenze
#! precall(delete_string)
addi a0, a2, 0
jal delete_string
#! postcall(delete_string)

addi a0, a1, 0
#! end


occorrenze_decrypt: 
#! a0 a1 a2 a3 a4 a5 t0 t1 t2 t3 t4
#! manage_ra
# a0 stringa_in_chiaro (dest) (ptr), a1 cypher_text (source) (ptr) -> (in_place su stringa_in_chiaro) (restituisce in a0 <- a0)

# scorro la stringa partendo dalla posizione 2 (preventivamente salvo il primo carattere)
# ogni volta che incontro una cifra la aggiungo alla somma parziale e quando trovo un '-', uno spazio o la fine della stringa
# salvo nella destinazione il carattere attuale
# se avevo trovato un '-' proseguo con il numero successivo
# se avevo trovato uno spazio modifico il carattere attuale e proseguo
# se infine avevo terminato la stringa finisco la procedura

li a2, 2 # indice che scorre la stringa da decifrare (inizializzato a 2 perchè in posizione 0 e 1 ci sono rispettivamente il carattere e '-')
li a3, 0 # somma parziale
lw a4, app_occorrenze # appoggio dove lavorare durante il decrypt, alla fine verrà copiato in a0
lb a5, 0(a1) # a5 indica il carattere da scrivere attuale (inizializzato al primo carattere della stringa da decifrare)
li t4, 0 # contatore dei caratteri inseriti a destinazione

loop_occorrenze_decrypt:
add t0, a1, a2
lb t1, 0(t0) # t1 = cypher_text[a2] ovvero il carattere corrente


li t2, 45 # ascii '-'
li t3, 32 # ascii 'space'
# se il carattere corrente è un '-' oppure ' ' (spazio) allora inserisco nella stringa in chiaro il carattere corrente 
# e, nel caso dello spazio, passo al carattere successivo
beq t1, t2, scrivi_carattere_occorrenze
beq t1, t3, scrivi_carattere_occorrenze
beq t1, zero, scrivi_carattere_occorrenze 

# se arrivo qui significa che ho trovato un numero e devo sommarlo alla somma parziale
li t2, 10
mul a3, a3, t2 # moltiplico per 10 la somma parziale e successivamente sommo il numero appena trovato

addi t1, t1, -48 # normalizzazione ascii
add a3, a3, t1

j incr_loop_occorrenze_decrypt

scrivi_carattere_occorrenze:
# se il carattere corrente è un '-' (t2) scrivo semplicemente nella stringa in chiaro
# altrimenti significa che è uno spazio quindi devo scrivere il numero nella stringa in chiaro e aggiornare il valore del carattere corrente

add t0, a4, a3
sb a5, 0(t0) # a4[a3] = a5, scrivo nella posizione corretta il carattere da scrivere attuale 
li a3, 0 # reset della somma parziale
addi t4, t4, 1

beq t1, t2, incr_loop_occorrenze_decrypt # se sono arrivato qui per un '-' allora passo all'incremento
beq t1, zero, fine_occorrenze_decrypt # se sono arrivato qui perchè era l'ultimo carattere della stringa allora finisco l'algoritmo
# altrimenti aggiorno il carattere attuale e incremento a mano
add t0, a1, a2
lb a5, 1(t0) # carattere successivo allo spazio
addi a2, a2, 2 # incrementanto di 2 adesso (e successivamente di 1) punterà al primo numero del carattere attuale successivo

incr_loop_occorrenze_decrypt:
addi a2, a2, 1
j loop_occorrenze_decrypt

fine_occorrenze_decrypt:
add t0, a4, t4
sb zero, 0(t0) # inserisco 0 in fondo alla stringa_in_chiaro

# copio il vettore temporaneo che ho usato durante l'algoritmo nella stringa di destinazione (a0)
addi a1, a4, 0
jal str_copy 
#! end

trova_occorrenze_caratteri:
#! a0 a1 a2 t0 t1 t2 t3
#! manage_ra

# a0 stringa, a1 appoggio -> (in place)

# per prima cosa controllo se la stringa ha un solo carattere e gestisco quel caso a parte altrimenti
# scorro la stringa a0 e per ogni carattere controllo che non sia in a1 altrimenti ce lo inserisco
# i primi due caratteri della stringa li inserisco a mano all'interno di a1 nell'ordine specificato dalla specifica
# ovvero il primo carattere di a1 deve essere il secondo della stringa da cifrare

lb t2, 1(a0)
bne t2, zero, check_trova_occorrenze_caratteri 
# se arrivo qui è perchè il secondo carattere della stringa è '0' ciò significa che la stringa ha un solo carattere 
# perciò devo inserirlo in posizione zero e terminare la procedura
lb t2, 0(a0)
sb t2, 0(a1)
li t1, 1
j end_loop_occorrenze_crypt

check_trova_occorrenze_caratteri:
li t0, 2 # indice for stringa
li t1, 0 # indice array di appoggio (numero di caratteri univoci presenti nella stringa)

lb t2, 1(a0) # carico in t2 il carattere in posizione 1
sb t2, 0(a1) # lo inserisco in prima posizione dell'appoggio
addi t1, t1, 1

lb t3, 0(a0) # carico in t3 il carattere in pos 0
beq t2, t3, loop_occorrenze_crypt # se è uguale a quello in posizione 0 allora salto al ciclo
sb t3, 1(a1) # altrimenti lo salvo in posizione 1 dell'appoggio
addi t1, t1, 1

# il ciclo comincia dalla terza posizione e termina quando finisce la stringa a0
loop_occorrenze_crypt:
add a2, a0, t0
lb a2, 0(a2) # a2 = stringa[t0]
beq a2, zero, end_loop_occorrenze_crypt # (while stringa[t0] != 0)

# chiamo la procedura che controlla se il carattere corrente è all'interno della stringa a1
# ritorna: 0 se non è presente, 1 se è presente
#! precall(check_char_in_string)
addi a0, a1, 0
addi a1, a2, 0
jal check_char_in_string
addi t3, a0, 0
#! postcall(check_char_in_string)

bgt t3, zero, continue_loop
add t3, a1, t1 # se non è presente in a1 ce lo inserisco
sb a2, 0(t3)
addi t1, t1, 1

continue_loop:
addi t0, t0, 1
j loop_occorrenze_crypt

end_loop_occorrenze_crypt:
add t2, a1, t1
sb zero, 0(t2) # aggiungo 0 in fondo alla stringa di appoggio
#! end