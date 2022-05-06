.data
myplaintext: .string "a$%--..dsfsksD!SFSDFsdsf"
mycypher: .string "ABCDE"
working_place: .word 800000
_originale: .string "Originale: "
_decifrato: .string "Decifrato: "
_cifrato_usando: .string "Cifrato usando: "
_decifrato_usando: .string "Decifrato usando: "
_alg_a_cesare: .string "Algoritmo di Cesare (A)"
_alg_b_blocchi: .string "Algoritmo a Blocchi (B)"
_alg_c_occorrenze: .string "Algoritmo a Occorrenze (C)"
_alg_d_dizionario: .string "Algoritmo a Dizionario (D)"
_alg_e_inversione: .string "Algoritmo a Inversione (E)"
new_line: .string "\n"
sostK: .word 1
blocKey: .string "OLE"
app_occorrenze: .word 200000
app_2_occorrenze: .word 500000
.text
j main
modulo:
addi sp, sp, -4
sw ra, 0(sp)
loop_modulo_1:
bge a0, zero, continue_modulo
add a0, a0, a1
j loop_modulo_1
continue_modulo:
rem a0, a0, a1 # resto divisione x/n
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
str_copy:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0 # indice che scorre la stringa sorgente
loop_str_copy:
add t1, a1, t0
lb t1, 0(t1) # t1 = sorg[t0]
beq t1, zero, end_str_copy
add t2, t0, a0
sb t1, 0(t2)
addi t0, t0, 1
j loop_str_copy
end_str_copy:
add t2, a0, t0
sb t1, 0(t2) # inserisco lo 0 in fondo alla stringa dest a0
lw ra, 0(sp)
addi sp, sp, 4
jr ra
stampa_new_line:
addi sp, sp, -4
sw ra, 0(sp)
addi sp, sp, -8
sw a0, 4(sp)
sw a7, 0(sp)
la a0, new_line
li a7, 4
ecall
lw a7, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
lw ra, 0(sp)
addi sp, sp, 4
jr ra
delete_string:
addi sp, sp, -4
sw ra, 0(sp)
li t0, 0
loop_delete_string:
add t1, a0, t0
lb t1, 0(t1)
beq t1, zero, end_delete_string
add t1, a0, t0
sb zero, 0(t1)
addi t0, t0, 1
j loop_delete_string
end_delete_string:
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
lw a5, app_2_occorrenze
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
sb t0, 0(a5)
li t1, 0 # indice for caratteri_univoci
li t5, 1 # indice cypher_text
for_esterno:
add t2, a2, t1
lb a3, 0(t2) # a3 = caratteri_univoci[t1]
beq a3, zero, end_for_esterno
add t2, a5, t5
sb a3, 0(t2) # inserisco nel cypher text il carattere corrente
addi t5, t5, 1
li t3, 0 # indice for_interno (ovvero la posizione nella stringa in chiaro)
for_interno:
add t4, a0, t3
lb a4, 0(t4) # a4 = stringa_in_chiaro[t3]
beq a4, zero, end_for_interno
bne a4, a3, continue_for_interno
add t2, a5, t5
li t0, 45 # codice ascii '-'
sb t0, 0(t2) # inserisco -
addi sp, sp, -20
sw a0, 16(sp)
sw a1, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, t3, 0
jal conta_cifre
addi t6, a0, 0 # numero di cifre di t3 (pos del carattere)
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a1, 12(sp)
lw a0, 16(sp)
addi sp, sp, 20
addi sp, sp, -8
sw t3, 4(sp)
sw t6, 0(sp)
loop_posizione_modulo:
beq t6, zero, end_loop_posizione_modulo
addi sp, sp, -8
sw a0, 4(sp)
sw a1, 0(sp)
addi a0, t3, 0
li a1, 10
jal modulo
addi t0, a0, 0 # t0 = ultima cifra
lw a1, 0(sp)
lw a0, 4(sp)
addi sp, sp, 8
sub t3, t3, t0 # sottraggo l'ultima cifra (probabilmente inutile)
li t4, 10
divu t3, t3, t4 # divido per 10
add t4, a5, t5
add t4, t4, t6
addi t0, t0, 48 # normalizzazione tabella ascii cifre
sb t0, 0(t4)
addi t6, t6, -1
j loop_posizione_modulo
end_loop_posizione_modulo:
lw t2, 0(sp)
lw t3, 4(sp)
addi sp, sp, 8
addi t2, t2, 1
add t5, t5, t2
continue_for_interno:
addi t3, t3, 1
j for_interno
end_for_interno:
li t0, 32 # ascii for space
add t4, a5, t5
sb t0, 0(t4)
addi t5, t5, 1
addi t1, t1, 1
j for_esterno
end_for_esterno:
li t0, 0
addi t5, t5, -1
add t4, a5, t5
sb t0, 0(t4)
addi sp, sp, -20
sw a0, 16(sp)
sw a1, 12(sp)
sw t0, 8(sp)
sw t1, 4(sp)
sw t2, 0(sp)
addi a0, a1, 0
addi a1, a5, 0
jal str_copy
lw t2, 0(sp)
lw t1, 4(sp)
lw t0, 8(sp)
lw a1, 12(sp)
lw a0, 16(sp)
addi sp, sp, 20
addi sp, sp, -12
sw a0, 8(sp)
sw t0, 4(sp)
sw t1, 0(sp)
addi a0, a2, 0
jal delete_string
lw t1, 0(sp)
lw t0, 4(sp)
lw a0, 8(sp)
addi sp, sp, 12
addi a0, a1, 0
lw ra, 0(sp)
addi sp, sp, 4
jr ra
occorrenze_decrypt:
addi sp, sp, -4
sw ra, 0(sp)
li t4, 0 # contatore di quanti numeri ho pushato nella stack
li a5, 1
li a4, 0
li t6, 0 # caratteri inseriti nella stringa_in_chiaro
lw a6, app_occorrenze # appoggio dove inserire la stringa_in_chiaro appena decifrata
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
addi a2, a2, -1 # (altrimenti comincerebbe dallo 0)
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
add t2, t2, a6 # t2 posizione in cui mettere il carattere a3
sb a3, 0(t2)
addi t6, t6, 1
addi t4, t4, -1
j loop_inserimento_numeri_occorrenze
end_inserimento_numeri_occorrenze:
addi a2, a2, -1 # scorro un carattere in più per saltare lo spazio nel mezzo alle codifiche
j incr_loop_occorrenze_decrypt
pass_occorrenze_decrypt:
beq a3, t2, push_numero_stack_occorrenze # se trovo un '-' devo pushare il numero (a4) nella stack
addi a3, a3, -48 # riconverto la cifra in ascii a decimale
mul t2, a3, a5
add a4, a4, t2 # incremento la somma parziale
li a7, 10
mul a5, a5, a7
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
add t0, a6, t6
sb zero, 0(t0) # inserisco 0 in fondo alla stringa_in_chiaro
addi a1, a6, 0
jal str_copy 
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
sb zero, 0(t2) # aggiungo 0 in fondo alla stringa di appoggio
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
lw a0, working_place
la a1, myplaintext
jal str_copy # copio in working_place il myplaintext per utilizzarlo come luogo di lavoro per gli algoritmi senza influenzare la memoria circostante (durante l'algoritmo occorrenze)
li s0, 0 # contatore degli algoritmi di cifratura applicati
li s1, 0 # indice per scorrere mycypher
la s2, mycypher
loop_crypt_main:
add t0, s2, s1
lb t1, 0(t0) # algoritmo di cifratura attuale
beq t1, zero, loop_decrypt_main 
li a7, 4
la a0, _cifrato_usando
ecall
li t2, 65 # A
beq t1,t2, alg_A_cesare_cr
li t2, 66 # B
beq t1,t2, alg_B_blocchi_cr
li t2, 67 # C
beq t1,t2, alg_C_occorrenze_cr
li t2, 68 # D
beq t1,t2, alg_D_dizionario_cr
li t2, 69 # E
beq t1,t2, alg_E_inversione_cr
alg_A_cesare_cr:
la a0, _alg_a_cesare
ecall
jal stampa_new_line
lw a0, working_place
lw a1, sostK
jal cesare_crypt
j incr_crypt_main
alg_B_blocchi_cr:
la a0, _alg_b_blocchi
ecall
jal stampa_new_line
lw a0, working_place
la a1, blocKey
jal blocchi_crypt
j incr_crypt_main
alg_C_occorrenze_cr:
la a0, _alg_c_occorrenze
ecall
jal stampa_new_line
lw a0, working_place
addi a1, a0, 0
jal occorrenze_crypt
j incr_crypt_main
alg_D_dizionario_cr:
la a0, _alg_d_dizionario
ecall
jal stampa_new_line
lw a0, working_place
jal dizionario
j incr_crypt_main
alg_E_inversione_cr:
la a0, _alg_e_inversione
ecall
jal stampa_new_line
lw a0, working_place
jal inversione_stringa
incr_crypt_main:
# Stampa risultato parziale
li a7, 4
ecall
jal stampa_new_line
jal stampa_new_line
addi s1, s1, 1
j loop_crypt_main
########################
########################
loop_decrypt_main:
addi s1, s1, -1
blt s1, zero, end_decrypt_main 
add t0, s2, s1
lb t1, 0(t0) # algoritmo di decifratura attuale
la a0, _decifrato_usando
li a7, 4
ecall
li t2, 65 # A
beq t1,t2, alg_A_cesare_decr
li t2, 66 # B
beq t1,t2, alg_B_blocchi_decr
li t2, 67 # C
beq t1,t2, alg_C_occorrenze_decr
li t2, 68 # D
beq t1,t2, alg_D_dizionario_decr
li t2, 69 # E
beq t1,t2, alg_E_inversione_decr
alg_A_cesare_decr:
la a0, _alg_a_cesare
ecall
jal stampa_new_line
lw a0, working_place
lw a1, sostK
jal cesare_decrypt
j incr_decrypt_main
alg_B_blocchi_decr:
la a0, _alg_b_blocchi
ecall
jal stampa_new_line
lw a0, working_place
la a1, blocKey
jal blocchi_decrypt
j incr_decrypt_main
alg_C_occorrenze_decr:
la a0, _alg_c_occorrenze
ecall
jal stampa_new_line
lw a0, working_place
addi a1, a0, 0
jal occorrenze_decrypt
j incr_decrypt_main
alg_D_dizionario_decr:
la a0, _alg_d_dizionario
ecall
jal stampa_new_line
lw a0, working_place
jal dizionario
j incr_decrypt_main
alg_E_inversione_decr:
la a0, _alg_e_inversione
ecall
jal stampa_new_line
lw a0, working_place
jal inversione_stringa
incr_decrypt_main:
# il decremento è presente in cima
li a7, 4
ecall
jal stampa_new_line
jal stampa_new_line
j loop_decrypt_main
end_decrypt_main:
jal stampa_new_line
jal stampa_new_line
li a7, 4
addi t0, a0, 0
la a0, _decifrato
ecall
addi a0, t0, 0
ecall
jal stampa_new_line
la a0, _originale
li a7, 4
ecall
la a0, myplaintext
ecall
jal stampa_new_line
