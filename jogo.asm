; Caio Alves Fiorotti - ELE15942 05.1N SISTEMAS EMBARCADOS I 
; Matheus Meier Schreiber - ELE15942 05.1N SISTEMAS EMBARCADOS I

; Exportando variáveis
global cor

; Importação de funções
extern line

segment codigo

..start:
  ; Inicialização dos registradores de segmento e stack pointer 
  xor ax, ax ; Limpa AX
  mov ax, dados ; Move o endereço do segmento de dados para AX
  mov ds, ax ; Move o endereço do segmento de dados para DS
  mov ax, pilha ; Move o endereço do segmento de pilha para AX
  mov ss, ax ; Move o endereço do segmento de pilha para SS
  mov sp, topo_pilha ; Move o endereço do topo da pilha para SP

  ; Salvar modo corrente de video(vendo como está o modo de video da maquina)
	mov ah, 0x0f
	int 0x10
	mov [modo_anterior], al   

  ; Alterar modo de video para gráfico 640x480 16 cores
	mov al, 0x12
	mov ah, 0
	int 0x10

  call desenha_tabuleiro

  mov ah, 0x08
  int 21h
  jmp exit ; Pula para o fim do programa


desenha_tabuleiro:
  ; Desenha primiera linha
  mov	byte[cor], branco
  mov	ax, 0
  push ax
  mov	ax, 159
  push ax
  mov	ax, 639
  push ax
  mov	ax, 159
  push ax
  call line

  ; Desenha segunda linha

  ret




exit:
  mov ah, 0 ; set video mode
	mov al, [modo_anterior] ; recupera o modo anterior
	int 10h

  mov ax, 0x4c00 ; Move o valor 0x4c00 para AX (parâmetro que finaliza o programa na inetrrupção 0x21)
  int 0x21 ; Chama a interrupção 0x21







segment dados
  cor db 0 ; inicializa com cor preta
  ; Cores
  preto equ 0
  azul equ 1
  verde equ 2
  cyan equ 3
  vermelh equ 4
  magenta equ 5
  marrom equ 6
  branco equ 7
  cinza equ 8
  azul_clar equ 9
  verde_clar equ 10
  cyan_clar equ 11
  rosa equ 12
  magenta_clar equ 13
  amarelo equ 14
  branco_intens equ 15

  modo_anterior	db 0


segment pilha pilha
  resb 512 ; Reserva 512 bytes para a pilha
topo_pilha: