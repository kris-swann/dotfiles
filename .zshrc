#
# Executed for all new zsh terminals
#

if [ -f ~/.profile ]; then
  source ~/.profile
fi

# Autocompletion
if [ -d "$HOME/.zfunc" ]; then
  fpath+=$HOME/.zfunc
fi
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C $(which aws_completer) aws

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

#####################################################################
### HISTORY
#####################################################################
export SAVEHIST=1000000000
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTFILE=~/.cache/zsh_history
setopt HIST_FIND_NO_DUPS  # Skip dupes after typing something then hitting up/down or ^p/^n
setopt HIST_IGNORE_ALL_DUPS # Remove older dupes when adding a new one (needed to dedupe up/down/^p/^n on empty line)
setopt HIST_REDUCE_BLANKS  # Remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # Append command to history file immediately after execution
setopt EXTENDED_HISTORY  # Record command start time

#####################################################################
### FUNCTIONS
#####################################################################

# Check if a command exists or not
exists () {
  command -v "$1" &> /dev/null
}

# Pass args to bc for simple one-off math
bb() { bc <<< "$@" }


#####################################################################
### VI MODE
#####################################################################

# Use vim keys in tab complete menu:
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey "^?" backward-delete-char  # Backspace works like normal
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# To see keycodes use: showkey -a
# ^ is control
# ^[ is alt
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey "^A" beginning-of-line
bindkey "^B" backward-char
bindkey "^E" end-of-line
bindkey "^F" forward-char
bindkey "^H" backward-delete-char
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^[[1;5D" backward-word  # left arrow
bindkey "^[[1;5C" forward-word   # right arrow

# bindkey -v '^?' backward-delete-char

insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

#####################################################################
### BASIC VARIABLES / GLOBAL SETTINGS
#####################################################################

export TERMINAL="kitty"
export EDITOR="nvim"
export LESS="-XFRS"
export UNAME="$(uname)"

#####################################################################
### ALIASES
#####################################################################

alias trash="gio trash"
alias t="trash"
alias open="xdg-open"

alias ls="eza"
alias ll="ls -al"

alias e="$EDITOR"
alias e.="$EDITOR ./"

alias g="git"
alias dc="docker-compose"
alias k="kubectl"
alias pip="pip3"

alias .f="git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME"
alias .fs=".f add ~/.config/nvim/spell/en.utf-8.add && .f commit -m 'Update spell file'"

alias gp="cd $HOME/Projects"
alias gd="cd $HOME/Downloads"
alias gcn="cd $HOME/.config/nvim/lua"

#####################################################################
### ADDITIONAL PATHS
#####################################################################

[ -d "$HOME/Scripts" ] && export PATH="$HOME/Scripts:$PATH"
[ -d "$HOME/.bin" ] && export PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Cargo installs
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

# Go installs
[ -d "/usr/local/go/bin" ] && export PATH="/usr/local/go/bin:$PATH"

# Homebrew
if [ -d "/opt/homebrew/bin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#####################################################################
### ADDITIONAL SOURCES
#####################################################################

export PATH="$HOME/.local/bin:$PATH"

# Fzf
if exists fzf; then
  eval "$(fzf --zsh)"
fi

# Fish-like autosuggestions
if [ -f  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Arch location
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Debian location
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # OSX location
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Fish-like syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # Arch location
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # Debian location
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f   /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # OSX location
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autocompletion for kubectl
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

# Sdkman (java version manager)
export SDKMAN_DIR="$HOME/.sdkman"
if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

eval "$(starship init zsh)"

# NVM (node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# libpq (psql binary)
if [ -d "/opt/homebrew/opt/libpq/bin" ]; then
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi
