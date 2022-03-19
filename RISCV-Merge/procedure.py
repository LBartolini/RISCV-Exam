

class Procedure:
    '''
    Class that stores everything about a procedure, it can be main or else.
    '''

    def __init__(self, name, used_registers, is_main=False, manage_ra=False):
        self.__name = name if not name.endswith(':') else name[:-1]
        self.__is_main = is_main
        self.__manage_ra = manage_ra
        self.__used_registers = used_registers
        self.__code = f'{name}:\n'  if not name.endswith(':') else name + '\n'  

    def add_line(self, line):
        self.__code += line
    
    def manage_ra(self):
        self.__manage_ra = True
        self.__code += "addi sp, sp, -4\n" + "sw ra, 0(sp)\n"

    def end_proc(self):
        if self.__manage_ra: self.__code += "lw ra, 0(sp)\n" + "addi sp, sp, 4\n"
        if not self.__is_main: self.__code += "jr ra\n"

    def get_code(self):
        return self.__code + '\n'

    def get_name(self):
        return self.__name
    
    def is_main(self):
        return self.__is_main
    
    def get_pre_call(self): 
        # returns the code that push all the used registers to the stack
        out = f"addi sp, sp, -{len(self.__used_registers)*4}\n"

        for i, used_reg in enumerate(self.__used_registers):
            out += f"sw {used_reg}, {len(self.__used_registers)*4-((i+1)*4)}(sp)\n"

        return out

    def get_post_call(self):
        # returns the code that pops all the used registers from the stack
        out = ""

        for i, used_reg in enumerate(self.__used_registers[::-1]):
            out += f"lw {used_reg}, {i*4}(sp)\n"
       
        out += f"addi sp, sp, {len(self.__used_registers)*4}\n"
       
        return out


if __name__ == '__main__':
    proc = Procedure("mult", ['a0', 'a1', 'a2'])
    print(proc.get_pre_call())
    print(proc.get_post_call())