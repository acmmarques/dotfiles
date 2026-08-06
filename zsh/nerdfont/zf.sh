#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# zf.sh [query...]. ZF_HEADER, when set, is passed to fzf as --header (the
# wizard uses it to preview the running icon composition).
QUERY="$*"

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

# --no-sort: fzf preserves our input order, so list.sh's favorites-pinning
# and full-before-fuzzy grouping survive. Native matching (no --disabled) is
# what highlights the matched characters. No --track: the cursor stays on its
# row as the query narrows, so trimming "boat" to "b" keeps the same line
# selected. change:reload re-groups list.sh's output as the query changes so
# full matches float above fuzzy ones. The reorder binds use reload-sync + a
# directional nudge to re-land the cursor on the moved favorite.
args=(
    --no-sort
    --delimiter=$'\t' --nth=2,3,4 --with-nth=1,3
    --prompt='glyph> ' --reverse --no-hscroll
    --bind "change:reload($SCRIPT_DIR/list.sh {q})"
    --bind "ctrl-f:execute-silent($SCRIPT_DIR/toggle.sh \"{}\")+reload($SCRIPT_DIR/list.sh {q})"
    --bind "ctrl-up:execute-silent($SCRIPT_DIR/move.sh up \"{}\")+reload-sync($SCRIPT_DIR/list.sh {q})+up"
    --bind "ctrl-down:execute-silent($SCRIPT_DIR/move.sh down \"{}\")+reload-sync($SCRIPT_DIR/list.sh {q})+down"
)

if [[ -n "$QUERY" ]]; then
    args+=(--query "$QUERY")
fi

if [[ -n "${ZF_HEADER:-}" ]]; then
    args+=(--header "$ZF_HEADER")
fi

# The wizard distinguishes Tab (definitive confirm) from Enter (pick) via
# fzf's --expect, which prefixes the result with the pressed key.
if [[ -n "${ZF_EXPECT_TAB:-}" ]]; then
    args+=(--expect=tab)
fi

fzf "${args[@]}" < <("$SCRIPT_DIR/list.sh" "$QUERY")
