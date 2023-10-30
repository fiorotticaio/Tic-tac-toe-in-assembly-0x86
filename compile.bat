@echo off
nasm16 -f obj -o projeto\linec.obj -l projeto\linec.lst projeto\linec.asm
nasm16 -f obj -o projeto\jogo.obj -l projeto\jogo.lst projeto\jogo.asm
nasm16 -f obj -o projeto\desenho.obj -l projeto\desenho.lst projeto\desenho.asm
nasm16 -f obj -o projeto\jogada.obj -l projeto\jogada.lst projeto\jogada.asm
nasm16 -f obj -o projeto\erro.obj -l projeto\erro.lst projeto\erro.asm
nasm16 -f obj -o projeto\mensag.obj -l projeto\mensag.lst projeto\mensag.asm
nasm16 -f obj -o projeto\verif.obj -l projeto\verif.lst projeto\verif.asm
freelink projeto\jogo projeto\linec projeto\desenho projeto\jogada projeto\erro projeto\mensag projeto\verif
@REM projeto\jogo.exe