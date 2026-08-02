# Flotnote Toggle (Karabiner + osascript)

A global hotkey that toggles Flotnote between three states:
1. **Closed** → opens the floating note
2. **Open + unfocused** (you're working elsewhere) → focuses the note (so you can type)
3. **Open + focused** (you're using it) → dismisses it with Escape, then restores your previous app/window

## How the toggle works

The script detects state from two sources, both fast:

- **Window count** (`count of windows of process "Flotnote"`) tells us if the note is open (1) or dismissed (0)
- **Frontmost bundle id** (via a single `lsappinfo` shell call) tells us if the note has focus:
  - `com.flotnote.app` → you're using the note (dismiss + restore)
  - anything else → the note is open but you clicked elsewhere (focus it)

Three-way branch:

```
wc == 0                   → record frontmost app (bid/name/window), open -a Flotnote
wc > 0  + not flotnote    → record frontmost app (bid/name/window), tell application "Flotnote" to activate
wc > 0  + com.flotnote.app → key code 53 (Escape), delay 0.2s, then restore recorded app + window
```

### Previous-app restore

Flotnote is an `LSUIElement` app (menu-bar only, no Dock icon), so it is **never in the Cmd+Tab app switcher**.
The old dismiss did `Cmd+Tab`, which just picked whatever was next in the MRU list — landing in the wrong app.

Instead, whenever the toggle gives Flotnote focus (first two branches) it records the currently frontmost app
into `/tmp/flotnote-prev-app` as **three lines**:

1. **Bundle identifier** — the restore key (unique per app, e.g. `com.google.Chrome.app.<hash>` for a Chrome PWA)
2. **Displayed name** — fallback key (e.g. `ChatGPT`, `Spotify`)
3. **Front window title** — used only to raise a specific window (regular apps); empty for PWAs

On dismiss it Escape-closes the note, then restores via **`tell application id <bid> to activate`** (the reliable,
forceful activation for any app, including Chrome PWAs). If a window title was recorded it then raises that specific
window with `perform action "AXRaise"` and re-activates. If the recorded app has quit, or the file is empty, it falls
back to just dismissing (no restore).

The state file is ephemeral and rewritten on every focus, so it never goes stale.

### Chrome PWA caveats (the reason for bundle-id keying)

All Chrome PWAs (ChatGPT, Spotify, Gmail, …) run the **same executable `app_mode_loader`**, so System Events reports
`name of process` and `displayed name of process` identically for every one of them, and PWA windows report their AX
`name` as `missing value`. Two things that DO distinguish them:

- **`bundle identifier`** — unique per PWA: `com.google.Chrome.app.cadlkien…` (ChatGPT), `…pjibgcll…` (Spotify)
- **`lsappinfo front`** — the authoritative frontmost-app query (LaunchServices)

So capture does everything in **one shell call** — `lsappinfo info "$(lsappinfo front | sed 's/:$//')"` — and parses
`bundleID="…"` and the displayed name from its output. No process enumeration at all.

### Fast-process resolution (no repeat loops)

The current script resolves processes with a **single System Events predicate**:

```applescript
first application process whose bundle identifier is <bid>
```

This is both ~15× faster than the old `repeat` loop over `every application process` (which took ~2.5s with ~120
processes running — the original "sometimes slow" bug) and reliable.

**Gotcha:** not all `whose` predicates are safe. `whose unix id is X` can return the **wrong** process when several
`app_mode_loader` processes are running (the old bug). `whose bundle identifier is X` and `whose displayed name is X`
do **not** have that problem — always key on bundle id or displayed name, never on unix id or name.

### The two AppleScript gotchas that bit here

1. **Handler scope:** a top-level `set stateFile to …` is **invisible inside handlers** — only `property`/`global`
   are visible. `stateFile` must be a `property`.
2. **Don't share a System Events block between Escape and restore.** Sending `key code 53` and then doing restore
   work *inside the same* `tell application "System Events"` block makes System Events win the focus race after
   Flotnote deactivates (the app ends up stuck on System Events or a stale PWA). The script therefore uses
   self-contained one-line tells: `key code 53` in its own block, then the restore `activate` **outside** any System
   Events block, then (only for window-raise) a fresh System Events block, followed by a final re-activate.

### Restore timing

The dismiss path deliberately waits `0.2s` after Escape: Flotnote's window closes but the app stays *nominally*
frontmost for up to ~1.5s, and an activate issued during that window is overridden. Waiting until the focus
transition settles, then activating, is what makes the restore stick. Total toggle time is ~0.3–0.5s.

## Files

| File | Purpose |
|---|----|
| `~/.flotnote-toggle.scpt` | Precompiled AppleScript (what actually runs) |
| `~/.flotnote-toggle.applescript` | Human-readable source (edit this, recompile with `osacompile`) |
| `~/code/dotfiles/zsh/zsh_functions` | `toggle_flotnote()` function |
| `~/code/dotfiles/zsh/zsh_aliases` | `alias flot="toggle_flotnote"` |
| `~/.config/karabiner/karabiner.json` | Karabiner Complex Modification binding (fn+N) |

## Setup instructions (new machine)

### 1. Install the AppleScript

Create `~/.flotnote-toggle.applescript` with this source:

```applescript
property stateFile : "/tmp/flotnote-prev-app"

on betweenQuotes(t)
	set AppleScript's text item delimiters to "\""
	set parts to text items of t
	set AppleScript's text item delimiters to ""
	if (count of parts) is greater than 1 then return item 2 of parts
	return ""
end betweenQuotes

on firstWord(t)
	set AppleScript's text item delimiters to " "
	set ws to text items of t
	set AppleScript's text item delimiters to ""
	if (count of ws) is 0 then return ""
	set w to item 1 of ws
	if (length of w) is greater than 1 and w starts with "\"" and w ends with "\"" then
		return text 2 thru -2 of w
	end if
	return w
end firstWord

on frontmostLine()
	set info to do shell script "lsappinfo info \"$(lsappinfo front | sed 's/:$//')\""
	set bid to ""
	set disp to ""
	set theLines to paragraphs of info
	if (count of theLines) is greater than 0 then set disp to my firstWord(item 1 of theLines)
	repeat with ln in theLines
		if ln contains "bundleID=" then
			set bid to my betweenQuotes(ln)
			exit repeat
		end if
	end repeat
	return bid & linefeed & disp
end frontmostLine

on captureContext()
	set theBid to ""
	set theDisp to ""
	set theWin to ""
	set theOk to "0"
	try
		set ctxLine to my frontmostLine()
		set theOk to "1"
		set parts to paragraphs of ctxLine
		if (count of parts) is greater than 0 then set theBid to item 1 of parts
		if (count of parts) is greater than 1 then set theDisp to item 2 of parts
		if theBid is not "" and theBid is not "com.flotnote.app" then
			tell application "System Events"
				set targetProc to first application process whose bundle identifier is theBid
				try
					set theWin to name of front window of targetProc
					if theWin is missing value then set theWin to ""
				on error
					set theWin to ""
				end try
			end tell
		end if
	on error
		set theOk to "0"
	end try
	return theBid & linefeed & theDisp & linefeed & theWin & linefeed & theOk
end captureContext

on writeState(s)
	try
		set fh to open for access (POSIX file stateFile) with write permission
		set eof of fh to 0
		write s to fh
		close access fh
	on error
		try
			close access fh
		end try
	end try
end writeState

on readState()
	try
		return read (POSIX file stateFile)
	on error
		return ""
	end try
end readState

on flotWc()
	tell application "System Events"
		if exists process "Flotnote" then return count of windows of process "Flotnote"
		return 0
	end tell
end flotWc

on openFlotnote()
	set ctx to my captureContext()
	set parts to paragraphs of ctx
	set rec to ""
	if (count of parts) is greater than 2 then
		set rec to item 1 of parts & linefeed & item 2 of parts & linefeed & item 3 of parts
	end if
	my writeState(rec)
	do shell script "open -a Flotnote"
end openFlotnote

on dismissFlotnote()
	set ctx to my captureContext()
	set parts to paragraphs of ctx
	set cb to ""
	set ok to "0"
	if (count of parts) is greater than 0 then set cb to item 1 of parts
	if (count of parts) is greater than 3 then set ok to item 4 of parts
	if ok is not "1" then
		tell application "Flotnote" to activate
	else if cb is "com.flotnote.app" then
		tell application "System Events" to key code 53
		delay 0.2
		set stxt to my readState()
		set sparts to paragraphs of stxt
		set prevBid to ""
		set prevDisp to ""
		set prevWin to ""
		if (count of sparts) is greater than 0 then set prevBid to item 1 of sparts
		if (count of sparts) is greater than 1 then set prevDisp to item 2 of sparts
		if (count of sparts) is greater than 2 then set prevWin to item 3 of sparts
		set usedBid to false
		if prevBid is not "" and prevBid is not "com.flotnote.app" then
			try
				tell application id prevBid to activate
				set usedBid to true
			end try
		end if
		if not usedBid and prevDisp is not "" and prevDisp is not "Flotnote" then
			try
				tell application prevDisp to activate
			end try
		end if
		if prevWin is not "" then
			delay 0.05
			try
				tell application "System Events"
					set targetProc to first application process whose bundle identifier is prevBid
					set targetWin to first window of targetProc whose name is prevWin
					perform action "AXRaise" of targetWin
				end tell
			end try
			if usedBid then
				try
					tell application id prevBid to activate
				end try
			end if
		end if
	else
		set rec to item 1 of parts & linefeed & item 2 of parts & linefeed & item 3 of parts
		my writeState(rec)
		tell application "Flotnote" to activate
	end if
end dismissFlotnote

if my flotWc() is 0 then
	my openFlotnote()
else
	my dismissFlotnote()
end if
```

Compile it:

```bash
osacompile -o ~/.flotnote-toggle.scpt ~/.flotnote-toggle.applescript
```

### 2. Add the shell function

In `~/code/dotfiles/zsh/zsh_functions` (or `~/.zshrc` if not using the dotfiles repo):

```zsh
# Flotnote Toggle
toggle_flotnote() { /usr/bin/osascript "$HOME/.flotnote-toggle.scpt"; }
```

And in `~/code/dotfiles/zsh/zsh_aliases`:

```zsh
alias flot="toggle_flotnote"
```

Reload:

```bash
source ~/.zshrc
```

Test with:

```bash
flot
```

### 3. Bind a global hotkey (Karabiner-Elements)

In Karabiner-Elements → Complex Modifications → Add your own rule,
add a manipulator that runs `/usr/bin/osascript /Users/andremarques/.flotnote-toggle.scpt`.

Example Karabiner JSON snippet:

```json
{
    "description": "Flot Note",
    "manipulators": [
        {
            "from": {
                "key_code": "n",
                "modifiers": {
                    "mandatory": ["fn"],
                    "optional": ["any"]
                }
            },
            "to": [
                {
                    "modifiers": [],
                    "shell_command": "/usr/bin/osascript /Users/andremarques/.flotnote-toggle.scpt"
                }
            ],
            "type": "basic"
        }
    ]
}
```

### 4. Grant Accessibility permission

The app running the script (Karabiner-Elements, or Terminal if testing via `flot`)
needs **Accessibility** permission in System Settings → Privacy & Security → Accessibility.

If using macOS Shortcuts or Automator instead of Karabiner, also grant **Automation** (Apple Events) permission
for Shortcuts → System Events.

## Permissions troubleshooting

The most common issue: pressing the hotkey does nothing when Flotnote is open.
This usually means the calling process doesn't have Accessibility permission.

Check the toggle log (if you added one) or run directly:

```bash
osascript ~/.flotnote-toggle.scpt
```

If this works in Terminal but not via the hotkey, grant Accessibility to the hotkey app.

## Karabiner alternative: direct fn+N binding

The specific binding used: **fn + N** (the Flotnote toggle). No other modifiers.
Karabiner sends the shell_command directly — no intermediary shortcut needed.

## Testing (regression harness)

`/tmp/test-toggle.sh` round-trips each app: focus it, toggle (capture + open Flotnote), toggle again
(dismiss + restore), then asserts the restored frontmost bundle id. It covers the three critical targets:

- Spotify PWA (bundle-id restore, PWA window = `missing value`)
- ChatGPT PWA (the same PWA quirk — previously restored to the wrong PWA)
- Ghostty (window-title capture + `AXRaise` restore)

It also prints per-toggle timing; expect ~0.3–0.5s per toggle.
