### Mount hardisk external

```
mount /dev/sda1 /mnt
```
### Generate Key

```
openssl genrsa -out /mnt/key/key_luks 4096
```
### Add key on partition

```
cryptsetup luksAddKey /dev/nvme0n1p3 /key/key_luks
```

```
cryptsetup luksAddKey /dev/nvme0n1p4 /key/key_luks
```
### copy key file to mnt

```
cp /mnt/key/key_luks /etc/cryptsetup-keys.d
```

```
nvim /etc/crypttab
```

```

```

```
echo "rd.luks.uuid=$(blkid -s UUID -o value /dev/nvme0n1p3) rd.luks.key=$(blkid -s UUID -o value /dev/nvme0n1p3)=/key/key_luks:UUID=$(blkid -s UUID -o value /dev/sda1) rd.luks.options=$(blkid -s UUID -o value /dev/nvme0n1p3)=keyfile-timeout=10s root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf
```

```
nvim /etc/mkinitcpio.d/defaults.conf
```

```
Module=(vfat)
```

```shell
mkinitcpio -P
```

```shell 
reboot
```
