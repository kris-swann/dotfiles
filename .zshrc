[ -f ~/.profile ] && source ~/.profile
[ -f ~/.profile_local ] && source ~/.profile_local

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
### ALIASES
#####################################################################

alias t="trash"

alias g="git"
alias dc="docker-compose"
alias .f="git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME"
alias .fprivate="git --git-dir=$HOME/Projects/dotfiles-private/ --work-tree=$HOME"
alias e="$EDITOR"
alias e.="$EDITOR ./"
alias gm="cd /run/media/kris"
alias gp="cd ~/Projects"
alias gd="cd ~/Downloads"

alias weather="curl wttr.in"
alias news="curl nycurl.sytes.net -silent | less"

alias ls="exa"
alias ll="ls -al"

alias awslocal="AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=${DEFAULT_REGION:-'us-east-1'} aws --endpoint-url=http://localhost:4566"

#####################################################################
### ADDITIONAL PATHS
#####################################################################

# Add scripts
export PATH="$HOME/Scripts:$PATH"

# Add global npm installs (setup w/: npm config set prefix '~/.npm-global')
export PATH="$HOME/.npm-global/bin:$PATH"

# Add pip --user packages (installed via `pip install <package> --user`)
export PATH="$HOME/.local/bin:$PATH"

# Add nim (installed via choosenim)
export PATH="$HOME/.nimble/bin:$PATH"

# Add cargo installs
export PATH="$HOME/.cargo/bin:$PATH"

# If using pyenv, add to path and set up so can use it
if [ -d ~/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Garden.io
if [ -d ~/.garden ]; then
  export PATH="$PATH:$HOME/.garden/bin"
fi


# Golang (debian)
if [ -d /usr/local/go ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi


#####################################################################
### ADDITIONAL SOURCES
#####################################################################

# Fzf magic
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  # Arch location
  source /usr/share/fzf/key-bindings.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  # Debian location
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# Fish-like autosuggestions
if [ -f  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Arch location
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Debian location
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # OSX Location
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Fish-like syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # Arch location
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # Debian location
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # OSX location
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.config/tabtab/__tabtab.zsh ] && . ~/.config/tabtab/__tabtab.zsh || true

eval "$(starship init zsh)"
[ -f ~/.zshrc_local ] && source ~/.zshrc_local

# Autocompletion for kubectl
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# NVM (this works on arch, but not on debian)
# TODO: if on archlinux:
# source /usr/share/nvm/init-nvm.sh
# TODO else:
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# TODO: fi

# Autoexec "nvm use" when entering a dir with a .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# Sdkman (java version manager)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
