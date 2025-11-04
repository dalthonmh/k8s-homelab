# Abrir PowerShell como Administrador
# Creación: 28/10/2025
# Autor: dalthonmh


# -----------------------------------------------
# 1. Crear VM Generación 2
# Nota: crewdragon es el nombre de la VM que vamos a crear
New-VM -Name "crewdragon" `
    -MemoryStartupBytes 2GB `
    -Generation 2 `
    -NewVHDPath "C:\Hyper-V\crewdragon.vhdx" `
    -NewVHDSizeBytes 20GB `
    -SwitchName "Default Switch"

# Desactivar memoria dinámica
Set-VMMemory -VMName "crewdragon" `
    -DynamicMemoryEnabled $false

# Configurar procesadores
Set-VMProcessor -VMName "crewdragon" -Count 2

# Deshabilitar Secure Boot (importante para instalación)
Set-VMFirmware -VMName "crewdragon" -EnableSecureBoot Off

# Adjuntar ISO de Debian
Add-VMDvdDrive -VMName "crewdragon" `
    -Path "D:\iso\debian-13-amd64-netinst.iso"

# Configurar boot desde DVD primero
$dvd = Get-VMDvdDrive -VMName "crewdragon"
Set-VMFirmware -VMName "crewdragon" -FirstBootDevice $dvd
# -----------------------------------------------



# -----------------------------------------------
# 2. Configuracion de red
# Listar switches disponibles
Get-VMSwitch
# Crear un switch externo en modo bridge usando el Wi-Fi
New-VMSwitch -Name "WiFi-Bridge" -NetAdapterName "Wi-Fi" -AllowManagementOS $true
# -----------------------------------------------



# -----------------------------------------------
# 3. Establecer la red luego de instalar el sistema operativo
Connect-VMNetworkAdapter -VMName "crewdragon" -SwitchName "WiFi-Bridge"
# -----------------------------------------------



# -----------------------------------------------
# 4. Eliminar la maquina virtual
Remove-VM -Name "crewdragon" -Force
# -----------------------------------------------
