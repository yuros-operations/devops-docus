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
| 1    | [storage](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/storage.md) |
| 2    | [base](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/base.md)       |
| 3    | [config](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/config.md)   |
| 4    | [kernel](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/kernel.md)       |
| 5    | [security](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/security.md)   |
| 6    | [network](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/network.md)   |
| 7    | [mitigate](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/mitigate.md)   |



### after instalation
```
sudo echo " " > /etc/os-release 
```
```
sudo nvim /etc/os-release
```
```
NAME="Blackbird"
PRETTY_NAME="Blackbird"
ID=blackbird
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://blackbird.lektor.co.id/"
DOCUMENTATION_URL="https://blackbird.lektor.co.id/"
SUPPORT_URL="https://blackbird.lektor.co.id/support/"
BUG_REPORT_URL="https://gitlab.blackbird.org/groups/issues"
PRIVACY_POLICY_URL="https://blackbird.lektor.co.id/privacy-policy/"
LOGO=blackbird-logo
```

| step | link                                                        |
| ---- | ----------------------------------------------------------- |
| 1    |  [aide](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/aide.md)  |
| 2    |  [display](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/display.md)  |
| 3    |  [apps](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/apps.md)  |
| 4    |  [perf](https://github.com/devops-yuros/devops-document/blob/main/laptop_v.2/perf.md)  |

