# ════════════════════════════════════════════════════════════════
# 1. POWERLEVEL10K INSTANT PROMPT
# ════════════════════════════════════════════════════════════════
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ════════════════════════════════════════════════════════════════
# 2. OH-MY-ZSH
# ════════════════════════════════════════════════════════════════
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git gitfast last-working-dir common-aliases zsh-autosuggestions zsh-syntax-highlighting history-substring-search)

ZSH_DISABLE_COMPFIX=true

source "${ZSH}/oh-my-zsh.sh"

unalias rm
unalias lt

# ════════════════════════════════════════════════════════════════
# 3. ENVIRONMENT VARIABLES
# ════════════════════════════════════════════════════════════════
export HOMEBREW_NO_ANALYTICS=1

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

export PYTHONBREAKPOINT=ipdb.set_trace

export GITHUB_USERNAME='acmmarques'
export USER='andcardo'
export MAIL='andcardo@student.42lisboa.com'

# Colored output
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# ════════════════════════════════════════════════════════════════
# 4. PATH
# ════════════════════════════════════════════════════════════════
export PATH="${HOME}/.rbenv/bin:${PATH}"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export NVM_DIR="$HOME/.nvm"

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"
export PATH="/usr/local/bin:${PATH}"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:"${HOME}/.local/bin/"

# ════════════════════════════════════════════════════════════════
# 5. TOOL INITIALIZERS
# ════════════════════════════════════════════════════════════════
type -a rbenv > /dev/null && eval "$(rbenv init -)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

eval "$(zoxide init zsh)"

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
# herdr auto-start is disabled — run `herdr` manually to launch the
# workspace manager. The herdr server already runs as a background
# daemon, so `herdr` attaches instantly when you need it.

# ════════════════════════════════════════════════════════════════
# 9. PROMPT
# ════════════════════════════════════════════════════════════════
PROMPT=$'\n'$PROMPT
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ════════════════════════════════════════════════════════════════
# 10. COMPLETIONS
# ════════════════════════════════════════════════════════════════
[ -s "/Users/andremarques/.bun/_bun" ] && source "/Users/andremarques/.bun/_bun"
source <(herdr completion zsh) 2>/dev/null

# ════════════════════════════════════════════════════════════════
# 11. BACKGROUND SERVICES
# ════════════════════════════════════════════════════════════════
if ! pgrep "lemonade" > /dev/null; then
  lemonade server > /dev/null 2>&1 &
  disown
fi
