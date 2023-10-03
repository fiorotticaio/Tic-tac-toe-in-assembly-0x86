; Exportando variáveis
global desenha_tabuleiro
; Importando funções
extern line, cor


desenha_tabuleiro:
  pushf
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push bp


  mov	byte[cor], 7 ; Seta a cor da linha para branco

  ; Desenha primiera linha horizontal
  mov	ax, 170
  push ax
  mov	ax, 350
  push ax
  mov	ax, 470
  push ax
  mov	ax, 350
  push ax
  call line

  ; Desenha segunda linha horizontal
  mov	ax, 170
  push ax
  mov	ax, 250
  push ax
  mov	ax, 470
  push ax
  mov	ax, 250
  push ax
  call line

  ; Desenha primeira linha vertical
  mov	ax, 270
  push ax
  mov	ax, 450
  push ax
  mov	ax, 270
  push ax
  mov	ax, 150
  push ax
  call line

  ; Desenha segunda linha vertical
  mov	ax, 370
  push ax
  mov	ax, 450
  push ax
  mov	ax, 370
  push ax
  mov	ax, 150
  push ax
  call line


  ; Desenhando campo de comando
  mov byte[cor], 3 ; Setaando a cor da linha para ciano
  ; Desenhando a linha de cima
  mov	ax, 50
  push ax
  mov	ax, 100
  push ax
  mov	ax, 590
  push ax
  mov	ax, 100
  push ax
  call line

  ; Desenhando a linha de baixo
  mov	ax, 50
  push ax
  mov	ax, 70
  push ax
  mov	ax, 590
  push ax
  mov	ax, 70
  push ax
  call line

  ; Desenhando a linha da esquerda
  mov	ax, 50
  push ax
  mov	ax, 100
  push ax
  mov	ax, 50
  push ax
  mov	ax, 70
  push ax
  call line

  ; Desenhando a linha da direita
  mov	ax, 590
  push ax
  mov	ax, 100
  push ax
  mov	ax, 590
  push ax
  mov	ax, 70
  push ax
  call line


  ; Desenhando campo de mensagens
  ; Desenhando a linha de cima
  mov	ax, 50
  push ax
  mov	ax, 50
  push ax
  mov	ax, 590
  push ax
  mov	ax, 50
  push ax
  call line

  ; Desenhando a linha de baixo
  mov	ax, 50
  push ax
  mov	ax, 20
  push ax
  mov	ax, 590
  push ax
  mov	ax, 20
  push ax
  call line

  ; Desenhando a linha da esquerda
  mov	ax, 50
  push ax
  mov	ax, 50
  push ax
  mov	ax, 50
  push ax
  mov	ax, 20
  push ax
  call line

  ; Desenhando a linha da direita
  mov	ax, 590
  push ax
  mov	ax, 50
  push ax
  mov	ax, 590
  push ax
  mov	ax, 20
  push ax
  call line



  pop bp
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  popf
  ret ; Retorna da função