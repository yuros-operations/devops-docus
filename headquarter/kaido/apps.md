### flatpak
#### instalation

```
sudo pacman -S flatpak gnome-software --noconfirm
```

#### configuration

```
sudo usermod -aG helios
```
```
sudo mkdir /opt/flat
```

```
sudo mv /var/lib/flatpak/* /opt/flat
```

```
sudo rm -r /var/lib/flatpak
```

```
sudo ln -sf /opt/flat /var/lib/flatpak
```

```
sudo flatpak override --filesystem=$HOME/.themes
```

```
sudo flatpak override --filesystem=$HOME/.icons
```
```
sudo flatpak override --env=GTK_THEME=flow
```
```
sudo flatpak override --env=ICON_THEME=eggs
```


### browser

#### instalation
```
sudo flatpak install --system  flathub org.mozilla.firefox
```

```
 sudo flatpak install --system flathub com.google.Chrome
```
```
sudo echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/50-bubblewrap.conf
```
```
sudo sysctl -w kernel.unprivileged_userns_clone=1
```
### development
#### instalation
```
sudo flatpak install --system flathub com.visualstudio.code
```

### media player

#### installation

```
sudo pacman -S mpd mpc mpv yt-dlp --noconfirm
```
```
sudo flatpak install --system flathub de.wagnermartin.Plattenalbum
```
#### configuration
```
nvim .config/hypr/hyprland.conf
```
uncommenting
```
exec-once = /usr/bin/mpd --no-daemon 
```

### office tools

#### installation

```
sudo pacman -S hugo --noconfirm
```
```
sudo pacman -S go
```

```
sudo flatpak install --system flathub md.obsidian.Obsidian
```

```
sudo flatpak install --system flathub org.gnome.Calendar
```

```
sudo flatpak install --system flathub org.gnome.Evolution
```

```
sudo flatpak install --system flathub org.gnome.Calculator
```

### key tools

#### installation

```
sudo flatpak install --system flathub org.keepassxc.KeePassXC
```

```
cd .local/share/applications
```

```
rm -fr org.keepassxc.KeePassXC
```

### finance

```
sudo flatpak install --system flathub fr.free.Homebank
```

### pacman config

```
sudo nvim /etc/pacman.conf
```

add `TrustedOnly` 

```
Siglevel = Required DatabaseOptional TrustedOnly
```

uncommenting

```
LogFile     = /var/log/pacman.log
```

```
HoldPkg     = pacman glibc
```

### gnome-keyring

```
sudo nvim /etc/pam.d/login
```
add
```
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
```
```
sudo nvim /etc/pam.d/passwd
```
add
```
password	optional	pam_gnome_keyring.so
```
```
sudo systemctl enable --global gcr-ssh-agent.socket
```
