```
pacstrap /mnt base base-devel neovim lvm2 openssh polkit ethtool iptables-nft dnsmasq
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
