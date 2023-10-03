; Importando variáveis
extern buffer, tamanho_max_buffer
; Exportando funções
global le_jogada


le_jogada:
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
  mov dh, 24 ; Posição horizontal (0 a 24, dependendo do modo de vídeo)
  mov dl, 8 ; Posição vertical (0 a 79, dependendo do modo de vídeo)
  int 0x10 ; Chamada do sistema BIOS

  ; Exibir o prompt na tela
  ; mov ah, 0x09 ; Função de exibição de string
  ; mov dx, prompt ; Endereço da mensagem
  ; int 0x21 ; Chamada do sistema

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
  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf

  ret ; Retornar para o programa principal