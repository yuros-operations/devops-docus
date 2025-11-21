```
nvim /etc/pacman.conf
```

tambahkan 
```
[yuros]
Server = https://packages.yuros.org/x86_64/
```


di bawah 

```
Server = file:///home/custompkgs
```

```
pacman -Syy
```




fungtion:

app-opti: membersihkan cache
app-pure: menghapus package dan depedencies
app-must: force installing ketika ada konflik
app-del: untuk menghapus package tanpa depedencies 
app-sync: update database aplikasi
app-add: untuk menambahkan package
