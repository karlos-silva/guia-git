# 14. .gitignore e hooks

## .gitignore

O arquivo `.gitignore`, na raiz do repositório, lista o que o Git deve **ignorar**: dependências, arquivos gerados, configurações locais e segredos.

```gitignore
# Dependências
node_modules/
.venv/
__pycache__/

# Build
dist/
build/
*.pyc

# Variáveis de ambiente e segredos
.env
.env.*
!.env.example      # o ! abre exceção: este arquivo É versionado

# Sistema e editor
.DS_Store
Thumbs.db
.idea/
.vscode/*
!.vscode/extensions.json

# Logs
*.log
```

### Sintaxe

| Padrão | Ignora |
| --- | --- |
| `arquivo.txt` | Qualquer `arquivo.txt`, em qualquer pasta |
| `/arquivo.txt` | Só o da raiz |
| `pasta/` | A pasta inteira |
| `*.log` | Todo arquivo terminado em `.log` |
| `**/temp` | `temp` em qualquer nível |
| `!importante.log` | Exceção: **não** ignora este |
| `# texto` | Comentário |

Não precisa escrever do zero: o [github/gitignore](https://github.com/github/gitignore) tem modelos para cada linguagem, e o GitHub oferece um ao criar o repositório.

### Já commitei o arquivo, e agora?

O `.gitignore` só vale para arquivos que o Git ainda **não acompanha**. Se o arquivo já foi commitado, pare de versioná-lo (ele continua no seu disco):

```bash
git rm --cached .env
git rm -r --cached node_modules
git commit -m "chore: para de versionar .env e node_modules"
```

> Se o arquivo tinha senha ou token, isso **não basta**: ele continua no histórico. Veja [Commitei uma senha](16-problemas-comuns.md#commitei-uma-senha-ou-token).

### .gitignore global

Para o que é seu e não do projeto (sistema operacional, editor):

```bash
echo ".DS_Store" >> ~/.gitignore_global
git config --global core.excludesFile ~/.gitignore_global
```

### Conferindo

```bash
git check-ignore -v arquivo.log   # mostra qual regra está ignorando o arquivo
git status --ignored              # lista os ignorados
```

## .gitattributes

Define como o Git trata cada tipo de arquivo:

```gitattributes
* text=auto           # normaliza fim de linha
*.sh text eol=lf      # scripts sempre com LF
*.png binary          # nunca tenta fazer diff/merge de imagem
*.psd filter=lfs diff=lfs merge=lfs -text   # arquivos grandes no Git LFS
```

## Hooks

Hooks são scripts que o Git roda automaticamente em certos momentos. Ficam em `.git/hooks/`, com o nome do evento e sem extensão.

### Do lado do cliente (no seu computador)

| Hook | Quando roda | Uso comum |
| --- | --- | --- |
| `pre-commit` | Antes de criar o commit | Rodar lint e formatador, bloquear `console.log` |
| `commit-msg` | Depois de escrever a mensagem | Validar o padrão da mensagem |
| `prepare-commit-msg` | Antes de abrir o editor | Preencher a mensagem com um modelo ou o nome da branch |
| `pre-push` | Antes do push | Rodar os testes |
| `post-checkout` | Depois de trocar de branch | Instalar dependências que mudaram |
| `post-merge` | Depois de um merge ou pull | Idem |

Se o script terminar com erro (`exit 1`), o Git **cancela** a operação. Para pular os hooks numa emergência: `git commit --no-verify`.

### Do lado do servidor

`pre-receive`, `update` e `post-receive`/`post-update` rodam no servidor que recebe o push. No GitHub você não acessa esses hooks: o equivalente são as **regras de proteção de branch**, o [GitHub Actions](11-github-actions.md) e os **webhooks**.

### Compartilhando hooks com o time

A pasta `.git/hooks` não é versionada. Para todo mundo usar os mesmos hooks:

- Guarde os scripts numa pasta do repositório (ex.: `.githooks/`) e peça para cada um rodar `git config core.hooksPath .githooks`.
- Ou use uma ferramenta: [Husky](https://typicode.github.io/husky) (JavaScript), [pre-commit](https://pre-commit.com) (Python e outros), [Lefthook](https://github.com/evilmartians/lefthook) (qualquer linguagem).

## Hooks deste repositório

A pasta [`scripts/`](../scripts) tem ferramentas prontas para o [padrão de commit](04-padroes-de-commit.md). Requisitos: Git e Bash (no Windows, use o Git Bash).

### Validação de mensagem: `commit-msg.sh`

Recusa commits fora do padrão `[emoji] tipo(escopo): descrição`. Mensagens geradas pelo próprio Git (`Merge ...`, `Revert "..."`, `fixup! ...`) passam direto.

Instalando em um projeto:

```bash
git clone https://github.com/karlos-silva/guia-git.git
./guia-git/scripts/install.sh caminho/do/seu-projeto
```

Sem o caminho, ele instala no repositório da pasta atual. Se já existir outro hook `commit-msg`, é feito um backup em `commit-msg.bak`.

Em todos os projetos da máquina:

```bash
./guia-git/scripts/install.sh --global
```

Isso copia o hook para `~/.git-hooks` e configura `core.hooksPath` global. Atenção: com isso o Git passa a ignorar a pasta `.git/hooks` de cada projeto.

Testando (este commit deve ser recusado):

```bash
git commit --allow-empty -m "arrumei umas coisas"
```

```text
✗ Mensagem de commit fora do padrão:
    "arrumei umas coisas"

  Formato:  [emoji] tipo(escopo opcional): descrição
  ...
```

Para aceitar outros tipos, edite a variável `TYPES` no começo do script.

### Assistente de commit: `commit.sh`

Monta a mensagem para você. Escolha o tipo, informe o escopo (opcional) e a descrição:

```bash
git add .
./guia-git/scripts/commit.sh
```

```text
 1) ✨ feat      novo recurso
 2) 🐛 fix       correção de bug
 ...
Tipo: 1
Escopo (opcional): login
Descrição: adiciona botão de mostrar senha

✓ :sparkles: feat(login): adiciona botão de mostrar senha
```

Ele commita só o que estiver no stage.

---

[← Anterior](13-github-cli.md) · [Índice](../README.md) · [Próximo: Git avançado →](15-git-avancado.md)
