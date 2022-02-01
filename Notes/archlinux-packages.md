# Archlinux packages

List of packages I have installed on my systems, with explainations

Serves as the source of truth for [`Scripts/package_sync`](../Scripts/package_sync)

### How it works

Any text text above `# Packages` will be ignored, the rest will be passed to the parser

Text wrapped with `<x-pkg>pkg-name</x-pkg>` is a required package, text wrapped with `<x-opkg>opt-pkg-name</x-opkg>` is an optional package. **Only include one package per tag, do not include package groups!** (meta-packages are OK)

Note that as per the [wiki](https://wiki.archlinux.org/title/Arch_package_guidelines#Package_naming), package names can only include alphanumerics and any of `@`, `.`, `_`, `+`, `-`. Any characters that are not one of these that are inside the tag will be stripped by the parser (this allows using markdown-formatting inside the tag)

# Packages

All text above this point will be ignored, all text below this point will be passed to the parser

### Absolute minimal packages, installed during pacstrap of base-install
* <x-pkg>`base`</x-pkg> Meta-package of minimal packages to define an archlinux installation
* <x-pkg>`linux`</x-pkg> Linux kernel
* <x-pkg>`linux-firmware`</x-pkg> Firmware for common hardware

### Bootloader
* <x-pkg>`grub`</x-pkg> Bootloader
* <x-pkg>`efibootmgr`</x-pkg> For bootloading in efi systems
* <x-pkg>`os-prober`</x-pkg> For automatically discovering other installed operating systems when generating grub-config
* <x-opkg>`intel-ucode`</x-opkg> OR <x-opkg>`amd-ucode`</x-opkg> Processor stability and security updates, needs to be loaded by the bootloader. See the [wiki](https://wiki.archlinux.org/title/Microcode)

### Networking
* <x-pkg>`networkmanager`</x-pkg> Easy networking configuration
  * VPN plugins
    * <x-pkg>`networkmanager-openconnect`</x-pkg>
    * <x-pkg>`networkmanager-openvpn`</x-pkg>
    * <x-pkg>`networkmanager-pptp`</x-pkg>
    * <x-pkg>`networkmanager-vpnc`</x-pkg>
* <x-pkg>`openssh`</x-pkg> Provides ssh
* <x-pkg>`iw`</x-pkg> CLI for wireless config

### Base-devel
Packages included in the `base-devl` package group, copy-pasted from https://archlinux.org/groups/x86_64/base-devel/
* <x-pkg>`autoconf`</x-pkg> GNU tool for automatically configuring source code
* <x-pkg>`automake`</x-pkg> GNU tool for automatically creating Makefiles
* <x-pkg>`binutils`</x-pkg> A set of programs to assemble and manipulate binary and object files
* <x-pkg>`bison`</x-pkg> The GNU general-purpose parser generator
* <x-pkg>`fakeroot`</x-pkg> Tool for simulating superuser privileges
* <x-pkg>`file`</x-pkg> File type identification utility
* <x-pkg>`findutils`</x-pkg> GNU utilities to locate files
* <x-pkg>`flex`</x-pkg> A tool for generating text-scanning programs
* <x-pkg>`gawk`</x-pkg> GNU version of awk
* <x-pkg>`gcc`</x-pkg> The GNU Compiler Collection - C and C++ frontends
* <x-pkg>`gettext`</x-pkg> GNU internationalization library
* <x-pkg>`grep`</x-pkg> A string search utility
* <x-pkg>`groff`</x-pkg> GNU troff text-formatting system
* <x-pkg>`gzip`</x-pkg> GNU compression utility
* <x-pkg>`libtool`</x-pkg> A generic library support script
* <x-pkg>`m4`</x-pkg> The GNU macro processor
* <x-pkg>`make`</x-pkg> GNU make utility to maintain groups of programs
* <x-pkg>`pacman`</x-pkg> A library-based package manager with dependency support
* <x-pkg>`patch`</x-pkg> A utility to apply patch files to original sources
* <x-pkg>`pkgconf`</x-pkg> Package compiler and linker metadata toolkit
* <x-pkg>`sed`</x-pkg> GNU stream editor
* <x-pkg>`sudo`</x-pkg> Give certain users the ability to run some commands as root
* <x-pkg>`texinfo`</x-pkg> GNU documentation system for on-line information and printed output
* <x-pkg>`which`</x-pkg> A utility to show the full path of commands

### Shells (more is better 😀)
* <x-pkg>`dash`</x-pkg> Fash POSIX complient sh
* <x-pkg>`bash`</x-pkg> The grandaddy
* <x-pkg>`zsh`</x-pkg> My daily driver
  * <x-pkg>`zsh-completions`</x-pkg> Additional completions
  * <x-pkg>`zsh-autosuggestions`</x-pkg> Fish-like autosuggestions
  * <x-pkg>`zsh-syntax-highlighting`</x-pkg> Fish-like syntax highlighting
* <x-pkg>`fish`</x-pkg> Alternative to zsh
* <x-pkg>`xonsh`</x-pkg> Experimental: python + shell
* <x-pkg>`nushell`</x-pkg> Experimental: Powershell-like structured I/O shell
* <x-pkg>`starship`</x-pkg> Cross-shell easy-to-configure prompt

### Text editor
* <x-pkg>`vi`</x-pkg> The OG
* <x-pkg>`vim`</x-pkg> The classic
* <x-pkg>`neovim`</x-pkg> My daily driver

### Compression/Archive
* <x-pkg>`atool`</x-pkg> Wrapper for varios archive types, provides commands `aunpack` (extract), `apack` (create), `als` (list), `acat` (extract to stdout)
* <x-pkg>`tar`</x-pkg> For `.tar` files
* <x-pkg>`bzip2`</x-pkg> For `.bz2`, `.bz` files
* <x-pkg>`gzip`</x-pkg> For `.gz`, `.z` files
* <x-pkg>`lrzip`</x-pkg> For `.lrz` files
* <x-pkg>`lz4`</x-pkg> For `.lz4` files
* <x-pkg>`lzip`</x-pkg> For `.lz` files
* <x-pkg>`lzop`</x-pkg> For `.lzop` files
* <x-pkg>`xz`</x-pkg> For `.xz`, `.lzma` files
* <x-pkg>`zstd`</x-pkg> For `.zst` files
* <x-pkg>`p7zip`</x-pkg> For `.7z` files
* <x-pkg>`unrar`</x-pkg> For `.rar` files
* <x-pkg>`zip`</x-pkg> & <x-pkg>`unzip`</x-pkg> For `.zip` files

### Low-level utils
* <x-pkg>`pacman-contrib`</x-pkg> Pacman utils `pactree`, `checkupdates`, `rankmirrors`, etc.
* <x-pkg>`ntp`</x-pkg> Network Time Protocol i.e. Clock syncronization
* <x-pkg>`acpi`</x-pkg> CLI for battery, power, and system temp
* <x-pkg>`cpupower`</x-pkg> Adjust/throttle/overclock cpu power
* <x-pkg>`psmisc`</x-pkg> Utils for managing process `pstree`, `killall`, `fuser`, `pidof`, `peekfd`, etc.
* <x-pkg>`man-db`</x-pkg> Provides `man` util
* <x-pkg>`man-pages`</x-pkg> Provides man page contents
* <x-pkg>`less`</x-pkg> Simple pager
* <x-pkg>`most`</x-pkg> Alternative, more feature-rich pager
* <x-pkg>`tree`</x-pkg> List dirs as a tree
* <x-pkg>`bc`</x-pkg> Calculator
* <x-pkg>`libqalculate`</x-pkg> Provides `qalc`, a calculator with unit and currency conversions
* <x-pkg>`ripgrep`</x-pkg> Grep but faster
* <x-pkg>`jq`</x-pkg> Json manipulation from terminal
* <x-pkg>`diffutils`</x-pkg> Commands for diffs and patches
* <x-pkg>`rsync`</x-pkg> Sync files
* <x-pkg>`unison`</x-pkg> Like rsync but better at bi-directional sync
* Modernized utils
  * <x-pkg>`bat`</x-pkg> Prettified `cat`
  * <x-pkg>`lsd`</x-pkg> Prettified `ls`
  * <x-pkg>`dfc`</x-pkg> Prettified `df` (disk-usage)

### Bluetooth
* <x-pkg>`bluez`</x-pkg> Provide bluetooth daemons
* <x-pkg>`bluez-utils`</x-pkg> Provides `bluetoothctl`

### Terminal programs
* <x-pkg>`screenfetch`</x-pkg> Show system & theme info for ricing screenshots
* <x-pkg>`htop`</x-pkg> Task/process manager
* <x-pkg>`ranger`</x-pkg> File manager
* <x-pkg>`speedtest-cli`</x-pkg> Speedtest.net but in the terminal
* <x-pkg>`ffmpeg`</x-pkg> CLI to record screen & audio
* <x-pkg>`fzf`</x-pkg> Fuzzy finder
* <x-pkg>`mdp`</x-pkg> CLI Markdown powerpoint-like tool

### Development tools
* <x-pkg>`wget`</x-pkg> Downloading files
* <x-pkg>`curl`</x-pkg> Downloading files
* <x-pkg>`httpie`</x-pkg> Curl with sane syntax
* <x-pkg>`git`</x-pkg> Version control
* <x-pkg>`gdb`</x-pkg> GNU debugger
* <x-pkg>`npm`</x-pkg> Node package manager
* <x-pkg>`pyenv`</x-pkg> Manage multiple python versions
* <x-pkg>`python-pip`</x-pkg> Pip
* <x-pkg>`python-pipx`</x-pkg> Pipx: For installing pip packages in venvs
* <x-pkg>`shellcheck`</x-pkg> Lint shell scripts
* <x-pkg>`shfmt`</x-pkg>Autoformat shell scripts
* <x-pkg>`aws-cli`</x-pkg> AWS
* <x-pkg>`docker`</x-pkg> and <x-pkg>`docker-compose`</x-pkg> Containers
* <x-pkg>`kubectl`</x-pkg> Kubernetes command line

### Fonts
* <x-pkg>`ttf-dejavu`</x-pkg>
* Google Noto fonts
    * <x-pkg>`noto-fonts`</x-pkg> Wide UTF coverage as ttf fonts
    * <x-pkg>`noto-fonts-cjk`</x-pkg> Chinese, Japanese, Korean fonts
    * <x-pkg>`noto-fonts-emoji`</x-pkg> Emojis
    * <x-pkg>`noto-fonts-extra`</x-pkg> TTF varients

### Desktop environment
* <x-pkg>`sxhkd`</x-pkg> Simple X hotkey daemon for keybindings
* <x-pkg>`qtile`</x-pkg> Window manager
* <x-pkg>`dmenu`</x-pkg> Extensible pop-up typeahead menu
* X11
  * <x-pkg>`xorg-server`</x-pkg> The X graphical server
  * <x-pkg>`xorg-xinit`</x-pkg> Start X server
  * <x-pkg>`xorg-xrdb`</x-pkg> CLI for setting/viewing X server settings, (dpi, font-size etc.)
  * <x-pkg>`xorg-xrandr`</x-pkg> Provides xrandr for managing multiple displays
  * <x-pkg>`xorg-xprop`</x-pkg> Detect window properties
  * <x-pkg>`xorg-xwininfo`</x-pkg> Query info about windows
  * <x-pkg>`xorg-xdpyinfo`</x-pkg> Info about X server
  * <x-pkg>`xorg-xkill`</x-pkg> Utility to kill the window you click
  * <x-pkg>`xorg-xev`</x-pkg> Display pressed keys and mouse movements, good for debugging
  * <x-pkg>`xorg-xfontsel`</x-pkg> Utility for selecting X11 font names
  * <x-pkg>`xorg-xsetroot`</x-pkg> Set X background and cursor
  * <x-pkg>`xwallpaper`</x-pkg> Set the wallpaper
  * <x-pkg>`xclip`</x-pkg> Clipboard commands from terminal
  * <x-pkg>`xdotool`</x-pkg> Automate literally everything
  * <x-pkg>`acpilight`</x-pkg> Provides `xbacklight` to change screen brightness

### File management utils
* MIME types
  * <x-pkg>`xdg-utils`</x-pkg> Various XDG CLI utils `xdg-open`, `xdg-mime`, `xdg-screensaver`
  * <x-pkg>`desktop-file-utils`</x-pkg> Registers pacman hook to build cache database of MIME types
  * <x-pkg>`shared-mime-info`</x-pkg> Registers pacman hook to build the shared MIME-info database cache
* <x-pkg>`trash-cli`</x-pkg> Freedesktop.org Trash spec `trash-put`, `trash-empty`, `trash-list`, `trash-restore`

### File systems
* <x-pkg>`btrfs-progs`</x-pkg> btrfs utils
* <x-pkg>`dosfstools`</x-pkg> dos fs utils
* <x-pkg>`e2fsprogs`</x-pkg> ext3/4/ utils
* <x-pkg>`xfsprogs`</x-pkg> XFS utils
* <x-pkg>`exfat-utils`</x-pkg> exFAT fs utils
* <x-pkg>`f2fs-tools`</x-pkg> Flash-Friendly File System (F2FS) utils -- for NAND SSD, sd cards, etc
* <x-pkg>`jfsutils`</x-pkg> JFS utils
* <x-pkg>`mtpfs`</x-pkg> FUSE that supports MTP devices
* <x-pkg>`nfs-utils`</x-pkg> Network File System
* <x-pkg>`ntfs-3g`</x-pkg> NTFS utils
* <x-pkg>`reiserfsprogs`</x-pkg> ReiserFS utils

### Drivers
* <x-pkg>`xf86-input-elographics`</x-pkg> Elographics touchscreen
* <x-pkg>`xf86-input-synaptics`</x-pkg> Laptop touchpads
* <x-pkg>`xf86-input-evdev`</x-pkg> Generic event devices (all inputs the kernel knows about)
* <x-pkg>`xf86-input-wacom`</x-pkg> Wacom tablets
* <x-pkg>`xf86-video-intel`</x-pkg> Intel graphics
* <x-pkg>`xf86-video-amdgpu`</x-pkg> AMD graphics
* <x-pkg>`nvidia`</x-pkg> NVIDIA drivers
* <x-pkg>`nvidia-settings`</x-pkg> GUI for NVIDIA driver settings

### Audio
* <x-pkg>`pipewire`</x-pkg> Sound system replaces PulseAudio and JACK
  * <x-pkg>`pipewire-docs`</x-pkg> Docs
  * <x-pkg>`pipewire-alsa`</x-pkg> Route ALSA to pipewire
  * <x-pkg>`pipewire-pulse`</x-pkg> Route PulseAudio to pipewire
  * <x-pkg>`pipewire-jack`</x-pkg> Route JACK to pipewire
* <x-pkg>`helvum`</x-pkg> Pipewire Patchbay
* <x-pkg>`wireplumber`</x-pkg> TODO figure out what this is
* <x-pkg>`easyeffects`</x-pkg> Audio effects for pipwire
* <x-pkg>`pamixer`</x-pkg> CLI commands for volume control
* <x-pkg>`pulsemixer`</x-pkg> TUI volume mixer

### Graphical programs
* <x-pkg>`kitty`</x-pkg> Terminal emulator of choice
* <x-pkg>`arandr`</x-pkg> Graphical xrandr, for setting screen layouts
* <x-pkg>`xdot`</x-pkg> Graphical viewer of Graphviz dot files
* <x-pkg>`zathura`</x-pkg> Document viewer
  * <x-pkg>`zathura-pdf-mupdf`</x-pkg> PDF, ePub, OpenXPS support
* <x-pkg>`firefox`</x-pkg> Web browerser of choice
* <x-pkg>`chromium`</x-pkg> Fallback browser if the others don't work
* <x-pkg>`vlc`</x-pkg> Video/audio player supporting many file types
* <x-pkg>`feh`</x-pkg> Image viewer
* <x-pkg>`xdot`</x-pkg> Graphviz viewer
* <x-pkg>`piper`</x-pkg> GUI to configure mice (uses ratbagd daemon under hood)
