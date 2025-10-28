# firewall configuration microtik

install winbox di flatpak 
```
flatpak install flathub com.mikrotik.WinBox
```

```
firewallcmd --zone=public --add-port=5678/udp --permanent
```
*jika tidak terlalu penting, jangan dibuat permanent
