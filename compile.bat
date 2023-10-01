@echo off
nasm16 -f obj -o projeto\linec.obj -l projeto\linec.lst projeto\linec.asm
nasm16 -f obj -o projeto\jogo.obj -l projeto\jogo.lst projeto\jogo.asm
nasm16 -f obj -o projeto\desenho.obj -l projeto\desenho.lst projeto\desenho.asm
freelink projeto\jogo projeto\linec projeto\desenho
projeto\jogo.exe