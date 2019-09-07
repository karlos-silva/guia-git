#!/usr/bin/env bash
#
# Hook commit-msg: recusa mensagens fora do padrão
#   [emoji] tipo(escopo)!: descrição
#
# Instale com ./install.sh ou copie para .git/hooks/commit-msg

TYPES='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert|security|init'

MSG_FILE="$1"

# Primeira linha que não seja vazia nem comentário
subject=$(grep -v '^[[:space:]]*#' "$MSG_FILE" | grep -m1 '[^[:space:]]')

# Mensagens criadas pelo próprio Git passam direto
if [[ $subject =~ ^(Merge\ |Revert\ \"|fixup!\ |squash!\ |amend!\ ) ]]; then
    exit 0
fi

# Emoji opcional: :codigo: ou qualquer caractere fora do ASCII
export LC_ALL=C
emoji='(:[a-z0-9_+-]+:|[^ -~]+)'
pattern="^(${emoji}[[:space:]]+)?(${TYPES})(\([a-zA-Z0-9_./-]+\))?!?:[[:space:]]+[^[:space:]]"

if [[ $subject =~ $pattern ]]; then
    exit 0
fi

cat >&2 <<EOF

✗ Mensagem de commit fora do padrão:
    "$subject"

  Formato:  [emoji] tipo(escopo opcional): descrição
  Tipos:    ${TYPES//|/, }

  Exemplos:
    :sparkles: feat(login): adiciona botão de mostrar senha
    :bug: fix: corrige cálculo de média
    docs: atualiza README

  Guia completo: https://github.com/karlos-silva/guia-git/blob/main/docs/04-padroes-de-commit.md

EOF
exit 1
