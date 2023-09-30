; Caio Alves Fiorotti - ELE15942 05.1N SISTEMAS EMBARCADOS I 
; Matheus Meier Schreiber - ELE15942 05.1N SISTEMAS EMBARCADOS I


; Exportando variáveis
global cor
; Importando funções
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

  ; Salvar modo corrente de video (vendo como está o modo de video da maquina)
	mov ah, 0x0f
	int 0x10
	mov [modo_anterior], al   

  ; Alterar modo de video para gráfico 640x480 16 cores
	mov al, 0x12
	mov ah, 0
	int 0x10

  call desenha_tabuleiro ; Desenha o tabuleiro

  ; Lê um caractere da entrada padrão
  mov ah, 0x08
  int 21h ; Só sai dali quando ler algum caractere da entrada padrão
  jmp exit ; Pula para o fim do programa


desenha_tabuleiro:
  mov	byte[cor], branco ; Seta a cor da linha para branco

  ; Desenha primiera linha horizontal
  mov	ax, 170
  push ax
  mov	ax, 350
  push ax
  mov	ax, 470
  push ax
  mov	ax, 350
  push ax
  call line

  ; Desenha segunda linha horizontal
  mov	ax, 170
  push ax
  mov	ax, 250
  push ax
  mov	ax, 470
  push ax
  mov	ax, 250
  push ax
  call line

  ; Desenha primeira linha vertical
  mov	ax, 270
  push ax
  mov	ax, 450
  push ax
  mov	ax, 270
  push ax
  mov	ax, 150
  push ax
  call line

  ; Desenha segunda linha vertical
  mov	ax, 370
  push ax
  mov	ax, 450
  push ax
  mov	ax, 370
  push ax
  mov	ax, 150
  push ax
  call line


  ; Desenhando campo de comando
  mov byte[cor], cyan ; Setaando a cor da linha para ciano
  ; Desenhando a linha de cima
  mov	ax, 50
  push ax
  mov	ax, 100
  push ax
  mov	ax, 590
  push ax
  mov	ax, 100
  push ax
  call line

  ; Desenhando a linha de baixo
  mov	ax, 50
  push ax
  mov	ax, 70
  push ax
  mov	ax, 590
  push ax
  mov	ax, 70
  push ax
  call line

  ; Desenhando a linha da esquerda
  mov	ax, 50
  push ax
  mov	ax, 100
  push ax
  mov	ax, 50
  push ax
  mov	ax, 70
  push ax
  call line

  ; Desenhando a linha da direita
  mov	ax, 590
  push ax
  mov	ax, 100
  push ax
  mov	ax, 590
  push ax
  mov	ax, 70
  push ax
  call line


  ; Desenhando campo de mensagens
  ; Desenhando a linha de cima
  mov	ax, 50
  push ax
  mov	ax, 50
  push ax
  mov	ax, 590
  push ax
  mov	ax, 50
  push ax
  call line

  ; Desenhando a linha de baixo
  mov	ax, 50
  push ax
  mov	ax, 20
  push ax
  mov	ax, 590
  push ax
  mov	ax, 20
  push ax
  call line

  ; Desenhando a linha da esquerda
  mov	ax, 50
  push ax
  mov	ax, 50
  push ax
  mov	ax, 50
  push ax
  mov	ax, 20
  push ax
  call line

  ; Desenhando a linha da direita
  mov	ax, 590
  push ax
  mov	ax, 50
  push ax
  mov	ax, 590
  push ax
  mov	ax, 20
  push ax
  call line

  ret ; Retorna da função



exit:
  mov ah, 0 ; Seta o modo de vídeo
	mov al, [modo_anterior] ; Recupera o modo anterior
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