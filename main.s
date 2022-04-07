#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s
#!include inversione.s
#!include dizionario.s

.data
plain_text: .string "pippoplutopaperino"
.text
main:
la a0, plain_text
la a1, Cypher_occorrenze

jal occorrenze_crypt
#jal blocchi_decrypt

addi a0, a1, 0
li a7, 4 # stampa stringa
ecall
#! end