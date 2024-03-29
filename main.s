#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s
#!include inversione.s
#!include dizionario.s

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
.text
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
#! end