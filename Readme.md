# Dotfiles

## Setup

Inspired by:
- https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html
- https://news.ycombinator.com/item?id=11070797

- SSH if keys already setup
  - `git clone --separate-git-dir=$HOME/Projects/dotfiles git@github.com:kris-swann/dotfiles.git $HOME/tmpdotfiles`
- HTTPS if keys not yet setup
  - `git clone --separate-git-dir=$HOME/Projects/dotfiles https://github.com/kris-swann/dotfiles $HOME/tmpdotfiles`

```
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

Add the following line to `~/.ssh/config`

```
Include ~/.ssh/config.common
```

Enable ssh-agent systemd service

```
systemctl --user enable ssh-agent
systemctl --user start ssh-agent  # Or reboot
```

Add ssh key to github, follow [this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) guide

Change https to ssh
```
.f remote set-url origin git@github.com:kris-swann/dotfiles.git
```

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
