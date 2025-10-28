### blackbird hyprland

#### installation

```
sudo pacman -S uwsm hyprland hyprpolkitagent hypridle hyprlock xdg-desktop-portal-hyprland pipewire pipewire-pulse pipewire-jack wireplumber pavucontrol kitty qt5-wayland qt6-wayland ttf-jetbrains-mono-nerd ttf-droid btop nautilus nautilus-image-converter sushi mako waybar wofi wl-clipboard cliphist mailcap hyprshot gnome-keyring libsecret brightnessctl hyprpicker --noconfirm
```
#### service

```
sudo systemctl --global enable hypridle.service
```

```
sudo systemctl --global enable hyprpolkitagent
```

```
sudo systemctl --global enable waybar
```
```
sudo systemctl --global enable pipewire-pulse
```

### sddm

#### guideline

```
sudo pacman -S sddm --noconfirm
```

```
sudo git clone https://github.com/blackbird-package/claw.git /tmp/claw
```

```
sudo cp -fr /tmp/claw/pkg.tar.xz /usr/share/sddm/themes
```
```
cd /usr/share/sddm/themes
```

```
sudo tar -xf pkg.tar.xz 
```

#### configuration

```
sudo mkdir /etc/sddm.conf.d/
```

```
sudo mv /usr/share/sddm/themes/claw/sddm-default.conf /etc/sddm.conf.d/default.conf
```

```
sudo vim /etc/sddm.conf.d/default.conf
```
change at `[Theme]`
```
Current=claw
```


#### service

```
sudo systemctl enable sddm
```


### profile
#### configuration

```
sudo vim /etc/profile
```

ensure append path
```
append_path '/opt/rbin'
```
