; Importando variáveis e funções
extern buffer, tamanho_max_buffer, desenha_jogada, xc, yc, rtn, imprime_erro_comando_invalido, imprime_erro_jogada_invalida_vez, imprime_erro_jogada_invalida_pos, limpa_prompt_erro, tamanho_jogada, prompt_vazio, jogador_da_vez, posicoes_do_tabuleiro
; Exportando variáveis e funções funções 
global le_jogada, computa_jogada, verifica_jogada_valida



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
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8   ; Posição horizontal (45: chutando e vendo onde fica melhor)
  add dl, bl   ; Volta o cursor uma unidade p esquerda
  int 0x10     ; Chamada do sistema BIOS

  jmp proximo_caractere

terminou_jogada:
  ; Move o cursor para a direita
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 45   ; Posição horizontal (45: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

  ; Limpa a impressão da jogada anterior antes
  mov dx, prompt_vazio ; String vazia para limpar o prompt
  mov ah, 9            ; Função de exibição de caractere
  int 21h              ; Chamada do sistema

  mov [tamanho_jogada], bx ; Armazena o tamanho da jogada para futura verificação
  mov cx, bx               ; Inicializa contador com o tamanho do buffer
  xor bx, bx               ; Inicializa apontador de caractere no buffer

  ; Move o cursor para a direita de novo
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 45   ; Posição horizontal (45: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS


exibe_caracteres_digitados:
  mov ah, 02h           ; Função de exibição de caractere
  mov dl, [buffer + bx] ; Caractere a ser exibido
  int 21h               ; Chamada do sistema
  inc bx                ; Avançar para o próximo caractere no buffer
  loop exibe_caracteres_digitados

  ; Move o cursor para a esquerda de volta
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8    ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

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


retorno:
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
  cmp ax, 0x03                       ; Comparar com 3
  je tamanho_jogada_valido           ; Se for 3, vai pras proximas validações
  call imprime_erro_comando_invalido ; Se não for 3, imprime erro antes
  mov byte [rtn], 0                  ; Se não for 3, retorna 0
  jmp retorno

tamanho_jogada_valido
  ; Verifica se o primeiro caractere é X ou C
  mov al, [buffer]             ; AL recebe o primeiro caractere da jogada
  cmp al, 0x58                 ; Comparar com X
  je primeiro_caractere_valido ; Se for X, pula para o próximo teste
  cmp al, 0x43                 ; Comparar com C
  je primeiro_caractere_valido ; Se for C, pula para o próximo teste

  mov byte [rtn], 0                  ; Se não for X ou C, retorna 0
  call imprime_erro_comando_invalido ; Se não for X ou C, imprime erro e retorna
  jmp retorno

primeiro_caractere_valido:
  ; Verifica se o segundo caractere é 1, 2 ou 3
  mov al, [buffer + 1]        ; AL recebe o segundo caractere da jogada
  cmp al, 0x31                ; Comparar com 1
  je segundo_caractere_valido ; Se for 1, pula para o próximo teste
  cmp al, 0x32                ; Comparar com 2
  je segundo_caractere_valido ; Se for 2, pula para o próximo teste
  cmp al, 0x33                ; Comparar com 3
  je segundo_caractere_valido ; Se for 3, pula para o próximo teste

  mov byte [rtn], 0                  ; Se não for 1, 2 ou 3, retorna 0
  call imprime_erro_comando_invalido ; Se não for 1, 2 ou 3, imprime erro e retorna
  jmp retorno

segundo_caractere_valido:
  ; Verifica se o terceiro caractere é 1, 2 ou 3
  mov al, [buffer + 2]         ; AL recebe o terceiro caractere da jogada
  cmp al, 0x31                 ; Comparar com 1
  je terceiro_caractere_valido ; Se for 1, pula para o próximo teste
  cmp al, 0x32                 ; Comparar com 2
  je terceiro_caractere_valido ; Se for 2, pula para o próximo teste
  cmp al, 0x33                 ; Comparar com 3
  je terceiro_caractere_valido ; Se for 3, pula para o próximo teste

  mov byte [rtn], 0                  ; Se não for 1, 2 ou 3, retorna 0
  call imprime_erro_comando_invalido ; Se não for 1, 2 ou 3, imprime erro e retorna
  jmp retorno

terceiro_caractere_valido: ; Se chegou até aqui, o comando é válido
  ; Verifica se é a vez do jogador da jogada
  mov al, [buffer]        ; AL recebe o primeiro caractere da jogada
  cmp al, 0x58            ; Comparar com X
  je primeiro_caractere_x ; Se for X, pula para o próximo teste

  cmp al, 0x43            ; Comparar com C
  je primeiro_caractere_c ; Se for C, pula para o próximo teste

primeiro_caractere_x: ; Verifica se é a vez de X
  mov bl, [jogador_da_vez]    ; BL recebe o jogador da vez
  cmp bl, 0                   ; Comparar com 0 - jogador X
  je verifica_posicao_ocupada ; Se for a vez do jogador X, verifica se a posição está ocupada 

  mov byte [rtn], 0                 ; Se não for a vez do jogador X, retorna 0
  call imprime_erro_jogada_invalida_vez ; Se não for a vez do jogador X, imprime erro e retorna
  jmp retorno                       

primeiro_caractere_c: ; Verifica se é a vez de C
  mov bl, [jogador_da_vez]    ; BL recebe o jogador da vez
  cmp bl, 1                   ; Comparar com 1 - jogador C
  je verifica_posicao_ocupada ; Se for a vez do jogador C, verifica se a posição está ocupada

  mov byte [rtn], 0                     ; Se não for a vez do jogador C, retorna 0
  call imprime_erro_jogada_invalida_vez ; Se não for a vez do jogador C, imprime erro e retorna
  jmp retorno

verifica_posicao_ocupada: ; Mesma ideia que a computa_jogada
  ; Limpando registradores
  xor al,al
  xor bl,bl
  xor cl,cl
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

  ; Compara se a jogada é na posicao 11
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
  jmp jogada_valida
  jmp_curto_11:

  ; Compara se a jogada é na posicao 12
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
  jmp jogada_valida
  jmp_curto_22:

  ; Compara se a jogada é na posicao 13
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
  jmp jogada_valida
  jmp_curto_33:

  ; Compara se a jogada é na posicao 21
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
  jmp jogada_valida
  jmp_curto_44:

  ; Compara se a jogada é na posicao 22
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
  jmp jogada_valida
  jmp_curto_55:

  ; Compara se a jogada é na posicao 23
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
  jmp jogada_valida
  jmp_curto_66:

  ; Compara se a jogada é na posicao 31
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
  jmp jogada_valida
  jmp_curto_77:

  ; Compara se a jogada é na posicao 32
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
  jmp jogada_valida
  jmp_curto_88:

  ; Compara se a jogada é na posicao 33
  cmp bl, 0x09
  jne jmp_curto_99
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
  jmp jogada_valida
  jmp_curto_99:

posicao_ocupada:
  mov byte [rtn], 0                     ; Retorna 0
  call imprime_erro_jogada_invalida_pos ; Se a posição já estiver ocupada, imprime erro e retorna
  jmp retorno

jogada_valida:
  ; Faz o toggle da variável jogador_da_vez (passa a vez pro próximo jogador)
  mov bl, [jogador_da_vez] ; BL recebe o jogador da vez
  xor bl, 0x01             ; Faz o toggle do jogador da vez
  mov [jogador_da_vez], bl ; Atualiza o jogador da vez

  call limpa_prompt_erro ; Limpa o prompt de erro
  mov byte [rtn], 1      ; Retorna 1
  
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