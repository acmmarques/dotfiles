#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUERY="${1:-}"

# Custom command popups run through /bin/sh -c and may not inherit a login PATH.
for p in /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin" "$HOME/.nix-profile/bin"; do
    if [[ -d "$p" && ":$PATH:" != *":$p:"* ]]; then
        PATH="$p:$PATH"
    fi
done

command -v fzf >/dev/null 2>&1 || {
    echo "zf: fzf not found" >&2
    exit 1
}

args=(
    --no-sort
    --delimiter=$'\t' --nth=2,3,4 --with-nth=1,3
    --prompt='glyph> ' --reverse --no-hscroll
    --bind "ctrl-f:execute-silent($SCRIPT_DIR/toggle.sh \"{}\")+reload($SCRIPT_DIR/list.sh)"
)

if [[ -n "$QUERY" ]]; then
    args+=(--query "$QUERY")
fi

fzf "${args[@]}" < <("$SCRIPT_DIR/list.sh")
