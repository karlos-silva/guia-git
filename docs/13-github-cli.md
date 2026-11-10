# 13. GitHub CLI (`gh`) e IA

O `gh` é a linha de comando oficial do GitHub. O Git cuida do histórico. O `gh` cuida de tudo que fica **no GitHub**: repositórios, issues, pull requests, Actions, releases.

Hoje ele é ainda mais importante: **agentes de IA que trabalham no terminal** (Claude Code, GitHub Copilot CLI, Codex, Cursor e outros) usam o `gh` para ler issues, abrir PRs e investigar o CI. Quem domina o `gh` sabe o que pedir para a IA e entende o que ela está fazendo.

## Instalação e login

```bash
brew install gh          # macOS
winget install GitHub.cli   # Windows
sudo apt install gh      # Debian/Ubuntu (veja cli.github.com para versões mais novas)
```

```bash
gh auth login            # escolha GitHub.com, SSH e login pelo navegador
gh auth status           # mostra a conta logada e as permissões (scopes) do token
```

O `gh auth login` também configura o Git para usar as mesmas credenciais.

Mais de uma conta (pessoal e trabalho):

```bash
gh auth login                  # faça login na segunda conta
gh auth switch                 # alterna a conta ativa
```

Falta permissão para alguma coisa (ex.: apagar repositório)?

```bash
gh auth refresh -s delete_repo
```

## Repositórios

```bash
gh repo create meu-projeto --public --source . --push   # cria no GitHub a partir da pasta atual
gh repo create meu-projeto --private --clone            # cria vazio e já clona
gh repo clone usuario/projeto
gh repo fork usuario/projeto --clone                    # fork + clone + remoto upstream
gh repo sync                                            # atualiza seu fork com o original
gh repo view usuario/projeto                            # README e descrição no terminal
gh repo view --web                                      # abre no navegador
gh repo list usuario --limit 50
gh repo edit --description "Nova descrição"
```

## Issues

```bash
gh issue list                                  # abertas no repositório atual
gh issue list --label bug --assignee @me
gh issue view 42 --comments                    # issue completa, com comentários
gh issue create --title "Bug no login" --body "Passos para reproduzir..."
gh issue comment 42 --body "Resolvido no PR #50"
gh issue edit 42 --add-label "good first issue"
gh issue close 42
gh issue develop 42 --checkout                 # cria uma branch ligada à issue e entra nela
```

## Pull requests

```bash
gh pr create --fill                    # título e descrição a partir dos commits
gh pr create --draft --base develop --reviewer fulano
gh pr create --title "feat: busca" --body-file descricao.md
gh pr list                             # PRs abertos
gh pr status                           # seus PRs e os que esperam sua revisão
gh pr view 15                          # detalhes do PR
gh pr diff 15                          # as mudanças
gh pr checkout 15                      # baixa o PR para testar localmente
gh pr checks 15 --watch                # acompanha o CI até terminar
gh pr review 15 --approve
gh pr review 15 --request-changes --body "Faltou tratar lista vazia"
gh pr comment 15 --body "Testei aqui e funcionou 👍"
gh pr merge 15 --squash --delete-branch
gh pr merge 15 --squash --auto         # faz o merge sozinho quando o CI passar e houver aprovação
```

## GitHub Actions

```bash
gh run list                         # últimas execuções
gh run watch                        # acompanha a execução em andamento
gh run view 123456 --log-failed     # só o log dos passos que falharam
gh run rerun 123456 --failed        # roda de novo só os jobs que falharam
gh workflow run deploy.yml          # dispara um workflow com workflow_dispatch
gh secret set API_TOKEN             # cadastra um segredo (pede o valor sem mostrar)
gh variable set AMBIENTE --body producao
```

## Releases

```bash
gh release create v1.2.0 --generate-notes
gh release list
gh release download v1.2.0
```

## Busca

```bash
gh search repos "todo app" --language=typescript --sort=stars
gh search issues "login" --repo usuario/projeto --state open
gh search prs --author @me --state open
gh search code "useEffect" --repo usuario/projeto
```

## Saída em JSON: o superpoder do `gh`

Quase todo comando de listagem aceita `--json` com os campos que você quer e `--jq` para filtrar. Isso transforma o `gh` em fonte de dados para scripts (e para IA):

```bash
gh pr list --json number,title,author --jq '.[] | "\(.number) \(.title) (@\(.author.login))"'
gh issue list --label bug --json number --jq 'length'          # quantos bugs abertos
gh pr view 15 --json files --jq '.files[].path'                # arquivos alterados no PR
gh run list --json status,conclusion,name --limit 5
```

Rode `gh pr list --json` sem campos para ver a lista de campos disponíveis.

Para o que não tem comando pronto, o `gh api` chama a API do GitHub já autenticado:

```bash
gh api repos/{owner}/{repo}/contributors --jq '.[].login'
gh api user --jq .login
gh api --paginate repos/{owner}/{repo}/issues --jq '.[].title'
gh api graphql -f query='{ viewer { login repositories { totalCount } } }'
```

`{owner}` e `{repo}` são preenchidos com o repositório da pasta atual.

## Aliases e extensões

```bash
gh alias set prs 'pr list --author @me'      # agora: gh prs
gh alias list

gh extension browse                          # catálogo de extensões
gh extension install dlvhdr/gh-dash          # painel de PRs e issues no terminal
```

## `gh` em scripts e no GitHub Actions

Nos runners do GitHub Actions o `gh` já vem instalado. Basta passar o token:

```yaml
jobs:
  comentar:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    steps:
      - run: gh pr comment "$PR" --repo "$GITHUB_REPOSITORY" --body "Obrigado pelo PR! 🎉"
        env:
          GH_TOKEN: ${{ github.token }}
          PR: ${{ github.event.pull_request.number }}
```

Variáveis de ambiente úteis em scripts:

| Variável | Para que serve |
| --- | --- |
| `GH_TOKEN` | Token usado pelo `gh` (no Actions, `${{ github.token }}`) |
| `GH_REPO` | Repositório alvo, sem precisar estar na pasta (`usuario/projeto`) |
| `GH_PROMPT_DISABLED` | Nunca faz perguntas interativas: falha em vez de travar esperando resposta |
| `GH_PAGER` | Paginador. `GH_PAGER=cat` evita que a saída abra no `less` |
| `NO_COLOR` | Saída sem cores, mais fácil de processar |

## Usando o `gh` com IA

### Por que os agentes usam o `gh`

- **Já está autenticado**: o agente usa o seu login, sem precisar de token extra.
- **Saída estruturada**: `--json` dá dados exatos, sem a IA ter que "ler" uma página.
- **Não interativo**: flags como `--title`, `--body`, `--fill` e `--yes` permitem fazer tudo num comando só.
- **Cobre o ciclo inteiro**: da issue ao merge, sem sair do terminal.

### O que você pode pedir (e o que a IA roda)

| Você pede | O agente normalmente roda |
| --- | --- |
| "Lê a issue 42 e resolve" | `gh issue view 42 --comments`, cria branch, commita, `gh pr create` |
| "Por que o CI quebrou?" | `gh run list`, `gh run view <id> --log-failed` |
| "Revisa o PR 15" | `gh pr view 15`, `gh pr diff 15`, `gh pr review 15 --comment` |
| "Responde os comentários do review" | `gh api repos/{owner}/{repo}/pulls/15/comments`, ajusta o código, push |
| "Abre um PR com essas mudanças" | `git push -u origin <branch>`, `gh pr create --fill` |
| "Quais issues de bug estão sem dono?" | `gh issue list --label bug --search "no:assignee"` |
| "Cria uma release com o que entrou" | `gh release create vX.Y.Z --generate-notes` |

Por isso os outros capítulos importam: com [padrão de commit](04-padroes-de-commit.md), PRs pequenos e CI configurado, a IA entrega trabalho que dá para revisar e confiar.

### IA do próprio GitHub pelo `gh`

```bash
gh copilot                                   # abre o GitHub Copilot CLI (preview)
gh agent-task create "Adicionar testes ao módulo de pagamento"   # delega uma tarefa ao agente do Copilot (preview)
gh agent-task list
```

Os dois estão em preview e podem mudar. Alternativa ao `gh` para agentes: o **GitHub MCP Server**, que dá acesso ao GitHub para ferramentas de IA compatíveis com MCP.

### Segurança: a IA usa as **suas** permissões

O agente pode fazer tudo que o seu token permite: apagar branch, fazer merge, tornar um repositório público. Então:

- **Revise antes de ações irreversíveis.** Configure a ferramenta de IA para pedir confirmação antes de `push --force`, `pr merge`, `repo delete` e `repo edit --visibility`.
- **Proteja a `main`** com regras de branch: exigir PR, revisão humana e CI passando. Assim nem você nem a IA conseguem pular etapas por engano.
- **Token com o mínimo de permissão** para automações: use um *fine-grained personal access token* restrito aos repositórios necessários.
- **Confira o que vai no PR**: `gh pr diff` antes de pedir revisão para outra pessoa.
- **Cuidado com conteúdo de terceiros**: issues e comentários públicos podem conter instruções maliciosas tentando enganar a IA. Desconfie quando o agente quiser fazer algo que você não pediu.

## Cola rápida do `gh`

| Comando | O que faz |
| --- | --- |
| `gh auth login` / `gh auth status` | Login e conferência |
| `gh repo create --source . --push` | Sobe a pasta atual para um repositório novo |
| `gh repo clone` / `gh repo fork --clone` | Clona / faz fork e clona |
| `gh issue list` / `gh issue view <n>` | Lista / lê issues |
| `gh issue develop <n> --checkout` | Branch a partir da issue |
| `gh pr create --fill` | Abre PR |
| `gh pr checkout <n>` | Testa um PR localmente |
| `gh pr checks --watch` | Acompanha o CI do PR |
| `gh pr merge --squash --delete-branch` | Faz o merge |
| `gh run view --log-failed` | Log do que falhou no Actions |
| `gh api <rota> --jq <filtro>` | Qualquer coisa da API |
| `gh <comando> --json <campos>` | Saída estruturada para scripts e IA |

Documentação completa: [cli.github.com/manual](https://cli.github.com/manual).

---

[← Anterior](12-recursos-do-github.md) · [Índice](../README.md) · [Próximo: .gitignore e hooks →](14-gitignore-e-hooks.md)
