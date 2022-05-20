.data
blocKey: .string "OLE"
.text

blocchi_crypt: 
#! a0 a1 a2 a3 a4 a5 t0 t1 t2 t3
#! manage_ra
# a0 stringa (ptr), a1 key (ptr) -> (in place)

# scorro la stringa a0 e ci sommo 
# (in modulo 96) il codice del carattere corrispondente nel blocco
# calcolo la posizione del carattere del blocco 
# eseguendo il modulo alla lunghezza del blocco
li a2, 0 # indice for stringa

# calcolo la lunghezza del blocco e la salvo in t3(a1)
#! precall(str_len)
addi a0, a1, 0
jal str_len
addi t3, a0, 0 # len key
#! postcall(str_len)

# ciclo che scorre la stringa a0
loop_blocchi_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]

# calcolo la posizione del carattere da sommare
#! precall(modulo)
addi a0, a2, 0
addi a1, t3, 0
jal modulo
addi t2, a0, 0
#! postcall(modulo)
add t2, t2, a1
lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_crypt

# sommo in modulo 96 la chiave con il carattere corrente
#! precall(modulo)
add a0, a4, a5
li a1, 96
jal modulo
addi t0, a0, 0
#! postcall(modulo)
addi t0, t0, 32
# sovrascrivo il nuovo carattere
sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_crypt
end_loop_blocchi_crypt:
#! end

blocchi_decrypt: 
#! a0 a1 a2 a3 a4 a5 t0 t1 t2 t3
#! manage_ra
# a0 stringa (ptr), a1 key (ptr) -> (in place)

# scorro la stringa a0 e, come per la cifratura, scorro in modulo la blocco
# e sottraggo il valore in modulo 96
li a2, 0 # indice for stringa

# lunghezza del blocco
#! precall(str_len)
addi a0, a1, 0
jal str_len
addi t3, a0, 0 # len key
#! postcall(str_len)

# ciclo che scorre la stringa
loop_blocchi_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]

# calcolo la posizione del carattere del blocco
#! precall(modulo)
addi a0, a2, 0
addi a1, t3, 0
jal modulo
addi t2, a0, 0
#! postcall(modulo)
add t2, t2, a1
lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_decrypt

#! precall(modulo)
sub a0, a4, a5
addi a0, a0, -32
li a1, 96
jal modulo
addi t0, a0, 0
#! postcall(modulo)

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
#! end