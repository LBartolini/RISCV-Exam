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

# inserisco come primo carattere uno spazio
# questo mi servirà per semplificare il codice per la fase di decifrazione
li t0, 32 # space
sb t0, 0(a5)

li t1, 0 # indice for caratteri_univoci
li t5, 1 # indice cypher_text (destinazione)
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
#! a0 a1 a2 a3 a4 a5 a6 t0 t1 t2 t3 t4 t6 t7
#! manage_ra
# a0 stringa_in_chiaro (dest) (ptr), a1 cyper_text (source) (ptr) -> (in_place su stringa_in_chiaro) (restituisce in a0 <- a0)

# scorrere il cypher text dalla fine verso l'inizio
# quando si trova un numero lo si mette da parte e si moltiplica per 1 (la prima volta)
# poi si moltiplica l'1 per 10 e il successivo numero lo si moltiplica per 10 e si somma al precedente
# continuare così finchè non si trova un -, in tal caso si effettua il push sulla stack del numero completo e si 
# incrementa un contatore che terrà traccia di quanti numeri ho inserito nella stack
# si prosegue fino a quando il carattere successivo è uno spazio, in tal caso il carattere 
# attuale è il carattere da posizionare nella stringa in chiaro
# si esegue un ciclo per quanti numeri sono nella stack, ogni volta si fa il pop e si inserisce il carattere nella posizione a0[pop()]
# finisce il ciclo esterno quando l'indirizzo attuale è l'indirizzo iniziale

li t4, 0 # contatore di quanti numeri ho inserito nella stack
li a5, 1 # moltiplicatore della posizione della cifra (1, 10, 100, ...)
li a4, 0 # appoggio temporaneo in cui calcolo la somma delle singole cifre che incontro
li t6, 0 # caratteri inseriti nella stringa_in_chiaro
lw a6, app_occorrenze # appoggio dove lavorare durante il decrypt, alla fine verrà copiato in a0

# calcolo la lunghezza della stringa a1 così da poter scorrerla dalla fine all'inizio
#! precall(str_len)
addi a0, a1, 0
jal str_len
addi a2, a0, 0
#! postcall(str_len)

add a2, a1, a2 # a2 contiene l'indirizzo dell'ultimo carattere del cypher_text
addi a2, a2, -1 # (altrimenti comincerebbe dallo 0 in fondo alla stringa)
addi a1, a1, 1 # incremento l'indirizzo del cypher_text così il ciclo si ferma al punto giusto

# per capire quando terminare il ciclo e soprattutto per capire quando termina la serie di posizioni relative ad un carattere
# vengono usati tre caratteri adiacenti contemporaneamente
loop_occorrenze_decrypt:
blt a2, a1, fine_occorrenze_decrypt # ciclo finchè la posizione a sinistra fa parte della stringa
lb a3, 0(a2) # a3 carattere corrente
lb t0, 1(a2) # carattere a destra
lb t1, -1(a2) # carattere a sinistra

li t2, 45 # ascii '-'
li t3, 32 # ascii 'space'
# se il carattere a sinistra non è uno spazio o quello a destra non è un '-' allora continuo all'interno del ciclo
bne t1, t3, pass_occorrenze_decrypt
bne t0, t2, pass_occorrenze_decrypt

# se entro qui significa che ho trovato un carattere all'interno del cypher_text
# e devo inserirlo nella stringa in chiaro
# per farlo faccio un ciclo che parte da t4(contatore dei numeri nella stack) e finisce a zero
loop_inserimento_numeri_occorrenze:
beq t4, zero, end_inserimento_numeri_occorrenze

lw t2, 0(sp) # pop del numero
addi sp, sp, 4

add t2, t2, a6 # t2 posizione in cui mettere il carattere a3
sb a3, 0(t2)
addi t6, t6, 1 # incremento l'indice che scorre la stringa di destinazione

addi t4, t4, -1
j loop_inserimento_numeri_occorrenze

end_inserimento_numeri_occorrenze:
addi a2, a2, -1 # scorro un carattere in più per saltare lo spazio nel mezzo alle codifiche
j incr_loop_occorrenze_decrypt

pass_occorrenze_decrypt:
# se il carattere corrente è un '-' (t2) devo pushare il numero (a4) nella stack
# altrimenti significa che è una cifra e devo moltiplicarla e sommarla alla somma parziale
beq a3, t2, push_numero_stack_occorrenze 

addi a3, a3, -48 # riconverto la cifra da ascii a decimale

mul t2, a3, a5 # moltiplico per la sua posizione all'interno del numero finale

add a4, a4, t2 # aggiungo alla somma parziale

li a7, 10
mul a5, a5, a7

j incr_loop_occorrenze_decrypt

push_numero_stack_occorrenze:
addi sp, sp, -4
sw a4, 0(sp)
addi t4, t4, 1 # incremento il contatore dei numeri nella stack
li a5, 1 # resetto a5 (valore con cui moltiplico la cifra attuale dei numeri)
li a4, 0 # resetto a4 (somma parziale del numero)

incr_loop_occorrenze_decrypt:
addi a2, a2, -1
j loop_occorrenze_decrypt

fine_occorrenze_decrypt:
add t0, a6, t6
sb zero, 0(t0) # inserisco 0 in fondo alla stringa_in_chiaro

# copio il vettore temporaneo che ho usato durante l'algoritmo nella stringa di destinazione (a0)
addi a1, a6, 0
jal str_copy 
#! end

trova_occorrenze_caratteri:
#! a0 a1 a2 t0 t1 t2 t3
#! manage_ra

# a0 stringa, a1 appoggio -> (in place)

# scorro la stringa a0 e per ogni carattere controllo che non sia in a1 altrimenti ce lo inserisco
# i primi due caratteri della stringa li inserisco a mano all'interno di a1 nell'ordine specificato dalla specifica
# ovvero il primo carattere di a1 deve essere il secondo della stringa da cifrare
# NB: questa procedura funziona sotto l'ipotesi iniziale che la variabile myplaintext contenga almeno due caratteri

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