import argparse
import os
import pyperclip
import re
from program import Program
from procedure import Procedure
from variable import Variable

program = Program()


def prepare_procedures(lines, entry_point):
    in_proc = False
    in_text = False

    for i, l in enumerate(lines):
        if l.strip() == ".text":
            in_text = True
        elif in_text and not in_proc and l.strip().endswith(':'):
            in_proc = True
            name = l.strip()[:-1]
            used_reg = lines[i+1][2:].strip().split(' ')
            manage_ra = (lines[i+2].strip() == "#! manage_ra")
            proc = Procedure(name, used_reg, is_main=(entry_point == name))
            if manage_ra: proc.manage_ra()
            program.add_procedure(proc)

        elif in_text and in_proc and l.strip() == "#! end":
            in_proc = False


def preprocess(source_path, directory=None, imported=False, prepare=True, entry_point=""):
    directory = os.path.dirname(
        source_path) if directory is None else directory
    path = source_path if not imported else directory+'/'+source_path

    with open(path, 'r') as f:
        lines = f.readlines()

    if not imported and not lines[0].startswith('#!'):
        raise Exception(
            "Main file must contain an entry point (first line of the file is not '#! <entry proc>')")

    entry_point = lines[0][2:].strip() if not imported else entry_point
    lines = lines if imported else lines[1:]

    if prepare:
        prepare_procedures(lines, entry_point)
        if imported: return

    in_data = False
    current_proc = None
    files_to_import = []
    for l in lines:
        if l.strip().startswith('#!include'):
            preprocess(l[9:].strip(), directory, imported=True,
                       prepare=True, entry_point=entry_point)
            files_to_import.append(l[9:].strip())
        elif l.strip().startswith('.data'):
            in_data = True
        elif in_data and ':' in l:
            #name, _type, value = l.strip().split(' ')

            x = l.strip().split(' ')
            if '.string' in x:
                name = x[0]
                _type = ".string"
                value = " ".join(x[x.index('.string')+1:])
            else:
                name = x[0]
                _type = x[1]
                value = x[2]

            var = Variable(name, _type, value)
            program.add_variable(var)
        elif l.strip().startswith('.text'):
            in_data = False
        elif not in_data and current_proc is None and l.strip().endswith(':'):
            current_proc = program.get_proc(l.strip()[:-1])
        elif not in_data and current_proc is not None and l.strip() == "#! end":
            current_proc.end_proc()
            current_proc = None
        elif not in_data and current_proc is not None and l.strip().startswith('#! precall'):
            current_proc.add_line(program.get_proc(
                l.strip()[2:-1].strip().split('(')[1]).get_pre_call())
        elif not in_data and current_proc is not None and l.strip().startswith('#! postcall'):
            current_proc.add_line(program.get_proc(
                l.strip()[2:-1].strip().split('(')[1]).get_post_call())
        elif not in_data and current_proc is not None:
            if l.strip().startswith('#!'): continue
            current_proc.add_line(l)
    
    for file in files_to_import:
        preprocess(file, directory, imported=True, prepare=False)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-s', help="Path to main source file", type=str)
    parser.add_argument('-o', help="Path to destination merged file", type=str)
    parser.add_argument(
        '-cc', help="Copy to clipboard flag", action="store_true")

    args = parser.parse_args()

    preprocess(args.s)
    out = re.sub(r'\n\s*\n', '\n', program.get_code())

    if args.o is not None:
        with open(args.o, 'w') as f:
            f.write(out)
    if args.cc:
        pyperclip.copy(out)

    if not args.cc and args.o is None:
        raise Exception('Please select a way of representing the output!')
