#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
BASE_DIR="$SCRIPT_DIR/.."

OS_DISK="$BASE_DIR/os_disk.qcow2"
DATA_DISK="$BASE_DIR/data_disk.qcow2"
SPARE_DISK="$BASE_DIR/spare_disk.qcow2"

SSH_PORT=2224
HTTP_PORT=8082

qemu-system-x86_64 \
  -m 2G \
  -enable-kvm \
  -cpu host \
  -smp 2 \
  -drive file="$OS_DISK",format=qcow2,if=virtio \
  -drive file="$DATA_DISK",format=qcow2,if=virtio \
  -drive file="$SPARE_DISK",format=qcow2,if=virtio \
  -netdev user,id=n1,hostfwd=tcp::${SSH_PORT}-:22,hostfwd=tcp::${HTTP_PORT}-:80 \
  -device virtio-net-pci,netdev=n1 \
  -boot d
