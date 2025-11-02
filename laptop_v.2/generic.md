# 1. Partitioning

## physical volume

### disk layout
| disk | partition | type              | luks  | lvm   | label    |  format | mount                      |
| ---- | --------- | ----------------- | ----- | ----- | -------- |  ------ | -------------------------- |
| 0    | 1         | efi               | false | false | boot     |  fat 32 | /boot                      |
| 0    | 2         | linux file system | true  | false | keys     |  luks   | none                       |
| 0    | 3         | linux root (x86_64) | true  | true  | proc |  luks   | see logical layout point 1 |
| 0    | 4         | linux home        | true  | true  | data |  luks   | see logical layout point 1 |

gunakan cfdisk untuk membuat physical volume sesuai dengan guide line

### disk encryption
```
cryptsetup luksFormat --sector-size=4096 /dev/partisi_keys
```

```
cryptsetup luksFormat --sector-size=4096 /dev/partisi_root
```

```
cryptsetup luksFormat --sector-size=4096 /dev/partisi_data
```

```
cryptsetup luksOpen /dev/partisi_root proc
```

```
cryptsetup luksOpen /dev/partisi_data data
```

## logical volume

### disk layout root
| partition | list | group | name |  mount                    | format |
| --------- | ---- | ----- | ---- |  -------------------------| ------ |
| 2         | 1    | proc  | root |  /mnt                     | ext4   |
| 2         | 2    | proc  | opts |  /mnt/opt                 | ext4   |
| 2         | 3    | proc  | vars |  /mnt/var                 | ext4   |
| 2         | 4    | proc  | vlog |  /mnt/var/log             | ext4   |
| 2         | 5    | proc  | vaud |  /mnt/var/log/audit       | ext4   |
| 2         | 6    | proc  | vpac |  /mnt/var/cache/pacman    | ext4   |
| 2         | 7    | proc  | ring |                           | ext4   |
| 2         | 8    | proc  | temp |  /mnt/tmp                 | ext4   |
| 2         | 9    | proc  | vtmp |  /mnt/var/tmp             | ext4   |

#### data disk group
| partition | list | group | name |  mount                       | format |
| --------- | ---- | ----- | ---- | ---------------------------- | ------ |
| 2         | 1    | data  | home |  /mnt/home                   | ext4   |

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
vgcreate data /dev/mapper/data
```

### root
```
lvcreate -L [ size in G | M ] proc -n root
```
```
mkfs.ext4 -b 4096 /dev/proc/root
```
```
mount /dev/proc/root /mnt
```
### boot
```
mkfs.vfat -F32 -S 4096 -n BOOT [ partition path ]
```
```
mkdir /mnt/boot
```
```
mount -o uid=0,gid=0,fmask=0077,dmask=0077 [ path boot partition ] /mnt/boot
```
### opts
```
lvcreate -L [ size in G | M ] proc -n opts
```
```
mkfs.ext4 -b 4096 /dev/proc/opts
```
```
mkdir /mnt/opt
```
```
mount -o rw,nodev,nosuid,relatime /dev/proc/opts /mnt/opt
```
### vars
```
lvcreate -L [ size in G | M ] proc -n vars
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
### vlog
```
lvcreate -L [ size in G | M ] proc -n vlog
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
lvcreate -L [ size in G | M ] proc -n vaud
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
### vpac
```
lvcreate -L [ size in G | M ] proc -n vpac
```
```
mkfs.ext4 -b 4096 /dev/proc/vpac
```
```
mkdir -p /mnt/var/cache/pacman
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/proc/vpac /mnt/var/cache/pacman
```
### ring
```
lvcreate -L [ size in G | M ] proc -n ring
```
```
cryptsetup luksFormat --sector-size=4096 /dev/proc/ring
```
```
cryptsetup luksOpen /dev/proc/ring proc_keys
```
```
mkfs.ext4 -b 4096 /dev/mapper/proc_keys
```
### temp
```
lvcreate -L [ size in G | M ] proc -n temp
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
### vtmp
```
lvcreate -l 100%FREE proc -n vtmp
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
### home
```
lvcreate -l100%FREE data -n home
```
```
mkfs.ext4 -b 4096 /dev/data/home
```
```
mkdir /mnt/home
```
```
mount -o rw,nodev,noexec,nosuid,relatime /dev/data/home /mnt/home
```
# 2. instalation package
for intel
```
pacstrap /mnt base base-devel neovim lvm2 openssh polkit git iptables-nft iwd ethtool linux-hardened linux-firmware mkinitcpio intel-ucode libpwquality cracklib less bubblewrap-suid irqbalance reflector
```
for amd
```
pacstrap /mnt base base-devel neovim lvm2 openssh polkit git iptables-nft iwd ethtool linux-hardened linux-firmware mkinitcpio amd-ucode libpwquality cracklib less bubblewrap-suid irqbalance reflector
```
### network configuration
```
mkdir /mnt/var/lib/iwd
```
```
cp /var/lib/iwd/*.psk /mnt/var/lib/iwd
```
```
cp /etc/systemd/network/* /mnt/etc/systemd/network/
```
### fstab
```
genfstab -U /mnt > /mnt/etc/fstab
```
### chrooting
```
arch-chroot /mnt
```
### hostname
```
echo 'nama_hostname' > /etc/hostname
```
### localtime
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
### operational user
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
useradd -m nama_user
```
```
passwd nama_user
```
```
echo "nama_user ALL=(ALL:ALL) ALL" > /etc/sudoers.d/00_nama_user
```
```
su nama_user
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
### system user
```
useradd -m loki
```
```
passwd loki
```
```
echo "loki ALL=(ALL:ALL) ALL" > /etc/sudoers.d/00_nama_user
```
```
su nama_user
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

### skel

```
mkdir /etc/skel/.config
```

```
git clone https://github.com/blackbird-package/skel /tmp/skel
```
```
mv /tmp/skel/skels/* /etc/skel/.config
```

```
rm /etc/profile /etc/bash.bashrc
```

```
cp /tmp/skel/profile /tmp/skel/bash.bashrc /etc/
```

```
git clone https://github.com/blackbird-package/conf.git /tmp/conf
```

```
 mv /tmp/conf/cfg/etc/skel/.local/ /etc/skel/
```

### themes

#### installation

```
git clone https://github.com/blackbird-package/flow.git /tmp/flow
```

#### configuration

```
mkdir /usr/share/themes
```

```
 mkdir /etc/skel/.themes
```

```
 tar -xf /tmp/flow/pkg.tar.xz -C /usr/share/themes/
```

```
 tar -xf /tmp/flow/pkg.tar.xz -C /etc/skel/.themes/
```


### icons

```
 git clone https://github.com/blackbird-package/eggs.git /tmp/eggs
```

#### configuration

```
mkdir /etc/skel/.icons
```

```
tar -xf /tmp/eggs/pkg.tar.xz -C /usr/share/icons/
```

```
tar -xf /tmp/eggs/pkg.tar.xz -C /etc/skel/.icons/
```
### firewelld

```
nvim /usr/lib/firewalld/zones/block.xml
```
```
nvim /usr/lib/firewalld/zones/external.xml
```
```
nvim /usr/lib/firewalld/zones/home.xml
```
```
nvim /usr/lib/firewalld/zones/internal.xml 
```
 
delete semua service 

```
nvim /usr/lib/firewalld/zones/public.xml 
```

delete semua service selain ssh,dan tamahkan
```
  <port protocol="tcp" port="51379"/>
```
dibawah
```
<service name="ssh"/>
```

## os release

```
echo '' > /usr/lib/os-release
```
```
nvim /usr/lib/os-release
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

## pamd


To avoid the temptation of creating weak passwords, PAM must be properly configured to implement a password policy, as well as securely control the login process. Here we are going to implement this password policy:

- Minimum length: 14 characters.
- Required characters: Uppercase, lowercase, digits, and special characters.
- Different characters between passwords: 3 characters.
- Retries: 3 times.
- Retries before locking: 6 times.
- Time between each retry: 3 seconds.
- Time before automatic account lockout: 10 minutes.
- Storing method: SHA-512 in /etc/shadow.

To achieve it, open /etc/pam.d/passwd in a text editor, comment all lines --considering you have not changed this file yet-- and add the next lines.
```
nvim /etc/pam.d/passwd
```
```
password required pam_cracklib.so retry=3 minlen=14 difok=3 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1
password required pam_unix.so     use_authtok sha512 shadow
```

## package manager

```
nvim /etc/pacman.conf
```
```
SigLevel = Required DatabaseOptional TrustedOnly
```
uncomment
```
UseSysLog
Color
VerbosePkgLists
```

## apparmor 

```
systemctl enable apparmor.service
```

## secure shell hardening

```
mv /etc/ssh/sshd_config /etc/backup
```
```
nvim /etc/ssh/sshd_config
```
```
# Include drop-in configurations
Include /etc/ssh/sshd_config.d/*.conf

Protocol 2

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms mlkem768x25519-sha256,sntrup761x25519-sha512,curve25519-sha256@libssh.org
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256

PermitRootLogin no
PermitEmptyPasswords no
LoginGraceTime 20
MaxAuthTries 3
MaxSessions 10
ClientAliveCountMax 3
Banner no

AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no

# override default of no subsystems
#Subsystem	sftp	/usr/lib/ssh/sftp-server
```
```
systemctl enable ssh
```


## kernels harden

```
nvim /etc/sysctl.d/30-secs.conf
```

```
## disable ipv6
net.ipv6.conf.all.disable_ipv6 = 1

# prevent the automatic loading of line disciplines
# https://lore.kernel.org/patchwork/patch/1034150
dev.tty.ldisc_autoload=0


# additional protections for fifos, hardlinks, regular files, and symlinks
# https://patchwork.kernel.org/patch/10244781
# slightly tightened up from the systemd default values of "1" for each
fs.protected_fifos=2
fs.protected_regular=2


## yama ptrac
## https://theprivacyguide1.github.io/linux_hardening_guide
kernel.yama.ptrace_scope=2


# prevents processes from creating new io_uring instances
# https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
kernel.io_uring_disabled=2


# disable unprivileged user namespaces
# https://lwn.net/Articles/673597
# (these two values are redundant, but not all kernels support the first one)
user.max_user_namespaces=0


# reverse path filtering to prevent some ip spoofing attacks
# (default in some distributions)
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1


# reverse path filtering to prevent some ip spoofing attacks
# (default in some distributions)
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1


# disable icmp redirects and RFC1620 shared media redirects
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.all.shared_media=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.default.secure_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv4.conf.default.shared_media=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0


# disable tcp timestamps to avoid leaking some system information
# https://www.whonix.org/wiki/Disable_TCP_and_ICMP_Timestamps
net.ipv4.tcp_timestamps=0

# disable usb
kernel.deny_new_usb=1

#disable coredum
kernel.core_pattern=|/bin/false
```

## module hardening

### network
```
nvim /etc/modprobe.d/disable-network-protocols.conf
```
```
install dccp /bin/true
install sctp /bin/true
install rds /bin/true
install tipc /bin/true
install n-hdlc /bin/true
install ax25 /bin/true
install netrom /bin/true
install x25 /bin/true
install rose /bin/true
install decnet /bin/true
install econet /bin/true
install af_802154 /bin/true
install ipx /bin/true
install appletalk /bin/true
install psnap /bin/true
install p8023 /bin/true
install p8022 /bin/true
```

### filesystem
```
nvim /etc/modprobe.d/disable-filesystem-protocols.conf
```
```
install cramfs /bin/true
install freevxfs /bin/true
install jffs2 /bin/true
install hfs /bin/true
install hfsplus /bin/true
install squashfs /bin/true
install udf /bin/true
```


## loging config
```
mkdir -p /etc/systemd/journald.conf.d/
```
```
nvim /etc/systemd/journald.conf.d/01-default.conf
```
```
[Journal]
SystemMaxUse=1G
SystemKeepFree=500M
RuntimeMaxUse=200M
RuntimeKeepFree=50M
MaxFileSec=1month
Storage=persistent
```

## sleep config
```
mkdir -p /etc/systemd/sleep.conf.d/
```
```
nvim /etc/systemd/sleep.conf.d/01-blackbird.conf
```
```
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowHybridSleep=no
AllowSuspendThenHibernate=no
```

## coredump config
```
nvim /etc/systemd/coredump.conf
```
comment "[coredum]" dan tambah di akhir document
```
[Coredump]
Storage=none
ProcessSizeMax=0
```

## login sudoers
```
nvim /etc/sudo.conf
```
tambahkan pada bagian paling bawah
```
## Config Log
Defaults logfile="/var/log/sudo.log"
```

## autoupdate
```
nvim /etc/systemd/system/update.service
```
```
[Unit]
Description=Run system update

[Service]
Type=oneshot
ExecStart=/usr/bin/pacman --sync --refresh --sysupgrade --noconfirm
```
```
nvim /etc/systemd/system/update.timer
```
```
[Unit]
Description=Run the system update daily

[Timer]
OnCalendar=hourly
Persistent=true
Unit=update.service

[Install]
WantedBy=timers.target
```
```
systemctl enable update.timer 
```
## prometheus 
```
sudo systemctl enable prometheus.service
```
```
sudo systemctl enable prometheus-node-exporter.service
```
```
sudo systemctl stop firewalld
```

### configuration
```
cd /etc/prometheus
```
```
cp prometheus.yml prometheus.yml.bck
```

```
nvim /etc/prometheus/prometheus.yml
```
tambahkan ke paling bawah
```
scrape_configs:
   - job_name: 'prometheus'
     static_configs:
       - targets: ['localhost:9090']
         labels:
           app: "promotheus"
   - job_name: 'node'
     static_configs:
       - targets: ['localhost:9100']
         labels:
           app: "exporter"
```
### network
```
systemctl enable systemd-networkd
```
```
systemctl enable systemd-resolved
```
```
systemctl enable sshd
```
```
systemctl enable iwd
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
### 01-boot
```
echo "rd.luks.uuid=UUID=$(blkid -s UUID -o value /dev/nvme0n1p3) root=/dev/proc/root" > /etc/cmdline.d/01-boot.conf
```

### 03-secs
```
echo "lsm=landlock,lockdown,yama,integrity,apparmor,bpf lockdown=integrity init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 slab_nomerge vsyscall=none randomize_kstack_offset=1" > /etc/cmdline.d/03-secs.conf
```

### 04-perf
```
echo "ipv6.disable=1" > /etc/cmdline.d/04-perf.conf
```
### 06-misc

```
echo "rw quiet" > /etc/cmdline.d/06-misc.conf
```

## cryptab
```
echo "data UUID=$(blkid -s UUID -o value /dev/nvme0n1p4) none" >> /etc/crypttab
```

