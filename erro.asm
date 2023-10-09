; Importando variáveis e funções
extern prompt_comando_invalido, prompt_jogada_invalida, prompt_vazio
; Exportando variáveis e funções funções 
global imprime_erro_comando_invalido, imprime_erro_jogada_invalida, limpa_prompt_erro



; ******************************************************************************
; Função imprime_erro_comando_invalido
; ******************************************************************************
imprime_erro_comando_invalido:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 27    ; Posição vertical
  mov dl, 8     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov dx, prompt_comando_invalido
  mov ah, 9
  int 21h

  ; Recuperando o contexto
  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf

  ret ; Retornando da função



; ******************************************************************************
; Função imprime_erro_jogada_invalida
; ******************************************************************************
imprime_erro_jogada_invalida:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 27    ; Posição vertical
  mov dl, 8     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov dx, prompt_jogada_invalida
  mov ah, 9
  int 21h

  ; Recuperando o contexto
  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf

  ret ; Retornando da função



; ******************************************************************************
; Função limpa_prompt_erro
; ******************************************************************************
limpa_prompt_erro:
  ; Salvando o contexto
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp

  mov ah, 0x02  ; Função 0x02: Configurar posição do cursor
  mov bh, 0     ; Página de vídeo (normalmente 0)
  mov dh, 27    ; Posição vertical
  mov dl, 8     ; Posição horizontal 
  int 0x10      ; Chamada do sistema BIOS

  mov dx, prompt_vazio ; String vazia para limpar o prompt
  mov ah, 9            ; Função de exibição de caractere
  int 21h              ; Chamada do sistema

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