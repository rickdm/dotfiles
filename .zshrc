# Created by Rick Mortensen for 5.9
#$PATH
export PATH=/home/rmortensen/.asdf/shims:/home/rmortensen/.asdf/bin:/home/rmortensen/.cargo/bin:/home/rmortensen/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:
HELIX_RUNTIME=/home/rmortensen/.config/helix/helix/runtime

export RUBY_YJIT_ENABLE=1

EDITOR="nvim"

#asdf
. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

source $(dirname $(gem which colorls))/tab_complete.sh

#Plugins
source /usr/share/zsh-z/zsh-z.plugin.zsh
source /usr/share/command-not-found/command-not-found.plugin.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-completions/zsh-completions.plugin.zsh
source /usr/share/zsh-fzf/key-bindings.zsh
source /usr/share/zsh-fzf/completion.zsh
source /usr/share/zsh-fzf/fzf.plugin.zsh

# zsh-z plugin options
ZSH_CASE=smart # lower case patterns are treated as case insensitive
zstyle ':completion:*' menu select # improve completion menu style

#Load and initialize autocompletion
autoload -Uz compinit && compinit -i
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
# Use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
if zstyle -t ':prezto:module:completion:*' case-sensitive; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  setopt CASE_GLOB
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unsetopt CASE_GLOB
fi

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit

#setopt prompt_subst
#PROMPT=' %F{blue}$(collapse_pwd)${vcs_info_msg_0_} %{$reset_color%}λ % '

# Preview file content using bat (https://github.com/sharkdp/bat)
#export FZF_COMPLETION_OPTS='--border --info=inline'

### history

HISTFILE="$HOME/.zhistory"
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history f
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet

### moar commandline & keybindings

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -e
bindkey '^[[Z' reverse-menu-complete
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --human-readable --group-directories-first --classify'
  alias dir='dir --color=auto --human-readable --group-directories-first --classify'
  alias vdir='vdir --color=auto --human-readable --group-directories-first --classify'
  alias grep='grep --color=auto --human-readable --group-directories-first --classify'
  alias fgrep='fgrep --color=auto --human-readable --group-directories-first --classify'
  alias egrep='egrep --color=auto --human-readable --group-directories-first --classify'
fi

# some more aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias emacs='emacs-nox'
alias lx='exa --icons --long --recurse --level=1 -a'
alias hx='helix'

# enable command-subsitution in PS1
autoload -U colors zsh/terminfo
colors

setopt PROMPT_SUBST

NL=$'\n'

PS1='$NL%B%F{green}%n%f%b@%B%F{cyan}%m%f%b %F{blue}%~%f$NL%B%(?.%F{green}.%F{red})%(!.%F{blue}λ%f.>)%f%b '
#Right-side prompt
