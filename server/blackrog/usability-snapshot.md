create snapshop

membuat snapshot
```
qemu-image snapshot -c snaparch arch.qcow2
```

list snapshot
```
qemu-image snapshot -l arch.qcow2
```

revert snapshot
```
qemu-image snapshot -a snaparch arch.qcow2
```
