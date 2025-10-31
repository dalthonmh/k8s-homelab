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
