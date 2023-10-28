; Importando variáveis e funções
extern buffer, tamanho_max_buffer, desenha_jogada, xc, yc, rtn, imprime_erro_comando_invalido, imprime_erro_jogada_invalida_vez, imprime_erro_jogada_invalida_pos, limpa_prompt_erro, tamanho_jogada, prompt_vazio_jogada, jogador_da_vez, posicoes_do_tabuleiro, jogadas_x, jogadas_c, desenha_diagonal_1, desenha_diagonal_2, desenha_coluna_1, desenha_coluna_2, desenha_coluna_3, desenha_linha_1, desenha_linha_2, desenha_linha_3, cor, jogo_acabou, prompt_fim_jogo_emp, prompt_fim_jogo_x, prompt_fim_jogo_c, prompt_inicial, prompt_vazio_erro, imprime_erro_jogada_invalida_tam
; Exportando variáveis e funções funções 
global le_jogada, computa_jogada, verifica_jogada_valida, verifica_vencedor, mensagem_fim_jogo, mensagem_inicial



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
  mov dl, 0x20  ; Caractere de 'branco' para limpar o prompt
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

  cmp bx, 0x0
  je jogada_em_branco

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
; Função verifica_jogada_valida
; ******************************************************************************
verifica_jogada_valida:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  ; Verifica se foram digitados apenas 3 caracteres
  mov ax, [tamanho_jogada]           ; AX recebe o tamanho da jogada
  cmp ax, 0x03                       ; Comparar com tamanho 4 pois são tres posições com caracteres mais o 'enter' (0, 1, 2, 3)
  je tamanho_jogada_valido           ; Se for 3, vai pras proximas validações
  call imprime_erro_comando_invalido ; Se não for 3, imprime erro antes
  mov byte [rtn], 0                  ; Se não for 3, retorna 0
  jmp retorno_jogada_eh_invalida

tamanho_jogada_valido:
  ; Verifica se o primeiro caractere é X ou C
  mov byte al, [buffer]             ; AL recebe o primeiro caractere da jogada
  cmp al, 0x58                 ; Comparar com X
  je primeiro_caractere_valido ; Se for X, pula para o próximo teste
  cmp al, 0x43                 ; Comparar com C
  je primeiro_caractere_valido ; Se for C, pula para o próximo teste

  mov byte [rtn], 0                  ; Se não for X ou C, retorna 0
  call imprime_erro_comando_invalido ; Se não for X ou C, imprime erro e retorna
  jmp retorno_jogada_eh_invalida

primeiro_caractere_valido:
  ; Verifica se o segundo caractere é 1, 2 ou 3
  mov byte al, [buffer + 1]        ; AL recebe o segundo caractere da jogada
  cmp al, 0x31                ; Comparar com 1
  je segundo_caractere_valido ; Se for 1, pula para o próximo teste
  cmp al, 0x32                ; Comparar com 2
  je segundo_caractere_valido ; Se for 2, pula para o próximo teste
  cmp al, 0x33                ; Comparar com 3
  je segundo_caractere_valido ; Se for 3, pula para o próximo teste

  mov byte [rtn], 0                  ; Se não for 1, 2 ou 3, retorna 0
  call imprime_erro_comando_invalido ; Se não for 1, 2 ou 3, imprime erro e retorna
  jmp retorno_jogada_eh_invalida

segundo_caractere_valido:
  ; Verifica se o terceiro caractere é 1, 2 ou 3
  mov byte al, [buffer + 2]         ; AL recebe o terceiro caractere da jogada
  cmp al, 0x31                 ; Comparar com 1
  je terceiro_caractere_valido ; Se for 1, pula para o próximo teste
  cmp al, 0x32                 ; Comparar com 2
  je terceiro_caractere_valido ; Se for 2, pula para o próximo teste
  cmp al, 0x33                 ; Comparar com 3
  je terceiro_caractere_valido ; Se for 3, pula para o próximo teste

  mov byte [rtn], 0                  ; Se não for 1, 2 ou 3, retorna 0
  call imprime_erro_comando_invalido ; Se não for 1, 2 ou 3, imprime erro e retorna
  jmp retorno_jogada_eh_invalida

terceiro_caractere_valido: ; Se chegou até aqui, o comando é válido
  ; Verifica se é a vez do jogador da jogada
  mov byte al, [buffer]        ; AL recebe o primeiro caractere da jogada
  cmp al, 'X'            ; Comparar com X
  je primeiro_caractere_x ; Se for X, pula para o próximo teste

  cmp al, 'C'            ; Comparar com C
  je primeiro_caractere_c ; Se for C, pula para o próximo teste

primeiro_caractere_x: ; Verifica se é a vez de X
  mov byte bl, [jogador_da_vez]    ; BL recebe o jogador da vez
  cmp bl, 0                   ; Comparar com 0 - jogador X
  je verifica_posicao_ocupada ; Se for a vez do jogador X, verifica se a posição está ocupada 

  mov byte [rtn], 0                 ; Se não for a vez do jogador X, retorna 0
  call imprime_erro_jogada_invalida_vez ; Se não for a vez do jogador X, imprime erro e retorna
  jmp retorno_jogada_eh_invalida                       

primeiro_caractere_c: ; Verifica se é a vez de C
  mov byte bl, [jogador_da_vez]    ; BL recebe o jogador da vez
  cmp bl, 1                   ; Comparar com 1 - jogador C
  je verifica_posicao_ocupada ; Se for a vez do jogador C, verifica se a posição está ocupada

  mov byte [rtn], 0                     ; Se não for a vez do jogador C, retorna 0
  call imprime_erro_jogada_invalida_vez ; Se não for a vez do jogador C, imprime erro e retorna
  jmp retorno_jogada_eh_invalida

retorno_jogada_eh_invalida:
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

verifica_posicao_ocupada: ; Mesma ideia que a computa_jogada
  ; Limpando registradores
  xor ax,ax
  xor bx,bx
  xor cx,cx
  xor dx, dx

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
  
  ; =============== Compara se a jogada é na posicao 11 ===============
  cmp bl, 0x01
  jne jmp_curto_11
  ; Verifica se a posicao 11 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x01 ; 0000 0001
  cmp dx, 0x01
  jne marca_posicao_11
  jmp posicao_ocupada
  ; Marca a posicao 11 como jogada
  marca_posicao_11:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x01
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 11
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_11
  atualiza_x_11:
  mov dx, [jogadas_x]
  or dx, 0x01
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_11:
  mov dx, [jogadas_c]
  or dx, 0x01
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_11:

  ; =============== Compara se a jogada é na posicao 12 ===============
  cmp bl, 0x02
  jne jmp_curto_22
  ; Verifica se a posicao 12 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x02 ; 0000 0010
  cmp dx, 0x02
  jne marca_posicao_12
  jmp posicao_ocupada
  ; Marca a posicao 12 como jogada
  marca_posicao_12:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x02
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 12
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_12
  atualiza_x_12:
  mov dx, [jogadas_x]
  or dx, 0x02
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_12:
  mov dx, [jogadas_c]
  or dx, 0x02
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_22:

  ; =============== Compara se a jogada é na posicao 13 ===============
  cmp bl, 0x03
  jne jmp_curto_33
  ; Verifica se a posicao 13 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x04 ; 0000 0100
  cmp dx, 0x04
  jne marca_posicao_13
  jmp posicao_ocupada
  ; Marca a posicao 13 como jogada
  marca_posicao_13:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x04
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 13
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_13
  atualiza_x_13:
  mov dx, [jogadas_x]
  or dx, 0x04
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_13:
  mov dx, [jogadas_c]
  or dx, 0x04
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_33:

  ; =============== Compara se a jogada é na posicao 21 ===============
  cmp bl, 0x04
  jne jmp_curto_44
  ; Verifica se a posicao 21 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x08 ; 0000 1000
  cmp dx, 0x08
  jne marca_posicao_21
  jmp posicao_ocupada
  ; Marca a posicao 21 como jogada
  marca_posicao_21:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x08
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 21
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_21
  atualiza_x_21:
  mov dx, [jogadas_x]
  or dx, 0x08
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_21:
  mov dx, [jogadas_c]
  or dx, 0x08
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_44:

  ; =============== Compara se a jogada é na posicao 22 ===============
  cmp bl, 0x05
  jne jmp_curto_55
  ; Verifica se a posicao 22 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x10 ; 0001 0000
  cmp dx, 0x10
  jne marca_posicao_22
  jmp posicao_ocupada
  ; Marca a posicao 22 como jogada
  marca_posicao_22:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x10
  mov [posicoes_do_tabuleiro], dx
  
  ; Atualizando os bytes de jogadas X ou C na posição 22
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_22
  atualiza_x_22:
  mov dx, [jogadas_x]
  or dx, 0x10
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_22:
  mov dx, [jogadas_c]
  or dx, 0x10
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_55:

  ; =============== Compara se a jogada é na posicao 23 ===============
  cmp bl, 0x06
  jne jmp_curto_66
  ; Verifica se a posicao 23 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x20 ; 0010 0000
  cmp dx, 0x20
  jne marca_posicao_23
  jmp posicao_ocupada
  ; Marca a posicao 23 como jogada
  marca_posicao_23:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x20
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 23
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_23
  atualiza_x_23:
  mov dx, [jogadas_x]
  or dx, 0x20
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_23:
  mov dx, [jogadas_c]
  or dx, 0x20
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_66:

  ; =============== Compara se a jogada é na posicao 31 ===============
  cmp bl, 0x07
  jne jmp_curto_77
  ; Verifica se a posicao 31 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x40 ; 0100 0000
  cmp dx, 0x40
  jne marca_posicao_31
  jmp posicao_ocupada
  ; Marca a posicao 31 como jogada
  marca_posicao_31:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x40
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 31
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_31
  atualiza_x_31:
  mov dx, [jogadas_x]
  or dx, 0x40
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_31:
  mov dx, [jogadas_c]
  or dx, 0x40
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_77:

  ; =============== Compara se a jogada é na posicao 32 ===============
  cmp bl, 0x08
  jne jmp_curto_88
  ; Verifica se a posicao 32 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x80 ; 1000 0000
  cmp dx, 0x80
  jne marca_posicao_32
  jmp posicao_ocupada
  ; Marca a posicao 32 como jogada
  marca_posicao_32:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x80
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 32
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_32
  atualiza_x_32:
  mov dx, [jogadas_x]
  or dx, 0x80
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_32:
  mov dx, [jogadas_c]
  or dx, 0x80
  mov [jogadas_c], dx
  jmp jogada_valida
  jmp_curto_88:

  ; =============== Compara se a jogada é na posicao 33 ===============
  cmp bl, 0x09
  jne jogada_valida
  ; Verifica se a posicao 33 já foi jogada
  mov dx, [posicoes_do_tabuleiro]
  and dx, 0x100 ; 0001 0000 0000
  cmp dx, 0x100
  jne marca_posicao_33
  jmp posicao_ocupada
  ; Marca a posicao 33 como jogada
  marca_posicao_33:
  mov dx, [posicoes_do_tabuleiro]
  or dx, 0x100
  mov [posicoes_do_tabuleiro], dx

  ; Atualizando os bytes de jogadas X ou C na posição 33
  mov byte bl, [jogador_da_vez] 
  cmp bl, 0 ; verificando se é X
  jne atualiza_c_33
  atualiza_x_33:
  mov dx, [jogadas_x]
  or dx, 0x100
  mov [jogadas_x], dx
  jmp jogada_valida
  atualiza_c_33:
  mov dx, [jogadas_c]
  or dx, 0x100
  mov [jogadas_c], dx
  jmp jogada_valida

posicao_ocupada:
  mov byte [rtn], 0                     ; Retorna 0
  call imprime_erro_jogada_invalida_pos ; Se a posição já estiver ocupada, imprime erro e retorna
  jmp retorno_jogada_marcada

jogada_valida:
  ; Faz o toggle da variável jogador_da_vez (passa a vez pro próximo jogador)
  mov byte bl, [jogador_da_vez] ; BL recebe o jogador da vez
  xor bl, 0x01             ; Faz o toggle do jogador da vez
  mov [jogador_da_vez], bl ; Atualiza o jogador da vez

  call limpa_prompt_erro ; Limpa o prompt de erro
  mov byte [rtn], 1      ; Retorna 1
  
retorno_jogada_marcada:
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

mensagem_fim_jogo:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp
  
  call limpa_prompt_erro ; Limpa o prompt de mensagens antes de imprimir qualquer coisa

  ; Coloca o cursor no lugar
  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 27    ; Posição vertical
  mov dl, 8     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  xor dx, dx
  mov byte dl, [jogo_acabou]

  ; Imprimindo que o X ganhou
  x_eh_ganhador:
  cmp dl, 0x01
  jne c_eh_ganhador ; Continua o jogo
  mov dx, prompt_fim_jogo_x ; String de fim de jogo
  jmp imprime_fim_jogo
  
  ; Imprimindo que o C ganhou
  c_eh_ganhador:
  cmp dl, 0x02
  jne eh_empate ; Continua o jogo
  mov dx, prompt_fim_jogo_c ; String de fim de jogo
  jmp imprime_fim_jogo
  
  ; Imprimindo empate
  eh_empate:
  mov dx, prompt_fim_jogo_emp ; String de fim de jogo
  
  imprime_fim_jogo:
  mov ah, 9                   ; Função de exibição de caractere
  int 21h                     ; Chamada do sistema
  
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
  
mensagem_inicial:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp
  
  call limpa_prompt_erro ; Limpa o prompt de mensagens antes de imprimir qualquer coisa

  ; Coloca o cursor no lugar
  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 27    ; Posição vertical
  mov dl, 8     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  ; Limpa a impressão da jogada anterior antes
  mov dx, prompt_inicial ; String de boas vindas
  mov ah, 9              ; Função de exibição de caractere
  int 21h                ; Chamada do sistema

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