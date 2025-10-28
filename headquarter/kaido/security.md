### firewalld

```
pacman -S firewalld --noconfirm
```

```
systemctl enable firewalld
```
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
sudo nvim /etc/apparmor/parser.conf
```
uncommenting
```
write-cache
```
```
sudo reboot
```
```
sudo aa-enabled
```
