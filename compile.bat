@echo off
nasm16 -f obj -o projeto\linec.obj -l projeto\linec.lst projeto\linec.asm
nasm16 -f obj -o projeto\jogo.obj -l projeto\jogo.lst projeto\jogo.asm
freelink projeto\jogo projeto\linec
projeto\jogo.exe