# dotfiles

To easily keep files synced use symlinks! For files `ln -s ~/abs/path/to/repo/.config/some.file ~/.xonfig/some/file` and for folders `ln -sT ~/abs/path/to/repo/.config/somefolder/ ~/.config/somefolder`.

When setting up a new computer, be sure to make sure you set up avahi properly so that you can easily ssh to comptuers on a local network (make sure /etc/nsswitch.conf is configured correctly!)
