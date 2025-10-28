create snapshop

membuat snapshot
```
qemu-image snapshot -c snapshot_name image.qcow2
```

list snapshot
```
qemu-image snapshot -l image.qcow2
```

revert snapshot
```
qemu-image snapshot -a snapshot_name image.qcow2
```
