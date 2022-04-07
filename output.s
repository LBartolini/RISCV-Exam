.data
plain_text: .string "pippoplutopaperino"
K_cesare: .word -2
Key_blocchi: .string "OLE"
Cypher_occorrenze: .word 25000
app_occorrenze: .word 20000
.text
j main
modulo:
addi sp, sp, -4
sw ra, 0(sp)
loop_modulo_1:
bge a0, zero, loop_modulo_2
add a0, a0, a1
j loop_modulo_1
loop_modulo_2:
blt a0, a1, end_modulo
sub a0, a0, a1
j loop_modulo_2
end_modulo:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
str_len:
addi sp, sp, -4
sw ra, 0(sp)
li t1, 0
loop_str_len:
add t2, a0, t1
lb t0, 0(t2)
beq t0, zero, end_str_len
addi t1, t1, 1
j loop_str_len
end_str_len:
addi a0, t1, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra
check_char_in_string:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0 # indice for
li t2, 0 # boolean return value
loop_check_char:
add t1, a0, t0
lb t1, 0(t1)
beq t1, zero, end_loop_check_char
beq t1, a1, found_char
addi t0, t0, 1
j loop_check_char
found_char:
li t2, 1
end_loop_check_char:
addi a0, t2, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra
mult:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0
li t1, 0
loop_mult:
bge t0, a1, fine_loop_mult
add t1, t1, a0
addi t0, t0, 1
j loop_mult
fine_loop_mult:
add a0, t1, zero
lw ra, 0(sp)
addi sp, sp, 4
jr ra
conta_cifre:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 1 # contatore
li a1, 10 # base
loop_conta_cifre:
blt a0, a1, end_loop_conta_cifre
slli t1, a1, 3
slli t2, a1, 1
add a1, t1, t2 # a1*10
addi t0, t0, 1
j loop_conta_cifre
end_loop_conta_cifre:
addi a0, t0, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra
cesare_crypt:
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa
loop_cesare_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_crypt
li t1, 122
bgt a4, t1, cesare_crypt_next_check
li t1, 97
bge a4, t1, cesare_crypt_preparation
cesare_crypt_next_check:
li t1, 90
bgt a4, t1, cesare_crypt_incr
li t1, 65
bge a4, t1, cesare_crypt_preparation
j cesare_crypt_incr
cesare_crypt_preparation:
sub a4, a4, t1
cesare_crypt_save:
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
add a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t0, t0, t1
sb t0, 0(a3)
cesare_crypt_incr:
addi a2, a2, 1
j loop_cesare_crypt
end_loop_cesare_crypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
cesare_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa
loop_cesare_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
beq a4, zero, end_loop_cesare_decrypt
li t1, 122
bgt a4, t1, cesare_decrypt_next_check
li t1, 97
bge a4, t1, cesare_decrypt_preparation
cesare_decrypt_next_check:
li t1, 90
bgt a4, t1, cesare_decrypt_incr
li t1, 65
bge a4, t1, cesare_decrypt_preparation
j cesare_decrypt_incr
cesare_decrypt_preparation:
sub a4, a4, t1
cesare_decrypt_save:
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
sub a0, a4, a1
li a1, 26
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t0, t0, t1
sb t0, 0(a3)
cesare_decrypt_incr:
addi a2, a2, 1
j loop_cesare_decrypt
end_loop_cesare_decrypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
blocchi_crypt:
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa
addi sp, sp, -16
sw a0, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
jal str_len
addi t3, a0, 0 # len key
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16
loop_blocchi_crypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
addi a0, a2, 0
addi a1, t3, 0
jal modulo
addi t2, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t2, t2, a1
lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_crypt
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
add a0, a4, a5
li a1, 96
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
addi t0, t0, 32
sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_crypt
end_loop_blocchi_crypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
blocchi_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
li a2, 0 # indice for stringa
addi sp, sp, -16
sw a0, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
jal str_len
addi t3, a0, 0 # len key
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16
loop_blocchi_decrypt:
add a3, a0, a2
lb a4, 0(a3) # stringa[a2]
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
addi a0, a2, 0
addi a1, t3, 0
jal modulo
addi t2, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
add t2, t2, a1
lb a5, 0(t2) # key[a2%len(key)]
beq a4, zero, end_loop_blocchi_decrypt
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
sub a0, a4, a5
addi a0, a0, -32
li a1, 96
jal modulo
addi t0, a0, 0
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
li t1, 32
bge t0, t1, blocchi_decrypt_save
addi t0, t0, 96
blocchi_decrypt_save:
sb t0, 0(a3)
addi a2, a2, 1
j loop_blocchi_decrypt
end_loop_blocchi_decrypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
occorrenze_crypt:
addi sp, sp, -4
sw ra, 0(sp)
lw a2, app_occorrenze # ptr array di appoggio in cui salvo tutti i caratteri presenti nella stringa di partenza
addi sp, sp, -28
sw a0, 24(sp)
sw a1, 20(sp)
sw a2, 16(sp)
sw t0, 12(sp)
sw t1, 8(sp)
sw t2, 4(sp)
sw t3, 0(sp)
addi a1, a2, 0
jal trova_occorrenze_caratteri
lw t3, 0(sp)
lw t2, 4(sp)
lw t1, 8(sp)
lw t0, 12(sp)
lw a2, 16(sp)
lw a1, 20(sp)
lw a0, 24(sp)
addi sp, sp, 28
li t0, 32 # space
sb t0, 0(a1)
li t1, 0 # indice for caratteri_univoci
li t5, 1 # indice cypher_text
for_esterno:
add t2, a2, t1
lb a3, 0(t2) # a3 = caratteri_univoci[t1]
beq a3, zero, end_for_esterno
add t2, a1, t5
sb a3, 0(t2) # inserisco nel cypher text il carattere corrente
addi t5, t5, 1
li t3, 0 # indice for_interno (ovvero la posizione nella stringa in chiaro)
for_interno:
add t4, a0, t3
lb a4, 0(t4) # a4 = stringa_in_chiaro[t3]
beq a4, zero, end_for_interno
bne a4, a3, continue_for_interno
add t2, a1, t5
li t0, 45 # codice ascii '-'
sb t0, 0(t2) # inserisco -
addi t3, t3, 1 # per evitare l'errore della posizione zero
sb t3, 1(t2) # inserisco la posizione del carattere come numero puro
addi t5, t5, 2 
continue_for_interno:
addi t3, t3, 1
j for_interno
end_for_interno:
li t0, 32 # ascii for space
add t4, a1, t5
sb t0, 0(t4)
addi t5, t5, 1
addi t1, t1, 1
j for_esterno
end_for_esterno:
li t0, 0
addi t5, t5, -1
add t4, a1, t5
sb t0, 0(t4)
lw ra, 0(sp)
addi sp, sp, 4
jr ra
occorrenze_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
li t4, 0 # contatore di quanti numeri ho pushato nella stack
li a5, 1
addi sp, sp, -16
sw a0, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
jal str_len
addi a2, a0, 0
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16
add a2, a1, a2 # a2 contiene l'indirizzo dell'ultimo carattere del cypher_text
addi a2, a2, -1 # altrimenti comincerebbe dallo 0
addi a1, a1, 1 # così il ciclo sotto si ferma al punto giusto
loop_occorrenze_decrypt:
blt a2, a1, fine_occorrenze_decrypt # ciclo finchè la posizione a sinistra fa parte della stringa
lb a3, 0(a2) # a3 carattere corrente
lb t0, 1(a2) # carattere a destra
lb t1, -1(a2) # carattere a sinistra
li t2, 45 # ascii '-'
li t3, 32 # ascii 'space'
bne t1, t3, pass_occorrenze_decrypt
bne t0, t2, pass_occorrenze_decrypt
# se entro qui significa che ho trovato un carattere 
# e devo inserirlo nella stringa in chiaro
# per farlo fai un ciclo che parte da t4 e finisce a zero
loop_inserimento_numeri_occorrenze:
beq t4, zero, end_inserimento_numeri_occorrenze
lw t2, 0(sp) # pop del numero
addi sp, sp, 4
add t2, t2, a0 # t2 posizione in cui mettere il carattere a3
sb a3, 0(t2)
addi t4, t4, -1
j loop_inserimento_numeri_occorrenze
end_inserimento_numeri_occorrenze:
addi a2, a2, -1 # scorro un carattere in più per saltare lo spazio nel mezzo alle codifiche
j incr_loop_occorrenze_decrypt
pass_occorrenze_decrypt:
beq a3, t2, push_numero_stack_occorrenze # se trovo un '-' devo pushare il numero (a4) nella stack
addi a3, a3, -48 # riconverto la cifra in ascii a decimale
addi sp, sp, -16
sw a0, 12(sp)
sw a1, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
addi a0, a3, 0 # cifra
addi a1, a5, 0 # 1/10/100/...
jal mult
addi t2, a0, 0
lw t1, 0(sp)
lw t0, 4(sp)
lw a1, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16
add a4, a4, t2 # incremento la somma parziale
addi sp, sp, -16
sw a0, 12(sp)
sw a1, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
li a0, 10
addi a1, a5, 0 # 1/10/100/...
jal mult # moltiplico per 10 il fattore parziale che moltiplica le cifre
addi a5, a0, 0
lw t1, 0(sp)
lw t0, 4(sp)
lw a1, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16
j incr_loop_occorrenze_decrypt
push_numero_stack_occorrenze:
addi sp, sp, -4
sw a4, 0(sp)
addi t4, t4, 1 # incremento il contatore dei numeri nella stack
li a5, 1 # a5 è il valore con cui moltiplico la cifra attuale dei numeri
li a4, 0 # a4 è la somma parziale del numero
incr_loop_occorrenze_decrypt:
addi a2, a2, -1
j loop_occorrenze_decrypt
fine_occorrenze_decrypt:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
trova_occorrenze_caratteri:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 2 # indice for stringa
li t1, 0 # indice array di appoggio (numero di caratteri univoci presenti nella stringa)
lb t2, 1(a0) # carico in t2 il carattere in posizione 1
sb t2, 0(a1) # lo inserisco in prima posizione dell'appoggio
addi t1, t1, 1
lb t3, 0(a0) # carico in t3 il carattere in pos 0
beq t2, t3, loop_occorrenze_crypt # se è uguale a quello in posizione 0 allora salto al ciclo
sb t3, 1(a1) # altrimenti lo salvo in posizione 1 dell'appoggio
addi t1, t1, 1
loop_occorrenze_crypt:
add a2, a0, t0
lb a2, 0(a2) # a2 = stringa[t0]
beq a2, zero, end_loop_occorrenze_crypt # (while stringa[t0] != 0)
addi sp, sp, -20
sw a0, 16(sp)
sw a1, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
addi a1, a2, 0
jal check_char_in_string
addi t3, a0, 0
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a1, 12(sp)
lw a0, 16(sp)
addi sp, sp, 20
bgt t3, zero, continue_loop
add t3, a1, t1
sb a2, 0(t3)
addi t1, t1, 1
continue_loop:
addi t0, t0, 1
j loop_occorrenze_crypt
end_loop_occorrenze_crypt:
add t2, a1, t1
sb zero, 0(t2)
lw ra, 0(sp)
addi sp, sp, 4
jr ra
inversione_stringa:
addi sp, sp, -4
sw ra, 0(sp)
addi sp, sp, -16
sw a0, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
jal str_len
addi a1, a0, 0
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a0, 12(sp)
addi sp, sp, 16
srli a2, a1, 1 # divido per due per sapere quando fermarmi
li t0, 0 # indice per scorrere la stringa
loop_inversione_stringa:
beq t0, a2, fine_inversione_stringa
add t1, a0, t0
lb a3, 0(t1) # a3 = stringa[t0]
add t1, a0, a1
sub t1, t1, t0
addi t1, t1, -1
lb a4, 0(t1) # a4 = stringa[len(stringa)-t0]
# swap dei due caratteri opposti
add t1, a0, t0
sb a4, 0(t1) 
add t1, a0, a1
sub t1, t1, t0
addi t1, t1, -1
sb a3, 0(t1)
addi t0, t0, 1
j loop_inversione_stringa
fine_inversione_stringa:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
dizionario:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0 # indice per scorrere la stringa
loop_dizionario:
add t1, a0, t0
lb a1, 0(t1) # a1 = stringa[t0]
beq a1, zero, fine_dizionario
li a2, 48
blt a1, a2, incr_dizionario
li a2, 57
ble a1, a2, dizionario_numero
li a2, 65
blt a1, a2, incr_dizionario
li a2, 90
ble a1, a2, dizionario_maiusc
li a2, 97
blt a1, a2, incr_dizionario
li a2, 122
ble a1, a2, dizionario_minusc
j incr_dizionario
dizionario_numero:
li t2, 48
sub a1, a1,t2
sub a2, a2, a1
sb a2, 0(t1)
j incr_dizionario
dizionario_maiusc:
addi a1, a1, 32 # trasformo in minusc
li t2, 97
sub a1, a1, t2
li a2, 122
sub a1, a2, a1
sb a1, 0(t1)
j incr_dizionario
dizionario_minusc:
addi a1, a1, -32 # trasformo in maiusc
li t2, 65
sub a1, a1, t2
li a2, 90
sub a1, a2, a1
sb a1, 0(t1)
j incr_dizionario
incr_dizionario:
addi t0, t0, 1
j loop_dizionario
fine_dizionario:
lw ra, 0(sp)
addi sp, sp, 4
jr ra
main:
la a0, plain_text
la a1, Cypher_occorrenze
jal occorrenze_crypt
#jal blocchi_decrypt
addi a0, a1, 0
li a7, 4 # stampa stringa
ecall
