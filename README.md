# Dotfiles

Config files I can't live without

## Setup

Inspired by: https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html

```
git clone --separate-git-dir=$HOME/Projects/dotfiles git@github.com:kris-swann/dotfiles.git $HOME/tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r $HOME/tmpdotfiles
```

## Other

**TODO:** Evaluate if these are still up to date

When setting up a new computer, be sure to make sure you set up avahi properly
so that you can easily ssh to computers on a local network (make sure
/etc/nsswitch.conf is configured correctly!)

For easy two way syncing of folders between computers, I highly recommend
unison. E.g. `unison ~/Documents ssh://kris@commputername.local/Documents`

There are some profiles setup for my specific use case, they can be run as
just `unison sync_bigben` or `unison sync_boat` depending on which computer
you are on.
