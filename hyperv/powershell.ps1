# Abrir PowerShell como Administrador
# Creación: 28/10/2025
# Autor: dalthonmh


# -----------------------------------------------
# 1. Crear VM Generación 2
# Nota: newglenn es el nombre de la VM que vamos a crear
New-VM -Name "newglenn" `
    -MemoryStartupBytes 2GB `
    -Generation 2 `
    -NewVHDPath "C:\Hyper-V\newglenn.vhdx" `
    -NewVHDSizeBytes 20GB `
    -SwitchName "Default Switch"

# Desactivar memoria dinámica
Set-VMMemory -VMName "newglenn" `
    -DynamicMemoryEnabled $false

# Configurar procesadores
Set-VMProcessor -VMName "newglenn" -Count 2

# Deshabilitar Secure Boot (importante para instalación)
Set-VMFirmware -VMName "newglenn" -EnableSecureBoot Off

# Adjuntar ISO de Debian
Add-VMDvdDrive -VMName "newglenn" `
    -Path "D:\iso\debian-13-amd64-netinst.iso"

# Configurar boot desde DVD primero
$dvd = Get-VMDvdDrive -VMName "newglenn"
Set-VMFirmware -VMName "newglenn" -FirstBootDevice $dvd
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
Connect-VMNetworkAdapter -VMName "newglenn" -SwitchName "WiFi-Bridge"
# -----------------------------------------------



# -----------------------------------------------
# 4. Eliminar la maquina virtual
Remove-VM -Name "newglenn" -Force
# -----------------------------------------------
