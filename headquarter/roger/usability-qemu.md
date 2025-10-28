#### create qcow
```
qemu-image create -f image_file.qcow <disk size>G
```

# network using systemd bridge
```
qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 -machine type=q35 -cpu host -device intel-iommu -vga virtio -rtc base=utc -display gtk,show-cursor=on -net nic,model=virtio -net bridge,br=bridge -usb -device usb-tablet -hda devels.qcow2
```

# Guest using ssh fordward method
```
qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 -machine type=q35 -cpu host -device intel-iommu -vga virtio -rtc base=utc -display none,show-cursor=on -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22 -usb -device usb-tablet -hda image_file.qcow2
```
### connect ssh

```
ssh localhost -p 5555
```
