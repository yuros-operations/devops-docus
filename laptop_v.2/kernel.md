## installation
### for intel
```
yes | pacman -S linux-hardened linux-firmware mkinitcpio intel-ucode libpwquality cracklib less bubblewrap-suid reflector
```
### for amd

```
yes | pacman -S linux-hardened linux-firmware mkinitcpio amd-ucode libpwquality cracklib less bubblewrap-suid 
```



## configuration

### prepare boot directory for intel

```
rm /boot/initramfs-linux-hardened*
```

```
mkdir /boot/efi /boot/efi/linux /boot/efi/systemd /boot/efi/rescue /boot/efi/boot
```

```
mkdir /boot/kernel
```

```
mv /boot/intel-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel
```

### prepare boot directory for amd

```
rm /boot/initramfs-linux-hardened*
```

```
mkdir /boot/efi /boot/efi/linux /boot/efi/systemd /boot/efi/rescue /boot/efi/boot /boot/kernel
```

```
mv /boot/amd-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel
```


**[-] install boot path**

```
bootctl --path=/boot install
```



###  prepare initram directory

```
rm -fr /etc/mkinitcpio.conf.d
```

```
mv /etc/mkinitcpio.conf /etc/mkinitcpio.d/default
```

```
mv /etc/mkinitcpio.d/linux-hardened.preset /etc/mkinitcpio.d/default-hardened-preset
```


### configure kernel parameter

```
mkdir /etc/cmdline.d
```

```
touch /etc/cmdline.d/{01-boot.conf,02-mods.conf,03-secs.conf,04-perf.conf,05-misc.conf}
```

```
echo "rd.luks.uuid=$(blkid -s UUID -o value /dev/partisi_root) root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf
```

```
echo "data UUID=$(blkid -s UUID -o value /dev/partisi_data) none" >> /etc/crypttab
```

```
echo "ipv6.disable=1" > /etc/cmdline.d/04-perf.conf
```

```
echo "rw quiet" > /etc/cmdline.d/05-misc.conf
```


###  configure initramfs

```
echo "#blackbird initrams" > /etc/mkinitcpio.d/blackbird.conf
```

```
export CPIOHOOK="base systemd autodetect microcode modconf kms keyboard sd-vconsole sd-encrypt lvm2 block filesystems fsck"
```

```
printf "MODULES=()\nBINARIES=()\nFILES=()\nHOOKS=($CPIOHOOK)" >> /etc/mkinitcpio.d/blackbird.conf 
```
```
touch /etc/vconsole.conf
```


### configure linux preset

```
echo "#blackbird linux preset" > /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo 'ALL_config="/etc/mkinitcpio.d/blackbird.conf"' >> /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo 'ALL_kver="/boot/kernel/vmlinuz-linux-hardened"' >> /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo "PRESETS=('default')" >> /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo 'default_uki="/boot/efi/linux/blackbird.efi"' >> /etc/mkinitcpio.d/linux-hardened.preset
```


### generate efi files

```
mkinitcpio -P
```

