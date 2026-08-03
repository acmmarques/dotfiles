#!/usr/bin/env python3
"""Generate glyphs.tsv for the `nf` picker.

Joins the Nerd Fonts glyph list with upstream Font Awesome search terms and
Material Design Icons aliases/tags, so fuzzy search finds 'ship' when you
type 'boat'. Run by hand whenever you want to refresh; output is committed.

Output columns: glyph, name, hex, keywords
"""

import json
import sys
import urllib.request
from pathlib import Path

from topics import TOPICS, expand_topics

OUT = Path(__file__).parent / "glyphs.tsv"

SOURCES = {
    "nerd": "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json",
    "fa": "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/metadata/icons.json",
    "mdi": "https://raw.githubusercontent.com/Templarian/MaterialDesign-SVG/master/meta.json",
}


def fetch(name, url):
    print(f"fetching {name}...", file=sys.stderr)
    with urllib.request.urlopen(url, timeout=30) as r:
        return json.load(r)


def main():
    nerd = fetch("nerd", SOURCES["nerd"])
    nerd.pop("METADATA", None)
    fa = fetch("fa", SOURCES["fa"])
    mdi = fetch("mdi", SOURCES["mdi"])

    # Upstream keyword tables, keyed by unprefixed icon name.
    fa_terms = {
        k: [str(t) for t in v.get("search", {}).get("terms", [])]
        for k, v in fa.items()
    }
    mdi_terms = {
        m["name"]: list(m.get("aliases", [])) + list(m.get("tags", []))
        for m in mdi
        if "name" in m
    }

    rows = []
    matched = {"fa": 0, "md": 0}
    total = {"fa": 0, "md": 0}

    for name, info in sorted(nerd.items()):
        char = info.get("char")
        code = info.get("code", "")
        if not char:
            continue

        prefix, _, bare = name.partition("-")
        # Nerd Fonts uses underscores; both upstreams use hyphens.
        key = bare.replace("_", "-")
        extra = []
        if prefix in total:
            total[prefix] += 1
        if prefix == "fa":
            # '-o' marks a FA4 outline variant; fall back to the solid icon.
            extra = fa_terms.get(key) or (
                fa_terms.get(key[:-2], []) if key.endswith("-o") else []
            )
        elif prefix == "md":
            extra = mdi_terms.get(key) or (
                mdi_terms.get(key[:-8], []) if key.endswith("-outline") else []
            )
        if extra and prefix in matched:
            matched[prefix] += 1

        # Name words come FIRST and in order, so fzf's --tiebreak=begin ranks
        # a name hit (fa-save) above a mere synonym hit (fa-share -> 'save').
        words = []
        seen = set()
        for w in bare.replace("_", "-").split("-"):
            w = w.lower()
            if w and w not in seen:
                seen.add(w)
                words.append(w)
        for t in extra:
            for w in str(t).split():
                w = w.lower()
                # Drop punctuation-only tokens (MDI tags contain things like '+').
                if w and w not in seen and any(c.isalnum() for c in w):
                    seen.add(w)
                    words.append(w)

        words = expand_topics(TOPICS, words)

        keywords = " ".join(words)
        rows.append(f"{char}\t{name}\t{code}\t{keywords}")

    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8")

    print(f"\nwrote {len(rows)} glyphs -> {OUT}", file=sys.stderr)
    for p in ("fa", "md"):
        n, d = matched[p], total[p]
        pct = (100 * n / d) if d else 0
        print(f"  {p}: {n}/{d} enriched ({pct:.1f}%)", file=sys.stderr)


if __name__ == "__main__":
    main()
