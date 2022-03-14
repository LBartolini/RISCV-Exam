#!main
#include cesare.s
#include utils.s

.data
K_cesare: .word 1
plain_text: .string "abcdefghi"
.text
j main

main:
la a0, plain_text
lw a1, K_cesare

jal cesare_crypt
jal cesare_decrypt

li a7, 4 # stampa stringa
ecall