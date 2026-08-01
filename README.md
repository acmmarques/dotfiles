# André's Dotfiles

Welcome to my personal dotfiles repository! This repository contains my configuration files for various tools, shell environments, and editors. It is designed to be easily portable and structured logically by application.

## 📂 Repository Structure

Here is an overview of what is managed in this repository:

* **`ghostty/`** - Configuration for the [Ghostty](https://ghostty.org/) terminal emulator.
* **`git/`** - Global Git configuration (`gitconfig`) and global ignores (`gitignore`) featuring custom aliases and workflow enhancements.
* **`herdr/`** - Configuration for [herdr](https://herdr.dev/), a terminal workspace manager for AI coding agents.
* **`karabiner/`** - macOS keyboard customization rules for [Karabiner-Elements](https://karabiner-elements.pqrs.org/).
* **`nvim/`** - Complete Neovim setup built with `lazy.nvim` and structured for high performance and extensibility.
* **`zsh/`** - Z shell configuration:
  * `.zshrc`: The main configuration file, broken down into logical sections.
  * `zsh_aliases`: Grouped aliases for core commands, projects, and Dev/42 School tools.
  * `zsh_functions`: Helpful shell functions (e.g., YouTube downloading, directory navigation).

## 🚀 Installation / Setup

To set up these dotfiles on a new macOS machine, clone this repository to `~/code/dotfiles` and create the necessary symlinks.

### 1. Clone the repository

```bash
mkdir -p ~/code
git clone <your-repo-url> ~/code/dotfiles
cd ~/code/dotfiles
```

### 2. Create the Symlinks

You can manually link the files by running the following commands:

```bash
# Zsh
ln -sf ~/code/dotfiles/zsh/.zshrc ~/.zshrc

# Git
ln -sf ~/code/dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/code/dotfiles/git/gitignore ~/.gitignore

# Config Directories (creates them if they don't exist)
mkdir -p ~/.config/herdr ~/.config/karabiner ~/.config/ghostty

# App Configs
ln -sf ~/code/dotfiles/herdr/config.toml ~/.config/herdr/config.toml
ln -sf ~/code/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -sf ~/code/dotfiles/ghostty/config ~/.config/ghostty/config

# Neovim (Assuming the whole nvim folder is linked)
ln -sfn ~/code/dotfiles/nvim ~/.config/nvim
```

## 🛠️ Prerequisites & Dependencies

To get the full experience, ensure you have the following tools installed:

* **[Homebrew](https://brew.sh/)** - The macOS package manager.
* **[Oh My Zsh](https://ohmyz.sh/)** - Zsh framework.
  * Required plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `powerlevel10k`.
* **[Neovim](https://neovim.io/)** - Highly extensible Vim-based text editor.
* **[Herdr](https://herdr.dev/)** - Terminal multiplexer & workspace manager.
* **[Ghostty](https://ghostty.org/)** - Fast, native terminal emulator.
* **[Karabiner-Elements](https://karabiner-elements.pqrs.org/)** - For advanced keyboard modifications on macOS.
* **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** - Used by the custom YouTube downloader functions.

## 📝 Notes

* **Terminal Auto-start**: `herdr` is configured to be launched manually by typing `herdr` rather than forcing an auto-start on every new terminal instance. This prevents hanging or nesting issues.
* **Ghostty Path**: The Ghostty config is intentionally placed in `~/.config/ghostty/config` instead of the macOS `Library` path to remain XDG-compliant and cross-platform compatible.
