# Archlinux installation

Follow the installation tutorial at the [archlinux wiki](https://wiki.archlinux.org/)

Another good resource that inspired a lot of this document:
[Install Archlinux UEFI w/ Encrypted Disk](https://blog.bespinian.io/posts/installing-arch-linux-on-uefi-with-full-disk-encryption/)

Note: you can use `cfdisk` for a more graphical partitioning tool

Additionally make sure you install `networkmanager` (or some other way to
connect to the internet) from the install media. If you don't you won't be able
to access the internet after booting into the newly installed stystem.

Probably a good idea to also install `vim` and `neovim` at that step too.


---

# Post-install steps

### Setup Network Manager
1.  Start and enable service `systemctl enable NetworkManager.service --now`
2.  Use TUI front-end to setup wifi/wired connectiosn `nmtui`

### Create user
1.  Need to install zsh so can set as default shell `pacman -S zsh`
2.  Add user `useradd --create-home -g wheel -s /bin/zsh kris`
3.  Set password `passwd kris`

### Install and configure sudo
1.  **USE `visudo`, DO NOT MANUALLY EDIT `/etc/sudoers`**
2.  `pacman -S sudo vi`
3.  vi sucks, use nvim with visudo checks `EDITOR=nvim visudo`
4.  Add to sudofile
    ```
    # Comand Aliases
    Cmnd_Alias REBOOT = /usr/bin/shutdown, /usr/bin/reboot, /usr/bin/systemctl suspend
    Cmnd_Alias MOUNT = /usr/bin/mount, /usr/bin/umount
    Cmnd_Alias PACMAN_SYNC = /usr/bin/pacman -Syu, /usr/bin/pacman -Syyu
    Cmnd_Alias REBOOT_NETWORK_MANAGER = /usr/bin/systemctl restart NetworkManager
    # Allow root to use sudo
    root ALL=(ALL:ALL) ALL
    # Allow wheel users to use sudo
    %wheel  ALL=(ALL:ALL) ALL
    # Allow wheel users to run the following commands without a password
    %wheel ALL=(ALL:ALL) NOPASSWD: REBOOT, MOUNT, PACMAN_SYNC, REBOOT_NETWORK_MANAGER
    ```

### Disable annoying system beeb
1.  More info [here](https://wiki.archlinux.org/title/PC_speaker)
2.  Unload `rmmod pcspkr`
3.  Disable on boot `echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf`

### Log out of `root` and back in as new user
1.  `logout`

### Install [yay](https://github.com/Jguer/yay) (AUR helper)
1.  Install deps `pacman -S --needed git base-devel`
2.  Clone and install in tmp
    ```
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

### Make `pacman` and `yay` pretty
1.  `sudo nvim /etc/pacman.conf`
2.  Uncomment/add the follwing lines
    ```
    Color                   # UNCOMMENT THIS
    ILoveCandy              # UNCOMMENT THIS
    ParallelDownloads = 5   # UNCOMMENT THIS
    ```

### Setup [dotfiles](../README.md)
1.  Clone down with https not ssh, will setup ssh keys later and switch this repo over to use ssh
2.  Will also need to install rsync `pacman -S rsync`
3.  Don't do the config steps yet, just clone down and make sure that you have access to the scripts after re-logging

### Install packages
1.  `package-sync --install-req`

### Update GRUB
1.  See this document: [GRUB Config](./grub-config.md)

### Init neovim
1.  Open neovim `nvim`
2.  In nvim run `:PackerSync`

### Enable bluetooth
```
rfkill unblock bluetooth

system start bluetooth.service
systemctl enable bluetooth.service

# Power bluetooth on boot
# Add to /etc/bluetoothmain.conf
[Policy]
AutoEnable=true
```

### Set up ssh key with github and finish `dotfile` config
```
ssh-keygen -C "email@domain.com"
eval "$(ssh-agent)"
ssh-add ~/.ssh/id_rsa
# Follow rest of steps in dotfile setup
```

### Update touchpad, see [wiki](https://wiki.archlinux.org/title/Touchpad_Synaptics) for more details, also `man synaptics`
```
# Copy default config (provided by xf86-input-synaptics)
sudo cp /usr/share/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf
sudo nvim /etc/X11/xorg.conf.d/70-synaptics.conf

# Modify to be
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
    Option "TapButton1" "### # One finger tap is mouse button 1
    Option "TapButton2" "3"  # Two finger tap is mouse button 3
    Option "TapButton3" "2"  # Three finger tap is mouse button 2
    Option "VertTwoFingerScroll" "on"
    Option "HorizTwoFingerScroll" "on"
    Option "PalmDetect" "1"
    Option "PalmMinWidth" "5"
    Option "PalmMinZ" "50"
EndSection
```

### Configure backlighting
```
# Add to video group so can edit brightness
usermod -a -G video kris

# Add udev rule to allow video group to modify brightness
sudo nvim /etc/udev/rules.d/backlight.rules
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", GROUP="video", MODE="0664"
```
* May not be required on all systems, but I had to add this option to xorg.conf to work w/ dedicated graphics mode [wiki](https://wiki.archlinux.org/title/Laptop/Lenovo#Legion_series)
```
sudo nvim /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
Option "RegistryDwords" "EnableBrightnessControl=1"
```

### Set up docker access
```
sudo groupadd docker
sudo usermod -aG docker kris
# Relog
```

### Setup Logitech Mouse (via logiops, the only way to get full support that I've found for the MX Master Series)
(See more info [here](https://danishshakeel.me/configure-logitech-mx-master-3-on-linux-logiops/))
```
sudo ln -s /home/kris/.config/logid.cfg /etc/logid.cfg
systemctl enable --now logid.service
```
