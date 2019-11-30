#!/usr/bin/env bash
#
# Assistente de commit: monta a mensagem no padrão
#   :emoji: tipo(escopo): descrição
# e commita o que estiver no stage.

set -euo pipefail

options=(
    "feat|:sparkles:|✨|novo recurso"
    "fix|:bug:|🐛|correção de bug"
    "docs|:memo:|📝|documentação"
    "style|:art:|🎨|formatação, sem mudar comportamento"
    "refactor|:recycle:|♻️ |refatoração"
    "perf|:zap:|⚡|performance"
    "test|:white_check_mark:|✅|testes"
    "build|:package:|📦|build e dependências"
    "ci|:construction_worker:|👷|integração contínua"
    "chore|:wrench:|🔧|manutenção e configuração"
    "revert|:rewind:|⏪|reverte commit"
    "security|:lock:|🔒|segurança"
    "init|:tada:|🎉|commit inicial"
)

if git diff --cached --quiet; then
    echo "Nada no stage. Use 'git add' antes." >&2
    exit 1
fi

echo
for i in "${!options[@]}"; do
    IFS='|' read -r type _ icon desc <<<"${options[$i]}"
    printf '%2d) %s %-9s %s\n' "$((i + 1))" "$icon" "$type" "$desc"
done
echo

read -rp "Tipo: " choice
if ! [[ $choice =~ ^[0-9]+$ ]] || ((choice < 1 || choice > ${#options[@]})); then
    echo "Opção inválida." >&2
    exit 1
fi
IFS='|' read -r type emoji _ _ <<<"${options[$((choice - 1))]}"

read -rp "Escopo (opcional): " scope
read -rp "Descrição: " description

if [[ -z ${description// /} ]]; then
    echo "A descrição não pode ficar vazia." >&2
    exit 1
fi

message="$emoji $type${scope:+($scope)}: $description"

git commit -m "$message"
echo
echo "✓ $message"
