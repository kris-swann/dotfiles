# Dotfiles

Inspired by:
- https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html
- https://news.ycombinator.com/item?id=11070797

## Setup

Set up SSH git keys
- [Gen new ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Log into Github and add new key in settings

```
git clone --separate-git-dir=$HOME/Projects/dotfiles git@github.com:kris-swann/dotfiles.git $HOME/tmpdotfiles
rsync --recursive --verbose --exclude '.git' $HOME/tmpdotfiles/ $HOME/
rm -r $HOME/tmpdotfiles
```

## Reload a new shell (so you have access to the aliases)
```
.f config --local status.showUntrackedFiles no
```

Setup github user `~/.gitconfig.user` should look like this

```
[user]
    name = kris-swann
    email = todo@domain.com
```


## Set up git-crypt and spell files (Optional/Might remove)

Set up git-crypt (assumes keys are set-up)
```
git clone --separate-git-dir=$HOME/Projects/dotfiles-private git@github.com:kris-swann/dotfiles-private.git $HOME/tmpdotfiles-private

rsync --recursive --verbose --exclude '.git' $HOME/tmpdotfiles-private/ $HOME/
rm -r $HOME/tmpdotfiles-private

# Unlock git-crypt
.f crypt unlock ~/.local/share/dotfiles/git-crypt-key

# Verify by checking if spell files look correct
cat "$HOME/.config/nvim/spell/en.utf-8.add"
```

Set up gpg key (assumes dotfiles-private has been set up)
```
gpg --import ~/.local/share/gpg-exports/krisswannfastmail.private.armor.key

gpg --edit-key krisswann@fastmail.com
# trust
# 5
```
