# Abrir PowerShell como Administrador
# Creación: 28/10/2025
# Autor: dalthonmh

# -----------------------------------------------
# Configuracion de red
# Crear un switch externo en modo bridge usando el Wi-Fi
New-VMSwitch -Name "WiFi-Bridge" -NetAdapterName "Wi-Fi" -AllowManagementOS $true
# -----------------------------------------------



# -----------------------------------------------
# Crear VM Generación 2
# Nota: falcon9 es el nombre de la VM que vamos a crear
New-VM -Name "falcon9" `
    -MemoryStartupBytes 2GB `
    -Generation 2 `
    -NewVHDPath "C:\Hyper-V\falcon9.vhdx" `
    -NewVHDSizeBytes 20GB `
    -SwitchName "Default Switch"

# Configurar procesadores
Set-VMProcessor -VMName "falcon9" -Count 2

# Deshabilitar Secure Boot (importante para instalación)
Set-VMFirmware -VMName "falcon9" -EnableSecureBoot Off

# Adjuntar ISO de Debian
Add-VMDvdDrive -VMName "falcon9" `
    -Path "D:\iso\debian-13-amd64-netinst.iso"

# Configurar boot desde DVD primero
$dvd = Get-VMDvdDrive -VMName "falcon9"
Set-VMFirmware -VMName "falcon9" -FirstBootDevice $dvd

# Setear la red
Connect-VMNetworkAdapter -VMName "falcon9" -SwitchName "WiFi-Bridge"



# -----------------------------------------------
# Eliminar la maquina virtual
Remove-VM -Name "falcon9" -Force
# -----------------------------------------------
