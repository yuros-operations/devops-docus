## trouble
1. firmware pada arch tidak suppor
2. device wireless tidak terdeteksi

## solving
1. hapus package linux firmware yang terbaru
```
pacman -R linux-firmware
```

2. downgrade linux-firmware version 20250613.12fe085f-2
```
pacman -U https://archive.archlinux.org/packages/l/linux-firmware/linux-firmware-20250613.12fe085f-2-any.pkg.tar.zst
```
