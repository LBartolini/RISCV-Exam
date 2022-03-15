#!main
#include utils.s
#include cesare.s
#include blocchi.s
#include occorrenze.s
#define procedures.s

.data
K_cesare: .word 1
Key_blocchi: .string "abc"
Cypher_occorrenze: .word 25000

plain_text: .string "abcabcabc"

.text
j main

main:
la a0, plain_text
lw a1, Cypher_occorrenze

jal occorrenze_crypt
#jal blocchi_decrypt

jal str_len
# problema che la stringa in uscita da occorrenze_crypt è separata da spazi
# in questo modo è impossibile ciclare sulla stessa

li a7, 1 # stampa stringa
ecall