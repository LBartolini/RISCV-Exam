.data
sostK: .word 1
.text
# a0 stringa (ptr), a1 K -> (in place)
cesare_crypt: 
#! a0 a1 a2 a3 a4 t0 t1
#! manage_ra

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
#! precall(modulo)
add a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
#! postcall(modulo)
add t0, t0, t1
sb t0, 0(a3)

cesare_crypt_incr:
addi a2, a2, 1
j loop_cesare_crypt
end_loop_cesare_crypt:
#! end

# a0 stringa (ptr), a1 K -> (in place)
cesare_decrypt: 
#! a0 a1 a2 a3 a4 t0 t1
#! manage_ra

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

#! precall(modulo)
sub a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
#! postcall(modulo)
add t0, t0, t1
sb t0, 0(a3)

cesare_decrypt_incr:
addi a2, a2, 1
j loop_cesare_decrypt
end_loop_cesare_decrypt:
#! end