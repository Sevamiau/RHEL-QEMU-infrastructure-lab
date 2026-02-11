
# RHEL-QEMU-Infrastructure-Lab

This project is a functional RHEL 9.5 lab environment designed to practice storage isolation, LVM architecture, and system automation. It uses a three-disk layout to simulate how enterprise servers manage system files independently from application data.

## System Architecture

The lab is built around a "Multi-Pool" strategy. By separating the OS from the variable data, the system stays stable even if logs or databases grow unexpectedly and fill up their respective partitions.

### Storage Design

| Disk | Size | LVM Volume Group | Mount Point | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **vda** | 20GB | `vg_system` | `/`, `swap` | System: Core OS and binaries. |
| **vdb** | 10GB | `vg_data` | `/var` | Data: Logs, Web files, and Databases. |
| **vdc** | 5GB | *N/A* | *Unallocated* | Spare: Raw physical volume for live scaling. |

**Note on isolation:** Mounting `/var` on a separate physical device is a standard practice to prevent "log-flooding" from crashing the root partition. If the data disk fills up, the OS remains responsive, allowing the admin to troubleshoot and expand the volume.

---

## Setup and Installation

### 1. Prerequisites
* **Host OS:** Fedora or any Linux distribution with KVM/QEMU support.
* **Packages:** `qemu-kvm`, `libvirt`, `python3`.
* **Hardware:** At least 2GB of free RAM and 35GB of disk space.

### 2. ISO Preparation
You need the **RHEL 9.5 Binary DVD ISO** from the Red Hat Developer Portal. 
* Place the ISO in the project root.
* Make sure it's named `rhel-9.5-x86_64-dvd.iso` or update the path in the startup scripts.

### 3. Provision the Virtual Disks
Run these commands from the project root to create the "bricks" for your lab:

```bash
qemu-img create -f qcow2 os_disk.qcow2 20G
qemu-img create -f qcow2 data_disk.qcow2 10G
qemu-img create -f qcow2 spare_disk.qcow2 5G
```

### 4. Running the Installer
Use the provided script to boot the environment. This is configured for a **Minimal Install** (headless) profile:
```bash
./scripts/install_lab.sh
```

---
### 5. System Registration

RHEL requires an active subscription to access the official repositories. Since this lab is for development, you can use a no-cost Red Hat Developer Subscription.

After your first login, you must register the system. Running this command will prompt you for your Red Hat Portal username and password:
```
sudo subscription-manager register --auto-attach
```

Once registered, the system will have full access to the BaseOS and AppStream repositories, allowing you to install packages like Apache, Python, and Neovim.


## Management and Automation

### Connectivity
Once the installation is complete, you can access the server via SSH from your host terminal using port `2224`:
```bash
ssh -p 2224 user@localhost
```

### Storage Verification
Use these standard LVM tools to check the health of the pools:
* `lsblk`: Check the physical disk mapping.
* `sudo vgs`: Verify the `vg_system` and `vg_data` separation.
* `sudo lvs`: Check the distribution of logical volumes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
