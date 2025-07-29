# Created by Rick Mortensen for 5.9

# Set up PATH
paths=(
  /root/.cargo/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $HOME/.cargo/bin
  $HOME/development/flutter/bin
  $HOME/.dotnet/tools
  $HOME/.local/bin
)

export PATH=$(printf ":%s" "${paths[@]}")  # Join paths with ':'

# Enable Ruby JIT
export RUBY_YJIT_ENABLE=1

# Set Editor
export EDITOR="nvim"

# Initialize completions with ZSH's compinit
autoload -Uz compinit && compinit -i

# Load Plugins
plugin_dir="$HOME/.local"
plugins=(
  "zsh-z/zsh-z.plugin.zsh"
  "command-not-found/command-not-found.plugin.zsh"
  "zsh-autosuggestions/zsh-autosuggestions.zsh"
  "zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "zsh-completions/zsh-completions.plugin.zsh"
  "zsh-fzf/key-bindings.zsh"
  "completion.zsh"
  "fzf.plugin.zsh"
)

for plugin in "${plugins[@]}"; do
  [[ -f "$plugin_dir/$plugin" ]] && source "$plugin_dir/$plugin"
done

# ZSH-Z Plugin Options
ZSH_CASE=smart  # Lowercase patterns are case insensitive

# Improved Completion Settings
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Fuzzy Match Mistyped Completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Load & Initialize Prompt System
autoload -Uz promptinit && promptinit

# History Configuration
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY

# Keybindings
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -e
bindkey '^[[Z' reverse-menu-complete
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Enable Color Support and Useful Aliases
if [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"

  alias ls='ls --color=auto --human-readable --group-directories-first --classify'
  alias dir='dir --color=auto --human-readable --group-directories-first --classify'
  alias vdir='vdir --color=auto --human-readable --group-directories-first --classify'
  alias grep='grep --color=auto'
  alias fgrep='grep -F --color=auto'
  alias egrep='grep -E --color=auto'
fi

# Additional Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias emacs='emacs-nox'
alias lx='exa --icons --long --recurse --level=1 -a'
alias hx='hx'

# Enable Prompt Substitution
autoload -U colors zsh/terminfo
colors
setopt PROMPT_SUBST

NL=$'\n'

# Prompt Customization
PS1='$NL%B%F{green}%n%f%b@%B%F{cyan}%m%f%b %F{blue}%~%f$NL%B%(?.%F{green}.%F{red})%(!.%F{blue}λ%f.>)%f%b '

# Right-side prompt (if needed)

# Bun Completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Ruby Environment
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  export PATH="$(gem environment gemdir)/bin:$PATH"
fi

# Added by app (https://github.com/hkdb/app) installation
source /home/rickm/.config/app/.app_profile
. "/home/rickm/.deno/env"
# bun completions
[ -s "/home/rickm/.bun/_bun" ] && source "/home/rickm/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
