; Importando variáveis e funções
extern limpa_prompt_erro, jogo_acabou, prompt_fim_jogo_x, prompt_fim_jogo_c, prompt_fim_jogo_emp, prompt_inicial
; Exportando funções 
global mensagem_fim_jogo, mensagem_inicial


; ******************************************************************************
; Função mensagem_fim_jogo
; ******************************************************************************
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
  

; ******************************************************************************
; Função mensagem_inicial
; ******************************************************************************
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