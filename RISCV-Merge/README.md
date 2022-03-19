### Instructions on how to use the Preprocessor

Main file first line has to be a comment starting with '#!' and the only word present is going to be the entry point for the file.


To include different files you need to place an include statement in the main file. EVERY file must be imported by the main file.
syntax: '#!include <file_name>.s' (.s if that's the extension you're using)

Every other file imported will skip the first line.

Apart from the 'main' proc (aka entry point) every procedure needs to be written like the following.

main file must have '.text' to notify the end of '.data' part (even if there's no '.data') BUT you can't place any code in '.text' that is outside of a procedure. if you still want, you have to place it into the entry_point procedure, pre_processor will take care of how to reach it with a proper jump instruction.

example: (single quotes are there just for visualization purpose, in the files they don't have to be there)

'mult:' this is the name of the proc (usual riscv nomenclature), attention not to put anything after ':' (not even comments, if you want them place them before the declaration)

'#! a0 a1 a2 a3' this line (first after the name) should contain all the register that you use (modifiy, if you want to be sure that nothing happens you can place here even the registers that you read but its not mandatory)

'#! manage_ra' this should be the second line from the next (the next one after the register list) and it tells the preprocessor to manage 'ra' register in the stack (both the push and pop part at the start and end of the procedure)

'#! end' this should be the last line and it tells the preprocessor that the current procedure is ended
