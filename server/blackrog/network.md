### ethernet

```
printf "[Match]\n
Name=en*\n
Name=eth*\n
\n
[Link]\n
RequiredForOnline=routable\n
\n
[Network]\n
Bridge=bridge\n
\n
[DHCPv4]\n
RouteMetric=100\n
\n
[IPv6AcceptRA]\n
RouteMetric=100\n" > /etc/systemd/network/20-ethernet.network
```


### bridge

```
printf "[NetDev]\n
Name=bridge\n
Kind=bridge" > /etc/systemd/network/10-bridge.netdev
```

```
printf "[Match]\n
Name=bridge\n
\n
[Link]\n
RequiredForOnline=routable\n
\n
[Network]\n
Address=10.10.1.10/24\n
Gateway=10.10.1.1\n
\n
[DHCPv4]\n
RouteMetric=100\n
\n
[IPv6AcceptRA]\n
RouteMetric=100" > /etc/systemd/network/30-bridge.network
```
#### instruction

1. Replace `Address` using your network address with prefix, if you network address is `192.168.0.88`, Address value should be `Address=192.168.0.88/24`   
2. Replace `Gateway` using your network gateway, if you network address is `192.168.0.88`, gateway value should be `Gateway=192.168.0.1`


### resolve

```
mkdir /etc/systemd/resolved.conf.d/
```

```
printf "[Resolve]\n
DNS=10.10.1.1 8.8.8.8\n
MulticastDNS=yes\n
Domains=~\n
Cache=yes" > /etc/systemd/resolved.conf.d/blackbird_resolved.conf
```


### service

```
systemctl enable systemd-networkd.socket
```

```
systemctl enable systemd-resolved
```

```
systemctl enable sshd
```
### after instalation
#### protocol

```
sudo vim /etc/sysctl.d/20-blackbird-network-protocol.conf
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

#### wake on lan

```
sudo nvim /etc/systemd/network/50-ethernet.link
```
```
[Match]
MACAddress=aa:bb:cc:dd:ee:ff

[Link]
NamePolicy=kernel database onboard slot path
MACAddressPolicy=persistent
WakeOnLan=magic
```
```
sudo nvim /etc/udev/rules.d/81-wol.rules
```
```
ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="/usr/bin/ethtool -s $name wol g"
```
#### sleep
```
sudo mkdir -p /etc/systemd/sleep.conf.d/
```
```
sudo vim /etc/systemd/sleep.conf.d/01-blackbird.conf
```
```
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowHybridSleep=no
AllowSuspendThenHibernate=no
```
#### journald
```
sudo mkdir -p /etc/systemd/journald.conf.d/
```
```
sudo vim /etc/systemd/journald.conf.d/01-blackbird.conf
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
#### modprobe
```
sudo nvim /etc/modprobe.d/disable-network-protocols.conf
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
```
sudo nvim /etc/modprobe.d/disable-filesystem-protocols.conf
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

#### coredump

```
sudo nvim /etc/systemd/coredump.conf
```
commenting
```
[coredump]
```
tambahkan paling bawah
```
[Coredump]
Storage=none
ProcessSizeMax=0
```

