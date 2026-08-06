#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="$SCRIPT_DIR/glyphs.tsv"
FAV="$SCRIPT_DIR/favorites"

[[ -r "$DATA" ]] || exit 1
[[ -f "$FAV" ]] || : > "$FAV"

awk -F'\t' -v OFS='\t' -v favfile="$FAV" -v q="${1:-}" '
BEGIN {
    q = tolower(q)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", q)
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
    # A full match contains the whole query as a substring of the disp field
    # (what fzf actually searches with --nth=2,3,4 --with-nth=1,3); everything
    # else fzf matches only fuzzily. Favorites stay pinned; within each group
    # input order (--no-sort) is preserved.
    cls[name] = (q != "" && index(tolower(disp), q) > 0)
    names[++n] = name
}
END {
    for (i = 1; i <= order_n; i++) {
        nm = order[i]
        if (nm in row) {
            if (cls[nm]) {
                fullfav[++ff] = nm
            } else {
                partfav[++pf] = nm
            }
        }
    }
    for (i = 1; i <= n; i++) {
        nm = names[i]
        if (isfav[nm]) {
            continue
        }
        if (cls[nm]) {
            fulln[++fn] = nm
        } else {
            partn[++pn] = nm
        }
    }
    for (i = 1; i <= ff; i++) print row[fullfav[i]]
    for (i = 1; i <= fn; i++) print row[fulln[i]]
    for (i = 1; i <= pf; i++) print row[partfav[i]]
    for (i = 1; i <= pn; i++) print row[partn[i]]
}
' "$DATA"
