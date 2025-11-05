# Debian 13 Installation Automation

This preseed file automates the installation of Debian 13 (Trixie) for environments such as Hyper-V, VirtualBox, or bare-metal hardware. It configures key aspects such as localization, networking, accounts, partitioning, base system, repositories, and final commands to optimize the installation.

## 1. Configuration Summary

- **Localization and Networking**: English language, US keyboard, DHCP networking with default hostname.
- **Accounts**: Disables direct root access, creates an admin user with sudo privileges.
- **Partitioning**: Wipes the disk, uses ext4 without swap, and configures automatic partitioning.
- **Base System**: Installs the generic AMD64 kernel and enables additional firmware.
- **Repositories and Packages**: Activates non-free/contrib sections, installs basic tools and SSH, and enables automatic updates.
- **Bootloader**: Installs GRUB on the main disk with fast boot enabled.
- **Final Commands**: Adjusts SSH, enables essential services like Swap memory, and performs post-installation cleanup and updates.

## 2. Installation Steps

### 2.1. Verify Python Installation

Ensure Python is installed:

```bash
python --version
# Python 3.12.6
```

### 2.2. Start a Local Server for the Preseed File

1. Navigate to the directory where the `preseed.cfg` file is located:

   ```bash
   cd /k8s-homelab/debian
   python3 -m http.server 8090
   ```

2. During the Debian installation:
   - Select: **Advanced options → Automated install**.
   - [When prompted](/docs/debian-installation-request-preseed.png) for the preseed file, enter the URL:
     ```
     http://<server-ip>:8090/preseed.cfg
     ```

### 2.3. Configure a Static IP Address

After installing the operating system, configure a static IP address:

1. Edit the network interfaces configuration file:

   ```bash
   sudo vim /etc/network/interfaces
   ```

2. Update the file with the desired configuration:

   ```bash
   # This file describes the network interfaces available on your system
   # and how to activate them. For more information, see interfaces(5).

   source /etc/network/interfaces.d/*

   # The loopback network interface
   auto lo
   iface lo inet loopback

   # The primary network interface
   auto eth0
   iface eth0 inet static
       address 192.168.0.202
       netmask 255.255.255.0
       gateway 192.168.0.1
       dns-nameservers 8.8.8.8 1.1.1.1
   ```

3. Save the changes and restart the networking service:

   ```bash
   sudo systemctl restart networking
   ```

### 2.4. Change the Node Name

To change the node name (hostname):

```bash
sudo hostnamectl set-hostname <new-name>
hostname
```

## 3. Configure Passwordless sudo on Debian VMs

Change the default editor to a more convenient one:

```bash
sudo update-alternatives --config editor
```

On each Debian virtual machine, edit the sudoers file:

```bash
sudo visudo
```

Add the following line at the end of the file (replace `superadmin` with your actual username):

```bash
superadmin ALL=(ALL) NOPASSWD:ALL
```
