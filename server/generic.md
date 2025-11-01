# 1. Partitioning

## disk layout

#### physical volume
| disk | partition | type              | luks  | lvm   | label    | size      | format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- | --------- | ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     | 320M      | fat 32 | /boot                      |
| 0    | 2         | linux server data | true  | false | keys     | 256M      | luks   | none                       |
| 0    | 3         | linux file system | true  | true  | proc     | 22G       | luks   | see logical layout point 1 |
| 0    | 4         | linux server data | true  | true  | data     | 100% Free | luks   | see logical layout point 1 |


#### disk group
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


## procedure

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

### create logical volume

```
pvcreate /dev/mapper/proc
```

```
vgcreate proc /dev/mapper/proc
```

```
lvcreate -L 10G proc -n root
```

```
lvcreate -L 3.5G proc -n ubin
```

```
lvcreate -L 2.5G proc -n temp
```

```
lvcreate -L 2G proc -n ipcv
```

```
lvcreate -L 10G proc -n vda0
```

```
lvcreate -L 5G proc -n vars
```

```
lvcreate -L 5G proc -n vlog
```

```
lvcreate -L 1G proc -n vaud
```

```
lvcreate -L 2.5G proc -n vtmp
```

```
lvcreate -L 5G proc -n vpac
```

```
lvcreate -L 512M proc -n ring
```

```
lvcreate -L 5G proc -n home
```

### format partition
```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```

```
mkfs.ext4 -b 4096 /dev/proc/root
```

```
mkfs.ext4 -b 4096 /dev/proc/ubin
```

```
mkfs.ext4 -b 4096 /dev/proc/temp
```


```
mkfs.ext4 -b 4096 /dev/proc/ipcv
```

```
mkfs.ext4 -b 4096 /dev/proc/vda0
```

```
mkfs.ext4 -b 4096 /dev/proc/vars
```

```
mkfs.ext4 -b 4096 /dev/proc/vlog
```

```
mkfs.ext4 -b 4096 /dev/proc/vaud
```

```
mkfs.ext4 -b 4096 /dev/proc/vtmp
```

```
mkfs.ext4 -b 4096 /dev/proc/vpac
```

```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```

```
mkfs.ext4 -b 4096 /dev/proc/home
```

#### mount partition

root
```
mount /dev/proc/root /mnt
```

boot
```
mkdir /mnt/boot
```

```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot
```

ubin
```
mkdir /mnt/dev
```
```
mkdir /mnt/dev/swap
```
```
mount -o rw,nodev,nosuid,relatime /dev/proc/ubin /mnt/dev/swap
```

temp
```
mkdir /mnt/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/temp /mnt/tmp
```

ipcv
```
mkdir /mnt/dev/shm
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/ipcv /mnt/dev/shm
```

vda0
```
mkdir /mnt/dev/vda0
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vda0 /mnt/dev/vda0
```

var
```
mkdir /mnt/var
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vars /mnt/var
```

vlog
```
mkdir /mnt/var/log
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vlog /mnt/var/log
```

vaud
```
mkdir /mnt/var/log/audit
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vaud /mnt/var/log/audit
```

vtmp
```
mkdir /mnt/var/tmp
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vtmp /mnt/var/tmp
```

vpac
```
mkdir /mnt/var/cache
```

```
mkdir /mnt/var/cache/pacman
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```

home
```
mkdir /mnt/home
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/home /mnt/home
```

