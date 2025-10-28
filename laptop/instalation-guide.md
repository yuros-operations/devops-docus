### preparation

#### setting bios ke default

jika sudah pernah mengutak atik bios pada laptop, maka lakukan restore to default, kemudian **secure bootnya di disable**

#### connect internet

```
iwctl
```

cek ketersediaan driver

```
device list
```

cek list ssid wifi

```
station wlan0 get-networks
```

connect wifi

```
station wlan0 connect nama_ssid
```

#### cek efi

```
ls /sys/firmware/efi
```
note: jika ada isinya maka support efi, jika tidak ada berarti tidak support


#### load module crypt

```
modprobe dm_crypt
```

note: Jika tidak ada pesan error, installasi bisa di lanjutkan.

#### jika error
warning: langkah ini akan membuat os yang sudah terpasang akan hilang, seperti windows dan lain lain.

note: langkah ini dilakukan jika anda setuju untuk memformat keseluruhan hardisk atau ssd anda. maka disarankan juga untuk melakukan backup terlebih dahulu sebelum melakukan langkah berikut.

pastikan flashdisk bootingan arch tetap terpasang pada laptop

```
mkfs.ext4 /dev/nama_partisi_utama
```
kemudian tekan y untuk melakukan formatting keseluruhan paritisi yang sebelumnya 

note: partisi utama seperti sda,sdb,nvme0n1, dan lain lain.

```
cfdisk /dev/nama_partisi_utama
```
setelah itu pilih gpt agar bisa support efi.

### instalation

| step | link                                                        |
| ---- | ----------------------------------------------------------- |
| 1    | [storage](https://github.com/devops-yuros/devops-document/blob/main/laptop/storage.md) |
| 2    | [base](https://github.com/devops-yuros/devops-document/blob/main/laptop/base.md)       |
| 3    | [config](https://github.com/devops-yuros/devops-document/blob/main/laptop/config.md)   |
| 4    | [kernel](https://github.com/devops-yuros/devops-document/blob/main/laptop/kernel.md)       |
| 5    | [security](https://github.com/devops-yuros/devops-document/blob/main/laptop/security.md)   |
| 6    | [network](https://github.com/devops-yuros/devops-document/blob/main/laptop/network.md)   |
| 7    | [mitigate](https://github.com/devops-yuros/devops-document/edit/main/laptop/mitigate.md)   |



### after instalation

| step | link                                                        |
| ---- | ----------------------------------------------------------- |
| 1    |  [aide](https://github.com/devops-yuros/devops-document/blob/main/laptop/aide.md)  |
| 2    |  [display](https://github.com/devops-yuros/devops-document/blob/main/laptop/display.md)  |
| 3    |  [apps](https://github.com/devops-yuros/devops-document/blob/main/laptop/apps.md)  |
| 4    |  [perf](https://github.com/devops-yuros/devops-document/blob/main/laptop/perf.md)  |

