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

En el archivo powershell.ps1 encontraremos los comandos para crear máquinas virtuales.
