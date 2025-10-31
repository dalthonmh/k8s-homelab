# Instalación de una máquina virtual en MacOS

Este documento describe los pasos para crear y configurar una máquina virtual en VirtualBox con Debian 13 como sistema operativo.

## 1. Descarga de la imagen ISO

Descarga la imagen ISO del sistema operativo Debian 13 desde el siguiente enlace:

- [Debian Netinst ISO](https://www.debian.org/distrib/netinst)

> **Nota:** Guarda el archivo ISO en una ubicación accesible, como:  
> /Users/dalthon/Documents/iso/debian-13-amd64-netinst.iso.

## 2. Instalación de VirtualBox

Instala VirtualBox en tu sistema usando Homebrew:

```bash
brew update
brew install --cask virtualbox
```

Verifica que VirtualBox se haya instalado correctamente:

```bash
VBoxManage --version
```

## 3. Crear y Configurar la Máquina Virtual

Ejecuta los comandos del archivo [create_vm.sh](/virtualbox/create_vm.sh) para crear y configurar la máquina virtual. Asegúrate de que el archivo ISO esté en la ruta especificada.

Comandos básicos:

### 3.1. Iniciar la máquina virtual

```bash
VBoxManage startvm "spacex" --type gui
```

### 3.2. Eliminar la maquina virtual

```bash
VBoxManage controlvm "spacex" poweroff
VBoxManage unregistervm "spacex" --delete
```

## 4. Instalación Automática con Preseed

Para realizar una instalación automatizada usando un archivo preseed:

1. Levanta un servidor local para servir el archivo `preseed.cfg`

   ```bash
   cd /k8s-homelab/debian
   python3 -m http.server 8090
   ```

   > Puedes guiarte de: [README](/debian/README.md).

2. Durante la instalación de Debian:

   - Selecciona: Advanced options → Automated install.
   - Cuando [se solicite](/docs/debian-installation-request-preseed.png) el archivo preseed, ingresa la URL del archivo:
     `http://192.168.0.118:8090/preseed.cfg`

3. Continúa con la instalación automatizada.

## 5. Configuración de una IP estática

Después de instalar el sistema operativo, configura una dirección IP estática siguiendo estos pasos:

1. Edita el archivo de configuración de interfaces de red:

   ```bash
   sudo vim /etc/network/interfaces
   ```

2. Actualiza el archivo con la siguiente configuración, reemplazando `192.168.0.200` con la dirección IP deseada:

   ```sh
   # This file describes the network interfaces available on your system
   # and how to activate them. For more information, see interfaces(5).

   source /etc/network/interfaces.d/*

   # The loopback network interface
   auto lo
   iface lo inet loopback

   # The primary network interface
   auto enp0s3
   iface enp0s3 inet static
       address 192.168.0.200
       netmask 255.255.255.0
       gateway 192.168.0.1
       dns-nameservers 8.8.8.8 1.1.1.1
   ```

3. Guarda los cambios y reinicia el servicio de red para aplicar la configuración:

   ```sh
   sudo systemctl restart networking
   ```

## 6. Cambiar el nombre del Nodo

Para cambiar el nombre del nodo (hostname):

```sh
sudo hostnamectl set-hostname spacex
hostname
```
