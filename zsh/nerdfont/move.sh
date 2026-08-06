#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAV="$SCRIPT_DIR/favorites"

dir="${1:-}"
line="${2:-}"
[[ -n "$dir" && -n "$line" ]] || exit 0

name="$(printf '%s\n' "$line" | awk -F'\t' '{print $2}')"
[[ -n "$name" ]] || exit 0
[[ -f "$FAV" ]] || exit 0

favs=()
while IFS= read -r l; do
    favs+=("$l")
done < "$FAV"

i=-1
for j in "${!favs[@]}"; do
    if [[ "${favs[$j]}" == "$name" ]]; then
        i=$j
        break
    fi
done

[[ $i -ge 0 ]] || exit 0

case "$dir" in
    up)   t=$((i - 1)) ;;
    down) t=$((i + 1)) ;;
    *)    exit 0 ;;
esac

[[ $t -ge 0 && $t -lt ${#favs[@]} ]] || exit 0

favs[$i]=${favs[$t]}
favs[$t]=$name

tmp="$(mktemp)"
printf '%s\n' "${favs[@]}" > "$tmp"
mv "$tmp" "$FAV"
