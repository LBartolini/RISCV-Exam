#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s

.data
plain_text: .string "LAUREATO"
.text
main:
la a0, plain_text
lw a1, Key_blocchi

jal blocchi_crypt
jal blocchi_decrypt

li a7, 4 # stampa stringa
ecall
#! end