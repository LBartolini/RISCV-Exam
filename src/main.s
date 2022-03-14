#!main
#include utils.s
.data
 n: .word 6
.text
j main

# sei un coglione, questo è semplicemente
# un for ricorsivo 

main:
li s1, 1
lw a0, n

jal fattoriale

li a7, 1
ecall