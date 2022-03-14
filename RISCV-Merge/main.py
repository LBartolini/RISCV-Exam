import argparse
import os
import pyperclip
import re

class NotMainFile(Exception):
    def __init__(self):
        message = "Main Source file must be a main file! (first line has to be '#!main' and needs to exist a procedure called 'main:' and it has to be the last of the file"
        super().__init__(message)

class NotHeaderFile(Exception):
    def __init__(self):
        message = "Header file must be a header file! (first line has to be '#!header'"
        super().__init__(message)

def merge(source_path, dir=None, header=False):
    directory = os.path.dirname(source_path) if dir is None else dir
    out = f"\n\n#####\n## ({source_path})\n" if header else ""
    path = source_path if not header else directory+'/'+source_path

    with open(path, 'r') as f:
        lines = f.readlines()

    if not header and lines[0].strip() != '#!main':
        raise NotMainFile
    elif header and lines[0].strip() != '#!header':
        raise NotHeaderFile

    main_found = False
    
    files_to_include = []
    for l in lines[1:]:
        if l.startswith('#include'):
            files_to_include.append(l[8:].strip())
        else:
            if l.strip() == 'main:':
                if header: break
                main_found=True

                # concat libraries to the file before the main
                if not header and len(files_to_include) > 0: out += "### START HEADERS ###"
                for lib in files_to_include:
                    out += merge(lib, directory, True) + '\n'
                if not header and len(files_to_include) > 0: out += "\n### END HEADERS ###\n\n"
                files_to_include = []

            out += l
    
    if header:
        # concat libraries to the file before the main
        for lib in files_to_include:
            out += merge(lib, directory, True) + '\n'

    if not header and not main_found:
        raise NotMainFile

    return out


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-s', help="Path to main source file", type=str)
    parser.add_argument('-o', help="Path to destination merged file", type=str)
    parser.add_argument(
        '-cc', help="Copy to clipboard flag", action="store_true")

    args = parser.parse_args()

    out = merge(args.s)
    out = re.sub(r'\n\s*\n', '\n\n', out)

    if args.o is not None:
        with open(args.o, 'w') as f:
            f.write(out)
    if args.cc:
        pyperclip.copy(out)

    if not args.cc and args.o is None:
        raise Exception('Please select a way of representing the output!')
