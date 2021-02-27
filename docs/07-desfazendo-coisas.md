# 07. Desfazendo coisas

Errar faz parte. Quase tudo no Git dá para desfazer, desde que você escolha o comando certo.

## Qual comando usar?

| Situação | Comando |
| --- | --- |
| Quero descartar o que mudei num arquivo (sem commit) | `git restore arquivo` |
| Coloquei no stage sem querer | `git restore --staged arquivo` |
| Errei a mensagem do último commit | `git commit --amend` |
| Esqueci um arquivo no último commit | `git add arquivo` + `git commit --amend --no-edit` |
| Quero desfazer o último commit, mas manter as mudanças | `git reset --soft HEAD~1` |
| Quero jogar fora commits locais (não enviados) | `git reset --hard <hash>` |
| Quero desfazer um commit que **já foi enviado** | `git revert <hash>` |
| Apaguei algo e quero recuperar | `git reflog` |

## A regra de ouro

> **Não reescreva histórico que já foi enviado e que outras pessoas usam.**

`amend`, `reset` e `rebase` **reescrevem** o histórico: criam commits novos no lugar dos antigos. No seu computador, tudo bem. Mas se o commit já está no GitHub e alguém já baixou, você vai bagunçar o repositório da pessoa.

Commit já enviado? Use `git revert`, que **adiciona** um commit desfazendo o outro.

## Descartando mudanças: `git restore`

```bash
git restore index.html          # volta o arquivo para como estava no último commit
git restore .                   # todos os arquivos (cuidado: não tem volta)
git restore --staged index.html # tira do stage, mas mantém a mudança no arquivo
git restore --source=a1b2c3d index.html   # traz o arquivo como estava em outro commit
```

Arquivos novos (untracked) não são afetados pelo `restore`. Para apagar:

```bash
git clean -n    # mostra o que seria apagado
git clean -fd   # apaga de verdade (arquivos e pastas)
```

## Corrigindo o último commit: `--amend`

```bash
git commit --amend -m "fix: mensagem corrigida"
```

Esqueceu um arquivo:

```bash
git add esquecido.css
git commit --amend --no-edit
```

Se já tinha dado push, vai precisar de `git push --force-with-lease`. Só faça isso em branch sua.

## Voltando no tempo: `git reset`

O `reset` move a branch para outro commit. O que acontece com as mudanças depende da opção:

| Opção | Commits desfeitos | Stage | Seus arquivos |
| --- | --- | --- | --- |
| `--soft` | sim | mudanças ficam no stage | intactos |
| `--mixed` (padrão) | sim | limpo | mudanças ficam nos arquivos |
| `--hard` | sim | limpo | **mudanças apagadas** |

```bash
git reset --soft HEAD~1    # desfaz o último commit, tudo continua no stage
git reset HEAD~3           # desfaz os 3 últimos, mudanças ficam nos arquivos
git reset --hard a1b2c3d   # volta exatamente para aquele commit
```

`HEAD~1` significa "um commit antes do atual". `HEAD~3`, três antes.

> O `--hard` apaga mudanças não commitadas sem perguntar. Antes de usar, rode `git status` e confira.

## Desfazendo commit já enviado: `git revert`

```bash
git revert a1b2c3d
```

Cria um commit novo com o "oposto" do commit escolhido. O histórico fica intacto e ninguém do time é afetado. Depois é só `git push`.

## A rede de segurança: `git reflog`

O `reflog` registra **tudo** que o `HEAD` fez nos últimos ~90 dias: commits, resets, trocas de branch, rebases. Mesmo depois de um `reset --hard`, os commits continuam lá por um tempo.

```bash
git reflog
```

```text
a1b2c3d HEAD@{0}: reset: moving to HEAD~2
f4e5d6c HEAD@{1}: commit: feat: adiciona carrinho
...
```

Para recuperar:

```bash
git reset --hard f4e5d6c          # volta para lá
# ou, mais seguro, cria uma branch apontando para o commit perdido:
git branch recuperado f4e5d6c
```

Só não tem salvação o que **nunca foi commitado**. Mais um motivo para commitar com frequência.

---

[← Anterior](06-repositorios-remotos.md) · [Índice](../README.md) · [Próximo: Stash, rebase e cherry-pick →](08-stash-rebase-cherry-pick.md)
