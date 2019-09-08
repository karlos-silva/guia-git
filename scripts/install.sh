#!/usr/bin/env bash
#
# Instala o hook commit-msg.
#
#   ./install.sh                 no repositório da pasta atual
#   ./install.sh caminho/repo    em outro repositório
#   ./install.sh --global        em todos os repositórios da máquina

set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source_hook="$here/commit-msg.sh"

if [[ ! -f $source_hook ]]; then
    echo "Erro: commit-msg.sh não encontrado em $here" >&2
    exit 1
fi

case "${1:-}" in
    -h|--help)
        sed -n '3,7p' "$0" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
    --global)
        hooks_dir="$HOME/.git-hooks"
        ;;
    *)
        repo="${1:-.}"
        if ! git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
            echo "Erro: '$repo' não é um repositório Git." >&2
            exit 1
        fi
        # Respeita core.hooksPath e worktrees
        hooks_dir=$(git -C "$repo" rev-parse --git-path hooks)
        [[ $hooks_dir = /* ]] || hooks_dir="$repo/$hooks_dir"
        ;;
esac

target="$hooks_dir/commit-msg"
mkdir -p "$hooks_dir"

if [[ -f $target ]] && ! cmp -s "$source_hook" "$target"; then
    cp "$target" "$target.bak"
    echo "Hook anterior salvo em $target.bak"
fi

cp "$source_hook" "$target"
chmod +x "$target"

if [[ ${1:-} == --global ]]; then
    git config --global core.hooksPath "$hooks_dir"
    echo "✓ Hook global instalado em $target (core.hooksPath configurado)"
else
    echo "✓ Hook instalado em $target"
fi
echo "  Teste: git commit --allow-empty -m \"arrumei umas coisas\"  (deve ser recusado)"
