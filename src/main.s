#! main
#!include utils.s
#!include cesare.s
#!include blocchi.s
#!include occorrenze.s

.data
plain_text: .string "AMOAssEMBLY"
.text
main:
la a0, plain_text
lw a1, K_cesare

jal cesare_crypt
#jal cesare_decrypt

li a7, 4 # stampa stringa
ecall
#! end