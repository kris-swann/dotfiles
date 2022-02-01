[ -f ~/.profile ] && source ~/.profile
[ -f ~/.profile_local ] && source ~/.profile_local

# Path to your oh-my-zsh installation.
# export ZSH=$HOME/.oh-my-zsh

# Autocompletion
autoload -Uz compinit
compinit

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# List of plugins (space delimited) Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# plugins=(vi-mode urltools)

# source $ZSH/oh-my-zsh.sh

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
setopt HIST_FIND_NO_DUPS  # Skip dupes with ^P and ^N
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

# Keep track of cwds
update_cwd_data() {
  if exists xdotool; then
    mkdir -p /tmp/cwd_data
    pid=$(xdotool getwindowfocus getwindowpid)
    touch "/tmp/cwd_data/$pid"
    echo "$(pwd)" > "/tmp/cwd_data/$pid"
  fi
}
precmd_functions+=(update_cwd_data)

# Pass args to bc for simple one-off math
bb() { bc <<< "$@" }


#####################################################################
### VI MODE
#####################################################################

# Use vim keys in tab complete menu:
zstyle ':completion:*' menu select
zmodload zsh/complist
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
### ALIASES
#####################################################################

alias g="git"
alias .f="git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME"
alias e="$EDITOR"
alias gm="cd /run/media/kris"
alias gp="cd ~/Projects"
alias gd="cd ~/Downloads"

alias weather="curl wttr.in"
alias news="curl nycurl.sytes.net -silent | less"


alias ls="exa"
alias ll="ls -l"



#####################################################################
### ADDITIONAL PATHS
#####################################################################

# Add scripts to path
export PATH="$HOME/Scripts:$PATH"

# User specific global install path for npm
# To set prefix: npm config set prefix '~/.npm-global'
export PATH="$HOME/.npm-global/bin:$PATH"

# Add user pip installed packages (insalled via `pip install <package> --user`)
export PATH="$HOME/.local/bin:$PATH"

# If using pyenv, add to path and set up so can use it
if [ -d ~/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi


#####################################################################
### ADDITIONAL SOURCES
#####################################################################

# Fzf magic
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# Fish-like autosuggestions
if [ -f  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Arch location
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # OSX Location
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Fish-like syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # Arch location
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # OSX location
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.config/tabtab/__tabtab.zsh ] && . ~/.config/tabtab/__tabtab.zsh || true

eval "$(starship init zsh)"
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
