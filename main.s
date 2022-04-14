#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s
#!include inversione.s
#!include dizionario.s

.data
myplaintext: .string "pippoplutopaperino"
mycypher: .string "ABDE"
.text

main:
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
la a0, myplaintext
lw a1, sostK

jal cesare_crypt

j incr_crypt_main

alg_B_blocchi_cr:
la a0, myplaintext
la a1, blocKey

jal blocchi_crypt

j incr_crypt_main

alg_C_occorrenze_cr:
# TODO devi capire come fare questo
j incr_crypt_main

alg_D_dizionario_cr:
la a0, myplaintext

jal dizionario

j incr_crypt_main

alg_E_inversione_cr:
la a0, myplaintext

jal inversione_stringa

incr_crypt_main:
addi s1, s1, 1
j loop_crypt_main


########################
########################


loop_decrypt_main:
addi s1, s1, -1

beq s1, zero, end_decrypt_main 
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
la a0, myplaintext
lw a1, sostK

jal cesare_decrypt

j incr_decrypt_main

alg_B_blocchi_decr:
la a0, myplaintext
la a1, blocKey

jal blocchi_decrypt

j incr_decrypt_main

alg_C_occorrenze_decr:
# TODO devi capire come fare questo
j incr_decrypt_main

alg_D_dizionario_decr:
la a0, myplaintext

jal dizionario

j incr_decrypt_main

alg_E_inversione_decr:
la a0, myplaintext

jal inversione_stringa

incr_decrypt_main:
# il decremento è presente in cima
j loop_decrypt_main

end_decrypt_main:

la a0, myplaintext
li a7, 4
ecall
#! end