# 15. Git avançado

Ferramentas que você não usa todo dia, mas que salvam quando precisa.

## HEAD e detached HEAD

O `HEAD` aponta para onde você está agora: normalmente para uma branch, que aponta para o último commit dela.

Se você entra direto em um commit ou tag, o `HEAD` fica "solto" (**detached HEAD**):

```bash
git switch --detach a1b2c3d     # vai para um commit
git switch --detach v1.0.0      # vai para uma tag
```

Serve para olhar ou testar uma versão antiga. Se fizer commits ali e trocar de branch, eles ficam sem branch e podem se perder. Para guardar:

```bash
git switch -c minha-branch-nova
```

## Buscando no histórico

```bash
git log --grep="login"            # commits com "login" na mensagem
git log -S "calcularFrete"        # commits que adicionaram ou removeram esse texto no código
git log -p -- src/carrinho.js     # mudanças de um arquivo, commit a commit
git log --follow -- novo-nome.js  # segue o arquivo mesmo depois de renomeado
git log main..feat/login          # commits que estão na feat e não na main
git log --pretty="%h %an %ar %s"  # formato personalizado
git shortlog -sn                  # quantos commits cada pessoa fez
```

Comparando:

```bash
git diff main feat/login          # diferença entre branches
git diff a1b2c3d f4e5d6c          # entre dois commits
git diff HEAD~3 -- index.html     # um arquivo, comparado com 3 commits atrás
git diff --stat                   # só o resumo (arquivos e linhas)
```

## git bisect: achando o commit que quebrou

Algo funcionava na semana passada e hoje não funciona, com 80 commits no meio. O `bisect` faz uma **busca binária**: em uns 7 passos acha o culpado.

```bash
git bisect start
git bisect bad                 # o commit atual está quebrado
git bisect good v1.2.0         # nesta versão funcionava
```

O Git vai para um commit no meio do caminho. Teste e responda:

```bash
git bisect good   # ou
git bisect bad
```

Repita até ele mostrar o primeiro commit ruim. Depois volte ao normal:

```bash
git bisect reset
```

Com um script de teste, é automático:

```bash
git bisect run npm test
```

## git worktree: duas branches abertas ao mesmo tempo

Em vez de fazer stash e trocar de branch, abra outra branch em outra pasta, com o mesmo repositório:

```bash
git worktree add ../projeto-hotfix fix/urgente
cd ../projeto-hotfix      # trabalha aqui, a pasta original continua como estava
git worktree list
git worktree remove ../projeto-hotfix
```

## Submódulos

Um repositório dentro de outro, fixado em um commit específico. Útil para compartilhar uma biblioteca entre projetos.

```bash
git submodule add git@github.com:usuario/biblioteca.git libs/biblioteca
git clone --recurse-submodules <url>     # clona já trazendo os submódulos
git submodule update --init --recursive  # se clonou sem eles
git submodule update --remote            # atualiza para o último commit do submódulo
```

São fáceis de bagunçar. Se der para usar um gerenciador de pacotes (npm, pip), prefira.

## Git LFS: arquivos grandes

O Git guarda todas as versões de todos os arquivos. Com vídeos, PSDs e datasets o repositório incha rápido. O **Git LFS** guarda esses arquivos fora do histórico e deixa só um ponteiro no repositório.

```bash
git lfs install
git lfs track "*.psd"
git add .gitattributes
git add arte.psd
git commit -m "chore: adiciona arte em Git LFS"
```

O GitHub recusa arquivos acima de 100 MB fora do LFS.

## Patches

Para mandar mudanças sem push (por e-mail, por exemplo):

```bash
git diff > mudanca.patch          # mudanças não commitadas
git apply mudanca.patch           # aplica

git format-patch -2               # os 2 últimos commits, um arquivo por commit
git am 0001-*.patch               # aplica mantendo autor e mensagem
```

## Reescrevendo o histórico inteiro

Para remover um arquivo de **todos** os commits (senha vazada, arquivo gigante), use o [git filter-repo](https://github.com/newren/git-filter-repo). O antigo `git filter-branch` é lento e o próprio Git desaconselha.

```bash
git filter-repo --path .env --invert-paths
```

Isso muda o hash de todos os commits afetados. Depois é preciso `git push --force` e todo mundo do time precisa clonar de novo. Use só quando realmente necessário.

## Assinando commits

Prova que o commit foi feito por você (aparece como **Verified** no GitHub). Dá para assinar com a mesma chave SSH do [capítulo 06](06-repositorios-remotos.md):

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

E cadastre a chave no GitHub também como *Signing key*.

---

[← Anterior](14-gitignore-e-hooks.md) · [Índice](../README.md) · [Próximo: Problemas comuns →](16-problemas-comuns.md)
