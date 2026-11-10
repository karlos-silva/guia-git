# 04. Padrões de commit ✍️

Um bom histórico conta a história do projeto. Só de bater o olho no `git log` dá pra saber o que foi recurso novo, o que foi correção e o que foi só ajuste de texto.

Este guia segue o [Conventional Commits](https://www.conventionalcommits.org/pt-br), com um emoji opcional na frente para facilitar a leitura.

## Formato

```text
<emoji> <tipo>(<escopo>)!: <descrição>

<corpo>

<rodapé>
```

| Parte | Obrigatória? | O que é |
| --- | --- | --- |
| `emoji` | não | Ícone do tipo, como código (`:bug:`) ou o próprio caractere (🐛) |
| `tipo` | **sim** | Intenção do commit (`feat`, `fix`, `docs`...) |
| `escopo` | não | Parte do projeto afetada: `feat(login): ...` |
| `!` | não | Marca uma mudança que quebra compatibilidade: `feat(api)!: ...` |
| `descrição` | **sim** | Resumo curto, no imperativo: "adiciona", "corrige", "remove" |
| `corpo` | não | O porquê da mudança, quando o resumo não basta |
| `rodapé` | não | Referências: `Closes #42`, `BREAKING CHANGE: ...` |

## Tipos

| Tipo | Quando usar |
| --- | --- |
| `feat` | Novo recurso para quem usa o sistema |
| `fix` | Correção de bug |
| `docs` | Só documentação (README, comentários) |
| `style` | Formatação, espaços, ponto e vírgula, lint. Não muda comportamento |
| `refactor` | Reescreve código sem mudar o que ele faz |
| `perf` | Melhora de desempenho |
| `test` | Cria ou ajusta testes |
| `build` | Dependências e sistema de build (`package.json`, `requirements.txt`) |
| `ci` | Pipelines e automações (GitHub Actions, Docker de CI) |
| `chore` | Tarefas de manutenção que não entram nos outros (configs, `.gitignore`) |
| `revert` | Desfaz um commit anterior |
| `security` | Correção de vulnerabilidade ou reforço de segurança |
| `init` | Primeiro commit do projeto |

> Dica: `feat` e `fix` são os que mais importam. Na dúvida entre `chore` e outro tipo, escolha o mais específico.

## Emojis

| Emoji | Código | Tipo | Uso |
| --- | --- | --- | --- |
| 🎉 | `:tada:` | `init` | Commit inicial |
| ✨ | `:sparkles:` | `feat` | Novo recurso |
| 💄 | `:lipstick:` | `feat` | Visual / CSS |
| 📱 | `:iphone:` | `feat` | Responsividade |
| ♿ | `:wheelchair:` | `feat` | Acessibilidade |
| 🐛 | `:bug:` | `fix` | Correção de bug |
| 🚑️ | `:ambulance:` | `fix` | Correção urgente em produção |
| 🥅 | `:goal_net:` | `fix` | Tratamento de erros |
| 📝 | `:memo:` | `docs` | Documentação |
| 💡 | `:bulb:` | `docs` | Comentários no código |
| 🎨 | `:art:` | `style` | Formatação / estrutura |
| ♻️ | `:recycle:` | `refactor` | Refatoração |
| 🔥 | `:fire:` | `refactor` | Remove código ou arquivos |
| 🚚 | `:truck:` | `refactor` | Move ou renomeia arquivos |
| ⚡ | `:zap:` | `perf` | Performance |
| ✅ | `:white_check_mark:` | `test` | Testes |
| 📦 | `:package:` | `build` | Build / pacotes |
| ➕ | `:heavy_plus_sign:` | `build` | Adiciona dependência |
| ➖ | `:heavy_minus_sign:` | `build` | Remove dependência |
| 👷 | `:construction_worker:` | `ci` | Integração contínua |
| 🔧 | `:wrench:` | `chore` | Configuração |
| 🙈 | `:see_no_evil:` | `chore` | `.gitignore` |
| ⏪ | `:rewind:` | `revert` | Reverte mudanças |
| 🔒 | `:lock:` | `security` | Segurança |
| 🚧 | `:construction:` | qualquer | Trabalho em andamento |

Os emojis seguem o [gitmoji](https://gitmoji.dev). O GitHub converte os códigos (`:bug:`) em emoji na hora de exibir.

## Exemplos

```bash
git commit -m ":tada: init: estrutura inicial do projeto"
git commit -m ":sparkles: feat(carrinho): adiciona cupom de desconto"
git commit -m ":bug: fix(login): corrige redirecionamento após logout"
git commit -m ":memo: docs: explica como rodar o projeto localmente"
git commit -m ":recycle: refactor: extrai validação de CPF para função própria"
git commit -m ":heavy_plus_sign: build: adiciona axios"
git commit -m ":lock: security: bloqueia acesso sem token na rota /usuarios"
git commit -m "fix: corrige cálculo de média"   # sem emoji também vale
```

Commit com corpo e rodapé (abre o editor com `git commit`, sem `-m`):

```text
:sparkles: feat(api)!: troca autenticação por JWT

O login por sessão não funcionava com o app mobile.
Agora toda rota protegida espera o header Authorization.

BREAKING CHANGE: clientes antigos precisam enviar o token
Closes #42
```

## Bom x ruim

| ❌ Ruim | ✅ Bom |
| --- | --- |
| `update` | `docs: adiciona seção de instalação` |
| `arrumei` | `fix(form): impede envio com e-mail vazio` |
| `várias coisas` | Três commits, um para cada coisa |
| `fix: corrigido o bug que acontecia quando o usuário clicava duas vezes no botão de salvar e duplicava o registro.` | `fix: evita registro duplicado no duplo clique` |
| `wip` | `feat(perfil): adiciona upload de foto` (ou junte os "wip" antes do push com [rebase](08-stash-rebase-cherry-pick.md#rebase-interativo)) |

## Boas práticas

- **Um assunto por commit.** Se precisou de "e" na descrição, provavelmente são dois commits.
- **Descrição curta**, até uns 50 caracteres, no imperativo e sem ponto final.
- **Explique o porquê no corpo**, não o como. O como o código já mostra.
- **Commit pequeno e frequente** é mais fácil de revisar e de reverter.
- **Escolha um idioma** e mantenha no projeto inteiro.

## Automatizando

Este repositório tem um hook que recusa commits fora do padrão e um assistente que monta a mensagem para você. Veja em [.gitignore e hooks](14-gitignore-e-hooks.md#hooks-deste-repositório).

---

[← Anterior](03-primeiros-passos.md) · [Índice](../README.md) · [Próximo: Branches e merge →](05-branches-e-merge.md)
