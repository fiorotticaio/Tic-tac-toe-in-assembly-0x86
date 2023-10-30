; Importando variáveis e funções
extern buffer, tamanho_max_buffer, desenha_jogada, xc, yc, tamanho_jogada, prompt_vazio_jogada, posicoes_do_tabuleiro, jogadas_x, jogadas_c, desenha_diagonal_1, desenha_diagonal_2, desenha_coluna_1, desenha_coluna_2, desenha_coluna_3, desenha_linha_1, desenha_linha_2, desenha_linha_3, cor, jogo_acabou, imprime_erro_jogada_invalida_tam, mensagem_fim_jogo
; Exportando variáveis e funções 
global le_jogada, computa_jogada, verifica_vencedor


; ******************************************************************************
; Função le_jogada
; ******************************************************************************
le_jogada:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  ; Limpando o prompt antes da jogada ser feita
  mov cx, tamanho_max_buffer ; Loop para limpar o prompt
  xor bx, bx                 ; Zera apontador do prompt
  mov bl, 8                  ; Inicializa apontador do prompt

limpa_prompt_leitura:
  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 24    ; Posição vertical
  mov dl, bl    ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov ah, 02h   ; Função de exibição de caractere
  mov dl, 0x20  ; Caractere de le_jogadabranco' para limpar o prompt
  int 21h       ; Chamada do sistema

  inc bl        ; Avançar para a próxima posição

  loop limpa_prompt_leitura ; Decrementar o contador de tamanho máximo do buffer


  ; Configurar posição do cursor pra leitura da jogada
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8    ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

  ; Inicializar contador para tamanho máximo do buffer
  mov cx, tamanho_max_buffer ; Tamanho máximo do buffer determina o loop de leiura de caractere
  xor bx, bx                 ; Inicializa apontador de caractere no buffer


le_caractere:
  ; Ler um caractere do teclado
  mov ah, 0x01 ; Função de leitura de caractere
  int 21h      ; Chamada do sistema

  ; Verifica se foi pressionado BACKSPACE
  cmp al, 0x08   ; Comparar com BACKSPACE (0x08)
  je backspace   ; Se for BACKSPCE, apaga o caracter atual e volta um no cursor

  ; Verifica se foi pressionado ENTER
  cmp al, 0x0d       ; Comparar com ENTER (0x0d)
  je terminou_jogada ; Se for ENTER, termina a jogada

  ; Verifica se passou do limite do prompt (3 caracteres)
  cmp bx, 0x02
  jle continua_lendo
  call imprime_erro_jogada_invalida_tam ; Caso tenha ultrapassado limite, imprima o erro

  push bx ; Empilhando tamanho do comando digitado
  
  ; Move o cursor para a esquerda
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8    ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

  ; Limpa a jogada digitada
  mov dx, prompt_vazio_jogada ; String vazia para limpar o prompt
  mov ah, 9                   ; Função de exibição de caractere
  int 21h                     ; Chamada do sistema

  ; Move o cursor para a esquerda de volta
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8    ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS
  
  pop bx ; Desempilhando tamanho do comando digitado

  xor bx, bx   ; Reinicia o contador de caracteres
  mov cx, tamanho_max_buffer ; Tamanho máximo do buffer determina o loop de leiura de caractere
  jmp proximo_caractere

continua_lendo:
  mov [buffer + bx], al ; Armazenar o caractere lido no buffer
  inc bx                ; Avançar para o próximo caractere no buffer

proximo_caractere:
  loop le_caractere ; Decrementar o contador de tamanho máximo do buffer

backspace:
  mov ah, 02h  ; Função de exibição de caractere
  mov dl, 0x20 ; Caractere de 'branco' para limpar o prompt
  int 21h      ; Chamada do sistema
  
  cmp bx, 0x0  ; Verifica se ainda da pra apagar
  je proximo_caractere

  dec bx       ; Decrementa o contador do cursor

  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical 
  mov dl, 8    ; Posição horizontal 
  add dl, bl   ; Volta o cursor uma unidade p esquerda
  int 0x10     ; Chamada do sistema BIOS

  jmp proximo_caractere

terminou_jogada:

  cmp bx, 0x0              ; Compara se a jogada foi sem nada (apeans enter)
  je jogada_em_branco      ; Caso seja, apenas pule para o final

  mov [tamanho_jogada], bx ; Armazena o tamanho da jogada para futura verificação
  mov cx, bx               ; Inicializa contador com o tamanho do buffer

  ; Move o cursor para a direita
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 45   ; Posição horizontal (45: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

  ; Limpa a impressão da jogada anterior antes
  mov dx, prompt_vazio_jogada ; String vazia para limpar o prompt
  mov ah, 9                   ; Função de exibição de caractere
  int 21h                     ; Chamada do sistema

  ; Move o cursor para a direita de novo
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 45   ; Posição horizontal (45: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS
  
  xor bx, bx               ; Inicializa apontador de caractere no buffer

exibe_caracteres_digitados:
  mov ah, 02h           ; Função de exibição de caractere
  mov byte dl, [buffer + bx] ; Caractere a ser exibido
  int 21h               ; Chamada do sistema
  inc bx                ; Avançar para o próximo caractere no buffer
  loop exibe_caracteres_digitados

  ; Move o cursor para a esquerda de volta
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8    ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

jogada_em_branco:
  ; Recuperando o contexto
  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf

  ret ; Retornar para o programa principal


; ******************************************************************************
; Função computa_jogada
; ******************************************************************************
computa_jogada:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  ; Limpando registradores
  xor al,al
  xor bl,bl
  xor cl,cl

  ; Calcula-se a posicao a partir das coordenadas
  ; coordenadas | calculo de posicao                   |  posicao calculada
  ; 11 12 13    | (1-1)x3+1=1 (1-1)x3+2=2 (1-1)x3+3=3  |  1 2 3  
  ; 21 22 23    | (2-1)x3+1=4 (2-1)x3+2=5 (2-1)x3+3=6  |  4 5 6  
  ; 31 32 33    | (3-1)x3+1=7 (3-1)x3+2=8 (3-1)x3+3=9  |  7 8 9  

  mov byte al, [buffer + 1]
  sub al, 0x31 ; aqui faz-se [al - (30+1)], a subtração de 30 é para transformar ascii em decimal
  mov bl, 0x03
  mul bl
  mov byte bl, [buffer + 2]
  sub bl, 0x30
  add al, bl 
  mov bl, al ; em bl fica o resultado final da posicao calculada (número em decimal)

  ; Compara se a jogada é na posicao 11
  cmp bl, 0x01
  jne jmp_curto_1
  mov word [xc], 220  ; xc
  mov word [yc], 400  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_1:

  ; Compara se a jogada é na posicao 12
  cmp bl, 0x02
  jne jmp_curto_2
  mov word [xc], 320  ; xc
  mov word [yc], 400  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_2:

  ; Compara se a jogada é na posicao 13
  cmp bl, 0x03
  jne jmp_curto_3
  mov word [xc], 420  ; xc
  mov word [yc], 400  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_3:
  
  ; Compara se a jogada é na posicao 21
  cmp bl, 0x04
  jne jmp_curto_4
  mov word [xc], 220  ; xc
  mov word [yc], 300  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_4:

  ; Compara se a jogada é na posicao 22
  cmp bl, 0x05
  jne jmp_curto_5
  mov word [xc], 320  ; xc
  mov word [yc], 300  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_5:

  ; Compara se a jogada é na posicao 23
  cmp bl, 0x06
  jne jmp_curto_6
  mov word [xc], 420  ; xc
  mov word [yc], 300  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_6:

  ; Compara se a jogada é na posicao 31
  cmp bl, 0x07
  jne jmp_curto_7
  mov word [xc], 220  ; xc
  mov word [yc], 200  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_7:

  ; Compara se a jogada é na posicao 32
  cmp bl, 0x08
  jne jmp_curto_8
  mov word [xc], 320  ; xc
  mov word [yc], 200  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_8:

  ; Compara se a jogada é na posicao 33
  cmp bl, 0x09
  jne jmp_curto_9
  mov word [xc], 420  ; xc
  mov word [yc], 200  ; yc
  call desenha_jogada ; chamando funcao de desenhar jogada com parametros: xc, yc, caractere
  jmp_curto_9:

  ; Recuperando o contexto
  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf

  ret ; Retornar para o programa principal


; ******************************************************************************
; Função verifica_vencedor
; ******************************************************************************
verifica_vencedor:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  mov	byte[cor], 4 ; Seta a cor da linha para vermelho

  ; Posições convertidas em binário
  ; 11 - 0 0000 0001
  ; 12 - 0 0000 0010
  ; 13 - 0 0000 0100

  ; 21 - 0 0000 1000
  ; 22 - 0 0001 0000
  ; 23 - 0 0010 0000
  
  ; 31 - 0 0100 0000
  ; 32 - 0 1000 0000
  ; 33 - 1 0000 0000

  ; Possíveis variações de um jogo ganho
  ; 11 + 22 + 33 = 1 0001 0001 Diagonal \
  ; 13 + 22 + 31 = 0 0101 0100 Diagonal /

  ; 11 + 21 + 31 = 0 0100 1001 Coluna 1
  ; 12 + 22 + 32 = 0 1001 0010 Coluna 2
  ; 13 + 23 + 33 = 1 0010 0100 Coluna 3

  ; 11 + 12 + 13 = 0 0000 0111 Linha 1
  ; 21 + 22 + 23 = 0 0011 1000 Linha 2
  ; 31 + 32 + 33 = 1 1100 0000 Linha 3

  ; Limpando registrador
  xor dx,dx

  ; =========================== Verificando vencedor X ===========================

  ; Diagonal \
  mov dx, [jogadas_x]
  and dx, 0x111
  cmp dx, 0x111
  jne jmp_curto_100
  call desenha_diagonal_1
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_100:

  ; Diagonal /
  mov dx, [jogadas_x]
  and dx, 0x54
  cmp dx, 0x54
  jne jmp_curto_101
  call desenha_diagonal_2
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_101:

  ; Coluna 1
  mov dx, [jogadas_x]
  and dx, 0x49
  cmp dx, 0x49
  jne jmp_curto_102
  call desenha_coluna_1
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_102:

  ; Coluna 2
  mov dx, [jogadas_x]
  and dx, 0x92
  cmp dx, 0x92
  jne jmp_curto_103
  call desenha_coluna_2
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_103:

  ; Coluna 3
  mov dx, [jogadas_x]
  and dx, 0x124
  cmp dx, 0x124
  jne jmp_curto_104
  call desenha_coluna_3
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_104:

  ; Linha 1
  mov dx, [jogadas_x]
  and dx, 0x07
  cmp dx, 0x07
  jne jmp_curto_105
  call desenha_linha_1
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_105:

  ; Linha 2
  mov dx, [jogadas_x]
  and dx, 0x38
  cmp dx, 0x38
  jne jmp_curto_106
  call desenha_linha_2
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_106:

  ; Linha 3
  mov dx, [jogadas_x]
  and dx, 0x1C0
  cmp dx, 0x1C0
  jne jmp_curto_107
  call desenha_linha_3
  mov byte[jogo_acabou], 0x01 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_107:

  ; =========================== Verificando vencedor C ===========================

  ; Diagonal  \
  mov dx, [jogadas_c]
  and dx, 0x111
  cmp dx, 0x111
  jne jmp_curto_108
  call desenha_diagonal_1
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_108:
  
  ; Diagonal /
  mov dx, [jogadas_c]
  and dx, 0x54
  cmp dx, 0x54
  jne jmp_curto_109
  call desenha_diagonal_2
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_109:

  ; Coluna 1
  mov dx, [jogadas_c]
  and dx, 0x49
  cmp dx, 0x49
  jne jmp_curto_110
  call desenha_coluna_1
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_110:

  ; Coluna 2
  mov dx, [jogadas_c]
  and dx, 0x92
  cmp dx, 0x92
  jne jmp_curto_111
  call desenha_coluna_2
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_111:

  ; Coluna 3
  mov dx, [jogadas_c]
  and dx, 0x124
  cmp dx, 0x124
  jne jmp_curto_112
  call desenha_coluna_3
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_112:

  ; Linha 1
  mov dx, [jogadas_c]
  and dx, 0x07
  cmp dx, 0x07
  jne jmp_curto_113
  call desenha_linha_1
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_113:

  ; Linha 2
  mov dx, [jogadas_c]
  and dx, 0x38
  cmp dx, 0x38
  jne jmp_curto_114
  call desenha_linha_2
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_114:

  ; Linha 3
  mov dx, [jogadas_c]
  and dx, 0x1C0
  cmp dx, 0x1C0
  jne jmp_curto_115
  call desenha_linha_3
  mov byte[jogo_acabou], 0x02 ; Atualiza flag de jogo terminado
  jmp ultimo_jump
  jmp_curto_115:

  ; =========================== Empate ===========================
  mov dx, [posicoes_do_tabuleiro]
  cmp dx, 0x1FF
  jne ultimo_jump
  mov byte[jogo_acabou], 0x03 ; Atualiza flag de jogo terminado
  ultimo_jump:

  mov	byte[cor], 7 ; Seta a cor da linha para branco

  mov byte dl, [jogo_acabou]
  cmp dl, 0x0
  je pula_prompt
  call mensagem_fim_jogo
  pula_prompt:

  ; Recuperando o contexto
  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf

  ret ; Retornar para o programa principal