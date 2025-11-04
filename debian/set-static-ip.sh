#!/bin/bash
# Configure network and hostname in Debian 13
# Autor: dalthonmh@gmail.com
# Date: 2025-11-04

# ------------------------------------
# Validar permisos de ejecución
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse como root o con sudo."
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
# Step 1. Validar parámetros
if [ -z "$STATIC_IP" ] || [ -z "$HOSTNAME" ]; then
    echo "Faltan parámetros al script. [usuario] es opcional, default superadmin."
    echo "Uso: $0 ip hostname [usuario]"
    echo "Ejemplo: $0 192.168.0.200 spacex superadmin"
    exit 1
fi

# ------------------------------------
# Step 2. Detectar la interfaz activa (excluye 'lo')
INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)

if [ -z "$INTERFACE" ]; then
    echo "No se detectó ninguna interfaz de red activa."
    exit 1
fi

echo "👉 Interfaz detectada: $INTERFACE"

# ------------------------------------
# Step 3. Configurar IP estática
# Hacer backup del archivo original
cp "$INTERFACES_FILE" "$BACKUP_FILE"
echo "👉 Backup guardado en: $BACKUP_FILE"

# Crear archivo de configuración
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

echo "👉 Configuración de red actualizada."

# ------------------------------------
# Step 4. Cambiar hostname
hostnamectl set-hostname "$HOSTNAME"
echo "👉 Hostname cambiado a: $HOSTNAME"

# ------------------------------------
# Step 5. Configurar sudo sin contraseña
if ! grep -q "^$USERNAME ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo "👉 Configuración de sudo sin contraseña aplicada para $USERNAME."
else
    echo "👉 Configuración de sudo sin contraseña ya existe para $USERNAME."
fi

# ------------------------------------
# Step 6. (Opcional) Cambiar editor por defecto
if command -v update-alternatives &> /dev/null; then
    echo "Cambiando el editor por defecto a vim.basic..."
    update-alternatives --set editor /usr/bin/vim.basic
    echo "👉 Editor por defecto cambiado a vim.basic."
else
    echo "👉 update-alternatives no está disponible. Saltando configuración del editor."
fi

# ------------------------------------
# Finalizar
echo "👉 Configuración completada. Reinicia el servidor para aplicar todos los cambios."
echo "sudo systemctl reboot"