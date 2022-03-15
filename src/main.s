#!main
#include utils.s
#include cesare.s
#include blocchi.s
#include occorrenze.s
#define procedures.s

.data
K_cesare: .word 1
Key_blocchi: .string "abc"
Cyper_occorrenze: .word 1000

plain_text: .string "abcabcabc"
.text
j main

main:
la a0, plain_text
lw a1, Cyper_occorrenze

jal occorrenze_cyper
#jal blocchi_decrypt

li a7, 4 # stampa stringa
ecall