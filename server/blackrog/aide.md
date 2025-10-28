**installation aide**

```
cd /tmp
```

```
git clone https://aur.archlinux.org/aide.git
```

```
cd aide/
```

```
makepkg -sri --skippgpcheck
```
##### check file config

```
sudo aide -D
```
##### scanning file integration

```
sudo aide -i
```

##### check system

```
sudo aide -C
```

##### update baseline database

```
sudo aide -u
```
