@echo off
nasm16 -f obj -o projeto\linec.obj -l projeto\linec.lst projeto\linec.asm
nasm16 -f obj -o projeto\jogo.obj -l projeto\jogo.lst projeto\jogo.asm
nasm16 -f obj -o projeto\desenho.obj -l projeto\desenho.lst projeto\desenho.asm
nasm16 -f obj -o projeto\jogada.obj -l projeto\jogada.lst projeto\jogada.asm
nasm16 -f obj -o projeto\erro.obj -l projeto\erro.lst projeto\erro.asm
freelink projeto\jogo projeto\linec projeto\desenho projeto\jogada projeto\erro
@REM projeto\jogo.exe