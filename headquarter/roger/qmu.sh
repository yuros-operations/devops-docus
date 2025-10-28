#!/bin/bash

qemu-system-x86_64 \
	-enable-kvm \
	-m 4096 \
	-smp 2 \
	-machine type=q35 \
	-cpu host \
	-device intel-iommu \
	-drive if=pflash,format=raw,readonly=on,file=/home/luci/Downloads/OVMF_CODE.4m.fd \
	-drive if=pflash,format=raw,file=/home/luci/Downloads/OVMF_VARS.4m.fd \
	-rtc base=utc \
	-display gtk,show-cursor=on \
	-device e1000,netdev=net0 \
	-netdev user,id=net0,hostfwd=tcp::5555-:22 \
	-usb -device usb-tablet \
	-hda ~/Downloads/arch.qcow2  


