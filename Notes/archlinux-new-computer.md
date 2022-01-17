# Archlinux installation

Follow the installation tutorial at the [archlinux wiki](https://wiki.archlinux.org/)

Note that you can use `cfdisk` for a more graphical partitioning tool

Additionally make sure you install `networkmanager` (or some other way to
connect to the internet) from the install media. If you don't you won't be able
to access the internet after booting into the newly installed stystem.

Probably a good idea to also install `vim` and `neovim` at that step too.

---

# Post-install steps

1.  Start and enable `networkmanager`, setting up wifi and wired connections
    ```
    systemctl start NetworkManager.service
    systemctl enable NetworkManager.service
    nmtui  # TUI front-end for networkmanager
    ```
2.  Create user
    ```
    pacman -S zsh
    useradd --create-home -g wheel -s /bin/zsh kris
    passwd kris
    ```
3.  Install and configure `sudo` **(USE `visudo`, DO NOT MANUALLY EDIT `/etc/sudoers`)**
    ```
    pacman -S sudo vi

    # Add to /etc/sudoers with visudo
    # Comand Aliases
    Cmnd_Alias REBOOT = /usr/bin/shutdown, /usr/bin/reboot, /usr/bin/systemctl suspend
    Cmnd_Alias MOUNT = /usr/bin/mount, /usr/bin/umount
    Cmnd_Alias PACMAN_SYNC = /usr/bin/pacman -Syu, /usr/bin/pacman -Syyu
    Cmnd_Alias REBOOT_NETWORK_MANAGER = /usr/bin/systemctl restart NetworkManager
    # Allow root to use sudo
    root ALL=(ALL) ALL
    # Allow wheel users to use sudo
    %wheel  ALL=(ALL) ALL
    # Allow wheel users to run the following commands without a password
    %wheel ALL=(ALL) NOPASSWD: REBOOT, MOUNT, PACMAN_SYNC, REBOOT_NETWORK_MANAGER
    ```
4.  Disable annoying system beeb
    ```
    rmmod pcspkr
    echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf
    ```
5.  Log out of `root` and back in as new user
6.  Install [yay](https://github.com/Jguer/yay) (AUR helper)
    ```
    pacman -S --needed git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```
7.  Configure `pacman` and `yay` to make them pretty (edit `/etc/pacman.conf`)
    ```
    # Misc options
    Color      # UNCOMMENT THIS
    ILoveCandy # UNCOMMENT THIS
    ```
8.  Setup [dotfiles](../README.md) (clone with https, don't do the config steps, just clone down and make sure have access to the scripts)
9.  Install packages
    ```
    TODO: script that will sync markdown document with pacman -Qe and provide descriptions of what has been installed and why, warning if explicitly installed packages are missing explainations
    ```
10.  Update [GRUB](./grub-config.md)
