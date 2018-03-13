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

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

#####################################################################
### VARIABLES
#####################################################################

export EDITOR=nvim

# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

#####################################################################
### ALIASES
#####################################################################

alias e="$EDITOR"

alias weather="curl wttr.in"
alias news="curl nycurl.sytes.net -silent | less"

alias booksearch="calibredb list -f title -s "

alias gh="cd ~"
alias gm="cd /run/media/kris"
alias gc=" cd ~/.config"
alias gcr="cd ~/.config/ranger"
alias gci="cd ~/.config/i3"
alias gcn="cd ~/.config/nvim"
alias gcd="cd ~/.config/dotfiles"
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


# Push changes to laptop
push_sync() {
    rsync -aP --delete /home/kris/Archive kris@greyhound.local:/home/kris
    rsync -aP --delete /home/kris/Documents kris@greyhound.local:/home/kris
    rsync -aP --elete /home/kris/Pictures kris@greyhound.local:/home/kris
}

#####################################################################
### ADDITIONAL SOURCES
#####################################################################

# Enable use of virtualenvwrapper commands
source /usr/bin/virtualenvwrapper.sh

# Fzf magic
source /usr/share/fzf/key-bindings.zsh

# Autojumping
source /etc/profile.d/autojump.zsh

# Enable fish-like autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable fish-like syntax highlighting, must go at bottom of .zshrc
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
