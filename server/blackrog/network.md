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
