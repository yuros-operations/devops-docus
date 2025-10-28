### local time

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

```
hwclock --systohc
```

### hosts

```
echo 'blackrog' > /etc/hostname
```

```
echo "127.0.0.1        localhost" > /etc/hosts
```

```
echo "127.0.0.1        blackrog" >> /etc/hosts
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


### user

```
echo 'lektor ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00_lektor
```

```
useradd -m lektor
```

```
usermod -aG wheel lektor
```

```
echo "1511" | passwd lektor --stdin
```

```
passwd -l root
```
