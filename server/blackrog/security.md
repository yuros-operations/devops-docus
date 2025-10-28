### firewalld

```
pacman -S firewalld --noconfirm
```

```
systemctl enable firewalld
```
#### configuration
```
sudo firewall-cmd --zone=work --remove-service={dhcpv6-client,ssh} --permanent
```
```
sudo firewall-cmd --zone=public --remove-service=dhcpv6-client --permanent
```
```
sudo sudo firewall-cmd --zone=internal --remove-service={dhcpv6-client,ssh,mdns,samba-client} --permanent
```
```
sudo sudo firewall-cmd --zone=home --remove-service={dhcpv6-client,ssh,mdns,samba-client} --permanent
```
```
sudo firewall-cmd --zone=external --remove-service=ssh --permanent
```
```
sudo firewall-cmd --zone=dmz --remove-service=ssh --permanent
```
```
sudo firewall-cmd --zone=internal --add-service={http,https} --permanent
```
```
sudo firewall-cmd --zone=internal --add-interface=nama_driver_ethernet --permanent
```
```
sudo firewall-cmd --zone=public --add-interface=nama_driver_wifi --permanent
```
```
sudo firewall-cmd --reload
```
## after instalation

### apparmor
#### instalation
```
sudo pacman -S apparmor --noconfirm
```
```
sudo systemctl enable apparmor
```
#### configuration
```
sudo echo "apparmor=1 lsm=landlock,lockdown,yama,integrity,apparmor,bpf lockdown=integrity" > /etc/cmdline.d/03-secs.conf
```
```
sudo mkinitcpio -P
```
```
sudo reboot
```
```
sudo vim /etc/apparmor/parser.conf
```
uncomennt
```
write-cache
```

```
sudo reboot
```
```
sudo aa-enabled
```
### ssh
```
sudo nvim /etc/ssh/sshd_config
```
commenting
```
Subsystem sftp [...]
```
tambahkan paling bawah
```
Protocol 2

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms curve25519-sha256@libssh.org
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
```
