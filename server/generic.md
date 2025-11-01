# 1. Partitioning

## physical volume

### disk layout
| disk | partition | type              | luks  | lvm   | label    | size      | format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- | --------- | ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     | 320M      | fat 32 | /boot                      |
| 0    | 2         | linux server data | true  | false | keys     | 256M      | luks   | none                       |
| 0    | 3         | linux file system | true  | true  | proc     | 22G       | luks   | see logical layout point 1 |
| 0    | 4         | linux server data | true  | true  | data     | 100% Free | luks   | see logical layout point 1 |

gunakan cfdisk untuk membuat physical volume sesuai dengan guide line

### disk encryption
```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p2
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p3
```

```
cryptsetup luksFormat --sector-size=4096 /dev/nvme0n1p4
```

```
cryptsetup luksOpen /dev/nvme0n1p3 proc
```

```
cryptsetup luksOpen /dev/nvme0n1p4 data
```

## logical volume

### disk layout
| partition | list | group  | name | size | mount                 | format |
| --------- | ---- | ------ | ---- | ---- | --------------------- | ------ |
| 2         | 1    | proc   | root | 5G   | /mnt                  | ext4   |
| 2         | 3    | proc   | temp | 2G   | /mnt/tmp              | ext4   |
| 2         | 5    | proc   | vars | 3G   | /mnt/var              | ext4   |
| 2         | 2    | proc   | libs | 2G   | /mnt/var/usr/         | ext4   |
| 2         | 2    | proc   | game | 1G   | /mnt/var/games/       | ext4   |
| 2         | 6    | proc   | vlog | 2G   | /mnt/var/log/         | ext4   |
| 2         | 7    | proc   | vaud | 1G   | /mnt/var/log/audit    | ext4   |
| 2         | 8    | proc   | vtmp | 512M | /mnt/var/tmp/         | ext4   |
| 2         | 9    | proc   | vpac | 2G   | /mnt/var/cache/pacman | ext4   |
| 2         | 10   | proc   | ring | 512M |                       | luks   |
| 2         | 11   | proc   | home | 100% | /mnt/home             | ext4   |

```
pvcreate /dev/mapper/proc
```
```
vgcreate proc /dev/mapper/proc
```
```
pvcreate /dev/mapper/data
```
```
vgcreate proc /dev/mapper/data
```
### root
```
lvcreate -L 5G proc -n root
```
```
mkfs.ext4 -b 4096 /dev/proc/root
```
```
mount /dev/proc/root /mnt
```

### boot
```
mkfs.vfat -F32 -S 4096 -n BOOT /dev/nvme0n1p1
```
```
mkdir /mnt/boot
```
```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot
```

### temp
```
lvcreate -L 2G proc -n temp
```
```
mkfs.ext4 -b 4096 /dev/proc/temp
```
```
mkdir /mnt/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/temp /mnt/tmp
```

### vars
```
lvcreate -L 3G proc -n vars
```
```
mkfs.ext4 -b 4096 /dev/proc/vars
```
```
mkdir /mnt/var
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vars /mnt/var
```

### libs
```
lvcreate -L 2G proc -n libs
```
```
mkfs.ext4 -b 4096 /dev/proc/libs
```
```
mkdir /mnt/var/usr
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/libs /mnt/var/usr
```

### game
```
lvcreate -L 1G proc -n game
```
```
mkfs.ext4 -b 4096 /dev/proc/game
```
```
mkdir /mnt/var/games
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/game /mnt/var/games
```

### vlog
```
lvcreate -L 2G proc -n vlog
```
```
mkfs.ext4 -b 4096 /dev/proc/vlog
```
```
mkdir /mnt/var/log
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vlog /mnt/var/log
```

### vaud
```
lvcreate -L 1G proc -n vaud
```
```
mkfs.ext4 -b 4096 /dev/proc/vaud
```
```
mkdir /mnt/var/log/audit
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vaud /mnt/var/log/audit
```
### vtmp
```
lvcreate -L 512M proc -n vtmp
```
```
mkfs.ext4 -b 4096 /dev/proc/vtmp
```
```
mkdir /mnt/var/tmp
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vtmp /mnt/var/tmp
```
### vpac
```
lvcreate -L 2G proc -n vpac
```
```
mkfs.ext4 -b 4096 /dev/proc/vpac
```
```
mkdir -p /mnt/var/cache /mnt/var/cache/pacman
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```
### ring
```
lvcreate -L 512M proc -n ring
```
```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```
```
cryptsetup luksOpen /dev/proc/ring lvm_keys
```
```
mkfs.ext4 -b 4096 /dev/mapper/lvm_keys
```
### home
```
lvcreate -l100%FREE proc -n home
```
```
mkfs.ext4 -b 4096 /dev/proc/home
```
```
mkdir /mnt/home
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/home /mnt/home
```

# 2.installation


## intel server
```
pacstrap /mnt linux-hardened linux-firmware mkinitcpio intel-ucode tang clevis mkinitcpio-nfs-utils luksmeta libpwquality cracklib git base neovim lvm2 btrfs-progs openssh polkit ethtool iptables-nft firewalld apparmor rsync sudo debugedit fakeroot --noconfirm
```
## amd server
```
pacstrap /mnt linux-hardened linux-firmware mkinitcpio amd-ucode tang clevis mkinitcpio-nfs-utils luksmeta libpwquality cracklib git base neovim lvm2 btrfs-progs openssh polkit ethtool iptables-nft firewalld apparmor rsync sudo debugedit fakeroot  --noconfirm
```

## network configuration
```
cp /etc/systemd/network/* /mnt/etc/systemd/network/
```

## generate partition layout
```
genfstab -U /mnt > /mnt/etc/fstab
```


# 3. chrooting


```
arch-chroot /mnt
```

## hostname

```
echo 'nama_hostname' > /etc/hostname
```


## local time

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

```
hwclock --systohc
```
```
mkdir /etc/systemd/timesyncd.conf.d
```
```
nvim /etc/systemd/timesyncd.conf.d/local.conf
```
```
[Time]
NTP=0.id.pool.ntp.org 1.id.pool.ntp.org 2.id.pool.ntp.org 3.id.pool.ntp.org
FallbackNTP=time.cloudflare.com time.google.com time.aws.com
```
```
timedatectl set-ntp true
```
```
timedatectl set-timezone Asia/Jakarta
```
```
timedatectl status
```
```
timedatectl show-timesync --all
```
```
systemctl enable systemd-timesyncd.service
```

### locale

```
nvim /etc/locale.gen
```
uncommenting
```
en_US.UTF-8 UTF-8
en_US ISO-8859-1
```
```
locale-gen && locale > /etc/locale.conf
```
```
sed -i '1s/.*/LANG=en_US.UTF-8/' /etc/locale.conf
```
```
cat /etc/locale.conf
```
```
touch /etc/vconsole.conf
```
```
nvim /etc/vconsole.conf
```
```
FONT=lat2-16
FONT_MAP=8859-2
```

### user
```
rm /etc/skel/.bash_profile
```
```
rm /etc/skel/.bashrc
```
```
rm /etc/skel/.bash_logout
```
```
echo 'loki ALL=(ALL:ALL) ALL' >> /etc/sudoers
```
```
cat /etc/sudoers
```
```
useradd -d /var/usr loki
```
```
chown -R loki:loki /var/usr
```
```
passwd loki
```
```
su loki
```
```
sudo su
```
```
exit
```
```
exit
```
```
passwd -l root
```
### hook clevis
```
su loki
```
```
git clone https://aur.archlinux.org/mkinitcpio-clevis-hook.git 
```
```
cd mkinitcpio-clevis-hook
```
```
makepkg -si
```
```
clevis luks bind -d /dev/nvme0n1p3 tang '{"url":"http://10.10.1.10:51379"}'
```
```
clevis luks bind -d /dev/nvme0n1p3 tang '{"url":"http://10.10.1.11:51379"}'
```
```
clevis luks bind -d /dev/nvme0n1p4 tang '{"url":"http://10.10.1.10:51379"}'
```
```
clevis luks bind -d /dev/nvme0n1p4 tang '{"url":"http://10.10.1.11:51379"}'
```
### tang server
```
systemctl enable tangd.socket
```
```
mkdir /etc/systemd/system/tangd.socket.d
```
```
nvim /etc/systemd/system/tangd.socket.d/override.conf
```
```
[Socket]
ListenStream=
ListenStream=51379 
```
```
systemctl show tangd.socket -p Listen
```

### boot directory
#### intel server
```
rm /boot/initramfs-linux-hardened*
```

```
mkdir -p /boot/efi /boot/efi/linux /boot/efi/systemd /boot/efi/rescue /boot/efi/boot
```

```
mkdir /boot/kernel
```

```
mv /boot/intel-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel
```

#### amd server
```
rm /boot/initramfs-linux-hardened*
```

```
mkdir -p /boot/efi /boot/efi/linux /boot/efi/systemd /boot/efi/rescue /boot/efi/boot
```

```
mkdir /boot/kernel
```

```
mv /boot/amd-ucode.img /boot/vmlinuz-linux-hardened /boot/kernel
```
### kernel parameter

```
mkdir /etc/cmdline.d
```
```
touch /etc/cmdline.d/{01-boot.conf,02-mods.conf,03-secs.conf,04-perf.conf,05-nets.conf,06-misc.conf}
```
```
echo "cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p3):proc root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf
```
```
echo "data UUID=$(blkid -s UUID -o value /dev/nvme0n1p4) none" >> /etc/crypttab
```
```
echo "ipv6.disable=1" > /etc/cmdline.d/04-perf.conf
```
```
echo "ip=(ip address)::10.10.1.1:255.255.255.0::eth0:none nameserver=10.10.1.1 " /etc/cmdline.d/05-nets.conf
```
```
echo "rw quiet" > /etc/cmdline.d/06-misc.conf
```

### initram directory

```
rm -fr /etc/mkinitcpio.conf.d
```
```
mv /etc/mkinitcpio.conf /etc/mkinitcpio.d/default.conf
```
```
nvim /etc/mkinitcpio.d/default.conf
```
cari lalu commenting
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)
```
tambahkan
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont net clevis encrypt lvm2 block filesystems fsck)
```
tambahkan pada bagian binaries
```
/usr/bin/curl
```
#### configure linux preset

```
nvim /etc/mkinitcpio.d/linux-hardened.preset
```
uncommenting 

```
#ALL_config="/etc/mkinitcpio.conf"
```
lalu ubah
```
ALL_config="/etc/mkinitcpio.d/default.conf"
```
edit
```
ALL_kver="/boot/vmlinuz-linux-hardened"
```
menjadi
```
ALL_kver="/boot/kernel/vmlinuz-linux-hardened" 
```
edit
```
PRESETS=('default' 'fallback')
```
lalu menjadi
```
PRESETS=('default')
```
uncommenting
```
#default_uki="/efi/EFI/Linux/arch-linux-hardened.efi"
```
lalu ubah
```
default_uki="/boot/efi/linux/blackbird-hardened.efi"
```
commenting
```
fallback_image="/boot/initramfs-linux-hardened-fallback.img"
```
```
fallback_options="-S autodetect"
```

### generate efi files

```
mkinitcpio -P
```
### bridge
```
rm /etc/systemd/network/20-wlan.network /etc/systemd/network/20-wwan.network
```
```
nvim /etc/systemd/network/20-ethernet.network
```
commenting di bawah [Network]
```
DHCP=yes
```
```
MulticastDNS=yes
```
tambahkan
```
Bridge=bridge
```
```
nvim /etc/systemd/network/10-bridge.netdev
```
```
Name=bridge
Kind=bridge
```
```
nvim /etc/systemd/network/30-bridge.network
```
```
[Match]
Name=bridge

[Link]
RequiredForOnline=routable

[Network]
Address=(ip address)/24
Gateway=10.10.1.1

[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100" 
```
