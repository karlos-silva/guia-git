# 06. Repositórios remotos

Um **remoto** é uma cópia do repositório em outro lugar, normalmente no GitHub. É por ele que você faz backup e colabora.

## Conectando com o GitHub via SSH

Com SSH você não precisa digitar senha a cada push. Faça uma vez por computador.

1. Gere uma chave:

   ```bash
   ssh-keygen -t ed25519 -C "seu-email@exemplo.com"
   ```

   Aperte Enter para aceitar o local padrão. A senha (passphrase) é opcional, mas recomendada.

2. Copie a chave **pública** (a que termina em `.pub`):

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. No GitHub: *Settings → SSH and GPG keys → New SSH key*, cole e salve.

4. Teste:

   ```bash
   ssh -T git@github.com
   # Hi seu-usuario! You've successfully authenticated...
   ```

> Nunca compartilhe o arquivo **sem** `.pub` (`id_ed25519`). Ele é a sua chave privada.

Prefere HTTPS? Funciona também, mas o GitHub não aceita a senha da conta: é preciso um *Personal Access Token* ou o [GitHub CLI](https://cli.github.com) (`gh auth login`), que configura tudo sozinho.

## Clonando um repositório

```bash
git clone git@github.com:usuario/projeto.git
git clone git@github.com:usuario/projeto.git outro-nome   # em outra pasta
```

O clone já vem com o remoto configurado com o nome `origin`.

## Enviando um projeto local para o GitHub

1. Crie o repositório no GitHub **vazio** (sem README, para não dar conflito).
2. No seu projeto:

```bash
git remote add origin git@github.com:usuario/projeto.git
git branch -M main
git push -u origin main
```

O `-u` liga sua `main` local à `main` do `origin`. Depois disso, basta `git push` e `git pull`.

## Gerenciando remotos

```bash
git remote -v                          # lista remotos e URLs
git remote add upstream <url>          # adiciona outro remoto
git remote set-url origin <nova-url>   # troca a URL (ex.: HTTPS → SSH)
git remote remove upstream             # remove
```

## Enviando: `git push`

```bash
git push                               # envia a branch atual
git push -u origin feat/login          # primeira vez de uma branch nova
git push origin --delete feat/login    # apaga a branch no remoto
```

Se o push for recusado com `rejected (fetch first)`, alguém enviou commits antes de você. Traga as mudanças com `git pull` e tente de novo.

## Recebendo: `fetch` x `pull`

| Comando | O que faz |
| --- | --- |
| `git fetch` | **Baixa** as novidades do remoto, mas não mexe nos seus arquivos |
| `git pull` | `fetch` + junta as novidades na sua branch atual |

O `fetch` é seguro para "dar uma olhada" antes de juntar:

```bash
git fetch
git log --oneline main..origin/main   # commits que estão no remoto e não aqui
git pull
```

### `pull` com merge ou com rebase

Por padrão o `pull` pode criar um commit de merge só porque você e outra pessoa commitaram na mesma branch. Com rebase, seus commits são reaplicados em cima dos do remoto e o histórico fica reto:

```bash
git pull --rebase
```

Para usar sempre:

```bash
git config --global pull.rebase true
```

## Branches remotas

`origin/main` é a "foto" da `main` do remoto, atualizada a cada `fetch`. Você não trabalha nela direto.

```bash
git branch -r                    # lista branches remotas
git switch feat/login            # cria a local a partir de origin/feat/login, se existir
git fetch --prune                # remove referências de branches apagadas no remoto
```

---

[← Anterior](05-branches-e-merge.md) · [Índice](../README.md) · [Próximo: Desfazendo coisas →](07-desfazendo-coisas.md)
