; Exportando funções
global desenha_tabuleiro, desenha_jogada, desenha_diagonal_1, desenha_diagonal_2, desenha_coluna_1, desenha_coluna_2, desenha_coluna_3, desenha_linha_1, desenha_linha_2, desenha_linha_3
; Importando variáveis e funções
extern line, cor, caracter, cursor, circle, xc, yc, buffer



; ******************************************************************************
; Função desenha_tabuleiro
; ******************************************************************************
desenha_tabuleiro:
  ; Salvando contexto
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


  mov	byte[cor], 7 ; Seta a cor da linha para branco
  xor dx, dx       ; limpando registrador dx

  ; Escrevendo o numero da casa 1,1
  mov dh, 3
  mov dl, 21
  call cursor  ; dh = linha dl=coluna
  mov al, 0x31 ; hex em ascii para o caractere ('1')
  call caracter 
  mov dl, 22
  call cursor  ; dh = linha dl=coluna
  mov al, 0x31 ; hex em ascii para o caractere ('1')
  call caracter

  ; Escrevendo o numero da casa 1,2
  mov dh, 3
  mov dl, 35
  call cursor  ; dh = linha dl=coluna
  mov al, 0x31 ; hex em ascii para o caractere ('1')
  call caracter 
  mov dl, 36
  call cursor  ; dh = linha dl=coluna
  mov al, 0x32 ; hex em ascii para o caractere ('2')
  call caracter

  ; Escrevendo o numero da casa 1,3
  mov dh, 3
  mov dl, 48
  call cursor  ; dh = linha dl=coluna
  mov al, 0x31 ; hex em ascii para o caractere ('1')
  call caracter 
  mov dl, 49
  call cursor  ; dh = linha dl=coluna
  mov al, 0x33 ; hex em ascii para o caractere ('3')
  call caracter

  ; Escrevendo o numero da casa 2,1
  mov dh, 9
  mov dl, 21
  call cursor  ; dh = linha dl=coluna
  mov al, 0x32 ; hex em ascii para o caractere ('2')
  call caracter 
  mov dl, 22
  call cursor  ; dh = linha dl=coluna
  mov al, 0x31 ; hex em ascii para o caractere ('1')
  call caracter

  ; Escrevendo o numero da casa 2,2
  mov dh, 9
  mov dl, 35
  call cursor  ; dh = linha dl=coluna
  mov al, 0x32 ; hex em ascii para o caractere ('2')
  call caracter 
  mov dl, 36
  call cursor  ; dh = linha dl=coluna
  mov al, 0x32 ; hex em ascii para o caractere ('2')
  call caracter

  ; Escrevendo o numero da casa 2,3
  mov dh, 9
  mov dl, 48
  call cursor  ; dh = linha dl=coluna
  mov al, 0x32 ; hex em ascii para o caractere ('2')
  call caracter 
  mov dl, 49
  call cursor  ; dh=linha dl=coluna
  mov al, 0x33 ; hex em ascii para o caractere ('3')
  call caracter

  ; Escrevendo o numero da casa 3,1
  mov dh, 15
  mov dl, 21
  call cursor  ; dh=linha dl=coluna
  mov al, 0x33 ; hex em ascii para o caractere ('3')
  call caracter 
  mov dl, 22
  call cursor  ; dh=linha dl=coluna
  mov al, 0x31 ; hex em ascii para o caractere ('1')
  call caracter

  ; Escrevendo o numero da casa 3,2
  mov dh, 15
  mov dl, 35
  call cursor  ; dh=linha dl=coluna
  mov al, 0x33 ; hex em ascii para o caractere ('3')
  call caracter 
  mov dl, 36
  call cursor  ; dh=linha dl=coluna
  mov al, 0x32 ; hex em ascii para o caractere ('2')
  call caracter

  ; Escrevendo o numero da casa 3,3
  mov dh, 15
  mov dl, 48
  call cursor  ; dh=linha dl=coluna
  mov al, 0x33 ; hex em ascii para o caractere ('3')
  call caracter 
  mov dl, 49
  call cursor  ; dh=linha dl=coluna
  mov al, 0x33 ; hex em ascii para o caractere ('3')
  call caracter

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
; Função desenha_jogada
; ******************************************************************************
desenha_jogada:
  mov cl, [buffer] ; Recebendo o caractere da jogada

  cmp cl, 'X'
  je desenha_X
  cmp cl, 'C'
  je desenha_C
  ret


desenha_C:
  mov ax, [xc]
  push ax
  mov ax, [yc]
  push ax
  mov ax, 20 ; raio
  push ax
  call circle 
  ret

desenha_X:
  mov ax, [xc]
  mov bx, [yc]

  xor dx,dx ; limpando registrador auxiliar

  mov dx, ax
  sub dx, 20
  push dx ; coord x1 da primeira linha

  mov dx, bx
  sub dx, 20
  push dx ; coord y1 da primeira linha
  
  mov dx, ax
  add dx, 20
  push dx ; coord x2 da primeira linha

  mov dx, bx
  add dx, 20
  push dx ; coord y2 da primeira linha
  call line

  mov dx, ax
  add dx, 20
  push dx ; coord x1 da segunda linha

  mov dx, bx
  sub dx, 20
  push dx ; coord y1 da segunda linha
  
  mov dx, ax
  sub dx, 20
  push dx ; coord x2 da segunda linha

  mov dx, bx
  add dx, 20
  push dx ; coord y2 da segunda linha
  call line

  ret ; Retornando da função

desenha_diagonal_1:
mov ax, 220
push ax ; coord x1

mov ax, 400
push ax ; coord y1

mov ax, 420 
push ax ; coord x2

mov ax, 200
push ax ; coord y2

call line

ret ; Retornando da função

desenha_diagonal_2:
mov ax, 420
push ax ; coord x1

mov ax, 400
push ax ; coord y1

mov ax, 220 
push ax ; coord x2

mov ax, 200
push ax ; coord y2

call line

ret ; Retornando da função

desenha_coluna_1:
mov ax, 220
push ax ; coord x1

mov ax, 400
push ax ; coord y1

mov ax, 220 
push ax ; coord x2

mov ax, 200
push ax ; coord y2

call line

ret ; Retornando da função

desenha_coluna_2:
mov ax, 320
push ax ; coord x1

mov ax, 400
push ax ; coord y1

mov ax, 320 
push ax ; coord x2

mov ax, 200
push ax ; coord y2

call line

ret ; Retornando da função

desenha_coluna_3:
mov ax, 420
push ax ; coord x1

mov ax, 400
push ax ; coord y1

mov ax, 420 
push ax ; coord x2

mov ax, 200
push ax ; coord y2

call line

ret ; Retornando da função

desenha_linha_1:
mov ax, 220
push ax ; coord x1

mov ax, 400
push ax ; coord y1

mov ax, 420 
push ax ; coord x2

mov ax, 400
push ax ; coord y2

call line

ret ; Retornando da função

desenha_linha_2:
mov ax, 220
push ax ; coord x1

mov ax, 300
push ax ; coord y1

mov ax, 420 
push ax ; coord x2

mov ax, 300
push ax ; coord y2

call line

ret ; Retornando da função

desenha_linha_3:
mov ax, 220
push ax ; coord x1

mov ax, 200
push ax ; coord y1

mov ax, 420 
push ax ; coord x2

mov ax, 200
push ax ; coord y2

call line

ret ; Retornando da função