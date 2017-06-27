# OMZ Config:
ZSH_THEME="agnoster"
export ZSH=~/.config/omz
source $ZSH/oh-my-zsh.sh



# PERSONAL CONFIG:
# Set editor for ranger
export EDITOR=nvim

export PATH=$PATH:/usr/local/lib/python3.5/dist-packages/

# Easy backups of home folder (make sure Drive is mounted first).
export BACKUP_LOC="/media/kris/TOSHIBA EXT"
alias backup_home='rsync -aP --delete /home/kris "$BACKUP_LOC"'

# For syncing flask drive (only sync sem 2).
export BACKUP_FLASH_DRVE="/media/kris/USB DISK"
alias syncflashdrive='rsync -aP --delete /home/kris/Documents/UMN/Year2/Sem2 "$BACKUP_FLASH_DRVE"'

# Make python and pip refer to version3.
alias python=python3
alias pip=pip3

sitePath='/home/kris/Projects/personalSite'
alias runwebsite='source $sitePath/virtualenv/bin/activate && python $sitePath/manage.py runserver && deactivate'

alias rdeps="apt rdepends --installed"
alias mauto="sudo apt-mark auto"

alias nmrestart="sudo service network-manager restart"
