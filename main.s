#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s
#!include inversione.s
#!include dizionario.s

.data
myplaintext: .string "poadsf4350$$--..dsfsksDSFSDFsdsf"
mycypher: .string "ABCDEABCDE"
working_place: .word 800000
.text

main:
lw a0, working_place
la a1, myplaintext
jal str_copy # copio in working_place il myplaintext per utilizzarlo come luogo di lavoro per gli algoritmi senza influenzare la memoria circostante (durante l'algoritmo occorrenze)

jal stampa_new_line
li s0, 0 # contatore degli algoritmi di cifratura applicati
li s1, 0 # indice per scorrere mycypher
la s2, mycypher

loop_crypt_main:
add t0, s2, s1
lb t1, 0(t0) # algoritmo di cifratura attuale
beq t1, zero, loop_decrypt_main 

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

alg_A_cesare_cr:
lw a1, sostK

jal cesare_crypt

j incr_crypt_main

alg_B_blocchi_cr:
la a1, blocKey

jal blocchi_crypt

j incr_crypt_main

alg_C_occorrenze_cr:
addi a1, a0, 0

jal occorrenze_crypt

j incr_crypt_main

alg_D_dizionario_cr:

jal dizionario

j incr_crypt_main

alg_E_inversione_cr:

jal inversione_stringa

incr_crypt_main:
li a7, 4
ecall

jal stampa_new_line
jal stampa_new_line

addi s1, s1, 1
j loop_crypt_main


########################
########################


loop_decrypt_main:
addi s1, s1, -1

blt s1, zero, end_decrypt_main 
add t0, s2, s1
lb t1, 0(t0) # algoritmo di decifratura attuale

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
lw a1, sostK

jal cesare_decrypt

j incr_decrypt_main

alg_B_blocchi_decr:
la a1, blocKey

jal blocchi_decrypt

j incr_decrypt_main

alg_C_occorrenze_decr:
addi a1, a0, 0

jal occorrenze_decrypt

j incr_decrypt_main

alg_D_dizionario_decr:

jal dizionario

j incr_decrypt_main

alg_E_inversione_decr:

jal inversione_stringa

incr_decrypt_main:
# il decremento è presente in cima
li a7, 4
ecall

jal stampa_new_line
jal stampa_new_line

j loop_decrypt_main

end_decrypt_main:

jal stampa_new_line
jal stampa_new_line

li a7, 4
ecall

jal stampa_new_line

la a0, myplaintext
li a7, 4
ecall

jal stampa_new_line
jal stampa_new_line
#! end