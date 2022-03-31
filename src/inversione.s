.text

# a0 stringa (ptr) -> (in place)
inversione_stringa:
#! a0 a1 a2 a3, a4 t0
#! manage_ra

#! precall(str_len)
jal str_len
addi a1, a0, 0
#! postcall(str_len)
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
#! end