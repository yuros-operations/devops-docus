### physical volume
| disk | partition | type              | luks  | lvm   | label    | size      | format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- | --------- | ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     | 320M      | fat 32 | /boot                      |
| 0    | 2         | linux file system | true  | false | keys     | 512M      | luks   | none                       |
| 0    | 3         | linux file system | true  | true  | lvm_root | 53.1G       | luks   | see logical layout point 1 |
| 0    | 4         | linux file system | true  | true  | lvm_data | 100% Free | luks   | see logical layout point 1 |
| -    | -         | tmpfs             | false | false | -        | -         | tmpfs  | /tmp                       |
#### root disk group

| partition | list | group | name | size | mount              | format |
| --------- | ---- | ----- | ---- | ---- | ------------------ | ------ |
| 2         | 1    | srv   | root | 25G   | /mnt               | ext4   |
| 2         | 2    | srv   | vars | 5G   | /mnt/var/          | ext4   |
| 2         | 3    | srv   | vtmp | 5G | /mnt/var/tmp/      | ext4   |
| 2         | 4    | srv   | vlog | 5G   | /mnt/var/log/      | ext4   |
| 2         | 5    | srv   | vaud | 5G | /mnt/var/log/audit | ext4   |
| 2         | 6    | srv   | swap | 100%FREE   | swap               | swap   |

## guidline
---
#### disk encrypt
```
cryptsetup luksFormat /dev/nvme0n1p2
```

```
cryptsetup luksFormat /dev/nvme0n1p3
```

```
cryptsetup luksFormat /dev/nvme0n1p4
```

```
cryptsetup luksOpen /dev/nvme0n1p3 lvm_root
```

```
cryptsetup luksOpen /dev/nvme0n1p4 lvm_data
```

#### logical volume
system
```
pvcreate /dev/mapper/lvm_root
```

```
vgcreate srv /dev/mapper/lvm_root
```

```
lvcreate -L 25G srv -n root
```

```
lvcreate -L 5G srv -n vars
```

```
lvcreate -L 5G srv -n vtmp
```

```
lvcreate -L 5G srv -n vlog
```

```
lvcreate -L 5G srv -n vaud
```

```
lvcreate -l 100%FREE srv -n swap
```

data

```
pvcreate /dev/mapper/lvm_data
```

```
vgcreate data /dev/mapper/lvm_data
```

```
lvcreate -L 50G data -n home
```



#### storage format
system

```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```

```
mkfs.ext4 -b 4096 /dev/srv/root
```

```
mkfs.ext4 -b 4096 /dev/srv/vars
```

```
mkfs.ext4 -b 4096 /dev/srv/vtmp
```

```
mkfs.ext4 -b 4096 /dev/srv/vlog
```

```
mkfs.ext4 -b 4096 /dev/srv/vaud
```

```
mkswap /dev/srv/swap
```

data

```
mkfs.ext4 -b 4096 /dev/data/home
```



#### mount partition

root
```
mount /dev/srv/root /mnt
```

boot
```
mkdir /mnt/boot
```

```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot
```

var
```
mkdir /mnt/var
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/srv/vars /mnt/var
```

vtmp
```
mkdir /mnt/var/tmp
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/srv/vtmp /mnt/var/tmp
```

vlog
```
mkdir /mnt/var/log
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/srv/vlog /mnt/var/log
```

vaud
```
mkdir /mnt/var/log/audit
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/srv/vaud /mnt/var/log/audit
```

swap
```
swapon /dev/srv/swap
```

home
```
mkdir /mnt/home
```

```
mount /dev/data/home /mnt/home
```
