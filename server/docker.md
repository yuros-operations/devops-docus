# 1. Partitioning
```
lvcreate -l100%FREE data -n dock
```
```
mkfs.btrfs /dev/data/dock
```
```
mkdir -p /mnt/var/lib/docker
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/data/dock /mnt/var/lib/docker
```
jika sudah terinstall
```
mkdir -p /var/lib/docker
```
