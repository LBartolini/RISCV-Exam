.data
myplaintext: .string "Test Completo"
mycypher: .string "ABCDE"
working_place: .word 800000
_originale: .string "Originale: "
_decifrato: .string "Decifrato: "
_cifrato_usando: .string "Cifrato usando: "
_decifrato_usando: .string "Decifrato usando: "
_alg_a_cesare: .string "Algoritmo di Cesare (A)"
_alg_b_blocchi: .string "Algoritmo a Blocchi (B)"
_alg_c_occorrenze: .string "Algoritmo a Occorrenze (C)"
_alg_d_dizionario: .string "Algoritmo a Dizionario (D)"
_alg_e_inversione: .string "Algoritmo a Inversione (E)"
new_line: .word 10
sostK: .word 1
blocKey: .string "abc"
app_occorrenze: .word 200000
app_2_occorrenze: .word 500000
.text
j main
modulo:
addi sp, sp, -4
sw ra, 0(sp)
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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

str_len:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa (ptr) -> a0 len

# scorro la stringa finchè non trovo il terminatore (0)
# e conto i singoli caratteri (tramite l'indice)

li t1, 0 # indice

loop_str_len:
add t0, a0, t1
lb t0, 0(t0)
beq t0, zero, end_str_len
addi t1, t1, 1
j loop_str_len

end_str_len:
addi a0, t1, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra

check_char_in_string:
addi sp, sp, -4
sw ra, 0(sp)

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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

conta_cifre:
addi sp, sp, -4
sw ra, 0(sp)

# a0 numero -> a0 k cifre
# controllo se il numero in input sia più piccolo della base, in tal caso restituisco il contatore
# altrimenti moltiplico per 10 e incremento il contatore

li t0, 1 # contatore delle cifre
li t1, 10 # valore costante dieci
li a1, 10 # base

loop_conta_cifre:
blt a0, a1, end_loop_conta_cifre

mul a1, a1, t1 # a1 *= 10

addi t0, t0, 1
j loop_conta_cifre
end_loop_conta_cifre:

addi a0, t0, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra

str_copy:
addi sp, sp, -4
sw ra, 0(sp)

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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

stampa_new_line:
addi sp, sp, -4
sw ra, 0(sp)

# procedura che stampa semplicemente un carattere new_line

add a0, s5, zero
li a7, 11
ecall

lw ra, 0(sp)
addi sp, sp, 4
jr ra

delete_string:
addi sp, sp, -4
sw ra, 0(sp)

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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

cesare_crypt:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa (ptr), a1 K -> (in place)

# scorro la  stringa (a0) e controllo ogni carattere
# se è una lettera minuscola o maiuscola applico l'algoritmo
# altrimenti proseguo con il ciclo
li a2, 0 # indice for stringa

loop_cesare_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_crypt

# controllo che sia una lettera minuscola
li t1, 122
bgt a4, t1, cesare_crypt_incr
li t1, 97
bge a4, t1, cesare_crypt_preparation

# controllo che sia una lettera maiuscola
li t1, 90
bgt a4, t1, cesare_crypt_incr
li t1, 65
bge a4, t1, cesare_crypt_preparation

# se arrivo qui è perchè sono fuori da 
# entrambi i range delle lettere minuscole e maiuscole
# perciò posso proseguire a scorrere la stringa
j cesare_crypt_incr

cesare_crypt_preparation:
# normalizzo il valore a4, sottraendo t1 ovvero il minimo del 
# range delle lettere minuscole o maiuscole, affinchè 
# sia compreso tra 0-25 prima di sommare k
sub a4, a4, t1

cesare_crypt_save:
# sommo k (a1) ed eseguo l'operazione di modulo (%26) per poi 
# salvare in memoria il valore finale
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
add a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t0, t0, t1
sb t0, 0(a3)

cesare_crypt_incr:
addi a2, a2, 1
j loop_cesare_crypt
end_loop_cesare_crypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

cesare_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa (ptr), a1 K -> (in place)

# scorro la stringa a0 e, come per la cifratura, controllo il carattere corrente 
# confrontandolo con i range di lettere minuscole e maiuscole
li a2, 0 # indice for stringa

loop_cesare_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_decrypt

# controllo lettere minuscole
li t1, 122
bgt a4, t1, cesare_decrypt_incr
li t1, 97
bge a4, t1, cesare_decrypt_preparation

# controllo lettere maiuscole
li t1, 90
bgt a4, t1, cesare_decrypt_incr
li t1, 65
bge a4, t1, cesare_decrypt_preparation
j cesare_decrypt_incr

cesare_decrypt_preparation:
# come per la fase di cifratura sottraggo il minimo del 
# range a cui appartiene il carattere
sub a4, a4, t1

cesare_decrypt_save:
# sottraggo k (a differenza di prima che sommavo)
# e procedo a salvare in memoria il risultato dell'operazione modulo (%26)

addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
sub a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t0, t0, t1
sb t0, 0(a3)

cesare_decrypt_incr:
addi a2, a2, 1
j loop_cesare_decrypt
end_loop_cesare_decrypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

blocchi_crypt:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa (ptr), a1 key (ptr) -> (in place)

# scorro la stringa a0 e ci sommo 
# (in modulo 96) il codice del carattere corrispondente nel blocco
# calcolo la posizione del carattere del blocco 
# eseguendo il modulo alla lunghezza del blocco
li a2, 0 # indice for stringa

# calcolo la lunghezza del blocco e la salvo in t3(a1)
addi sp, sp, -12
sw a0, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
addi a0, a1, 0
jal str_len
addi t3, a0, 0 # len key
lw t1, 0(sp)
lw t0, 4(sp)
lw a0, 8(sp)
addi sp, sp, 12

# ciclo che scorre la stringa a0
loop_blocchi_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]

# calcolo la posizione del carattere da sommare
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
addi a0, a2, 0
addi a1, t3, 0
jal modulo
addi t2, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t2, t2, a1
lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_crypt

# sommo in modulo 96 la chiave con il carattere corrente
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
add a0, a4, a5
li a1, 96
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
addi t0, t0, 32
# sovrascrivo il nuovo carattere
sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_crypt
end_loop_blocchi_crypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

blocchi_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa (ptr), a1 key (ptr) -> (in place)

# scorro la stringa a0 e, come per la cifratura, scorro in modulo la blocco
# e sottraggo il valore in modulo 96
li a2, 0 # indice for stringa

# lunghezza del blocco
addi sp, sp, -12
sw a0, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
addi a0, a1, 0
jal str_len
addi t3, a0, 0 # len key
lw t1, 0(sp)
lw t0, 4(sp)
lw a0, 8(sp)
addi sp, sp, 12

# ciclo che scorre la stringa
loop_blocchi_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]

# calcolo la posizione del carattere del blocco
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
addi a0, a2, 0
addi a1, t3, 0
jal modulo
addi t2, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t2, t2, a1
lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_decrypt

addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
sub a0, a4, a5
addi a0, a0, -32
li a1, 96
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8

li t1, 32
# controllo per normalizzare il codice in tabella ascii
bge t0, t1, blocchi_decrypt_save
addi t0, t0, 96

# sovrascrivo il nuovo carattere
blocchi_decrypt_save:
sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_decrypt
end_loop_blocchi_decrypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

occorrenze_crypt:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa in chiaro (source) (ptr), a1 cyper_text (dest) (ptr) -> (in_place su cypher_text) (restituisce in a0 <- a1)

# inizialmente scorro la stringa (a0) e salvo i caratteri che vi compaiono
# dopodichè scorro la lista dei caratteri univoci che compaiono nella stringa
# e per ogni carattere scorro nuovamente la stringa in chiaro
# e ogni volta che trovo il carattere attuale vado a scomporre il numero che identifica
# la posizione in cifre e le salvo nella stringa di return come caratteri ascii

# ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza
lw a2, app_occorrenze 
# secondo array di appoggio in cui lavoro per non corrompere la stringa in chiaro
# alla fine dell'algoritmo copierò tutti gli elementi da questo vettore (a5) in quello di destinazione (a1)
# NB: nei commenti all'interno dei due cicli for, il vettore cypher_text è in realtà il vettore di appoggio
# che però svolge il ruolo logico di cypher_text
lw a5, app_2_occorrenze

# memorizzo i caratteri che compaiono nella stringa in chiaro
addi sp, sp, -28
sw a0, 24(sp)
sw a1, 20(sp)
sw a2, 16(sp)
sw t0, 12(sp)
sw t1, 8(sp)
sw t2, 4(sp)
sw t3, 0(sp)
addi a1, a2, 0
jal trova_occorrenze_caratteri
lw t3, 0(sp)
lw t2, 4(sp)
lw t1, 8(sp)
lw t0, 12(sp)
lw a2, 16(sp)
lw a1, 20(sp)
lw a0, 24(sp)
addi sp, sp, 28

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

addi sp, sp, -16
sw a0, 12(sp)
sw a1, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
addi a0, t3, 0
jal conta_cifre
addi t6, a0, 0 # numero di cifre di t3 (pos del carattere)
lw t1, 0(sp)
lw t0, 4(sp)
lw a1, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16

# inserisco nella stack per preservarne il valore perchè questi registri verranno modificati sotto
addi sp, sp, -8
sw t3, 4(sp) # indice for interno
sw t6, 0(sp) # cifre di t3

# ciclo che inserisce le singole cifre nella destinazione
loop_posizione_modulo:
beq t6, zero, end_loop_posizione_modulo

# calcolo l'ultima cifra eseguendo il modulo 10
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
addi a0, t3, 0
li a1, 10
jal modulo
addi t0, a0, 0 # t0 = ultima cifra
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8

li t4, 10
div t3, t3, t4 # divido per 10

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

addi t5, t5, -1
add t4, a5, t5
sb zero, 0(t4) # salvo il terminatore di stringa nel vettore di appoggio a5

# copio l'intero vettore in a1 (cypher_text)
addi sp, sp, -20
sw a0, 16(sp)
sw a1, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
addi a1, a5, 0
jal str_copy
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a1, 12(sp)
lw a0, 16(sp)
addi sp, sp, 20

# sovrascrivo ogni cella del vettore che contiene i caratteri univoci
# per prepararlo nel caso venga utilizzato nuovamente l'algoritmo a occorrenze
addi sp, sp, -12
sw a0, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
addi a0, a2, 0
jal delete_string
lw t1, 0(sp)
lw t0, 4(sp)
lw a0, 8(sp)
addi sp, sp, 12

addi a0, a1, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra

occorrenze_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

trova_occorrenze_caratteri:
addi sp, sp, -4
sw ra, 0(sp)

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
addi sp, sp, -20
sw a0, 16(sp)
sw a1, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
addi a1, a2, 0
jal check_char_in_string
addi t3, a0, 0
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a1, 12(sp)
lw a0, 16(sp)
addi sp, sp, 20

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
lw ra, 0(sp)
addi sp, sp, 4
jr ra

inversione_stringa:
addi sp, sp, -4
sw ra, 0(sp)
# a0 stringa (ptr) -> (in place)

# scorro la stringa con i fino ad n/2 (con n lunghezza della stringa)
# ed eseguo una swap dei caratteri in posizione i e n-i
# osservare come non sia necessario separare la procedura in due fasi (cifratura e decifratura)
# in quanto la funzione di inversione sia essa stessa la sua funzione inversa
# ovvero riapplicando la stessa procedura si riottiene la stringa di partenza

# calcolo la lunghezza della stringa in a1
addi sp, sp, -12
sw a0, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
jal str_len
addi a1, a0, 0
lw t1, 0(sp)
lw t0, 4(sp)
lw a0, 8(sp)
addi sp, sp, 12

srli a2, a1, 1 # divido per due per sapere quando fermarmi
li t0, 0 # indice per scorrere la stringa

# nb: dividendo per due con srli eseguo un troncamento in caso di lunghezza dispari
# questo però non mi interessa perchè in quel caso il carattere centrale
# rimarrà nella stessa posizione

loop_inversione_stringa:
beq t0, a2, fine_inversione_stringa

# prendo i due caratteri da invertire
add t1, a0, t0
lb a3, 0(t1) # a3 = stringa[t0]
add t1, a0, a1
sub t1, t1, t0
addi t1, t1, -1
lb a4, 0(t1) # a4 = stringa[len(stringa)-t0]

# swap dei due caratteri opposti
add t1, a0, t0
sb a4, 0(t1) 
add t1, a0, a1
sub t1, t1, t0
addi t1, t1, -1
sb a3, 0(t1)

addi t0, t0, 1
j loop_inversione_stringa

fine_inversione_stringa:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

dizionario:
addi sp, sp, -4
sw ra, 0(sp)
# a0 (stringa) -> (in place)

# scorro la stringa a0 e per ogni carattere controllo a che categoria appartiene
# per ogni categoria (lett. minuscola, lett. maiuscola, cifra) eseguo l'operazione associata
# osservare come non sia necessario separare la procedura in due fasi (cifratura e decifratura)
# in quanto la funzione dizionario sia essa stessa la sua funzione inversa
# ovvero riapplicando la stessa procedura si riottiene la stringa di partenza

li t0, 0 # indice per scorrere la stringa

# ciclo per scorrere la stringa carattere per carattere
loop_dizionario:
add t1, a0, t0
lb a1, 0(t1) # a1 = stringa[t0]
beq a1, zero, fine_dizionario

# controllo per determinare se il carattere corrente
# sia o meno un numero
li a2, 48
blt a1, a2, incr_dizionario
li a2, 57
ble a1, a2, dizionario_numero

li a2, 65
blt a1, a2, incr_dizionario
li a2, 90
ble a1, a2, dizionario_maiusc

li a2, 97
blt a1, a2, incr_dizionario
li a2, 122
ble a1, a2, dizionario_minusc
j incr_dizionario

dizionario_numero:
li t2, 48
sub a1, a1,t2 # trasformo da ascii a unsigned
sub a2, a2, a1
sb a2, 0(t1)
j incr_dizionario

dizionario_maiusc:
li t2, 65
# ottengo in a1 la 'posizione' (cominciando a contare da 0) nell'alfabeto
# es: lettera b -> 1
sub a1, a1, t2 
li a2, 122
sub a1, a2, a1 # trovo il carattere corrispondente dell'alfabeto minuscolo
sb a1, 0(t1)
j incr_dizionario

dizionario_minusc:
li t2, 97
# ottengo in a1 la 'posizione' (cominciando a contare da 0) nell'alfabeto
sub a1, a1, t2
li a2, 90
sub a1, a2, a1 # trovo il carattere corrispondente dell'alfabeto maiuscolo
sb a1, 0(t1)

incr_dizionario:
addi t0, t0, 1
j loop_dizionario

fine_dizionario:
lw ra, 0(sp)
addi sp, sp, 4
jr ra

main:
# inizializzo tutti i registri del main
li s0, 0 # indice per scorrere mycypher
la s1, mycypher
lw s2, working_place
lw s3, sostK # chiave per cifrario a sostituzione
lw s4, blocKey # chiave per cifrario a blocchi
lw s5, new_line

# copio in working_place il myplaintext per utilizzarlo come luogo di lavoro 
# per gli algoritmi senza influenzare la memoria circostante 
# (specialmente durante l'algoritmo occorrenze)
add a0, s2, zero
la a1, myplaintext
jal str_copy 

# Fase di cifratura:
# scorro la stringa mycypher e per ogni carattere decido quale algoritmo applicare
# ogni volta carico nei registri di input (a0-a1-...) i dati necessari
# tra un'esecuzione e l'altra stampo i risultati parziali
loop_crypt_main:
add t0, s1, s0
lb t1, 0(t0) # algoritmo di cifratura attuale
beq t1, zero, loop_decrypt_main 

li a7, 4
la a0, _cifrato_usando
ecall

# scelta dell'algoritmo di cifratura
li t2, 65 # A
beq t1,t2, alg_A_cesare_cr
li t2, 66 # B
beq t1,t2, alg_B_blocchi_cr
li t2, 67 # C
beq t1,t2, alg_C_occorrenze_cr
li t2, 68 # D
beq t1,t2, alg_D_dizionario_cr
li t2, 69 # E
beq t1,t2, alg_E_inversione_cr

# prima di eseguire la procedura corretta stampo il nome dell'algoritmo usato
alg_A_cesare_cr:
la a0, _alg_a_cesare
ecall
jal stampa_new_line

add a0, s2, zero
add a1, s3, zero
jal cesare_crypt

j incr_crypt_main

alg_B_blocchi_cr:
la a0, _alg_b_blocchi
ecall
jal stampa_new_line

add a0, s2, zero
add a1, s4, zero
jal blocchi_crypt

j incr_crypt_main

alg_C_occorrenze_cr:
la a0, _alg_c_occorrenze
ecall
jal stampa_new_line

add a0, s2, zero
add a1, a0, zero
jal occorrenze_crypt

j incr_crypt_main

alg_D_dizionario_cr:
la a0, _alg_d_dizionario
ecall
jal stampa_new_line

add a0, s2, zero
jal dizionario

j incr_crypt_main

alg_E_inversione_cr:
la a0, _alg_e_inversione
ecall
jal stampa_new_line

add a0, s2, zero
jal inversione_stringa

incr_crypt_main:
# Stampa risultato parziale
li a7, 4
ecall
jal stampa_new_line
jal stampa_new_line

addi s0, s0, 1
j loop_crypt_main

# Fase di decifratura:
# scorro al contrario la stringa mycypher
# scelgo per ogni carattere il giusto algoritmo di decifratura
# stampo ogni volta il risultato parziale
loop_decrypt_main:
addi s0, s0, -1
blt s0, zero, end_decrypt_main 
add t0, s1, s0
lb t1, 0(t0) # algoritmo di decifratura attuale

la a0, _decifrato_usando
li a7, 4
ecall

# scelta dell'algoritmo
li t2, 65 # A
beq t1,t2, alg_A_cesare_decr
li t2, 66 # B
beq t1,t2, alg_B_blocchi_decr
li t2, 67 # C
beq t1,t2, alg_C_occorrenze_decr
li t2, 68 # D
beq t1,t2, alg_D_dizionario_decr
li t2, 69 # E
beq t1,t2, alg_E_inversione_decr

alg_A_cesare_decr:
la a0, _alg_a_cesare
ecall
jal stampa_new_line

add a0, s2, zero
add a1, s3, zero
jal cesare_decrypt

j incr_decrypt_main

alg_B_blocchi_decr:
la a0, _alg_b_blocchi
ecall
jal stampa_new_line

add a0, s2, zero
add a1, s4, zero
jal blocchi_decrypt

j incr_decrypt_main

alg_C_occorrenze_decr:
la a0, _alg_c_occorrenze
ecall
jal stampa_new_line

add a0, s2, zero
add a1, a0, zero
jal occorrenze_decrypt

j incr_decrypt_main

alg_D_dizionario_decr:
la a0, _alg_d_dizionario
ecall
jal stampa_new_line

add a0, s2, zero
jal dizionario

j incr_decrypt_main

alg_E_inversione_decr:
la a0, _alg_e_inversione
ecall
jal stampa_new_line

add a0, s2, zero
jal inversione_stringa

incr_decrypt_main:
# il decremento è presente all'inizio del ciclo
li a7, 4
ecall
jal stampa_new_line
jal stampa_new_line

j loop_decrypt_main

end_decrypt_main:

# infine stampo la stringa che ha subito il processo di cifratura-decifratura
# insieme alla stringa originale per confrontare il risultato
li a7, 4
la a0, _decifrato
ecall
addi a0, s2, 0
ecall

jal stampa_new_line

la a0, _originale
li a7, 4
ecall
la a0, myplaintext
ecall

jal stampa_new_line

