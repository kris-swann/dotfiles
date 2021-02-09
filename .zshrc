# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="steeef_custom"

# Autocompletion
autoload -Uz compinit
compinit

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# List of plugins (space delimited) Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git vi-mode urltools)

source $ZSH/oh-my-zsh.sh

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


#####################################################################
### VARIABLES
#####################################################################

export EDITOR=nvim
export LESS="-XFRS"

#####################################################################
### VI MODE
#####################################################################

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

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

alias nn="~/.local/nvim-nightly/bin/nvim"
alias e="$EDITOR"

alias weather="curl wttr.in"
alias news="curl nycurl.sytes.net -silent | less"

alias wine32="WINEPREFIX=$HOME/.wine32/ WINEARCH=win32 wine"
alias booksearch="calibredb list -f title -s "

alias gm="cd /run/media/kris"
alias gp="cd ~/Projects"
alias gd="cd ~/Projects/dotfiles"

#####################################################################
### ADDITIONAL PATHS
#####################################################################

# Add scripts to path
export PATH=~/Scripts:$PATH

# User specific global install path for npm
# To set prefix: npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH

# Add user pip installed packages (insalled via `pip install <package> --user`)
export PATH=~/.local/bin:$PATH

# If using pyenv, add to path and set up so can use it
if [ -d ~/.pyenv ]; then
    export PYENV_ROOT=~/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
fi

#####################################################################
### ADDITIONAL SOURCES
#####################################################################

# Fzf magic
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# Autojumping
if [ -f /etc/profile.d/autojump.zsh ]; then
    # Manjaro location
    source /etc/profile.d/autojump.zsh
elif [ -f /usr/local/etc/profile.d/autojump.sh ]; then
    # OSX Location
    source /usr/local/etc/profile.d/autojump.sh
fi

# Enable fish-like autosuggestions
if [ -f  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Manjaro location
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # OSX Location
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Enable fish-like syntax highlighting, must go at bottom of .zshrc
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # Manjaro location
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    # OSX location
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.zsh ] && . ~/.config/tabtab/__tabtab.zsh || true

[ -f ~/.profile ] && source ~/.profile
[ -f ~/.profile_local ] && source ~/.profile_local
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
