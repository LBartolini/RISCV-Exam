.text

dizionario:
#! a0
#! manage_ra
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
addi a1, a1, 32 # trasformo in minusc
li t2, 97
# ottengo in a1 la 'posizione' (cominciando a contare da 0) nell'alfabeto
# es: lettera b -> 1
sub a1, a1, t2 
li a2, 122
sub a1, a2, a1 # trovo il carattere corrispondente dell'alfabeto minuscolo
sb a1, 0(t1)
j incr_dizionario

dizionario_minusc:
addi a1, a1, -32 # trasformo in maiusc
li t2, 65
# ottengo in a1 la 'posizione' (cominciando a contare da 0) nell'alfabeto
# es: lettera b -> 1
sub a1, a1, t2
li a2, 90
sub a1, a2, a1 # trovo il carattere corrispondente dell'alfabeto maiuscolo
sb a1, 0(t1)

incr_dizionario:
addi t0, t0, 1
j loop_dizionario

fine_dizionario:
#! end