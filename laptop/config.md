### local time

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

```
hwclock --systohc
```

### hosts

```
echo 'nama_hostname' > /etc/hostname
```

```
echo "127.0.0.1        localhost" > /etc/hosts
```

```
echo "127.0.0.1        nama_hostname" >> /etc/hosts
```

```
printf "\n\n" >> /etc/hosts
```

```
echo "::1              localhost ip6-localhost ip6-loopback" >> /etc/hosts
```

```
echo "ff02::1          ip6-allnodes" >> /etc/hosts
```

```
echo "ff02::2          ip6-allroutes" >> /etc/hosts
```


### locale

```
printf "en_US.UTF-8 UTF-8\n en_US ISO-8859-1" >> /etc/locale.gen
```

```
locale-gen && locale > /etc/locale.conf
```

```
sed -i '1s/.*/LANG=en_US.UTF-8/' /etc/locale.conf
```
### skel

```
mkdir /etc/skel/.config
```

```
git clone https://github.com/blackbird-package/skel /tmp/skel
```
```
mv /tmp/skel/skels/* /etc/skel/.config
```

```
rm /etc/profile /etc/bash.bashrc
```

```
cp /tmp/skel/profile /tmp/skel/bash.bashrc /etc/
```

```
git clone https://github.com/blackbird-package/conf.git /tmp/conf
```

```
 mv /tmp/conf/cfg/etc/skel/.local/ /etc/skel/
```

### themes

#### installation

```
git clone https://github.com/blackbird-package/flow.git /tmp/flow
```

#### configuration

```
mkdir /usr/share/themes
```

```
 mkdir /etc/skel/.themes
```

```
 tar -xf /tmp/flow/pkg.tar.xz -C /usr/share/themes/
```

```
 tar -xf /tmp/flow/pkg.tar.xz -C /etc/skel/.themes/
```


### icons

```
 git clone https://github.com/blackbird-package/eggs.git /tmp/eggs
```

#### configuration

```
mkdir /etc/skel/.icons
```

```
tar -xf /tmp/eggs/pkg.tar.xz -C /usr/share/icons/
```

```
tar -xf /tmp/eggs/pkg.tar.xz -C /etc/skel/.icons/
```


### operational user

```
useradd -m nama_user
```

```
passwd nama_user
```

```
echo "nama_user ALL=(ALL:ALL) ALL" > /etc/sudoers.d/00_nama_user
```

### system user

```
useradd -m yuros
```

```
passwd yuros
```

```
echo "yuros ALL=(ALL:ALL) ALL" > /etc/sudoers.d/01_yuros
```

### remove access to user root

```
passwd -l root
```
