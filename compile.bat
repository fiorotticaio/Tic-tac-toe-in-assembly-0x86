@echo off
nasm16 -f obj -o OBJ\projeto\linec.obj -l LST\projeto\linec.lst linec.asm
nasm16 -f obj -o OBJ\projeto\jogo.obj -l LST\projeto\jogo.lst jogo.asm
freelink obj\projeto\jogo obj\projeto\linec,o
echo "\n"