# Guia de Git 🌱

Tudo o que você precisa para usar Git de verdade: do primeiro `git init` até trabalhar em time com branches, pull requests e um histórico limpo.

Escrito em português, direto ao ponto e com exemplos que você pode rodar no seu terminal.

## Como usar este guia

- **Começando do zero?** Siga os capítulos em ordem.
- **Já usa Git?** Pule para o que precisa. A [cola](docs/cola.md) e os [problemas comuns](docs/16-problemas-comuns.md) resolvem a maioria das dúvidas do dia a dia.
- **Aprenda fazendo.** Abra um terminal, crie uma pasta de teste e repita os comandos de cada capítulo.
- **Quer um mapa visual?** Os capítulos cobrem os tópicos do [roadmap de Git e GitHub do roadmap.sh](https://roadmap.sh/git-github). Use os dois juntos para marcar seu progresso.

## Trilha

### 🟢 Básico

| # | Capítulo | O que você aprende |
| --- | --- | --- |
| 01 | [O que é Git](docs/01-o-que-e-git.md) | Controle de versão, Git x GitHub, as três áreas |
| 02 | [Instalação e configuração](docs/02-instalacao-e-configuracao.md) | Instalar, configurar nome, e-mail e editor |
| 03 | [Primeiros passos](docs/03-primeiros-passos.md) | `init`, `status`, `add`, `commit`, `log`, `diff` |
| 04 | [Padrões de commit](docs/04-padroes-de-commit.md) | Conventional Commits, tipos, emojis e boas mensagens |

### 🟡 Intermediário

| # | Capítulo | O que você aprende |
| --- | --- | --- |
| 05 | [Branches e merge](docs/05-branches-e-merge.md) | Criar e trocar branches, merge e conflitos |
| 06 | [Repositórios remotos](docs/06-repositorios-remotos.md) | SSH, `clone`, `push`, `pull`, `fetch` |
| 07 | [Desfazendo coisas](docs/07-desfazendo-coisas.md) | `restore`, `amend`, `reset`, `revert`, `reflog` |
| 08 | [Stash, rebase e cherry-pick](docs/08-stash-rebase-cherry-pick.md) | Guardar trabalho, reescrever histórico, tags |

### 🔵 GitHub e colaboração

| # | Capítulo | O que você aprende |
| --- | --- | --- |
| 09 | [GitHub na prática](docs/09-github-na-pratica.md) | Perfil, README, issues, Projects, fork, pull request, code review |
| 10 | [Fluxos de trabalho](docs/10-fluxos-de-trabalho.md) | GitHub Flow, Git Flow, nomes de branch, trabalho em time |
| 11 | [GitHub Actions](docs/11-github-actions.md) | Automação: testes a cada push, segredos, artefatos |
| 12 | [Recursos do GitHub](docs/12-recursos-do-github.md) | Pages, Releases, Gists, segurança, Codespaces, API |
| 13 | [GitHub CLI (`gh`) e IA](docs/13-github-cli.md) | Issues, PRs e Actions pelo terminal, `--json`, e como agentes de IA usam o `gh` |

### 🟣 Avançado

| # | Capítulo | O que você aprende |
| --- | --- | --- |
| 14 | [.gitignore e hooks](docs/14-gitignore-e-hooks.md) | Ignorar arquivos e automatizar validações |
| 15 | [Git avançado](docs/15-git-avancado.md) | bisect, worktree, submódulos, LFS, patches, reescrever histórico |
| 16 | [Problemas comuns](docs/16-problemas-comuns.md) | "Commitei na branch errada", senha no commit, push recusado... |

### 📚 Referência

- [Cola de comandos](docs/cola.md): os comandos mais usados em uma página
- [Glossário](docs/glossario.md): os termos do Git explicados em uma linha

## Ferramentas

A pasta [`scripts/`](scripts) traz duas ferramentas para manter seus commits no padrão:

| Script | O que faz |
| --- | --- |
| [`install.sh`](scripts/install.sh) | Instala o hook que recusa commits fora do padrão |
| [`commit.sh`](scripts/commit.sh) | Assistente que monta a mensagem de commit para você |

```bash
git clone https://github.com/karlos-silva/guia-git.git
./guia-git/scripts/install.sh caminho/do/seu-projeto
```

Detalhes no capítulo [.gitignore e hooks](docs/14-gitignore-e-hooks.md#hooks-deste-repositório).

## Licença

[MIT](LICENSE). Use, copie e adapte à vontade.
