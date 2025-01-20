# Dotfiles

Inspired by:
- https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html
- https://news.ycombinator.com/item?id=11070797

---

Set up SSH git keys
- [Gen new ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Log into Github and add new key in settings

```
git clone --separate-git-dir=$HOME/Projects/dotfiles git@github.com:kris-swann/dotfiles.git $HOME/tmpdotfiles
rsync --recursive --verbose --exclude '.git' $HOME/tmpdotfiles/ $HOME/
rm -r $HOME/tmpdotfiles
```

Reload a new shell (so you have access to the aliases)

```
.f config --local status.showUntrackedFiles no
```

Setup github user `~/.gitconfig.user` should look like this

```
[user]
    name = kris-swann
    email = todo@domain.com
```
