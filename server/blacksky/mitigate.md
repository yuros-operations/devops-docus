## installation

### backup 

```
pacman -S rsync grsync --noconfirm
```


### recovery

```
curl --output recovery.efi https://boot.netboot.xyz/ipxe/netboot.xyz.efi
```

```
mv recovery.efi /boot/efi/rescue/
```

```
printf "title recovery\nefi /efi/rescue/recovery.efi" > /boot/loader/entries/recovery.conf
```