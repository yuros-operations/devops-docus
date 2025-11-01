# 1. Partitioning

## physical volume

### disk layout
| disk | partition | type              | luks  | lvm   | label    | size      | format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- | --------- | ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     | 320M      | fat 32 | /boot                      |
| 0    | 2         | linux server data | true  | false | keys     | 256M      | luks   | none                       |
| 0    | 3         | linux file system | true  | true  | proc     | 22G       | luks   | see logical layout point 1 |
| 0    | 4         | linux server data | true  | true  | data     | 100% Free | luks   | see logical layout point 1 |

gunakan cfdisk untuk membuat physical volume sesuai dengan guide line

### disk encryption
```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p2
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p3
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p4
```

```
cryptsetup luksOpen /dev/nvme0n1p3 proc
```

```
cryptsetup luksOpen /dev/nvme0n1p4 data
```

## logical volume

### disk layout
| partition | list | group  | name | size | mount                 | format |
| --------- | ---- | ------ | ---- | ---- | --------------------- | ------ |
| 2         | 1    | proc   | root | 5G   | /mnt                  | ext4   |
| 2         | 3    | proc   | temp | 2G   | /mnt/tmp              | ext4   |
| 2         | 5    | proc   | vars | 3G   | /mnt/var              | ext4   |
| 2         | 2    | proc   | libs | 2G   | /mnt/var/usr/         | ext4   |
| 2         | 2    | proc   | game | 1G   | /mnt/var/games/       | ext4   |
| 2         | 6    | proc   | vlog | 2G   | /mnt/var/log/         | ext4   |
| 2         | 7    | proc   | vaud | 1G   | /mnt/var/log/audit    | ext4   |
| 2         | 8    | proc   | vtmp | 512M | /mnt/var/tmp/         | ext4   |
| 2         | 9    | proc   | vpac | 2G   | /mnt/var/cache/pacman | ext4   |
| 2         | 10   | proc   | ring | 512M |                       | luks   |
| 2         | 11   | proc   | home | 100% | /mnt/home             | ext4   |

```
pvcreate /dev/mapper/proc
```
```
vgcreate proc /dev/mapper/proc
```
```
pvcreate /dev/mapper/data
```
```
vgcreate proc /dev/mapper/data
```
### root
```
lvcreate -L 5G proc -n root
```
```
mkfs.ext4 -b 4096 /dev/proc/root
```
```
mount /dev/proc/root /mnt
```

### boot
```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```
```
mkdir /mnt/boot
```
```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot
```

### temp
```
lvcreate -L 2G proc -n temp
```
```
mkfs.ext4 -b 4096 /dev/proc/temp
```
```
mkdir /mnt/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/temp /mnt/tmp
```

### vars
```
lvcreate -L 3G proc -n vars
```
```
mkfs.ext4 -b 4096 /dev/proc/vars
```
```
mkdir /mnt/var
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vars /mnt/var
```

### libs
```
lvcreate -L 2G proc -n libs
```
```
mkfs.ext4 -b 4096 /dev/proc/libs
```
```
mkdir /mnt/var/usr
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/libs /mnt/var/usr
```

### game
```
lvcreate -L 1G proc -n game
```
```
mkfs.ext4 -b 4096 /dev/proc/game
```
```
mkdir /mnt/var/games
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/game /mnt/var/games
```

### vlog
```
lvcreate -L 2G proc -n vlog
```
```
mkfs.ext4 -b 4096 /dev/proc/vlog
```
```
mkdir /mnt/var/log
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vlog /mnt/var/log
```

### vaud
```
lvcreate -L 1G proc -n vaud
```
```
mkfs.ext4 -b 4096 /dev/proc/vaud
```
```
mkdir /mnt/var/log/audit
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vaud /mnt/var/log/audit
```
### vtmp
```
lvcreate -L 512M proc -n vtmp
```
```
mkfs.ext4 -b 4096 /dev/proc/vtmp
```
```
mkdir /mnt/var/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vtmp /mnt/var/tmp
```
### vpac
```
lvcreate -L 2G proc -n vpac
```
```
mkfs.ext4 -b 4096 /dev/proc/vpac
```
```
mkdir -p /mnt/var/cache /mnt/var/cache/pacman
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```
### ring
```
lvcreate -L 512M proc -n ring
```
```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```
```
cryptsetup luksOpen /dev/proc/ring lvm_keys
```
```
mkfs.ext4 -b 4096 /dev/mapper/lvm_keys
```
### home
```
lvcreate -l100%FREE proc -n home
```
```
mkfs.ext4 -b 4096 /dev/proc/home
```
```
mkdir /mnt/home
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/home /mnt/home
```
# 2.packages

## intel server
```
pacstrap /mnt linux-hardened linux-firmware mkinitcpio intel-ucode tang clevis mkinitcpio-nfs-utils luksmeta libpwquality cracklib git base neovim lvm2 btrfs-progs openssh polkit ethtool iptables-nft firewalld apparmor rsync --noconfirm
```
## amd server
```
pacstrap /mnt linux-hardened linux-firmware mkinitcpio amd-ucode tang clevis mkinitcpio-nfs-utils luksmeta libpwquality cracklib git base neovim lvm2 btrfs-progs openssh polkit ethtool iptables-nft firewalld apparmor rsync --noconfirm
```
# 3. config
```
cp /etc/systemd/network/* /mnt/etc/systemd/network/
```

```
genfstab -U /mnt > /mnt/etc/fstab
```

```
arch-chroot /mnt
```
### local time

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

```
hwclock --systohc
```

### hosts

```
echo 'nama_hostname' > /etc/hostname
```

```
echo "127.0.0.1        localhost" > /etc/hosts
```

```
echo "127.0.0.1        hostname" >> /etc/hosts
```

```
printf "\n\n" >> /etc/hosts
```

```
echo "::1              localhost ip6-localhost ip6-loopback" >> /etc/hosts
```

```
echo "ff02::1          ip6-allnodes" >> /etc/hosts
```

```
echo "ff02::2          ip6-allroutes" >> /etc/hosts
```


### locale

```
printf "en_US.UTF-8 UTF-8\n en_US ISO-8859-1" >> /etc/locale.gen
```

```
locale-gen && locale > /etc/locale.conf
```

```
sed -i '1s/.*/LANG=en_US.UTF-8/' /etc/locale.conf
```


### user

```
echo 'lektor ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
```

```
useradd -m lektor
```

```
usermod -aG wheel lektor
```

```
echo "1511" | passwd lektor --stdin
```

```
passwd -l root
```
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
echo "cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p3):proc root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf
```

```
echo "data UUID=$(blkid -s UUID -o value /dev/nvme0n1p4) none" >> /etc/crypttab
```
```
echo "ipv6.disable=1" > /etc/cmdline.d/04-perf.conf
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
