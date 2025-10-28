ubah akses menjadi 700 pada setiap folder home semua user

```
sudo chmod 700 /home/helios
```

```
sudo chmod 700 /home/lektor
```

```
sudo chmod 700 /home/yuros
```

```
sudo chmod 700 /home/devel
```

---

```
cd /tmp
```

```
git clone https://github.com/blackbird-package/craw
```

```
sudo mkdir /opt/rbin
```

```
sudo cp -rf /craw/pkg/craw /opt/rbin
```

```
sudo cp -rf /craw/src/craw /opt/rbin
```

```
cd /opt/rbin
```

```
chmod +x craw
```

untuk menjalankan craw

```
craw open keys
```

jika ada error terkait bad sector lakukan langkah berikut

```
sudo su
```

```
mkfs.ext4 -b 4096 /dev/mapper/lvm_ring
```

```
reboot
```

setelah itu jalankan kembali crawnya, jika berhasil maka ketika lsblk akan terlihat pada proc-ring lvm-ring termount kepada /home/helios/.ssh
