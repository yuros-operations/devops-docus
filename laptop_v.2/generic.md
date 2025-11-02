# 1. Partitioning

## physical volume

### disk layout
| disk | partition | type              | luks  | lvm   | label    |  format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- |  ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     |  fat 32 | /boot                      |
| 0    | 2         | linux file system | true  | false | keys     |  luks   | none                       |
| 0    | 3         | linux root (x86_64) | true  | true  | proc |  luks   | see logical layout point 1 |
| 0    | 4         | linux home        | true  | true  | data |  luks   | see logical layout point 1 |

gunakan cfdisk untuk membuat physical volume sesuai dengan guide line

### disk encryption
```
cryptsetup luksFormat --sector-size=4096 /dev/partisi_keys
```

```
cryptsetup luksFormat --sector-size=4096 /dev/partisi_root
```

```
cryptsetup luksFormat --sector-size=4096 /dev/partisi_data
```

```
cryptsetup luksOpen /dev/partisi_root proc
```

```
cryptsetup luksOpen /dev/partisi_data data
```

## logical volume

### disk layout root
| partition | list | group | name |  mount                    | format |
| --------- | ---- | ----- | ---- |  -------------------------| ------ |
| 2         | 1    | proc  | root |  /mnt                     | ext4   |
| 2         | 2    | proc  | opts |  /mnt/opt                 | ext4   |
| 2         | 3    | proc  | vars |  /mnt/var                 | ext4   |
| 2         | 4    | proc  | vlog |  /mnt/var/log             | ext4   |
| 2         | 5    | proc  | vaud |  /mnt/var/log/audit       | ext4   |
| 2         | 6    | proc  | vpac |  /mnt/var/cache/pacman    | ext4   |
| 2         | 7    | proc  | ring |                           | ext4   |
| 2         | 8    | proc  | temp |  /mnt/tmp                 | ext4   |
| 2         | 9    | proc  | vtmp |  /mnt/var/tmp             | ext4   |

#### data disk group
| partition | list | group | name |  mount                       | format |
| --------- | ---- | ----- | ---- | ---------------------------- | ------ |
| 2         | 1    | data  | home |  /mnt/home                   | ext4   |

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
vgcreate data /dev/mapper/data
```

### root
```
lvcreate -L [ size in G | M ] proc -n root
```
```
mkfs.ext4 -b 4096 /dev/proc/root
```
```
mount /dev/proc/root /mnt
```
### boot
```
mkfs.vfat -F32 -S 4096 -n BOOT [ partition path ]
```
```
mkdir /mnt/boot
```
```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 [ path boot partition ] /mnt/boot
```
### opts
```
lvcreate -L [ size in G | M ] proc -n opts
```
```
mkfs.ext4 -b 4096 /dev/proc/opts
```
```
mkdir /mnt/opt
```
```
mount -o rw,nodev,nosuid,relatime /dev/proc/opts /mnt/opt
```
### vars
```
lvcreate -L [ size in G | M ] proc -n vars
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
### vlog
```
lvcreate -L [ size in G | M ] proc -n vlog
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
lvcreate -L [ size in G | M ] proc -n vaud
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
### vpac
```
lvcreate -L [ size in G | M ] proc -n vpac
```
```
mkfs.ext4 -b 4096 /dev/proc/vpac
```
```
mkdir -p /mnt/var/cache/pacman
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```
### ring
```
lvcreate -L [ size in G | M ] proc -n ring
```
```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```
```
cryptsetup luksOpen /dev/proc/ring proc_keys
```
```
mkfs.ext4 -b 4096 /dev/mapper/proc_keys
```
### temp
```
lvcreate -L [ size in G | M ] proc -n temp
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
### vtmp
```
lvcreate -l 100%FREE proc -n vtmp
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
### home
```
lvcreate -l100%FREE data -n home
```
```
mkfs.ext4 -b 4096 /dev/data/home
```
```
mkdir /mnt/home
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/data/home /mnt/home
```
# 2. instalation package
for intel
```
pacstrap /mnt base base-devel neovim lvm2 openssh polkit git iptables-nft iwd ethtool linux-hardened linux-firmware mkinitcpio intel-ucode libpwquality cracklib less bubblewrap-suid reflector
```
for amd
```
pacstrap /mnt base base-devel neovim lvm2 openssh polkit git iptables-nft iwd ethtool linux-hardened linux-firmware mkinitcpio amd-ucode libpwquality cracklib less bubblewrap-suid reflector
```
### network configuration
```
mkdir /mnt/var/lib/iwd
```
```
cp /var/lib/iwd/*.psk /mnt/var/lib/iwd
```
```
cp /etc/systemd/network/* /mnt/etc/systemd/network/
```
### fstab
```
genfstab -U /mnt > /mnt/etc/fstab
```
### chrooting
```
arch-chroot /mnt
```



