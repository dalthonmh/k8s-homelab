# Instalación de máquinas virtuales en Hyper-V

## Pasos previos:

Habilitar Hyper-V en Windows, esto se logra de la siguiente manera:

Entrar a:

1. Panel de control
2. Programas
3. Programas y características
4. Activar o desactivar las características de Windows
5. Habilitamos el check para Hyper-V
6. Reiniciamos el equipo

Descargar la ISO del sistema operativo a instalar.

- [debian](https://www.debian.org/distrib/netinst)

## Recursos a considerar

Definimos la cantidad de recursos a usar de acuerdo a la capacidad del equipo.

- Nombre: falcon9
- Generación: 2
- Memoria: 2 GB de RAM
- Procesadores: 2 núcleos
- Disco duro: 20 GB (VHDX)
- Firmware: Secure Boot deshabilitado
- ISO adjunto: Debian 13 (Netinst)
- Orden de arranque: DVD primero
- Red: Conexión a un switch externo en modo bridge (WiFi-Bridge)

## Ejecutar los comandos

En el archivo powershell.ps1 ejecutamos los comandos para `1. Crear VM Generación 2`

## Configuración de la red

Configuraremos la red para poner una IP estática al sistema operativo.

### Mediante comandos

Crear un switch externo en modo bridge usando el Wi-Fi

```ps1
New-VMSwitch -Name "WiFi-Bridge" -NetAdapterName "Wi-Fi" -AllowManagementOS $true
```

### Configuración asistida gráficamente (opcional)

1. Entramos al Administrador de Hyper-V
2. Entramos a la configuración de comnutadores virtuales
3. Creamos un nuevo conmutador de tipo Externo
4. De nombre le ponemos "WiFi-Bridge"
5. En tipo de conexión seleccionamos la que contenga "Wi-Fi Adapter"

Luego de instalar el sistema operativo para que tenga IP estática, configuraremos lo siguiente:

```ps1
Connect-VMNetworkAdapter -VMName "falcon9" -SwitchName "WiFi-Bridge"
```

Dentro del sistema operativo actualizamos esta configuración

```sh
vim /etc/network/interfaces
```

Actualizamos a la siguiente configuración donde 192.168.0.112 es la ip que colocaremos

```sh
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
    address 192.168.0.112
    netmask 255.255.255.0
    gateway 192.168.0.1
    dns-nameservers 8.8.8.8 1.1.1.1
```

Actualizamos la configuración

```sh
sudo systemctl restart networking
```

Cambiamos el nombre del nodo

```sh
sudo hostnamectl set-hostname falcon9
hostname
```
