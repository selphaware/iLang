gcc -std=c99 -O2 -Wall -Wextra remineon.c \
  -I/ucrt64/include/SDL2 -L/ucrt64/lib \
  -lmingw32 -lSDL2main -lSDL2 -lSDL2_ttf -mwindows \
  -o remineon.exe
