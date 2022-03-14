#!main
#include utils.s
#include cesare.s
#include blocchi.s

.data
K_cesare: .word 1
Key_blocchi: .string "abc"
plain_text: .string "abcdefghi"
.text
j main

main:
la a0, plain_text
la a1, Key_blocchi

jal blocchi_crypt
jal blocchi_decrypt

li a7, 4 # stampa stringa
ecall