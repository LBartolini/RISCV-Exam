#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s

.data
plain_text: .string "abc"
.text
main:
la a0, plain_text
lw a1, Cypher_occorrenze

jal occorrenze_crypt
jal occorrenze_decrypt

li a7, 4 # stampa stringa
ecall
#! end