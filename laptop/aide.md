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
aide -D
```
##### scanning file integration

```
aide -i
```

##### check system

```
aide -C
```

##### update baseline database

```
aide -u
```
