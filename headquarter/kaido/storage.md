### physical volume
| disk | partition | type              | luks  | lvm   | label    | size      | format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- | --------- | ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     | 320M      | fat 32 | /boot                      |
| 0    | 2         | linux file system | true  | false | keys     | 580M      | luks   | none                       |
| 0    | 3         | linux file system | true  | true  | lvm_root | 53G       | luks   | see logical layout point 1 |
| 0    | 4         | linux file system | true  | true  | lvm_data | 100% Free | luks   | see logical layout point 1 |

#### root disk group

| partition | list | group | name | size | mount                    | format |
| --------- | ---- | ----- | ---- | ---- | -------------------------| ------ |
| 2         | 1    | proc  | root | 20G  | /mnt                     | ext4   |
| 2         | 2    | proc  | opts | 15G  | /mnt/opt                 | ext4   |
| 2         | 3    | proc  | vars | 8G   | /mnt/var                 | ext4   |
| 2         | 4    | proc  | vlog | 1G   | /mnt/var/log             | ext4   |
| 2         | 5    | proc  | vaud | 512M | /mnt/var/log/audit       | ext4   |
| 2         | 6    | proc  | vpac | 3G   | /mnt/var/cache/pacman    | ext4   |
| 2         | 7    | proc  | ring | 1G   |                          | ext4   |
| 2         | 8    | proc  | temp | 2G   | /mnt/tmp                 | ext4   |
| 2         | 9    | proc  | vtmp | 100%FREE    | /mnt/var/tmp      | ext4   |

#### data disk group

| partition | list | group | name | size     | mount                       | format |
| --------- | ---- | ----- | ---- | -------- | ----------------------------| ------ |
| 2         | 1    | data  | home | 34G      | /mnt/home                   | ext4   |
| 2         | 2    | data  | devs | 50G      | /mnt/home/devel             | ext4   |
| 2         | 3    | data  | srvc | 5G       | /mnt/srv/http               | ext4   |
| 2         | 4    | data  | host | 100%FREE | /mnt/var/lib/libvirt/images | xfs    |

## guidline
---
#### disk encrypt
```
cryptsetup luksFormat --sector-size=4096  /dev/nvme0n1p2
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p3
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p4
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
vgcreate proc /dev/mapper/lvm_root
```

```
lvcreate -L 20G proc -n root
```

```
lvcreate -L 15G proc -n opts
```

```
lvcreate -L 8G proc -n vars
```

```
lvcreate -L 1G proc -n vlog
```

```
lvcreate -L 512M proc -n vaud
```

```
lvcreate -L 3G proc -n vpac
```

```
lvcreate -L 1G proc -n ring
```

```
lvcreate -L 2G proc -n temp
```

```
lvcreate -l 100%FREE proc -n vtmp
```

data

```
pvcreate /dev/mapper/lvm_data
```

```
vgcreate data /dev/mapper/lvm_data
```

```
lvcreate -L 34G data -n home
```

```
lvcreate -L 50G data -n devs
```

```
lvcreate -L 5G data -n srvc
```

```
lvcreate -l100%FREE data -n host
```

#### storage format
system

```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```

```
mkfs.ext4 -b 4096 /dev/proc/root
```

```
mkfs.ext4 -b 4096 /dev/proc/opts
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
mkfs.ext4 -b 4096 /dev/proc/vpac
```

```
mkfs.ext4 -b 4096 /dev/proc/temp
```

```
mkfs.ext4 -b 4096 /dev/proc/vtmp
```

```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```

data

```
mkfs.ext4 -b 4096 /dev/data/home
```

```
mkfs.ext4 -b 4096 /dev/data/devs
```

```
mkfs.ext4 -b 4096 /dev/data/srvc
```

```
mkfs.xfs -s size=4096 /dev/data/host
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

opt
```
mkdir /mnt/opt
```

```
mount -o rw,nodev,nosuid,relatime /dev/proc/opts /mnt/opt
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

temp
```
mkdir /mnt/tmp
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/temp /mnt/tmp
```

vtmp
```
mkdir /mnt/var/tmp
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vtmp /mnt/var/tmp
```

home
```
mkdir /mnt/home
```

```
mount -o rw,nodev,noexec,nosuid,relatime /dev/data/home /mnt/home
```

devs
```
mkdir /mnt/home/devel
```

```
mount -o rw,nodev,nosuid,relatime /dev/data/devs /mnt/home/devel
```

srvc
```
mkdir /mnt/srv
```
```
mkdir /mnt/srv/http
```

```
mount -o rw,nodev,nosuid,noexec,relatime /dev/data/srvc /mnt/srv/http
```


host
```
mkdir /mnt/var/lib
```
```
mkdir /mnt/var/lib/libvirt
```
```
mkdir /mnt/var/lib/libvirt/images
```
```
mount -o rw,nosuid,nodev,noexec,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota /dev/data/host /mnt/var/lib/libvirt/images
```

