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
```

# Implementações
- [x] Implementar configuração inicial do tabuleiro.
- [ ] Implementar comando de jogada (Xlc e Clc).
- [ ] Implementar os comandos de novo jogo (c) e sair (s).
- [ ] Implementar identificação de vitória.
- [ ] Implementar prompt de último comando.
- [ ] Implementar identificação de erros.