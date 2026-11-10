# Cola de comandos 📋

## Configuração

```bash
git config --global user.name "Seu Nome"
git config --global user.email "voce@exemplo.com"
git config --global init.defaultBranch main
git config --list
```

## Começando

| Comando | O que faz |
| --- | --- |
| `git init` | Cria um repositório na pasta atual |
| `git clone <url>` | Baixa um repositório |

## Dia a dia

| Comando | O que faz |
| --- | --- |
| `git status` | O que mudou e o que está no stage |
| `git add <arquivo>` / `git add .` | Coloca no stage |
| `git add -p` | Escolhe pedaço por pedaço |
| `git commit -m "tipo: mensagem"` | Registra o que está no stage |
| `git diff` | Mudanças fora do stage |
| `git diff --staged` | Mudanças no stage |
| `git log --oneline --graph` | Histórico resumido |
| `git show <hash>` | Detalhes de um commit |

## Branches

| Comando | O que faz |
| --- | --- |
| `git branch` | Lista branches |
| `git switch -c <nome>` | Cria e entra |
| `git switch <nome>` | Troca |
| `git merge <nome>` | Junta a branch na atual |
| `git branch -d <nome>` | Apaga (já mergeada) |
| `git rebase main` | Reaplica sua branch em cima da main |

## Remoto

| Comando | O que faz |
| --- | --- |
| `git remote -v` | Lista remotos |
| `git remote add origin <url>` | Conecta a um remoto |
| `git push -u origin <branch>` | Primeiro push de uma branch |
| `git push` | Envia |
| `git pull --rebase` | Traz e aplica as novidades |
| `git fetch` | Só baixa, sem aplicar |

## Desfazendo

| Comando | O que faz |
| --- | --- |
| `git restore <arquivo>` | Descarta mudanças no arquivo |
| `git restore --staged <arquivo>` | Tira do stage |
| `git commit --amend` | Corrige o último commit |
| `git reset --soft HEAD~1` | Desfaz o último commit, mantém as mudanças |
| `git reset --hard <hash>` | Volta para o commit e **apaga** as mudanças |
| `git revert <hash>` | Cria um commit que desfaz outro |
| `git reflog` | Histórico de tudo que o HEAD fez |

## Guardando e copiando

| Comando | O que faz |
| --- | --- |
| `git stash -u` | Guarda mudanças temporariamente |
| `git stash pop` | Traz de volta |
| `git cherry-pick <hash>` | Copia um commit para a branch atual |
| `git tag -a v1.0.0 -m "..."` | Cria uma tag |
| `git push --tags` | Envia as tags |

## Investigando

| Comando | O que faz |
| --- | --- |
| `git log --grep="texto"` | Busca na mensagem dos commits |
| `git log -S "texto"` | Busca no código alterado |
| `git blame <arquivo>` | Quem mudou cada linha |
| `git bisect start` | Acha o commit que introduziu um bug |

## GitHub CLI

| Comando | O que faz |
| --- | --- |
| `gh auth login` | Faz login |
| `gh repo create --source . --push` | Sobe a pasta atual para um repositório novo |
| `gh issue view <n> --comments` | Lê uma issue |
| `gh pr create --fill` | Abre pull request |
| `gh pr checkout <n>` | Baixa um PR |
| `gh pr checks --watch` | Acompanha o CI do PR |
| `gh run view --log-failed` | Log do que falhou no Actions |
| `gh <comando> --json <campos>` | Saída estruturada para scripts e IA |

Mais no capítulo [GitHub CLI (`gh`) e IA](13-github-cli.md).

---

[Índice](../README.md) · [Glossário →](glossario.md)
