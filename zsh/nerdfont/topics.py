"""Curated topic search layer for Nerd Font glyphs.

Merged into glyphs.tsv by build.py: every glyph whose name or upstream
keywords contain any of a topic's trigger terms gets the topic word appended
to its search keywords. Searching a topic then surfaces every related glyph
across all font sets (not just the fa/md sets that ship synonyms), so
'navigation' finds compasses, maps, routes, transport icons, etc.
"""

TOPICS = {
    "navigation": [
        "navigate", "navigation", "route", "routes", "directions", "direction",
        "compass", "map", "maps", "location", "gps", "path", "waypoint", "turn",
        "road", "traffic", "sail", "sailing", "ship", "boat", "ferry", "anchor",
        "plane", "airport", "flight", "destination", "travel", "highway",
    ],
    "terminal": [
        "terminal", "console", "shell", "prompt", "tty", "cli", "keyboard",
    ],
    "code": [
        "code", "coding", "developer", "development", "programming", "program",
        "script", "source", "snippet", "syntax", "language", "compile", "debug",
        "runtime",
    ],
    "git": [
        "git", "github", "gitlab", "branch", "commit", "merge", "rebase",
        "push", "pull", "repository", "repo", "versioning", "tag", "diff",
    ],
    "config": [
        "config", "configuration", "settings", "setup", "preferences", "tune",
        "toggle", "cog", "gear", "sliders",
    ],
    "save": ["save", "saved", "disk", "floppy", "floppydisk", "drive", "outbox"],
    "delete": ["delete", "remove", "trash", "bin", "discard", "clear", "erase"],
    "edit": ["edit", "pencil", "pen", "write", "annotate", "scratch", "compose"],
    "search": ["search", "find", "magnifier", "magnifying", "locate"],
    "folder": ["folder", "directory", "archive", "zip", "briefcase"],
    "file": ["file", "doc", "document", "text", "notes", "paper", "page", "sheet"],
    "cloud": ["cloud", "aws", "azure", "heroku", "deploy", "upload"],
    "server": ["server", "host", "rack", "virtual", "instance", "compute"],
    "database": [
        "database", "db", "sql", "data", "query", "table", "schema", "postgres",
        "mongo", "cache",
    ],
    "network": [
        "network", "wifi", "internet", "global", "globe", "link", "connection",
        "router", "ethernet", "switch",
    ],
    "security": [
        "lock", "key", "unlock", "shield", "firewall", "password", "secret",
        "safe", "login", "encryption",
    ],
    "communication": [
        "message", "chat", "comment", "email", "mail", "phone", "call", "bubble",
        "speech", "quote", "contact",
    ],
    "media": ["media", "video", "film", "movie", "tv", "screen", "projector"],
    "music": ["music", "song", "note", "audio", "playlist", "headphones", "speaker"],
    "audio": ["audio", "sound", "volume", "mute", "mic", "microphone", "wave"],
    "camera": ["camera", "photo", "picture", "image", "photography", "aperture", "lens"],
    "graph": [
        "graph", "chart", "plot", "bar", "line", "trend", "analytics", "stats",
        "diagram", "dashboard", "metrics",
    ],
    "money": [
        "money", "cash", "currency", "dollar", "euro", "yen", "coin", "coins",
        "wallet", "card", "bank", "price", "payment",
    ],
    "shopping": ["shopping", "cart", "bag", "store", "basket", "checkout", "gift"],
    "calendar": ["calendar", "date", "deadline", "schedule", "event"],
    "time": ["time", "clock", "watch", "hourglass", "alarm", "timer", "stopwatch"],
    "notification": ["notification", "bell", "alert", "toast", "announcement"],
    "check": ["check", "done", "complete", "success", "ok", "verified", "pass"],
    "error": ["error", "warning", "warn", "bug", "exclamation", "fail", "invalid", "stop"],
    "arrow": [
        "arrow", "left", "right", "up", "down", "caret", "chevron", "angle",
        "pointer", "cursor", "next", "previous", "direction",
    ],
    "user": [
        "user", "person", "people", "human", "profile", "account", "avatar",
        "contact", "group", "organization",
    ],
    "chat": [
        "chat", "message", "comment", "bubble", "speech", "quote", "conversation", "reply",
    ],
    "device": [
        "device", "mobile", "phone", "tablet", "laptop", "desktop", "computer",
        "monitor", "screen", "mouse", "cpu", "gpu", "storage", "battery",
    ],
    "browser": ["browser", "chrome", "firefox", "safari", "internet", "web", "window"],
    "tools": ["tools", "wrench", "hammer", "screwdriver", "gear", "toolbox", "hardware"],
    "construction": ["construction", "hammer", "wrench", "hardhat", "build", "builder"],
    "science": [
        "science", "dna", "beaker", "testtube", "flask", "microscope", "molecule",
        "atom", "lab", "experiment", "biology", "chemistry",
    ],
    "education": [
        "school", "book", "graduation", "study", "learn", "teacher", "university",
        "college", "library", "mortar",
    ],
    "medical": [
        "medical", "hospital", "health", "stethoscope", "bandage", "pulse",
        "pharmacy", "firstaid", "drug",
    ],
    "food": ["food", "pizza", "coffee", "cup", "restaurant", "beverage", "meal", "breakfast"],
    "transport": [
        "transport", "car", "train", "subway", "bus", "plane", "airplane",
        "taxi", "truck", "helicopter", "sail", "anchor",
    ],
    "container": ["container", "docker", "box", "cube", "package", "volume", "stack"],
}


def expand_topics(data, words):
    """Append every topic whose trigger terms appear in `words`.

    `words` is a list of search tokens (name words first, upstream synonyms
    after) for one glyph. Returns a new list with matching topic words appended.
    """
    seen = set(words)
    out = list(words)
    for topic, triggers in data.items():
        if any(t in seen for t in triggers):
            if topic not in seen:
                seen.add(topic)
                out.append(topic)
    return out