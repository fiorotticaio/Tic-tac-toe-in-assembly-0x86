; Caio Alves Fiorotti - ELE15942 05.1N SISTEMAS EMBARCADOS I 
; Matheus Meier Schreiber - ELE15942 05.1N SISTEMAS EMBARCADOS I


; Importando funções
extern desenha_tabuleiro, le_jogada, computa_jogada, verifica_jogada_valida
; Exportando variáveis
global cor, buffer, tamanho_max_buffer, xc, yc, rtn


segment codigo
..start:
  ; Inicialização dos registradores de segmento e stack pointer 
  xor ax, ax ; Limpa AX
  mov ax, dados ; Move o endereço do segmento de dados para AX
  mov ds, ax ; Move o endereço do segmento de dados para DS
  mov ax, pilha ; Move o endereço do segmento de pilha para AX
  mov ss, ax ; Move o endereço do segmento de pilha para SS
  mov sp, topo_pilha ; Move o endereço do topo da pilha para SP

  xor bx, bx

cria_novo_jogo:
  ; Salvar modo corrente de video (vendo como está o modo de video da maquina)
	mov ah, 0x0f
	int 0x10
	mov [modo_anterior], al   

  ; Alterar modo de video para gráfico 640x480 16 cores
	mov al, 0x12
	mov ah, 0
	int 0x10

  call desenha_tabuleiro ; Desenha o tabuleiro
  jmp faz_jogada

exit:
  mov ah, 0 ; Seta o modo de vídeo
	mov al, [modo_anterior] ; Recupera o modo anterior
	int 0x10

  mov ax, 0x4c00 ; Move o valor 0x4c00 para AX (parâmetro que finaliza o programa na inetrrupção 0x21)
  int 0x21 ; Chama a interrupção 0x21

faz_jogada:
  call le_jogada ; Lê a jogada do usuário

  ; Verifica se a primeira posição do buffer é igual a 's' (sair)
  mov byte al, [buffer] 
  cmp al, 's'
  je exit ; Se for 's', pula para o fim do programa
  
  ; Verifica se a primeira posição do buffer é igual a 'c' (novo jogo)
  cmp al, 'c'
  je cria_novo_jogo ; Se for, pula para o início do programa

  call verifica_jogada_valida ; Verifica se a jogada é válida
  mov byte bl, [rtn] ; Move o retorno da função para BL
  cmp bl, 0 ; Se a jogada for inválida, faz outra jogada
  je faz_jogada

  call computa_jogada

  ; TODO: Verifica se alguem venceu
  
  jmp faz_jogada ; Continua o jogo


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

  ; FIXME: Promp exibe bom os caracteres tudo bugado
  ; prompt db "Digite o comando: $", 0 ; 0 no final para indicar o fim da string
  buffer resb 4  ; Buffer para armazenar os caracteres das jogadas
  tamanho_max_buffer equ 4  ; Tamanho máximo do buffer
  
  xc resb 4  ; Posicao x da jogada
  yc resb 4  ; Posicao y da jogada

  rtn resb 1  ; Retorno da função


segment pilha pilha
  resb 512 ; Reserva 512 bytes para a pilha
topo_pilha: