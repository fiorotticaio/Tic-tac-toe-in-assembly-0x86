; Importando variáveis
extern buffer, tamanho_max_buffer
; Exportando funções
global le_jogada


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

  ; Configurar posição do cursor
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0 ; Página de vídeo (normalmente 0)
  mov dh, 24 ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8 ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10 ; Chamada do sistema BIOS

  ; Inicializar contador para tamanho máximo do buffer
  mov cx, tamanho_max_buffer ; Tamanho máximo do buffer determina o loop de leiura de caractere
  xor bx, bx ; Inicializa apontador de caractere no buffer


le_caractere:
  ; Ler um caractere do teclado
  mov ah, 0x01 ; Função de leitura de caractere
  int 21h ; Chamada do sistema

  ; Verifica se foi pressionado ENTER
  cmp al, 0x0d
  je terminou_jogada ; Se for ENTER, termina a jogada

  ; Armazenar o caractere lido no buffer
  mov [buffer + bx], al
  inc bx ; Avançar para o próximo caractere no buffer

  loop le_caractere ; Decrementar o contador de tamanho máximo do buffer


terminou_jogada:
  ; Move o cursor para a direita
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0 ; Página de vídeo (normalmente 0)
  mov dh, 24 ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 45 ; Posição horizontal (45: chutando e vendo onde fica melhor)
  int 0x10 ; Chamada do sistema BIOS

  ; Exibir os caracteres digitados (comando) na tela
  mov ah, 02h ; Função de exibição de caractere
  mov dl, [buffer] ; Caractere a ser exibido
  int 21h ; Chamada do sistema
  mov dl, [buffer + 1] ; Caractere a ser exibido
  int 21h ; Chamada do sistema
  mov dl, [buffer + 2] ; Caractere a ser exibido
  int 21h ; Chamada do sistema

  ; Move o cursor para a esquerda de volta
  mov ah, 0x02 ; Função 0x02: Configurar posição do cursor
  mov bh, 0 ; Página de vídeo (normalmente 0)
  mov dh, 24 ; Posição vertical (24: chutando e vendo onde fica melhor)
  mov dl, 8 ; Posição horizontal (8: chutando e vendo onde fica melhor)
  int 0x10 ; Chamada do sistema BIOS

  ; TODO: limpar a tela na posição inicial da jogada para o próximo comando

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