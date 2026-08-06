#!/usr/bin/env bash
# herdr create/rename wizard: pick a Nerd Font glyph, optionally add a name,
# then create or rename the tab/workspace/pane via the herdr CLI.
# Bound to the native create/rename keys through [[keys.command]] entries in
# herdr/config.toml, which pass the mode as $1:
#   create-tab | create-workspace | rename-tab | rename-workspace | rename-pane
# The glyph is always copied to the clipboard too, so it can still be pasted
# into any field herdr owns.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERDR_BIN="${HERDR_BIN_PATH:-herdr}"
MODE="${1:-create-tab}"

# herdr runs this command through /bin/sh -c, which may not carry a login
# PATH; make sure fzf and herdr are reachable before relying on PATH.
for p in /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin" "$HOME/.nix-profile/bin"; do
    if [[ -d "$p" && ":$PATH:" != *":$p:"* ]]; then
        PATH="$p:$PATH"
    fi
done

die() {
    echo "wizard: $*" >&2
    read -r -p "press enter to close" _ || true
    exit 1
}

command -v "$HERDR_BIN" >/dev/null 2>&1 || die "herdr not found"

# Pick loop: each Enter picks one icon and relaunches the picker with a
# clean query (empty input); the running composition is shown as the
# picker's header. Tab is the definitive accept; re-picking an
# already-picked icon also accepts.
glyphs=""
first=""
tail=""
names=""
while :; do
    sel="$(ZF_HEADER="$glyphs" ZF_EXPECT_TAB=1 "$SCRIPT_DIR/zf.sh")" || exit 0
    key="${sel%%$'\n'*}"
    sel="${sel#*$'\n'}"
    name="$(printf '%s\n' "$sel" | awk -F'\t' '{print $2}')"
    [[ -n "$name" ]] || exit 0
    if [[ "$key" == "tab" ]]; then
        break
    fi
    if printf '%s' "$names" | grep -qwF "$name"; then
        break
    fi
    glyph="$(printf '%s\n' "$sel" | awk -F'\t' '{print $1}')"
    if [[ -z "$first" ]]; then
        first="$glyph"
    else
        tail="${tail:+$tail }$glyph"
    fi
    glyphs="${glyphs:+$glyphs }$glyph"
    names="$names $name"
done

# herdr's own fields can't be reached by send-text; clipboard is the bridge.
if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$glyphs" | pbcopy
fi

echo
echo "glyph:  $glyphs"
read -r -p "name:   " rest || exit 0
rest="$(printf '%s' "$rest" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
label="${first}${rest:+  $rest}${tail:+ $tail}"

case "$MODE" in
    create-tab)
        "$HERDR_BIN" tab create --label "$label" --focus ;;
    create-workspace)
        "$HERDR_BIN" workspace create --label "$label" --focus ;;
    rename-tab)
        [[ -n "${HERDR_ACTIVE_TAB_ID:-}" ]] || die "HERDR_ACTIVE_TAB_ID unset"
        "$HERDR_BIN" tab rename "$HERDR_ACTIVE_TAB_ID" "$label" ;;
    rename-workspace)
        [[ -n "${HERDR_ACTIVE_WORKSPACE_ID:-}" ]] || die "HERDR_ACTIVE_WORKSPACE_ID unset"
        "$HERDR_BIN" workspace rename "$HERDR_ACTIVE_WORKSPACE_ID" "$label" ;;
    rename-pane)
        [[ -n "${HERDR_ACTIVE_PANE_ID:-}" ]] || die "HERDR_ACTIVE_PANE_ID unset"
        "$HERDR_BIN" pane rename "$HERDR_ACTIVE_PANE_ID" "$label" ;;
    *)
        die "unknown mode: $MODE" ;;
esac
