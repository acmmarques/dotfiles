# acmmarques Dotfiles

## 📂 Repository Structure

* **`flotnote/`** - Flotnote floating-note toggle: the AppleScript source (`flotnote-toggle.applescript`) and its guide (`flotnote-toggle-guide.md`).
* **`ghostty/`** - Configuration for the [Ghostty](https://ghostty.org/) terminal emulator.
* **`herdr/`** - Configuration for [herdr](https://herdr.dev/), a terminal workspace manager for AI coding agents.
* **`karabiner/`** - macOS keyboard customization rules for [Karabiner-Elements](https://karabiner-elements.pqrs.org/), with `Internal-ISO` and `Logitech-ANSI` profiles.
* **`nvim/`** - Complete Neovim setup built with `lazy.nvim` and structured for high performance and extensibility.
* **`zsh/`** - Z shell configuration:
  * `.zshrc`: The main configuration file, broken down into logical sections.
  * `zsh_aliases`: Grouped aliases for core commands and dev tools.
  * `zsh_functions`: Shell functions (`toggle-kb`, `kb-sync`, `toggle_flotnote`, YouTube downloads).
  * `nerdfont/`: Nerd Font glyph picker used by herdr for naming tabs, workspaces, and panes. Pick a glyph, then optionally add a name; while typing the name, press the Down arrow to insert another glyph.

Git configuration is intentionally **not** managed here — see [Notes](#-notes).

## 🛠️ Prerequisites

Install these before linking anything:

```bash
# Homebrew packages
brew install neovim herdr ghostty fzf zoxide lazygit yt-dlp luarocks
brew install --cask karabiner-elements

# Oh My Zsh (KEEP_ZSHRC so it doesn't clobber the symlink you make later)
RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k theme + the two custom plugins the .zshrc declares
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

Neovim's Mason setup also installs npm-based tools such as Prettier and
`eslint_d`; Node.js and npm must be available on `PATH`. LuaCheck requires
LuaRocks, installed above.

`powerlevel10k` is a **theme**, not a plugin — it is set via `ZSH_THEME`, not in the `plugins` array. The remaining plugins (`git`, `gitfast`, `last-working-dir`, `common-aliases`, `history-substring-search`) ship with Oh My Zsh.

## 🚀 Installation

### 1. Clone

```bash
mkdir -p ~/code
git clone <your-repo-url> ~/code/dotfiles
```

The paths in `.zshrc` and `zsh_aliases` assume `~/code/dotfiles`. Cloning elsewhere requires editing those files.

### 2. Link

> **These commands overwrite existing config.** `~/.config/nvim` and `~/.config/karabiner/karabiner.json` in particular are removed outright. Back them up first if you care about them.

```bash
# Zsh
ln -sf ~/code/dotfiles/zsh/.zshrc ~/.zshrc

mkdir -p ~/.config/herdr ~/.config/karabiner ~/.config/ghostty

# Neovim -- `ln -sfn` against an EXISTING directory silently creates the link
# *inside* it. The target must be removed first.
rm -rf ~/.config/nvim
ln -s ~/code/dotfiles/nvim ~/.config/nvim

# Karabiner -- quit the app first, it holds the file open
osascript -e 'quit app "Karabiner-Elements"'
rm -f ~/.config/karabiner/karabiner.json
ln -s ~/code/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

# Ghostty / herdr
ln -sf ~/code/dotfiles/ghostty/config ~/.config/ghostty/config
ln -sf ~/code/dotfiles/herdr/config.toml ~/.config/herdr/config.toml

# Flotnote
ln -sf ~/code/dotfiles/flotnote/flotnote-toggle.applescript ~/.flotnote-toggle.applescript
osacompile -o ~/.flotnote-toggle.scpt ~/.flotnote-toggle.applescript
```

### 3. Verify

```bash
zsh -n ~/.zshrc          # syntax check before you trust it
exec zsh                 # reload
```

## 📝 Notes

* **Git config is not managed here.** This repo is used across machines with different git identities (work vs. personal), so `~/.gitconfig` is left alone deliberately. Set identity per machine, or use `includeIf` to scope it by directory.

* **Karabiner symlinks do not survive.** Karabiner-Elements rewrites `karabiner.json` via atomic replace on every settings change and profile switch, which **replaces the symlink with a regular file**. When that happens the repo silently stops tracking your config. Run `kb-sync` to pull the live file back into the repo and restore the link. Check with `ls -la ~/.config/karabiner/karabiner.json`.

* **Keyboard profiles.** `toggle-kb` switches between the `Internal-ISO` (Apple) and `Logitech-ANSI` profiles. The function matches on those exact names — renaming a profile in the GUI breaks it.

* **No multiplexer auto-start.** `herdr` is launched manually rather than from `.zshrc`. Auto-attaching a multiplexer at shell startup causes nesting and hangs.

* **Ghostty path.** Config lives at `~/.config/ghostty/config` rather than the macOS `Library` path, to stay XDG-compliant.

* **PATH hygiene.** Relative entries such as `./bin` and `./node_modules/.bin` are deliberately kept off `PATH` — they let any directory you `cd` into hijack the commands you run.
