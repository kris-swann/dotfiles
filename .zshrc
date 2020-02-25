# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="steeef_custom"

# Autocompletion
autoload -Uz compinit
compinit

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode urltools)

source $ZSH/oh-my-zsh.sh

#####################################################################
### VARIABLES
#####################################################################

export EDITOR=nvim

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

alias e="$EDITOR"

alias weather="curl wttr.in"
alias news="curl nycurl.sytes.net -silent | less"

alias wine32="WINEPREFIX=$HOME/.wine32/ WINEARCH=win32 wine"
alias booksearch="calibredb list -f title -s "

alias gh="cd ~"
alias gm="cd /run/media/kris"
alias gc=" cd ~/.config"
alias gcr="cd ~/.config/ranger"
alias gci="cd ~/.config/i3"
alias gcn="cd ~/.config/nvim"
alias gd="cd ~/Documents"
alias gp="cd ~/Projects"
alias gs="cd ~/Documents/UMN/Year3/Sem2"

#####################################################################
### FUNCTIONS
#####################################################################

# Open the given calibre listing with zathura
bookopen() {
    db_entry=$(calibredb list -w 10000 -f formats -s id:$1 | tail -n1)
    file_listing=$(echo $db_entry | grep -oE '\[(.*)\]' | tr -d "[]")
    zathura $file_listing
}

# Recursively reset the permissions to the usual -rw-r--r-- for
# files and drwx-r-xr-x for directories.
# Parameters:
#   $1 -> The relative directory to modify permissions under
rnorm_permissions() {
    # Convert all permissions to rwxr-xr-x
    chmod 755 -R $1

    # Remove x permissions from files
    chmod -x $1/**/*(.)
}

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
if [[ -d ~/.pyenv ]]; then
    export PYENV_ROOT=~/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH

    # Load pyenv automatically by appending
    # the following to ~/.zshrc:
    eval "$(pyenv init -)"
fi

#####################################################################
### ADDITIONAL SOURCES
#####################################################################

# Enable use of virtualenvwrapper commands
[ -f /usr/bin/virtualenvwrapper.sh ] && source /usr/bin/virtualenvwrapper.sh

# Fzf magic
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# Autojumping
if [[ -f /etc/profile.d/autojump.zsh ]]; then
    # Manjaro location
    source /etc/profile.d/autojump.zsh
else
    # OSX Location
    source /usr/local/etc/profile.d/autojump.sh
fi

# Enable fish-like autosuggestions
if [[ -f  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # Manjaro location
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    # OSX Location
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Enable fish-like syntax highlighting, must go at bottom of .zshrc
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    # Manjaro location
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    # OSX location
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Any local-specific settings should go in ~/.extend.zshrc or ~/.local_profile
[ -f ~/.extend.zshrc ] && source ~/.extend.zshrc
[ -f ~/.local_profile ] && source ~/.local_profile
