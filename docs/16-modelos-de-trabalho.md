# 16. Modelos de trabalho nas empresas

O [capítulo 10](10-fluxos-de-trabalho.md) apresentou os fluxos de trabalho. Aqui vamos a fundo: como cada modelo funciona no dia a dia de uma empresa, os comandos de cada etapa, e como escolher (ou migrar) entre eles.

## Por que isso importa

Num projeto pessoal, qualquer jeito funciona. Numa empresa com 10, 50 ou 500 pessoas commitando no mesmo código, o modelo de branches define:

- **com que frequência** dá para colocar código em produção;
- **quanto conflito** o time enfrenta;
- **como corrigir** um bug urgente em produção;
- **quantas versões** do software precisam ser mantidas ao mesmo tempo;
- **quem aprova** o quê antes de chegar no cliente.

Não existe modelo melhor em absoluto. Existe o que combina com o produto e com o time.

## Git Flow

Criado em 2010 por Vincent Driessen, foi por anos o modelo mais famoso. Usa **duas branches permanentes** e três tipos de branches temporárias.

```text
hotfix/1.0.1          ●───●
                     /     \
main      ●─────────●───────●──────────────●        (só versões lançadas: v1.0.0, v1.0.1, v1.1.0)
           \       / v1.0.0  \ v1.0.1      / v1.1.0
release     \     ●──●        \           ●──●       (release/1.0, release/1.1)
             \   /             \         /
develop       ●─●───●───────────●───●───●───●        (integração)
                 \     /             \     /
feature           ●───●               ●───●          (feature/login, feature/busca)
```

| Branch | Sai de | Volta para | Para quê |
| --- | --- | --- | --- |
| `main` | — | — | Só código lançado. Cada merge recebe uma tag de versão |
| `develop` | `main` | — | Integração do que vai na próxima versão |
| `feature/*` | `develop` | `develop` | Um recurso novo |
| `release/*` | `develop` | `main` e `develop` | Congelar e estabilizar uma versão (só correções) |
| `hotfix/*` | `main` | `main` e `develop` | Correção urgente em produção |

### O ciclo na prática

Feature:

```bash
git switch develop
git switch -c feature/busca
# ... commits ...
git switch develop
git merge --no-ff feature/busca
git branch -d feature/busca
```

Release:

```bash
git switch -c release/1.1 develop
# só ajustes finais: versão no package.json, correções de bugs encontrados no teste
git switch main
git merge --no-ff release/1.1
git tag -a v1.1.0 -m "Versão 1.1.0"
git switch develop
git merge --no-ff release/1.1      # leva as correções de volta
git branch -d release/1.1
```

Hotfix:

```bash
git switch -c hotfix/1.1.1 main
# ... corrige ...
git switch main
git merge --no-ff hotfix/1.1.1
git tag -a v1.1.1 -m "Versão 1.1.1"
git switch develop
git merge --no-ff hotfix/1.1.1
git branch -d hotfix/1.1.1
```

Na prática, cada um desses merges vira um **pull request**. Existe também a extensão `git flow` (`git flow feature start busca`), que automatiza esses comandos.

### Prós e contras

| ✅ Prós | ❌ Contras |
| --- | --- |
| Separação clara entre o que está em produção e o que está em desenvolvimento | Muitas branches e muitos merges para lembrar |
| Ótimo para **versões planejadas** (v1.0, v1.1, v2.0) | Features ficam dias ou semanas longe da `develop`: conflitos grandes |
| Dá para estabilizar uma versão enquanto o time segue desenvolvendo | Entrega lenta: o código espera o próximo ciclo de release |
| Hotfix com caminho bem definido | Fácil esquecer de levar o hotfix para a `develop` |

**Quando usar:** apps de loja (iOS, Android), software instalado no cliente, bibliotecas e produtos que mantêm várias versões ao mesmo tempo.

> O próprio autor publicou em 2020 uma nota recomendando modelos mais simples (como o GitHub Flow) para software entregue continuamente, como aplicações web.

## GitHub Flow

Uma única branch permanente (`main`), sempre pronta para produção, e branches curtas que entram por pull request. Visto em detalhes no [capítulo 10](10-fluxos-de-trabalho.md#github-flow-recomendado-para-começar).

**Quando usar:** times pequenos e médios, aplicações web e APIs com deploy frequente. É o ponto de partida mais comum.

## GitLab Flow

Um meio-termo: o GitHub Flow mais **branches de ambiente**. O código só anda "para baixo", de um ambiente para o próximo:

```text
feature  ●───●
              \ (PR)
main      ●────●──────●──────────●
                       \          \
staging     ────────────●──────────●──────      (testes, homologação)
                                    \
production  ─────────────────────────●─────      (o que o cliente usa)
```

- Tudo entra primeiro na `main` (regra *upstream first*).
- Promover para `staging` ou `production` é um merge (ou cherry-pick) da branch anterior.
- Variante para produtos com versões: branches `release/1.x`, `release/2.x` saindo da `main`.

**Quando usar:** empresas com ambientes de homologação obrigatórios, aprovações formais antes da produção ou deploy em janelas específicas (bancos, governo, saúde).

## Trunk-based development

Todo mundo integra na **`main` (o "tronco")** pelo menos uma vez por dia. Ou commitando direto, ou com branches que vivem **horas, no máximo um ou dois dias**.

```text
main   ●─●─●─●─●─●─●─●─●─●─●─●─●─●─●   (vários merges por dia, sempre verde)
        \ / \ /   \ /     \ /
         ●   ●     ●       ●            (branches de horas)
```

É o modelo usado por empresas como Google e Meta. As pesquisas do DORA (*State of DevOps*) associam trunk-based a times com entregas mais rápidas e estáveis.

### O que torna o trunk-based possível

Ninguém integra código incompleto na `main` sem algumas práticas:

**1. CI forte e rápido.** Todo PR roda testes automatizados. A `main` quebrada é prioridade número um do time.

**2. Feature flags.** O código de um recurso incompleto entra em produção **desligado**:

```js
if (flags.isEnabled("novo-checkout", usuario)) {
  return renderNovoCheckout();
}
return renderCheckoutAntigo();
```

Depois dá para ligar só para o time interno, depois para 5% dos usuários, depois para todos, e desligar na hora se der problema, sem deploy. Ferramentas: LaunchDarkly, Unleash, Flagsmith, GrowthBook, ou um arquivo de configuração simples.

**3. Branch by abstraction.** Para trocar algo grande (ex.: o banco de dados), crie uma interface, faça o código antigo e o novo implementarem a mesma interface e troque aos poucos, sempre com a `main` funcionando.

**4. Mudanças pequenas.** PRs de dezenas de linhas, revisados em minutos ou horas, não dias.

### Releases no trunk-based

Duas formas comuns:

- **Deploy contínuo:** cada merge na `main` vai para produção automaticamente.
- **Branch de release cortada do tronco:** `release/2026-11` sai da `main` na data do lançamento. Correções são feitas **primeiro na `main`** e depois levadas com cherry-pick:

```bash
git switch main
# ... commit da correção ...
git switch release/2026-11
git cherry-pick a1b2c3d
```

| ✅ Prós | ❌ Contras |
| --- | --- |
| Quase não há conflitos grandes | Exige testes automatizados de verdade |
| Código chega rápido em produção | Exige disciplina: commits pequenos e `main` sempre verde |
| Histórico simples | Feature flags viram dívida se não forem removidas depois |
| Todo mundo vê o código de todo mundo cedo | Difícil para times sem CI ou com revisão lenta |

**Quando usar:** produtos web e SaaS com deploy frequente, times com boa cobertura de testes, empresas que querem entregar várias vezes ao dia.

## Comparando

| | Git Flow | GitHub Flow | GitLab Flow | Trunk-based |
| --- | --- | --- | --- | --- |
| Branches permanentes | `main` + `develop` | `main` | `main` + ambientes | `main` |
| Vida de uma feature branch | Dias a semanas | Dias | Dias | Horas (até 2 dias) |
| Frequência de deploy | Por versão planejada | Várias por semana | Conforme aprovação | Várias por dia |
| Complexidade | Alta | Baixa | Média | Baixa nas branches, alta na disciplina |
| Depende de testes automatizados | Média | Alta | Alta | Muito alta |
| Melhor para | Apps de loja, bibliotecas, várias versões | Times pequenos/médios, web | Ambientes regulados, homologação | SaaS, times maduros |

## Como escolher

Responda em ordem:

1. **Você mantém várias versões em produção ao mesmo tempo?** (ex.: clientes na v2 e na v3) → Git Flow ou trunk-based com branches de release.
2. **Existe homologação ou aprovação formal antes da produção?** → GitLab Flow (branches de ambiente) ou trunk-based com *environments* aprovados no CI.
3. **Tem testes automatizados confiáveis e deploy automatizado?** Sim → trunk-based. Ainda não → GitHub Flow, e evolua.
4. **Na dúvida** → GitHub Flow. É simples e fácil de evoluir para trunk-based.

## Governança: o que as empresas configuram

Independente do modelo, o GitHub tem ferramentas para garantir que as regras sejam seguidas:

| Recurso | O que faz |
| --- | --- |
| **Rulesets / proteção de branch** | Exige PR, aprovações, CI verde e histórico linear na `main`; bloqueia force push e exclusão |
| **CODEOWNERS** | Define quem precisa aprovar mudanças em cada pasta (ex.: time de pagamentos aprova `src/pagamentos/`) |
| **Merge queue** | Fila de merge: testa cada PR já combinado com os que entraram antes, evitando que a `main` quebre com muitos merges por dia |
| **Environments** | Deploy em produção só com aprovação de pessoas específicas |
| **Commits assinados** | Garante a autoria de cada commit ([capítulo 15](15-git-avancado.md#assinando-commits)) |
| **Versionamento automático** | Ferramentas como semantic-release e release-please leem os [commits padronizados](04-padroes-de-commit.md) e geram versão, changelog e release sozinhas |

Exemplo de `.github/CODEOWNERS`:

```text
*                     @empresa/tech-leads
/src/pagamentos/      @empresa/time-pagamentos
/infra/               @empresa/time-plataforma
*.md                  @empresa/docs
```

## Migrando de Git Flow para trunk-based

Muitas empresas fazem essa transição. Um caminho seguro:

1. **Automatize os testes e o deploy** primeiro. Sem isso, não comece.
2. **Encurte as feature branches**: meta de no máximo 2 ou 3 dias.
3. **Adote feature flags** para recursos que levam mais tempo.
4. **Faça merge da `develop` na `main` com mais frequência**, até a `develop` virar redundante.
5. **Aposente a `develop`**: todo PR passa a mirar a `main`.
6. **Corte releases da `main`** (ou faça deploy contínuo).

## Na prática

| Tipo de empresa | Modelo comum |
| --- | --- |
| Startup com produto web | GitHub Flow, evoluindo para trunk-based |
| SaaS grande | Trunk-based + feature flags + merge queue |
| App mobile | Git Flow ou trunk-based com branches de release (as lojas exigem versões) |
| Biblioteca open source | GitHub Flow + tags e releases, branches `release/x.y` para manter versões antigas |
| Banco, governo, saúde | GitLab Flow com ambientes e aprovações formais |
| Agência, projetos por cliente | GitHub Flow, um repositório por projeto |

## Exercício

1. Num repositório de teste, simule o Git Flow: crie `develop`, uma `feature/x`, uma `release/1.0` com tag `v1.0.0` e um `hotfix/1.0.1`. Veja o resultado com `git log --oneline --graph --all`.
2. No mesmo repositório, simule trunk-based: cinco commits pequenos direto na `main`, um deles com um recurso "escondido" atrás de um `if` de feature flag.
3. Compare os dois gráficos. Qual é mais fácil de entender?

---

[← Anterior](15-git-avancado.md) · [Índice](../README.md) · [Próximo: Problemas comuns →](17-problemas-comuns.md)
