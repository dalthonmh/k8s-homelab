# Instalación de Máquinas Virtuales en Hyper-V

## 1. Requisitos Previos

1. **Habilitar Hyper-V en Windows**:

   - Ve a: Panel de control → Programas → Programas y características → Activar o desactivar las características de Windows.
   - Activa la casilla de Hyper-V y reinicia el equipo.

2. **Descargar la ISO del sistema operativo**:
   - [Debian Netinst ISO](https://www.debian.org/distrib/netinst)

> **Nota:** Guarda el archivo ISO en una ubicación accesible, como:  
> D:\iso\debian-13-amd64-netinst.iso.

## 2. Configuración de la Máquina Virtual

- **Nombre**: `falcon9`
- **Generación**: 2
- **Memoria**: 2 GB de RAM
- **Procesadores**: 2 núcleos
- **Disco Duro**: 20 GB (VHDX)
- **Firmware**: Secure Boot deshabilitado
- **ISO adjunto**: Debian 13 (Netinst)
- **Orden de arranque**: DVD primero
- **Red**: Conexión a un switch externo en modo bridge (`WiFi-Bridge`)

## 3. Pasos para Crear la Máquina Virtual

1. Abre PowerShell como Administrador.
2. Ejecuta el archivo [powershell.ps1](/hyperv/powershell.ps1) para automatizar la creación de la máquina virtual.

## 4. Configuración de Red

### 4.1. Crear un Switch Externo

Para conectar la máquina virtual a la red, crea un switch externo en modo bridge:

```powershell
New-VMSwitch -Name "WiFi-Bridge" -NetAdapterName "Wi-Fi" -AllowManagementOS $true
```

### 4.2. Configuración Gráfica (Opcional)

1. Abre el Administrador de Hyper-V.
2. Ve a la configuración de conmutadores virtuales.
3. Crea un nuevo conmutador de tipo Externo.
4. Asigna el nombre `WiFi-Bridge`.
5. Selecciona el adaptador de red que contenga "Wi-Fi Adapter".

### 4.3. Conectar la Máquina Virtual al Switch

Después de crear el switch, conecta la máquina virtual:

```powershell
Connect-VMNetworkAdapter -VMName "falcon9" -SwitchName "WiFi-Bridge"
```
