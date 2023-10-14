# Convençoes
## Gerais
- **Código** devem ser escrito em **português**.
- **Commits** devem ser escritos em **português**.
## Variáveis
- Nome das **variáveis** devem ser escritas em **snake_case**.
## Labels
- Noma das **labels** devem ser escritas em **snake_case**.

# Como rodar
## Linux
- Criar pasta frasm com os arquivos de execução do DOSBox dentro da pasta Home
- Clonar o repositório dentro da pasta frasm
- Abrir DOSBox
- No DOSBox, digitar:
```bash
C:\> mount c /home/{seu_user}/frasm
C:\> c: (caso o : não esteja funcionando, apertar alt + 58 no teclado numérico)
C:\> Tic-tac-toe-in-assembly-0x86\compile.bat
C:\> Tic-tac-toe-in-assembly-0x86\jogo.exe
```

# Implementações
- [x] Implementar configuração inicial do tabuleiro.
- [x] Adicionar numeração às casas (caracteres)
- [x] Implementar os comandos de novo jogo (c) e sair (s).
- [x] Implementar prompt de último comando.
- [x] Implementar comando de jogada (Xlc e Clc).
- [x] Implementar tecla de BACKSPACE.
- [x] Implementar validação de jogada
  - [x] caso no campo de simbolo tenha uma letra diferente de `X`, `C`, `c`, ou `s`
  - [x] caso no campo de coordenada tenha um numero diferente de `1`,`2`,`3`
  - [x] quando extrapola o tamanho do comando (3 caracteres)
  - [x] mesmo jogador nao deve jogar duas vezes seguidas
  - [x] nao se deve jogar em uma posição já preenchida
- [x] Implementar identificação de vitória.
- [ ] Implementar identificação de empate.
- [ ] Reiniciar o jogo após vitória ou empate.

# Bugs
- [ ] Problema com a impressão do prompt de jogada