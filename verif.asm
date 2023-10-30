; Exportando funções
global verifica_jogada_valida
; Importando variáveis e funções
extern tamanho_jogada, imprime_erro_comando_invalido, jogador_da_vez, rtn, buffer, imprime_erro_jogada_invalida_vez, posicoes_do_tabuleiro, jogadas_x, jogadas_c, imprime_erro_jogada_invalida_pos, limpa_prompt_erro


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