### trouble

aplikasi flatpak tidak bisa di open, (ldconfig failed, exists status 256)

### solving

```
sudo chmod u+s $(which bwrap)
```

(optional)
```
sudo flatpak -v --reinstall-all
```

