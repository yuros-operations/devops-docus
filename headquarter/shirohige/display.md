### blackbird hyprland

#### installation

```
sudo pacman -S uwsm hyprland hyprpolkitagent hypridle hyprlock xdg-desktop-portal-hyprland pipewire pipewire-pulse pipewire-jack wireplumber pavucontrol kitty qt5-wayland qt6-wayland ttf-jetbrains-mono-nerd ttf-droid btop nautilus nautilus-image-converter sushi mako waybar wofi wl-clipboard cliphist mailcap hyprshot gnome-keyring libsecret --noconfirm
```
#### service

```
systemctl --global enable hypridle.service
```

```
systemctl --global enable hyprpolkitagent
```

```
systemctl --global enable waybar
```
```
systemctl --global enable pipewire
```
### sddm

#### guideline

```
sudo pacman -S sddm --noconfirm
```

```
sudo git clone https://github.com/blackbird-package/claw.git
```

```
sudo cp -fr claw/pkg.tar.xz /usr/share/sddm/themes
```

```
sudo tar -xf /usr/share/sddm/themes/pkg.tar.xz 
```

#### configuration

```
mkdir /etc/sddm.conf.d/
```

```
mv /usr/share/sddm/themes/claw/sddm-default.conf /etc/sddm.conf.d/default.conf
```

```
sudo nvim /etc/sddm.conf.d/default.conf
```

#### service

```
sudo systemctl enable sddm
```


### profile
#### configuration

```
sudo nvim /etc/profile
```

change append path
```
append_path '/opt/rbin'
```
