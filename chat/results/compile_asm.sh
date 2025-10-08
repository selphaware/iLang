rem compile from C to ASM
gcc -S -O2 -masm=intel -fverbose-asm dataframe.c -o dataframe.s

rem compile from ASM to EXE
gcc dataframe.s -o dataframe.exe
