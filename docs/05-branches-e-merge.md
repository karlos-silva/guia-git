# 05. Branches e merge

## O que é uma branch

Uma branch é uma **linha paralela de trabalho**. Você cria uma branch para desenvolver algo (um recurso, uma correção) sem mexer na versão principal. Quando terminar, junta de volta.

```text
main     ●───●───●───────────●   ← merge
                  \         /
feat/login         ●───●───●
```

Por baixo dos panos, uma branch é só um ponteiro para um commit. Criar branch no Git é instantâneo e barato, então use à vontade.

## Comandos básicos

```bash
git branch                      # lista branches locais (* = a atual)
git branch -a                   # inclui as remotas
git switch -c feat/login        # cria e já entra na branch
git switch main                 # troca de branch
git switch -                    # volta para a branch anterior
git branch -m novo-nome         # renomeia a branch atual
git branch -d feat/login        # apaga (só se já tiver sido mergeada)
git branch -D feat/login        # apaga mesmo sem merge (cuidado)
```

> Você vai ver `git checkout` em tutoriais antigos. Ele faz várias coisas ao mesmo tempo. Desde o Git 2.23 existem `git switch` (trocar de branch) e `git restore` (restaurar arquivos), que são mais claros. Prefira os dois.

Antes de trocar de branch, commite ou guarde suas mudanças (com [stash](08-stash-rebase-cherry-pick.md#stash)). Se não, o Git pode recusar a troca ou levar as mudanças junto.

## Merge: juntando branches

Vá para a branch que vai **receber** as mudanças e faça o merge:

```bash
git switch main
git merge feat/login
```

### Fast-forward

Se a `main` não andou desde que a branch foi criada, o Git só "avança o ponteiro". Nenhum commit novo é criado:

```text
antes:   main ●───●
                   \
         feat       ●───●

depois:  main ●───●───●───●
```

### Merge de três vias

Se as duas branches andaram, o Git cria um **commit de merge** que une as duas:

```text
main  ●───●───●───────●   ← commit de merge
           \         /
feat        ●───●───●
```

Para sempre criar o commit de merge (deixa claro no histórico que ali entrou uma feature):

```bash
git merge --no-ff feat/login
```

## Conflitos

Acontece quando as duas branches mudaram **as mesmas linhas** do mesmo arquivo. O Git não sabe qual versão escolher e pede ajuda:

```text
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
```

O arquivo fica assim:

```html
<<<<<<< HEAD
<h1>Bem-vindo!</h1>
=======
<h1>Olá, visitante!</h1>
>>>>>>> feat/login
```

- Entre `<<<<<<< HEAD` e `=======`: a versão da branch atual.
- Entre `=======` e `>>>>>>>`: a versão da branch que está entrando.

### Resolvendo

1. Abra o arquivo e deixe do jeito certo (uma versão, a outra ou uma mistura).
2. **Apague as marcações** `<<<<<<<`, `=======` e `>>>>>>>`.
3. Marque como resolvido e finalize:

```bash
git add index.html
git commit          # o Git já sugere a mensagem de merge
```

Desistiu do merge? Volta tudo como estava:

```bash
git merge --abort
```

> O VS Code mostra botões "Accept Current", "Accept Incoming" e "Accept Both" em cima de cada conflito. Ajuda muito.

### Evitando conflitos

- Faça branches curtas, que duram dias e não semanas.
- Traga a `main` para sua branch com frequência (`git merge main` ou `git rebase main`).
- Combine com o time quem mexe em quê.

## Exercício

1. Num repositório de teste, crie a branch `feat/titulo` e mude o `<h1>` do `index.html`. Commite.
2. Volte para a `main`, mude o mesmo `<h1>` para outro texto. Commite.
3. Rode `git merge feat/titulo`, resolva o conflito e finalize.
4. Veja o resultado com `git log --oneline --graph`.

---

[← Anterior](04-padroes-de-commit.md) · [Índice](../README.md) · [Próximo: Repositórios remotos →](06-repositorios-remotos.md)
