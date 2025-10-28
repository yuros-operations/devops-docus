```
pacstrap /mnt base base-devel neovim lvm2 openssh polkit git pv iptables-nft iwd ethtool
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
