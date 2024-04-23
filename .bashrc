#
# ~/.bashrc
#
# Excecuted for all new bash terminals
#

# Early exit if not interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f ~/.profile ]; then 
  source ~/.profile
fi

export TERM=xterm-256color      # Ensure 256 color support.


# enable bash completion in interactive shells
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#####################################################################
### ALIASES
#####################################################################

alias trash="gio trash"
alias t="trash"
alias open="xdg-open"

alias ls="exa"
alias ll="ls -al"

alias e="$EDITOR"
alias e.="$EDITOR ./"

alias g="git"
alias dc="docker-compose"
alias k="kubectl"
alias python="python3"
alias pip="pip3"

alias .f="git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME"
alias .fs=".f add ~/.config/nvim/spell/en.utf-8.add && .f commit -m 'Update spell file'"

alias gm="cd /run/media/kris"
alias gp="cd ~/Projects"
alias gd="cd ~/Downloads"
alias gcn="cd ~/.config/nvim/lua"

alias gn="cd ~/Notes"
alias Notes='e ~/Notes -c ":chdir ~/Notes"'
alias NO='Notes'
alias no='Notes'

alias weather="curl wttr.in"
alias news="curl nycurl.sytes.net -silent | less"

#####################################################################

eval "$(starship init bash)"

if [ -f ~/.bashrc.extend ]; then
  source ~/.bashrc.extend
fi
