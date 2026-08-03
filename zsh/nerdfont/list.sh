#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="$SCRIPT_DIR/glyphs.tsv"
FAV="$SCRIPT_DIR/favorites"

[[ -r "$DATA" ]] || exit 1
[[ -f "$FAV" ]] || : > "$FAV"

awk -F'\t' -v OFS='\t' -v favfile="$FAV" '
BEGIN {
    while ((getline l < favfile) > 0) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", l)
        if (l == "") {
            continue
        }
        fav[l] = 1
        order[++order_n] = l
    }
}
{
    name = $2
    disp = $2
    sub(/^[a-z0-9]+-/, "", disp)
    if (name in fav) {
        disp = "★ " disp
    }
    row[name] = $1 OFS name OFS disp OFS $4
    isfav[name] = (name in fav)
    names[++n] = name
}
END {
    for (i = 1; i <= order_n; i++) {
        nm = order[i]
        if (nm in row) {
            print row[nm]
        }
    }
    for (i = 1; i <= n; i++) {
        nm = names[i]
        if (!isfav[nm]) {
            print row[nm]
        }
    }
}
' "$DATA"
