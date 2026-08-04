# ════════════════════════════════════════════════════════════════
# 1. POWERLEVEL10K INSTANT PROMPT
# ════════════════════════════════════════════════════════════════
# Must stay near the top. Anything that may require console input
# (password prompts, [y/n] confirmations) has to go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ════════════════════════════════════════════════════════════════
# 2. OH-MY-ZSH
# ════════════════════════════════════════════════════════════════
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	git
	gitfast
	last-working-dir
	common-aliases
	history-substring-search
	zsh-autosuggestions
	zsh-syntax-highlighting
)

ZSH_DISABLE_COMPFIX=true

if [[ -r "${ZSH}/oh-my-zsh.sh" ]]; then
	source "${ZSH}/oh-my-zsh.sh"
	# common-aliases ships aliases that get in the way; drop them if present.
	unalias rm 2>/dev/null
	unalias lt 2>/dev/null
else
	print -u2 "warning: oh-my-zsh not found at ${ZSH}; running without it"
fi

# ════════════════════════════════════════════════════════════════
# 3. ENVIRONMENT VARIABLES
# ════════════════════════════════════════════════════════════════
export HOMEBREW_NO_ANALYTICS=1

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=nvim
export VISUAL=nvim

# Colored output
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# ════════════════════════════════════════════════════════════════
# 4. PATH
# ════════════════════════════════════════════════════════════════
# Note: relative entries such as ./bin or ./node_modules/.bin are
# deliberately NOT on PATH -- they let any directory you cd into
# hijack the commands you run.
export PATH="/usr/local/bin:${PATH}:/usr/local/sbin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${HOME}/.opencode/bin:${PATH}"

# ════════════════════════════════════════════════════════════════
# 5. TOOL INITIALIZERS
# ════════════════════════════════════════════════════════════════
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# ════════════════════════════════════════════════════════════════
# 6. ALIASES
# ════════════════════════════════════════════════════════════════
source "${HOME}/code/dotfiles/zsh/zsh_aliases"

# ════════════════════════════════════════════════════════════════
# 7. FUNCTIONS
# ════════════════════════════════════════════════════════════════
source "${HOME}/code/dotfiles/zsh/zsh_functions"

# ════════════════════════════════════════════════════════════════
# 8. TERMINAL MULTIPLEXER (herdr)
# ════════════════════════════════════════════════════════════════
# No auto-start: run `herdr` manually to attach the workspace manager.
# Auto-attaching from .zshrc causes nesting and hangs.
if command -v herdr >/dev/null; then
	source <(herdr completion zsh) 2>/dev/null
fi

# ════════════════════════════════════════════════════════════════
# 9. PROMPT
# ════════════════════════════════════════════════════════════════
PROMPT=$'\n'$PROMPT
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
