#!procedures

#! push_ra
addi sp, sp, -4
sw ra, 0(sp)
#! end

#! pop_ra
lw ra, 0(sp)
addi sp, sp, 4
#! end