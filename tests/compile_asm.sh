rem compile from C to ASM
gcc -S -O2 -masm=intel -fverbose-asm dataframe.c -o dataframe.s

rem compile from ASM to EXE
gcc dataframe.s -o dataframe.exe

rem disassemble EXE to ASM
rem objdump -D -M intel myprog.exe > myprog.asm
