#!/usr/bin/env bash
# herdr popup picker: fuzzy-search Nerd Font glyphs and type the selected
# glyph into the focused pane's shell prompt.
# Data: glyphs.tsv (glyph, name, hex, keywords) built by build.py.
# fzf view/search behavior is shared with wizard.sh via zf.sh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERDR_BIN="${HERDR_BIN_PATH:-herdr}"

# herdr runs this command through /bin/sh -c, which may not carry a login
# PATH; make sure fzf and herdr are reachable before relying on PATH.
for p in /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin" "$HOME/.nix-profile/bin"; do
    if [[ -d "$p" && ":$PATH:" != *":$p:"* ]]; then
        PATH="$p:$PATH"
    fi
done

command -v "$HERDR_BIN" >/dev/null 2>&1 || { echo "pick: herdr not found" >&2; exit 1; }

sel="$("$SCRIPT_DIR/zf.sh")" || exit 0

glyph="${sel%%$'\t'*}"

# herdr's own name prompts are not panes, so send-text can't reach them.
# Always put the glyph on the clipboard too, ready to paste (cmd+v) into
# the naming window.
if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$glyph" | pbcopy
fi

# Popup context: HERDR_ACTIVE_PANE_ID is the underlying tiled pane.
# Fall back to HERDR_PANE_ID, then resolve the active pane via the CLI.
pane_id="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
if [[ -z "$pane_id" ]]; then
    pane_id="$( { "$HERDR_BIN" pane current 2>/dev/null || true; } \
        | sed -n 's/.*"pane_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
        | head -n1)"
fi
if [[ -z "$pane_id" ]]; then
    echo "pick: could not determine active pane" >&2
    exit 1
fi

"$HERDR_BIN" pane send-text "$pane_id" "$glyph"
