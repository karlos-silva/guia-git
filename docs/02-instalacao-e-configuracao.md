# 02. Instalação e configuração

## Instalando

**Windows:** baixe em [git-scm.com](https://git-scm.com/downloads) e instale com as opções padrão. Junto vem o **Git Bash**, um terminal que entende os comandos deste guia.

**macOS:** rode `git --version`. Se não estiver instalado, o sistema oferece instalar as Command Line Tools. Outra opção é o Homebrew:

```bash
brew install git
```

**Linux (Debian/Ubuntu):**

```bash
sudo apt update && sudo apt install git
```

Confira:

```bash
git --version
# git version 2.x.x
```

## Configuração inicial

Faça isso uma vez por computador. O nome e o e-mail aparecem em todos os seus commits.

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu-email@exemplo.com"
```

> Use o mesmo e-mail da sua conta do GitHub, assim os commits aparecem ligados ao seu perfil. Se não quiser expor o e-mail, use o endereço `@users.noreply.github.com` que o GitHub mostra em *Settings → Emails*.

Branch padrão `main` para repositórios novos:

```bash
git config --global init.defaultBranch main
```

Editor usado pelo Git (mensagens de commit, rebase etc.):

```bash
git config --global core.editor "code --wait"   # VS Code
git config --global core.editor "nano"          # nano, simples no terminal
```

Saída colorida (normalmente já vem ligada):

```bash
git config --global color.ui auto
```

## Quebra de linha (Windows x Linux/macOS)

Windows usa `CRLF` no fim das linhas e Linux/macOS usam `LF`. Para não ter arquivos "modificados" sem ninguém ter mexido:

```bash
# No Windows
git config --global core.autocrlf true

# No macOS/Linux
git config --global core.autocrlf input
```

Em projetos de time, o melhor é um arquivo `.gitattributes` no repositório, que vale para todo mundo:

```text
* text=auto
*.sh text eol=lf
```

## Conferindo as configurações

```bash
git config --list --show-origin   # tudo, e de onde veio cada valor
git config user.name              # um valor específico
```

Existem três níveis de configuração, do mais geral para o mais específico:

| Nível | Flag | Vale para | Arquivo |
| --- | --- | --- | --- |
| Sistema | `--system` | Todos os usuários da máquina | `/etc/gitconfig` |
| Global | `--global` | Seu usuário | `~/.gitconfig` |
| Local | `--local` (padrão) | Só aquele repositório | `.git/config` |

O mais específico ganha. Útil para, por exemplo, usar o e-mail do trabalho só no repositório do trabalho:

```bash
cd projeto-do-trabalho
git config user.email "voce@empresa.com"
```

## Atalhos (aliases)

```bash
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"
```

Agora `git st` e `git lg` funcionam.

---

[← Anterior](01-o-que-e-git.md) · [Índice](../README.md) · [Próximo: Primeiros passos →](03-primeiros-passos.md)
