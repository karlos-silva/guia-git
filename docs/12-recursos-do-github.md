# 12. Recursos do GitHub

O GitHub vai muito além de guardar código. Um tour pelo que vale conhecer.

## GitHub Pages

Hospedagem gratuita de sites estáticos (HTML, CSS e JS) direto do repositório.

1. *Settings → Pages*.
2. Em *Source*, escolha a branch (ex.: `main`) e a pasta (`/` ou `/docs`).
3. Em alguns minutos o site está em `https://seu-usuario.github.io/nome-do-repo`.

Um repositório chamado `seu-usuario.github.io` vira o site em `https://seu-usuario.github.io`. Ótimo para portfólio.

Para projetos com build (React, Vite, Astro) ou geradores de site estático (Jekyll, Hugo, Docusaurus), use *Source: GitHub Actions* e um workflow de deploy. Dá também para usar um **domínio próprio** em *Custom domain*.

## Releases

Versões oficiais do projeto, criadas a partir de uma [tag](08-stash-rebase-cherry-pick.md#tags). Cada release tem notas do que mudou e pode ter arquivos anexados (instaladores, `.zip`).

```bash
gh release create v1.0.0 --generate-notes
```

O `--generate-notes` monta as notas a partir dos PRs. Com os commits no padrão, fica fácil saber o que é recurso e o que é correção.

## GitHub CLI

O `gh` traz o GitHub para o terminal. Instale em [cli.github.com](https://cli.github.com) e faça login:

```bash
gh auth login
```

```bash
gh repo create meu-projeto --public --source . --push   # cria repo a partir da pasta atual
gh repo clone usuario/projeto
gh pr create --fill          # abre PR com título e corpo a partir dos commits
gh pr list
gh pr checkout 42            # baixa o PR 42 para testar
gh pr merge --squash
gh issue create
gh issue list --label bug
gh run watch                 # acompanha o GitHub Actions
gh browse                    # abre o repo no navegador
```

## Gists

Para compartilhar um trecho de código, uma anotação ou um arquivo de configuração sem criar repositório. Podem ser públicos ou secretos (não listados) e cada gist é um mini repositório Git. Em [gist.github.com](https://gist.github.com) ou:

```bash
gh gist create script.sh
```

## Wikis e Discussions

- **Wiki:** documentação longa do projeto, separada do código (aba *Wiki*, ativada em *Settings*).
- **Discussions:** fórum do repositório para dúvidas, ideias e anúncios. Deixa as issues só para trabalho concreto.

## Segurança

| Recurso | O que faz |
| --- | --- |
| **Dependabot alerts** | Avisa quando uma dependência tem vulnerabilidade conhecida |
| **Dependabot updates** | Abre PRs atualizando dependências |
| **Secret scanning** | Detecta senhas e tokens commitados por engano |
| **Code scanning** | Analisa o código atrás de falhas (CodeQL) |
| **Security advisories** | Reportar e corrigir vulnerabilidades em privado |

Ative em *Settings → Code security*. Para sua conta: autenticação em dois fatores e chaves SSH em vez de senha.

## Packages

O **GitHub Packages** hospeda pacotes (npm, Maven, NuGet, RubyGems) e imagens Docker (`ghcr.io`), ligados ao repositório e publicáveis pelo Actions.

## Codespaces e Copilot

- **Codespaces:** um VS Code completo rodando na nuvem, com o projeto já configurado. Aperte `.` em qualquer repositório para abrir um editor leve no navegador, ou *Code → Codespaces* para um ambiente completo com terminal.
- **Copilot:** assistente de IA para escrever, explicar e revisar código, no editor e no próprio GitHub (inclusive revisando PRs). Grátis para estudantes pelo GitHub Education.

## API, webhooks e apps

Para integrar o GitHub com outros sistemas:

- **REST API e GraphQL API:** consultar e alterar repositórios, issues e PRs por código. Rápido de testar com `gh api`:

  ```bash
  gh api repos/usuario/projeto/issues --jq '.[].title'
  ```

- **Webhooks:** o GitHub chama uma URL sua quando algo acontece (push, PR, issue).
- **GitHub Apps e OAuth Apps:** integrações que agem no GitHub com permissões próprias (bots, ferramentas de CI, "Login com GitHub").
- **Marketplace:** apps e actions prontos para instalar.

## Sponsors

O **GitHub Sponsors** permite apoiar financeiramente quem mantém projetos open source, ou receber apoio pelos seus.

---

[← Anterior](11-github-actions.md) · [Índice](../README.md) · [Próximo: .gitignore e hooks →](13-gitignore-e-hooks.md)
