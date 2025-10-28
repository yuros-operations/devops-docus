### local time

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

```
hwclock --systohc
```

### hosts

```
echo 'shanks' > /etc/hostname
```

```
echo "127.0.0.1        localhost" > /etc/hosts
```

```
echo "127.0.0.1        shanks" >> /etc/hosts
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
git clone https://github.com/blackbird-package/skel /tmp
```
```
mv /tmp/skels/* /etc/skel/.config
```

```
rm /etc/profile /etc/bash.bashrc
```

```
cp /tmp/profile /tmp/bash.bashrc /etc/
```

```
rm -fr /tmp/*
```

```
git clone https://github.com/blackbird-package/conf.git /tmp
```

```
 mv /tmp/cfg/etc/skel/.local/ /etc/skel/
```

```
rm -fr /tmp/*
```

### themes

#### installation


```
sudo git clone https://github.com/blackbird-package/flow.git /tmp
```

#### configuration

```
mkdir /usr/share/themes
```

```
 mkdir /etc/skel/.themes
```

```
 cp -rf /tmp/pkg.tar.xz /usr/share/themes/
```

```
 cp -rf /tmp/pkg.tar.xz /etc/skel/.themes/
```

```
 cd /usr/share/themes/
```

```
 tar -xf /usr/share/themes/pkg.tar.xz 
```

```
 cd /etc/skel/.themes/
```

```
 tar -xf /etc/skel/.themes/pkg.tar.xz 
```

```
rm -fr /tmp/*
```

### icons

```
 git clone https://github.com/blackbird-package/eggs.git /tmp
```

#### configuration

```
mkdir /etc/skel/.icons
```

```
cp -rf /tmp/pkg.tar.xz /usr/share/icons/
```

```
cp -rf /tmp/pkg.tar.xz /etc/skel/.icons/
```

```
cd /usr/share/icons/
```

```
tar -xf /usr/share/icons/pkg.tar.xz 
```

```
cd /etc/skel/.icons/ 
```

```
tar -xf /etc/skel/.icons/pkg.tar.xz 
```

```
rm -fr /tmp/*
```

```
cd /
```

### user

```
useradd -m lektor
```

```
echo "1511" | passwd lektor --stdin
```

```
useradd -m helios
```

```
echo "1511" | passwd helios --stdin
```

```
useradd -m devel
```

```
echo "1511" | passwd devel --stdin
```

```
echo 'helios ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_helios
```

```
passwd -l root
```
