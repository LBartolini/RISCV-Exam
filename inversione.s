.text

# a0 stringa (ptr) -> (in place)
inversione_stringa:
#! a0 a1 a2 a3, a4 t0
#! manage_ra

# scorro la stringa con i fino ad n/2 (con n lunghezza della stringa)
# ed eseguo una swap dei caratteri in posizione i e n-i
# osservare come non sia necessario separare la procedura in due fasi (cifratura e decifratura)
# in quanto la funzione di inversione sia essa stessa la sua funzione inversa
# ovvero riapplicando la stessa procedura si riottiene la stringa di partenza

# calcolo la lunghezza della stringa in a1
#! precall(str_len)
jal str_len
addi a1, a0, 0
#! postcall(str_len)

srli a2, a1, 1 # divido per due per sapere quando fermarmi
li t0, 0 # indice per scorrere la stringa

# nb: dividendo per due con srli eseguo un troncamento in caso di lunghezza dispari
# questo però non mi interessa perchè in caso di lunghezza dispari il carattere centrale
# rimarrà nella stessa posizione

loop_inversione_stringa:
beq t0, a2, fine_inversione_stringa

# prendo i due caratteri da invertire
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