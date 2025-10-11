# install C graphics lib
pacman -S mingw-w64-ucrt-x86_64-freeglut

# compile to assembly
gcc -S -O2 -masm=intel -fverbose-asm rcube.c -o rcube.s -lfreeglut -lopengl32 -lglu32

# 1) Assemble to object
gcc -c rcube.s -o rcube.o

# 2) Link with GLUT/OpenGL libs to make an .exe
gcc rcube.o -o rcube.exe -lfreeglut -lopengl32 -lglu32
