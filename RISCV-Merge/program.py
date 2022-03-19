

class Program:
    '''
    Class that holds all the informations about the Assembly program.
    It includes all of the Procedures and it stores the entry point of the program.
    '''

    def __init__(self):
        self.__entry_point = None # there need to exist one and only proc with is_main=True
        self.__data = [] # list of variables
        self.__procedures = {}

    def add_variable(self, var):
        self.__data.append(var)
    
    def add_procedure(self, proc):
        if proc.is_main() and self.__entry_point is not None: raise Exception("A program must have one and only entry point")
        if proc.is_main(): self.__entry_point = proc
        self.__procedures[proc.get_name()] = proc

    def get_proc(self, name):
        return self.__procedures[name]

    def get_code(self):
        # returns the code of the entire program with all its procedures
        if self.__entry_point is None: raise Exception("A program must have an entry point")
        
        out = ".data\n" if len(self.__data) > 0 else ""

        for var in self.__data:
            out += var.get_code()
        
        out += ".text\n" + f"j {self.__entry_point.get_name()}\n"

        for proc in self.__procedures:
            if self.__procedures[proc].is_main(): continue
            out += self.__procedures[proc].get_code()
        
        out += self.__entry_point.get_code()

        return out


