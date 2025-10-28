### firewalld

```
pacman -S firewalld --noconfirm
```

```
systemctl enable firewalld
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
sudo echo "lsm=landlock,lockdown,yama,integrity,apparmor,bpf" >> /etc/cmdline.d/03-secs.conf
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

```
sudo reboot
```
```
sudo aa-enabled
```
