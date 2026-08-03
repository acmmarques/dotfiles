#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAV="$SCRIPT_DIR/favorites"

line="${1:-}"
[[ -n "$line" ]] || exit 0

name="$(printf '%s\n' "$line" | awk -F'\t' '{print $2}')"
[[ -n "$name" ]] || exit 0

[[ -f "$FAV" ]] || : > "$FAV"

tmp="$(mktemp)"
if grep -qxF "$name" "$FAV" 2>/dev/null; then
    grep -vxF "$name" "$FAV" > "$tmp" || true
else
    {
        printf '%s\n' "$name"
        cat "$FAV"
    } > "$tmp"
fi

mv "$tmp" "$FAV"
