; Importando variáveis
extern prompt, buffer, tamanho_max_buffer
; Exportando funções
global le_jogada


le_jogada:
  ; Exibir o prompt na tela
  ; TODO: colocar na posição certa
  mov ah, 0x09 ; Função de exibição de string
  mov dx, prompt ; Endereço da mensagem
  int 0x21 ; Chamada do sistema

  ; Inicializar contador para tamanho máximo do buffer
  mov cx, tamanho_max_buffer
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
  ret ; Retornar para o programa principal