#!/bin/bash
# set-static-ip.sh
# Created: 2025-11-04, dalthonmh
# Description:
# This script configures a static IP address and hostname on a Debian 13 system.
# It also sets up passwordless sudo for a user and optionally changes the default editor.
#
# Requirements:
# - Run this script as root or with sudo privileges.
# - Provide the static IP address, hostname, and optionally the username.
#
# Usage:
#   sudo ./set-static-ip.sh <STATIC_IP> <HOSTNAME> [USERNAME]
#
# Example:
#   sudo ./set-static-ip.sh 192.168.0.200 spacex superadmin

# ------------------------------------
# Validate execution permissions
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

# ------------------------------------
# Variables
STATIC_IP="$1"
HOSTNAME="$2"
USERNAME=${3:-'superadmin'}
NETMASK="255.255.255.0"
GATEWAY="192.168.0.1"
DNS="8.8.8.8 1.1.1.1"
INTERFACES_FILE="/etc/network/interfaces"
BACKUP_FILE="/etc/network/interfaces.bak_$(date +%F_%H-%M-%S)"

# ------------------------------------
# Step 1. Validate input parameters
if [ -z "$STATIC_IP" ] || [ -z "$HOSTNAME" ]; then
    echo "Missing parameters. [USERNAME] is optional, default is 'superadmin'."
    echo "Usage: $0 <STATIC_IP> <HOSTNAME> [USERNAME]"
    echo "Example: $0 192.168.0.200 spacex superadmin"
    exit 1
fi

# ------------------------------------
# Step 2. Detect the active network interface (excluding 'lo')
INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)

if [ -z "$INTERFACE" ]; then
    echo "No active network interface detected."
    exit 1
fi

echo "👉 Detected network interface: $INTERFACE"

# ------------------------------------
# Step 3. Configure static IP
# Backup the original configuration file
cp "$INTERFACES_FILE" "$BACKUP_FILE"
echo "👉 Backup saved to: $BACKUP_FILE"

# Create the new configuration file
cat > "$INTERFACES_FILE" <<EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto $INTERFACE
iface $INTERFACE inet static
     address $STATIC_IP
     netmask $NETMASK
     gateway $GATEWAY
     dns-nameservers $DNS
EOF

echo "👉 Network configuration updated."

# Restart the network service to apply changes
systemctl restart networking
echo "👉 Network service restarted."

# ------------------------------------
# Step 4. Update hostname
hostnamectl set-hostname "$HOSTNAME"
echo "👉 Hostname updated to: $HOSTNAME"

# ------------------------------------
# Step 5. Configure passwordless sudo
if ! grep -q "^$USERNAME ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo "👉 Passwordless sudo configured for $USERNAME."
else
    echo "👉 Passwordless sudo already configured for $USERNAME."
fi

# ------------------------------------
# Step 6. (Optional) Change default editor
if command -v update-alternatives &> /dev/null; then
    echo "Changing default editor to vim.basic..."
    update-alternatives --set editor /usr/bin/vim.basic
    echo "👉 Default editor changed to vim.basic."
else
    echo "👉 update-alternatives is not available. Skipping editor configuration."
fi

# ------------------------------------
# Finalize
echo "👉 Configuration completed. Please reboot the server to apply all changes."
echo "sudo systemctl reboot"
