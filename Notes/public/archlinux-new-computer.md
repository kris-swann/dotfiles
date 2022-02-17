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
    * If having issues with wifi dropping all the time, try these (for info `man nm-settings`, `man NetworkManager.conf`)
        * Disable powersave
          ```
          nvim /etc/NetworkManager/conf.d/10-default-wifi-powersave.conf

          [connection]
          wifi.powersave = 2
          ```
        * Disable connectivity scans
          ```
          sudo nvim /etc/NetworkManager/conf.d/20-connectivity.conf

          [connectivity]
          .set.enabled=false
          ```
1.  Create user
    ```
    pacman -S zsh
    useradd --create-home -g wheel -s /bin/zsh kris
    passwd kris
    ```
1.  Install and configure `sudo` **(USE `visudo`, DO NOT MANUALLY EDIT `/etc/sudoers`)**
    ```
    pacman -S sudo vi

    # Add to /etc/sudoers with visudo
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
1.  Disable annoying system beeb
    ```
    rmmod pcspkr
    echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf
    ```
1.  Log out of `root` and back in as new user
1.  Install [yay](https://github.com/Jguer/yay) (AUR helper)
    ```
    pacman -S --needed git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    ```
1.  Configure `pacman` and `yay` to make them pretty (edit `/etc/pacman.conf`)
    ```
    # Misc options
    Color      # UNCOMMENT THIS
    ILoveCandy # UNCOMMENT THIS
    ```
1.  Setup [dotfiles](../README.md)
    * Clone down with https not ssh, will setup ssh keys later and switch this repo over to use ssh
    * Will also need to install rsync `pacman -S rsync`
    * Don't do the config steps yet, just clone down and make sure that you have access to the scripts after re-logging
1.  Install packages `package_sync --install-req`
1.  Update [GRUB](./grub-config.md)
1.  Init neovim, open neovin and run `:PackerSync`
1.  Enable bluetooth
    ```
    rfkill unblock bluetooth

    system start bluetooth.service
    systemctl enable bluetooth.service

    # Power bluetooth on boot
    # Add to /etc/bluetoothmain.conf
    [Policy]
    AutoEnable=true
    ```
1.  Set up ssh key with github and finish `dotfile` config
    ```
    ssh-keygen -C "email@domain.com"
    eval "$(ssh-agent)"
    ssh-add ~/.ssh/id_rsa
    # Follow rest of steps in dotfile setup
    ```
1.  Update touchpad, see [wiki](https://wiki.archlinux.org/title/Touchpad_Synaptics) for more details, also `man synaptics`
    ```
    # Copy default config (provided by xf86-input-synaptics)
    sudo cp /usr/share/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/70-synaptics.conf
    sudo nvim /etc/X11/xorg.conf.d/70-synaptics.conf

    # Modify to be
    Section "InputClass"
        Identifier "touchpad"
        Driver "synaptics"
        MatchIsTouchpad "on"
        Option "TapButton1" "1"  # One finger tap is mouse button 1
        Option "TapButton2" "3"  # Two finger tap is mouse button 3
        Option "TapButton3" "2"  # Three finger tap is mouse button 2
        Option "VertTwoFingerScroll" "on"
        Option "HorizTwoFingerScroll" "on"
        Option "PalmDetect" "1"
        Option "PalmMinWidth" "5"
        Option "PalmMinZ" "50"
    EndSection
    ```
1.  Configure backlighting
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
1.  Set up docker access
    ```
    sudo groupadd docker
    sudo usermod -aG docker kris
    # Relog
    ```
1.  Setup Logitech Mouse (via logiops, the only way to get full support that I've found for the MX Master Series)
    (See more info [here](https://danishshakeel.me/configure-logitech-mx-master-3-on-linux-logiops/))
    ```
    sudo ln -s /home/kris/.config/logid.cfg /etc/logid.cfg
    systemctl enable --now logid.service
    ```
