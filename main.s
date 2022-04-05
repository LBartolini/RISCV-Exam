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
la a1, Key_blocchi

jal blocchi_crypt
jal blocchi_decrypt

li a7, 4 # stampa stringa
ecall
#! end