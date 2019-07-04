# 03. Primeiros passos

Abra o terminal e acompanhe. Tudo aqui é seguro para testar.

## Criando um repositório

```bash
mkdir meu-projeto
cd meu-projeto
git init
```

O `git init` cria a pasta oculta `.git`, onde fica todo o histórico. Apagou a `.git`, apagou o histórico (os arquivos continuam).

## O ciclo básico

### 1. Veja o estado: `git status`

```bash
echo "# Meu projeto" > README.md
git status
```

```text
Untracked files:
  README.md
```

O Git viu um arquivo novo, mas ainda não acompanha ele.

### 2. Coloque no stage: `git add`

```bash
git add README.md       # um arquivo
git add src/            # uma pasta
git add .               # tudo que mudou na pasta atual
git add -p              # escolhe pedaço por pedaço (ótimo para commits caprichados)
```

### 3. Salve no histórico: `git commit`

```bash
git commit -m ":tada: init: cria README"
```

Sem o `-m`, o Git abre o editor para você escrever uma mensagem maior. Como escrever boas mensagens é assunto do [capítulo 04](04-padroes-de-commit.md).

### 4. Repita

```text
editar → git status → git add → git commit
```

Esse é 90% do uso diário.

## Vendo o que mudou: `git diff`

```bash
git diff             # mudanças que ainda NÃO estão no stage
git diff --staged    # mudanças que estão no stage (o que vai no commit)
git diff main        # compara com outra branch
```

Confira o `git diff --staged` antes de commitar. Evita commitar `console.log`, senha ou arquivo errado.

## Vendo o histórico: `git log`

```bash
git log                     # completo
git log --oneline           # uma linha por commit
git log --oneline --graph   # com desenho das branches
git log -p arquivo.py       # histórico de um arquivo, com as mudanças
git log --author="Karlos"   # só commits de alguém
git log --since="1 week"    # da última semana
```

Para ver um commit específico:

```bash
git show a1b2c3d
```

## Removendo e renomeando arquivos

Use os comandos do Git para ele entender o que aconteceu:

```bash
git rm arquivo.txt              # apaga e já coloca no stage
git rm --cached arquivo.txt     # para de versionar, mas mantém no disco
git mv antigo.txt novo.txt      # renomeia
```

## Quem mudou esta linha? `git blame`

```bash
git blame arquivo.py
```

Mostra, linha por linha, o último commit e o autor. Ótimo para entender por que um código está daquele jeito (não para achar culpado 🙂).

## Exercício

1. Crie uma pasta e rode `git init`.
2. Crie `index.html`, adicione e commite.
3. Mude o arquivo, veja o `git diff`, adicione e commite de novo.
4. Crie `style.css` e `script.js`. Commite **cada um separado**.
5. Rode `git log --oneline` e veja seus 4 commits.

---

[← Anterior](02-instalacao-e-configuracao.md) · [Índice](../README.md) · [Próximo: Padrões de commit →](04-padroes-de-commit.md)
