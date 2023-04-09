# GRUB config

For reference on what values are available in `/etc/default/grub` see here: https://www.gnu.org/software/grub/manual/grub/grub.html#Simple-configuration

### os-prober

For `os-prober` to be able to discover other operating systems, their boot partitions will need to be mounted

```
mount /dev/nvme0n1p1 /mnt/windowsboot
os-prober # Verify os-prober can find them
grub-mkconfig -o /boot/grub/grub.cfg
```

### Update font & font size

See basic reference here: https://blog.wxm.be/2014/08/29/increase-font-in-grub-for-high-dpi.html

```
# Install necesary dep for grub-mkfont
pacman -S --asdep freetype2
# Install a ttf source font
pacman -S ttf-dejavu

# Create a GRUB-compatible bitmap font
grub-mkfont --output=/boot/grub/fonts/DejaVuSansMono36.pf2 --size=36 /user/share/fonts/TTF/DejaVuSansMono.ttf

# Add to /etc/default/grub
GRUB_FONT=/boot/grub/fonts/DejaVuSansMono36.pf2
```

### Save last selected default on reboot
```
# Add to /etc/default/grub
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
```

### Set autoselect timeout to 2 seconds instead of default of 5
```
# Add to /etc/default/grub
GRUB_TIMEOUT=2
```
