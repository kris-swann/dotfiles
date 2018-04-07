# Dotfiles

This repo contains the my configuration files for different linux/unix utilities.

To easily keep files synced use symlinks!

If you want to easily set up symlinks, there is an interactive python script
to help with that (`python setup.py`), files should be backed up automatically
as you run the script.

When setting up a new computer, be sure to make sure you set up avahi properly
so that you can easily ssh to computers on a local network (make sure
/etc/nsswitch.conf is configured correctly!)

For easy two way syncing of folders between computers, I highly recommend
unison. E.g. `unison ~/Documents ssh://kris@commputername.local/Documents`
