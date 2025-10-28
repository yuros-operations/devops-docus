```
pacstrap /mnt base base-devel vim lvm2 openssh polkit git iptables-nft iwd ethtool 
```
```
mkdir /mnt/var/lib/iwd
```
```
cp /var/lib/iwd/*.psk /mnt/var/lib/iwd
```

```
cp /etc/systemd/network/* /mnt/etc/systemd/network/
```

```
genfstab -U /mnt > /mnt/etc/fstab
```

```
arch-chroot /mnt
```
