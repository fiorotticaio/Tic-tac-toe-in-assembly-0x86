; Caio Alves Fiorotti - ELE15942 05.1N SISTEMAS EMBARCADOS I 
; Matheus Meier Schreiber - ELE15942 05.1N SISTEMAS EMBARCADOS I

segment code

main:
  ;===== Inicialização dos registradores de segmento e stack pointer =====
  xor ax, ax ; Limpa AX
  mov ax, data ; Move o endereço do segmento de dados para AX
  mov ds, ax ; Move o endereço do segmento de dados para DS
  mov ax, stack ; Move o endereço do segmento de pilha para AX
  mov ss, ax ; Move o endereço do segmento de pilha para SS
  mov sp, stackTop ; Move o endereço do topo da pilha para SP

  ;===== Finaliza o programa =====
  mov ax, 0x4c00 ; Move o valor 0x4c00 para AX (parâmetro que finaliza o programa na inetrrupção 0x21)
  int 0x21 ; Chama a interrupção 0x21



segment data



segment stack stack
  resb 256
stackTop: