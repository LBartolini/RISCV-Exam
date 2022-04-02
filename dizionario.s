.text

# a0 (stringa) -> (in place)
dizionario:
#! a0
#! manage_ra
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
#! end