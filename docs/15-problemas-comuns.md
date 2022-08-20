# 15. Problemas comuns

Os "e agora?" mais frequentes, com a solução.

## Commitei na branch errada

Ainda **não** deu push. Os commits foram para a `main`, mas deveriam estar numa branch nova:

```bash
git branch feat/nova          # cria a branch apontando para os commits atuais
git reset --hard origin/main  # volta a main para como está no remoto
git switch feat/nova
```

Deveriam ir para uma branch que já existe:

```bash
git switch branch-certa
git cherry-pick a1b2c3d       # traz o commit
git switch main
git reset --hard HEAD~1       # remove da main (só se não tiver dado push)
```

## Commitei uma senha ou token

1. **Revogue a credencial imediatamente** (gere outra senha ou token no serviço). Considere que ela vazou: robôs varrem o GitHub atrás disso em minutos.
2. Tire do código e use variável de ambiente (`.env` no `.gitignore`).
3. Se o commit ainda não foi enviado: `git reset --soft HEAD~1`, corrija e commite de novo.
4. Se já foi enviado, apagar o arquivo num commit novo não resolve, porque ele continua no histórico. Remova com `git filter-repo` ([capítulo 14](14-git-avancado.md#reescrevendo-o-histórico-inteiro)). Mas o passo 1 é o que realmente importa.

## Push recusado: `rejected (fetch first)` / `non-fast-forward`

O remoto tem commits que você não tem. Traga e tente de novo:

```bash
git pull --rebase
git push
```

Se der conflito no rebase, resolva, `git add` e `git rebase --continue`.

## Push recusado depois de amend ou rebase

Você reescreveu commits que já estavam no remoto. Se a branch é **só sua**:

```bash
git push --force-with-lease
```

Se é compartilhada, não force: converse com o time ou use `git revert`.

## `Permission denied (publickey)`

O GitHub não reconheceu sua chave SSH.

```bash
ssh -T git@github.com     # testa a conexão
ls ~/.ssh                 # existe id_ed25519 e id_ed25519.pub?
```

Se não existir, gere e cadastre (veja o [capítulo 06](06-repositorios-remotos.md#conectando-com-o-github-via-ssh)). Se existir, confira se a `.pub` está cadastrada no GitHub.

## `fatal: not a git repository`

Você não está dentro de uma pasta com repositório. Confira com `pwd` e entre na pasta certa, ou rode `git init` se for um projeto novo.

## `fatal: refusing to merge unrelated histories`

Aparece quando você cria o repositório no GitHub **com** README e tenta enviar um projeto local que já tinha commits. São dois históricos sem relação:

```bash
git pull origin main --allow-unrelated-histories
# resolva conflitos, se houver
git push -u origin main
```

Para evitar: crie o repositório no GitHub vazio.

## Estou em "detached HEAD"

Você entrou num commit ou tag diretamente. Para voltar: `git switch main`. Se fez commits ali e quer guardar: `git switch -c nova-branch`. Detalhes no [capítulo 14](14-git-avancado.md#head-e-detached-head).

## Fiquei preso no editor do commit

O Git abriu o **Vim**. Para salvar e sair: aperte `Esc`, digite `:wq` e Enter. Para sair sem salvar: `Esc`, `:q!` e Enter.

Para não acontecer de novo, troque o editor ([capítulo 02](02-instalacao-e-configuracao.md#configuração-inicial)).

## Conflito e não sei o que fazer

```bash
git status            # mostra os arquivos em conflito
```

Resolva cada arquivo (apague as marcações `<<<<<<<`, `=======`, `>>>>>>>`), depois `git add` e `git commit` (ou `git rebase --continue`). Para desistir: `git merge --abort` ou `git rebase --abort`. Veja o [capítulo 05](05-branches-e-merge.md#conflitos).

## Arquivo aparece como modificado, mas não mexi

Quase sempre é fim de linha (CRLF x LF) ou permissão de arquivo:

```bash
git diff                                 # mostra ^M? É fim de linha
git config --global core.autocrlf input  # macOS/Linux (true no Windows)
git config core.fileMode false           # ignora mudança de permissão
```

## Arquivo grande demais (> 100 MB)

O GitHub recusa o push. Tire o arquivo do histórico (`git reset` se não enviou, ou `git filter-repo`) e use [Git LFS](14-git-avancado.md#git-lfs-arquivos-grandes) ou deixe fora do repositório.

## Apaguei uma branch ou commit sem querer

```bash
git reflog                       # ache o hash de onde a branch estava
git branch recuperada a1b2c3d
```

Veja o [capítulo 07](07-desfazendo-coisas.md#a-rede-de-segurança-git-reflog).

## Quero desfazer tudo e voltar igual ao GitHub

Apaga **todas** as mudanças locais (commitadas ou não) da branch atual:

```bash
git fetch
git reset --hard origin/main
git clean -fd     # remove também arquivos novos
```

---

[← Anterior](14-git-avancado.md) · [Índice](../README.md) · [Cola de comandos →](cola.md)
