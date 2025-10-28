## qemu
### instalation
```
sudo pacman -S qemu static qemu-user qemu-desktop net-tools
```
### configuration
```
sudo nvim /etc/qemu/bridge.conf
```
add line this
```
allow bridge
```
## podman
### instalation
```
sudo pacman -S podman crun podman-compose
```
### configuration
```
sudo nvim /etc/containers/registries.conf.d/10-unqualified-search-registries.conf
```
add
```
unqualified-search-registries = ["docker.io"]
```
