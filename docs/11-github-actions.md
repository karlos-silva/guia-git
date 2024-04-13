# 11. GitHub Actions

O **GitHub Actions** roda tarefas automaticamente quando algo acontece no repositório: rodar os testes a cada push, checar o lint em cada PR, publicar o site quando a `main` muda, gerar uma versão quando você cria uma tag.

## Conceitos

| Termo | O que é |
| --- | --- |
| **Workflow** | Um arquivo `.yml` em `.github/workflows/` que descreve a automação |
| **Evento (trigger)** | O que dispara o workflow: `push`, `pull_request`, horário, botão manual... |
| **Job** | Um conjunto de passos que roda numa máquina |
| **Step** | Um passo: um comando ou uma *action* pronta |
| **Action** | Passo reutilizável, publicado no [Marketplace](https://github.com/marketplace?type=actions) (ex.: `actions/checkout`) |
| **Runner** | A máquina que executa o job (Linux, Windows ou macOS, fornecida pelo GitHub ou sua) |

## YAML em 30 segundos

Os workflows são escritos em YAML. A indentação (com espaços, nunca tab) define a estrutura:

```yaml
chave: valor
lista:
  - item 1
  - item 2
objeto:
  nome: Karlos
  ativo: true
texto-longo: |
  várias linhas
  mantidas como estão
```

## Primeiro workflow: rodar testes

`.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  testes:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm            # guarda as dependências entre execuções

      - run: npm ci
      - run: npm test
```

Para Python, troque os passos:

```yaml
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: pip
      - run: pip install -r requirements.txt
      - run: pytest
```

Faça o push e acompanhe na aba **Actions**. No PR aparece ✅ ou ❌ ao lado de cada commit.

## Eventos mais usados

```yaml
on:
  push:                       # a cada push
    branches: [main]
  pull_request:               # a cada PR aberto ou atualizado
  workflow_dispatch:          # botão "Run workflow" na aba Actions
  schedule:
    - cron: "0 9 * * 1"       # toda segunda às 9h (UTC)
  release:
    types: [published]        # quando uma release é publicada
```

## Segredos e variáveis

Nunca coloque senha ou token no código. Cadastre em *Settings → Secrets and variables → Actions* e use no workflow:

```yaml
      - run: ./deploy.sh
        env:
          API_TOKEN: ${{ secrets.API_TOKEN }}
          AMBIENTE: ${{ vars.AMBIENTE }}
```

Os segredos aparecem como `***` nos logs.

## Contexto e condições

O workflow tem acesso a informações do evento (*contexts*):

```yaml
      - run: echo "Branch ${{ github.ref_name }}, autor ${{ github.actor }}"

      - name: Deploy só na main
        if: github.ref == 'refs/heads/main'
        run: ./deploy.sh
```

## Artefatos

Para guardar arquivos gerados (build, relatório de testes) e baixar depois:

```yaml
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/
```

## Status do workflow no README

```markdown
![CI](https://github.com/usuario/projeto/actions/workflows/ci.yml/badge.svg)
```

## Ideias de automação

- Lint e testes em cada PR.
- Validar a mensagem dos commits do PR no padrão do [capítulo 04](04-padroes-de-commit.md).
- Publicar o site no GitHub Pages a cada push na `main`.
- Gerar uma release quando criar uma tag `v*`.
- **Dependabot** (*Settings → Code security*) abrindo PRs para atualizar dependências.

> O Actions é gratuito para repositórios públicos. Repositórios privados têm uma cota mensal de minutos.

---

[← Anterior](10-fluxos-de-trabalho.md) · [Índice](../README.md) · [Próximo: Recursos do GitHub →](12-recursos-do-github.md)
