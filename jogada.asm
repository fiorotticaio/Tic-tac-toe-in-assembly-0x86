; Importando variáveis e funções
extern buffer, tamanho_max_buffer, desenha_jogada, xc, yc, rtn, imprime_erro_jogada_invalida, limpa_prompt_erro
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

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 24    ; Posição vertical
  mov dl, 8     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov ah, 02h   ; Função de exibição de caractere
  mov dl, 0x20  ; Caractere de 'branco' para limpar o prompt
  int 21h       ; Chamada do sistema

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 24    ; Posição vertical
  mov dl, 9     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov ah, 02h   ; Função de exibição de caractere
  mov dl, 0x20  ; Caractere de 'branco' para limpar o prompt
  int 21h       ; Chamada do sistema

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 24    ; Posição vertical
  mov dl, 10    ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov ah, 02h   ; Função de exibição de caractere
  mov dl, 0x20  ; Caractere de 'branco' para limpar o prompt
  int 21h       ; Chamada do sistema

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 24    ; Posição vertical
  mov dl, 11    ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov ah, 02h   ; Função de exibição de caractere
  mov dl, 0x20  ; Caractere de 'branco' para limpar o prompt
  int 21h       ; Chamada do sistema


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

  ; Verifica se foi pressionado ENTER
  cmp al, 0x0d       ; Comparar com ENTER (0x0d)
  je terminou_jogada ; Se for ENTER, termina a jogada
  
  mov [buffer + bx], al ; Armazenar o caractere lido no buffer
  inc bx                ; Avançar para o próximo caractere no buffer

  loop le_caractere ; Decrementar o contador de tamanho máximo do buffer


terminou_jogada:
  ; Move o cursor para a direita
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0    ; Página de vídeo (normalmente 0)
  mov dh, 24   ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 45   ; Posição horizontal (45: chutando e vendo onde fica melhor)
  int 0x10     ; Chamada do sistema BIOS

  ; Exibir os caracteres digitados (comando) na tela
  mov ah, 02h          ; Função de exibição de caractere
  mov dl, [buffer]     ; Caractere a ser exibido
  int 21h              ; Chamada do sistema
  mov dl, [buffer + 1] ; Caractere a ser exibido
  int 21h              ; Chamada do sistema
  mov dl, [buffer + 2] ; Caractere a ser exibido
  int 21h              ; Chamada do sistema

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
  sub al, 0x31 ; aqui faz-se [al - (30+1)], usa-se a subtração de 32 para transformar ascii em decimal
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

  ; Verifica se o primeiro caractere é X ou C
  mov al, [buffer]             ; AL recebe o primeiro caractere da jogada
  cmp al, 0x58                 ; Comparar com X
  je primeiro_caractere_valido ; Se for X, pula para o próximo teste
  cmp al, 0x43                 ; Comparar com C
  je primeiro_caractere_valido ; Se for C, pula para o próximo teste

  mov byte [rtn], 0                 ; Se não for X ou C, retorna 0
  call imprime_erro_jogada_invalida ; Se não for X ou C, imprime erro e retorna
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

  mov byte [rtn], 0                 ; Se não for 1, 2 ou 3, retorna 0
  call imprime_erro_jogada_invalida ; Se não for 1, 2 ou 3, imprime erro e retorna
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

  mov byte [rtn], 0                 ; Se não for 1, 2 ou 3, retorna 0
  call imprime_erro_jogada_invalida ; Se não for 1, 2 ou 3, imprime erro e retorna
  jmp retorno

terceiro_caractere_valido:
  ; Se chegou até aqui, a jogada é válida
  call limpa_prompt_erro ; Limpa o prompt de erro
  mov byte [rtn], 1      ; Retorna 1
  
  ; TODO: Verificar se a posição no tabuleiro já está ocupada

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