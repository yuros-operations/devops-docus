### physical volume
| disk | partition | type              | luks  | lvm   | label    |  format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- |  ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     |  fat 32 | /boot                      |
| 0    | 2         | linux file system | true  | false | keys     |  luks   | none                       |
| 0    | 3         | linux root (x86_64) | true  | true  | lvm_root |  luks   | see logical layout point 1 |
| 0    | 4         | linux home        | true  | true  | lvm_data |  luks   | see logical layout point 1 |


#### root disk group
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


##### minimal

boot = 320M  
vars = 5G  
root = 13G  
opts = 10G  
vlog = 1G  
vaud = 512M  
vpac = 2G  
temp = 2G  
ring = 512M  
vtmp = 2G


#### data disk group
| partition | list | group | name |  mount                       | format |
| --------- | ---- | ----- | ---- | ---------------------------- | ------ |
| 2         | 1    | data  | home |  /mnt/home                   | ext4   |


## guideline
---


#### disk encrypt

```
cryptsetup luksFormat --sector-size=4096  /dev/partisi keys
```

```
cryptsetup luksFormat --sector-size=4096 /dev/partisi root
```

```
cryptsetup luksFormat --sector-size=4096 /dev/partisi data
```

```
cryptsetup luksOpen /dev/partisi proc
```

```
cryptsetup luksOpen /dev/partisi data
```

#### logical volume
system

```
pvcreate /dev/mapper/proc 
```

```
vgcreate proc /dev/mapper/proc
```

```
lvcreate -L [ size in G | M ] proc -n root
```

```
lvcreate -L [ size in G | M ] proc -n opts
```

```
lvcreate -L [ size in G | M ] proc -n vars
```

```
lvcreate -L [ size in G | M ] proc -n vlog
```

```
lvcreate -L [ size in G | M ] proc -n vaud
```

```
lvcreate -L [ size in G | M ] proc -n vpac
```

```
lvcreate -L [ size in G | M ] proc -n ring
```

```
lvcreate -L [ size in G | M ] proc -n temp
```

```
lvcreate -l 100%FREE proc -n vtmp
```

data

```
pvcreate /dev/mapper/data
```

```
vgcreate data /dev/mapper/data
```

```
lvcreate -l100%FREE data -n home
```


#### storage format
system

```
mkfs.vfat -F32 -S 4096 -n BOOT [ partition path ]
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

```
cryptsetup luksOpen /dev/proc/ring proc_keys
```

```
mkfs.ext4 -b 4096 /dev/mapper/proc_keys
```

data

```
mkfs.ext4 -b 4096 /dev/data/home
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
mount -o uid=0,gid=0,fmask=0077,dmask=0077 [ path boot partition ] /mnt/boot
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
mkdir -p /mnt/var/cache/pacman
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
