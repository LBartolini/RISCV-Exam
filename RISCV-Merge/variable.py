

class Variable:
    def __init__(self, name, _type, value):
        self.__name = name if not name.endswith(':') else name[:-1]
        self.__type = _type if not _type.startswith('.') else _type[1:]
        self.__value = value if self.__type != 'ascii' else '"'+value+'"'
    
    def get_code(self):
        return f"{self.__name}: .{self.__type} {self.__value}\n"

if __name__ == '__main__':
    stringa = '  pippo: .string "100"'
    name, _type, value = stringa.strip().split(' ')
    var = Variable(name, _type, value)
    print(var.get_code())