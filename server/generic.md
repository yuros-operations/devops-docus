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
lvcreate -L 5G proc -n root
```

```
lvcreate -L 2G proc -n libs
```

```
lvcreate -L 1G proc -n game
```

```
lvcreate -L 2G proc -n temp
```

```
lvcreate -L 3G proc -n vars
```

```
lvcreate -L 2G proc -n vlog
```

```
lvcreate -L 1G proc -n vaud
```

```
lvcreate -L 512M proc -n vtmp
```

```
lvcreate -L 2G proc -n vpac
```

```
lvcreate -L 512M proc -n ring
```

```
lvcreate -l100%FREE proc -n home
```
### preparation

#### root

```
mkfs.ext4 -b 4096 /dev/proc/root
```
```
mount /dev/proc/root /mnt
```

#### boot
```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```
```
mkdir /mnt/boot
```
```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot
```

#### temp
```
mkfs.ext4 -b 4096 /dev/proc/temp
```
```
mkdir /mnt/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/temp /mnt/tmp
```

#### vars
```
mkfs.ext4 -b 4096 /dev/proc/vars
```
```
mkdir /mnt/var
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vars /mnt/var
```

#### libs
```
mkfs.ext4 -b 4096 /dev/proc/libs
```
```
mkdir /mnt/var/usr
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/libs /mnt/var/usr
```

#### game
```
mkfs.ext4 -b 4096 /dev/proc/game
```
```
mkdir /mnt/var/games
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/game /mnt/var/games
```

#### vlog
```
mkfs.ext4 -b 4096 /dev/proc/vlog
```
```
mkdir /mnt/var/log
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vlog /mnt/var/log
```

#### vaud
```
mkfs.ext4 -b 4096 /dev/proc/vaud
```
```
mkdir /mnt/var/log/audit
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vaud /mnt/var/log/audit
```
#### vtmp
```
mkfs.ext4 -b 4096 /dev/proc/vtmp
```
```
mkdir /mnt/var/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vtmp /mnt/var/tmp
```
#### vpac
```
mkfs.ext4 -b 4096 /dev/proc/vpac
```
```
mkdir /mnt/var/cache
```
```
mkdir /mnt/var/cache/pacman
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```
#### ring
```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```
#### home
```
mkfs.ext4 -b 4096 /dev/proc/home
```
```
mkdir /mnt/home
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/home /mnt/home
```

