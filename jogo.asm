; Caio Alves Fiorotti - ELE15942 05.1N SISTEMAS EMBARCADOS I 
; Matheus Meier Schreiber - ELE15942 05.1N SISTEMAS EMBARCADOS I


; Importando funções
extern desenha_tabuleiro, le_jogada, computa_jogada, verifica_jogada_valida, verifica_vencedor, mensagem_fim_jogo, mensagem_inicial
; Exportando variáveis
global cor, buffer, tamanho_max_buffer, xc, yc, rtn, prompt_comando_invalido, prompt_jogada_invalida_vez, prompt_jogada_invalida_pos, prompt_vazio_erro, prompt_vazio_jogada, tamanho_jogada, jogador_da_vez, posicoes_do_tabuleiro, jogadas_x, jogadas_c, jogo_acabou, prompt_fim_jogo, prompt_inicial, prompt_jogada_invalida_tam


segment codigo
..start:
  ; Inicialização dos registradores de segmento e stack pointer 
  xor bx, bx         ; Limpa BX
  xor ax, ax         ; Limpa AX
  mov ax, dados      ; Move o endereço do segmento de dados para AX
  mov ds, ax         ; Move o endereço do segmento de dados para DS
  mov ax, pilha      ; Move o endereço do segmento de pilha para AX
  mov ss, ax         ; Move o endereço do segmento de pilha para SS
  mov sp, topo_pilha ; Move o endereço do topo da pilha para SP


cria_novo_jogo:
  ; Resetando as variáveis
  mov byte [jogador_da_vez], 0
  mov byte [posicoes_do_tabuleiro], 0
  mov byte [posicoes_do_tabuleiro + 1], 0
  mov byte [jogo_acabou], 0
  mov byte [jogadas_x], 0
  mov byte [jogadas_x+1], 0
  mov byte [jogadas_c], 0
  mov byte [jogadas_c+1], 0
  mov byte [rtn], 1

  ; Salvar modo corrente de video (vendo como está o modo de video da maquina)
	mov ah, 0x0f
	int 0x10
	mov [modo_anterior], al   

  ; Alterar modo de video para gráfico 640x480 16 cores
	mov al, 0x12
	mov ah, 0
	int 0x10

  call desenha_tabuleiro ; Desenha o tabuleiro

  call mensagem_inicial ; Escreve prompt de boas vindas

  jmp faz_jogada

exit:
  mov ah, 0               ; Seta o modo de vídeo
	mov al, [modo_anterior] ; Recupera o modo anterior
	int 0x10

  mov ax, 0x4c00 ; Move o valor 0x4c00 para AX (parâmetro que finaliza o programa na inetrrupção 0x21)
  int 0x21       ; Chama a interrupção 0x21

faz_jogada:
  call le_jogada ; Lê a jogada do usuário

  ; Verifica se a primeira posição do buffer é igual a 's' (sair)
  mov byte al, [buffer] 
  cmp al, 's'
  je exit ; Se for 's', pula para o fim do programa
  
  ; Verifica se a primeira posição do buffer é igual a 'c' (novo jogo)
  cmp al, 'c'
  je cria_novo_jogo ; Se for, pula para o início do programa

  ; Verifica se o jogo acabou, caso tenha acabado, nao realize a jogada, mas continue o loop
  mov dl, [jogo_acabou]
  cmp dl, 1
  je faz_jogada ; Continua o jogo

  call verifica_jogada_valida ; Verifica se a jogada é válida
  mov byte bl, [rtn]          ; Move o retorno da função para BL
  cmp bl, 0                   ; Comparação para ver se a jogada é válida
  je faz_jogada               ; Se a jogada for inválida, volta o loop e faz outra jogada

  call computa_jogada  ; Computa a jogada digitada pelo usuario (já validada)

  ; call verifica_vencedor ; Verifica se houve vencedor apos a jogada

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

  ; TODO: talvez tenha que inicializar esses vetores aqui
  buffer resb 10             ; Buffer para armazenar os caracteres das jogadas
  tamanho_max_buffer equ 10  ; Tamanho máximo do buffer
  tamanho_jogada resb 2      ; Guarda o tamanho da jogada digitada
  
  xc resb 4  ; Posicao x da jogada
  yc resb 4  ; Posicao y da jogada

  rtn resb 1  ; Retorno de função

  prompt_inicial db "Bem-vindo!$", 0 ; 0 no final para indicar o fim da string
  prompt_comando_invalido db "Comando Invalido$", 0
  prompt_jogada_invalida_vez db "Jogada Invalida - Vez do outro jogador$", 0
  prompt_jogada_invalida_pos db "Jogada Invalida - Posicao ja ocupada$", 0
  prompt_jogada_invalida_tam db "Jogada Invalida - Tamanho muito grande$", 0
  prompt_vazio_erro db "                                      $", 0
  prompt_vazio_jogada db "           $", 0 ; Menor para não estragar a caixa de mensagens
  prompt_fim_jogo db "Jogo terminado!$", 0 ; String final quando uma partida acaba

  jogador_da_vez db 0 ; 0 para o jogador X e 1 para o jogador C
  jogo_acabou db 0 ; 0 para jogo ainda em andamento e 1 para jogo terminado

  posicoes_do_tabuleiro resb 2 ; Cada bit representa uma posição (8 bits do primeiro byte + 1 bit do segundo)
  jogadas_x resb 2 ; Cada bit ligado representa uma posição onde tem uma jogada X
  jogadas_c resb 2 ; Cada bit ligado representa uma posição onde tem uma jogada C
  


segment pilha pilha
  resb 512 ; Reserva 512 bytes para a pilha
topo_pilha: