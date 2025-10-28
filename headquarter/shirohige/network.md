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
Address=10.10.1.60/24\n
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
DNS=10.10.1.1 1.1.1.1 8.8.8.8\n
MulticastDNS=yes\n
Domains=~\n
Cache=yes" > /etc/systemd/resolved.conf.d/20-blackbird-resolved-protocol.conf
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

#### protocol

```
sudo nvim /etc/sysctl.d/20-blackbird-network-protocol.conf
```

```
# Generate by Blackbird Installation


## disable ipv6
net.ipv6.conf.all.disable_ipv6 = 1


## ensure packet redirect sending is disabled
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0


#ensure bogus icmp responses are ignored
net.ipv4.icmp_ignore_bogus_error_responses = 1


net.ipv4.icmp_echo_ignore_broadcasts = 1


## ensure broadcast icmp requests are ignored 
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0


## ensure icmp redirects are not accepted 
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

## ensure reverse path filtering is enabled
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1


## ensure source routed packets are not accepted
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0


## ensure suspicious packets are logged
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1


## ensure tcp syn cookies is enabled
net.ipv4.tcp_syncookies = 1

## ensure ipv6 router advertisements are not accepted
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
```
### wake on lan 
```
sudo nvim /etc/systemd/system/wol@.service 
```
add

```
[Unit]
Description=Wake-on-LAN for %i
Requires=network.target
After=network.target

[Service]
ExecStart=/usr/bin/ethtool -s %i wol g
Type=oneshot

[Install]
WantedBy=multi-user.target
```

### journald
```
sudo nvim /etc/systemd/journald.conf.d/00-blackbird-journal-protocol.conf 
```
add
```
[Journal]
SystemMaxUse=1G
SystemKeepFree=500M
RuntimeMaxUse=200M
RuntimeKeepFree=50M
MaxFileSec=1month
Storage=persistent
```
### sleep
```
sudo nvim /etc/systemd/sleep.conf.d/00-blackbird-sleep-protocol.conf 
```
add
```
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowHybridSleep=no
AllowSuspendThenHibernate=no
```
