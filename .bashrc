#
# ~/.bashrc
#



[[ $- != *i* ]] && return



colors() {
    local fgc bgc vals seq0

    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    # foreground colors
    for fgc in {30..37}; do
        # background colors
        for bgc in {40..47}; do
            fgc=${fgc#37} # white
            bgc=${bgc#40} # black

            vals="${fgc:+$fgc;}${bgc}"
            vals=${vals%%;}

            seq0="${vals:+\e[${vals}m}"
            printf "  %-9s" "${seq0:-(default)}"
            printf " ${seq0}TEXT\e[m"
            printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
        done
        echo; echo
    done
}



export TERM=xterm-256color      # Ensure 256 color support.



[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc



#[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion



# enable bash completion in interactive shells
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi



# Add MKL to LD_LIBRARY_PATH.
# source /opt/intel/parallel_studio_xe_2017.0.035/bin/psxevars.sh intel64
# source /home/kris/intel/mkl/bin/mklvars.sh intel64
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/mkl/lib/intel64/



# Add MARS OpenCV3 to LD_LIBRARY_PATH.
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/kris/MARS/MarsFramework/MARSFramework/3rd-party/opencv-cv/linux/lib/



# Easy backups of home folder (make sure Drive is mounted first).
export BACKUP_LOC="/media/kris/TOSHIBA EXT"
alias backup_home='rsync -aP --delete /home/kris "$BACKUP_LOC"'
# For syncing flask drive.
export BACKUP_FLASH_DRVE="/media/kris/USB DISK"
alias syncflashdrive='rsync -aP --delete /home/kris/Documents/UMN/Year2/Sem2 "$BACKUP_FLASH_DRVE"'



# Make python and pip refer to version3.
alias python=python3
alias pip=pip3


sitePath='/home/kris/Documents/Code/Django/personalSite'
alias runwebsite='source $sitePath/virtualenv/bin/activate && python $sitePath/manage.py runserver && deactivate'


alias rdeps="apt rdepends --installed"
alias mauto="sudo apt-mark auto"


alias nmrestart="sudo service network-manager restart"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
