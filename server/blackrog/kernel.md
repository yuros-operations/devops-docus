## installation

```
yes | pacman -S linux-hardened linux-firmware mkinitcpio intel-ucode tang clevis mkinitcpio-nfs-utils libpwquality luksmeta git --noconfirm
```



## configuration

### prepare boot directory

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
touch /etc/cmdline.d/{01-boot.conf,02-mods.conf,03-secs.conf,04-perf.conf,05-misc.conf,06-nets.conf}
```

```
echo "cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p3):lvm_root root=/dev/srv/root" > /etc/cmdline.d/01-boot.conf
```

```
echo "data UUID=$(blkid -s UUID -o value /dev/nvme0n1p4) none" >> /etc/crypttab
```

```
echo "intel_iommu=on i915.fastboot=1" > /etc/cmdline.d/02-mods.conf
```


###  configure initramfs

```
echo "#blackrog initrams" > /etc/mkinitcpio.d/blackrog.conf
```

```
export CPIOHOOK="base udev autodetect microcode modconf kms keyboard net clevis encrypt lvm2 block filesystems fsck"
```

```
export CPIOMODS="vfio_pci vfio vfio_iommu_type1"
```

```
export CPIOBINS="/usr/bin/curl"
```

```
printf "MODULES=($CPIOMODS)\nBINARIES=($CPIOBINS)\nFILES=()\nHOOKS=($CPIOHOOK)" >> /etc/mkinitcpio.d/blackrog.conf 
```


### configure linux preset

```
echo "#blackrog linux preset" > /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo 'ALL_config="/etc/mkinitcpio.d/blackrog.conf"' >> /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo 'ALL_kver="/boot/kernel/vmlinuz-linux-hardened"' >> /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo "PRESETS=('default')" >> /etc/mkinitcpio.d/linux-hardened.preset
```

```
echo 'default_uki="/boot/efi/linux/blackrog.efi"' >> /etc/mkinitcpio.d/linux-hardened.preset
```


### generate efi files

```
mkinitcpio -P
```

