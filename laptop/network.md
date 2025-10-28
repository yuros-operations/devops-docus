
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

```
systemctl enable iwd
```
#### protocol

```
sudo vim /etc/sysctl.d/20-blackbird-network-protocol.conf
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
