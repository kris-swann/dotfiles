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

#### Setup Network Manager
1.  Start and enable service `systemctl enable NetworkManager.service --now`
2.  Use TUI front-end to setup wifi/wired connectiosn `nmtui`

#### Create user
1.  Need to install zsh so can set as default shell `pacman -S zsh`
2.  Add user `useradd --create-home -g wheel -s /bin/zsh kris`
3.  Set password `passwd kris`

#### Install and configure sudo
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

#### Disable annoying system beeb
1.  More info [here](https://wiki.archlinux.org/title/PC_speaker)
2.  Unload `rmmod pcspkr`
3.  Disable on boot `echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf`

#### Log out of `root` and back in as new user
1.  Either run `logout` or `Ctrl-D`

#### Install yay (AUR helper)
1.  Docs [here](https://github.com/Jguer/yay)
2.  Install deps `pacman -S --needed git base-devel`
3.  Clone and install in tmp
    ```
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```

#### Make `pacman` and `yay` pretty
1.  `sudo nvim /etc/pacman.conf`
2.  Uncomment/add the follwing lines
    ```
    Color                   # UNCOMMENT THIS
    ILoveCandy              # UNCOMMENT THIS
    ParallelDownloads = 5   # UNCOMMENT THIS
    ```

#### Setup dotfiles
1.  Follow directions [here](../../README.md)
2.  Clone down with https not ssh, will setup ssh keys later and switch this repo over to use ssh
3.  Will also need to install rsync `pacman -S rsync`
4.  Don't do the config steps yet, just clone down and make sure that you have access to the scripts after re-logging

#### Install packages
1.  `sudo pacman -S python`
2.  `package-sync --install-req`

#### Update GRUB
1.  Follow directions [here](./grub-config.md)

#### Init neovim
1.  Open `nvim`
2.  In nvim run `:PackerSync`

#### Enable bluetooth
1.  Check if bluetooth soft or hard blocked with `rfkill`
2.  Remove softblock if necessary `rfkill unblock bluetooth`
3.  Enable `systemctl enable bluetooth.service --now`
4.  Power on bluetooth on boot `sudo nvim /etc/bluetooth.conf`
    ```
    [Policy]
    AutoEnable=true
    ```

#### Set up ssh key, add to github, and finish dotfile config
1.  Create key
    ```
    ssh-keygen -C "email@domain.com"
    eval "$(ssh-agent)"
    ssh-add ~/.ssh/id_rsa
    ```
2.  Add ssh key to github
3.  Follow rest of steps in dotfile setup [here](../../README.md)

#### Update touchpad
1.  See [wiki](https://wiki.archlinux.org/title/Touchpad_Synaptics) for more details, also `man synaptics`
2.  Copy default config (provided by `xf86-input-synaptics`)
    `sudo cp /usr/share/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf`
3.  Modify config `sudo nvim /etc/X11/xorg.conf.d/70-synaptics.conf`
    ```
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

#### Configure backlighting
1.  Need to be in `video` group to edit brightness `usermod -a -G video kris`
2.  Add udev rule to allow video group to modify brightness `echo 'ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", GROUP="video", MODE="0664"' | sudo tee /etc/udev/rules.d/backlight.rules`
3.  Lenovo Legion Laptop had trouble on dedicated graphicsmode (see more info in the [wiki](https://wiki.archlinux.org/title/Laptop/Lenovo#Legion_series))
    ```
    sudo nvim /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    Option "RegistryDwords" "EnableBrightnessControl=1"
    ```

#### Set up docker access
1.  Add user to group so don't have to prefix docker commands with sudo
    ```
    sudo groupadd docker
    sudo usermod -aG docker kris
    ```
2.  Relog

#### Setup Logitech Mouse
1.  Best support for MX Master Series seems to be via `logiops`
2.  See more info [here](https://danishshakeel.me/configure-logitech-mx-master-3-on-linux-logiops/)
3.  Link configs `sudo ln -s /home/kris/.config/logid.cfg /etc/logid.cfg`
4.  Enable service `systemctl enable logid.service --now`

#### Enable automatic time sync
1.  `sudo systemctl enable systemd-timesyncd.service --now`

#### Improve power management (for laptops only)
1.  Use `tlp` and `tlp-rdw` for simple power optimizations
1.  Enable service `systemctl enable tlp.service --now`
2.  Prevent conflicts `systemctl enable NetworkManager-dispatcher.service --now`
3.  Run `sudo tlp-stat` and follow any recommendations there

#### Automatic fstrim (for SSDs only)
1.  Enable automaticly scheduled SSD housekeeping `sudo systemctl enable fstrim.timer --now`

#### Automatic mirror list updates
1.  Use `reflector` for auto updating mirror list
2.  Edit config `sudo nvim /etc/xdg/reflector/reflector.conf` (for more info `man reflector`)
    ```
    --save /etc/pacman.d/mirrorlist
    --protocol https
    --country 'United States'
    --latest 10
    --sort rate
    ```
3. Enable service `systemctl enable reflector.timer --now`

#### Decrease swappiness for systems with a lot of RAM
1. To reduce swappiness permenentaly `echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf`
