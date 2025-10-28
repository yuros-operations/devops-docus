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
sudo firewall-cmd --add-port=51379/tcp --permanent
```

```
sudo firewall-cmd --reload
```

```
sudo mkdir /etc/systemd/system/tangd.socket.d
```
```
sudo nvim /etc/systemd/system/tangd.socket.d/override.conf
```

```
[Socket]
ListenStream=
ListenStream=51379 
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
echo test | clevis encrypt tang '{"url":"http://10.10.1.10:7500"}' -y | clevis decrypt
```

#### ip parameter
```
sudo systemctl enable clevis-luks-askpass.path
```

```
sudo nvim /etc/cmdline.d/06-nets.conf
```

```
ip=10.10.1.10::10.10.1.1:255.255.255.0::eth0:none nameserver=10.10.1.11 
```

```
sudo mkinitcpio -P
```

#### clevis
```
sudo clevis luks bind -d /dev/nvme0n1p3 tang '{"url":"http://10.10.1.11:7500"}'
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
