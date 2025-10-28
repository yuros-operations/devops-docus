#### package
```
git clone https://aur.archlinux.org/mkinitcpio-clevis-hook.git
```

```
cd mkinitcpio-clevis-hook
```

```
makepkg -sri
```

```
sudo mkinitcpio -P
```

#### tang server
```
sudo systemctl enable --now tangd.socket
```

```
sudo firewall-cmd --add-port=7500/tcp --permanent
```

```
sudo firewall-cmd --reload
```

```
sudo mkdir /etc/systemd/system/tangd.socket.d
```

```
sudo printf '[Socket]\n
ListenStream=\n
ListenStream=7500' > /etc/systemd/system/tangd.socket.d/override.conf
```

```
sudo systemctl daemon-reload
```

```
systemctl show tangd.socket -p Listen
```

```
sudo systemctl restart tangd.socket
```

#### test tang
```
echo test | clevis encrypt tang '{"url":"http://10.10.1.11:7500"}' -y | clevis decrypt
```

```
echo test | clevis encrypt tang '{"url":"http://10.10.1.10:7500"}' -y | clevis decrypt
```

#### ip parameter
```
sudo systemctl enable clevis-luks-askpass.path
```

```
sudo echo "ip=10.10.1.80::10.10.1.1:255.255.255.0::eth0:none nameserver=10.10.1.10 nameserver=1.1.1.1 nameserver=8.8.8.8" > /etc/cmdline.d/06-nets.conf
```

```
sudo mkinitcpio -P
```

#### clevis
```
sudo clevis luks bind -d /dev/nvme0n1p3 tang '{"url":"http://10.10.1.10:7500"}'
```

```
sudo clevis luks bind -d /dev/nvme0n1p3 tang '{"url":"http://10.10.1.11:7500"}'
```

```
sudo clevis luks bind -d /dev/nvme0n1p4 tang '{"url":"http://10.10.1.10:7500"}'
```

```
sudo clevis luks bind -d /dev/nvme0n1p4 tang '{"url":"http://10.10.1.11:7500"}'
```

```
sudo clevis luks list -d /dev/nvme0n1p3
```

```
sudo clevis luks list -d /dev/nvme0n1p4
```
