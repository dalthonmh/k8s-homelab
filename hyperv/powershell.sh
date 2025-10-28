# Abrir PowerShell como Administrador

# starship es el nombre de la VM que vamos a crear
# -----------------------------------------------
# Eliminar la maquina virtual
Remove-VM -Name "starship" -Force
# -----------------------------------------------


# -----------------------------------------------
# Crear VM Generación 2
New-VM -Name "starship" `
    -MemoryStartupBytes 2GB `
    -Generation 2 `
    -NewVHDPath "C:\Hyper-V\starship.vhdx" `
    -NewVHDSizeBytes 20GB `
    -SwitchName "Default Switch"

# Configurar procesadores
Set-VMProcessor -VMName "starship" -Count 2

# Deshabilitar Secure Boot (importante para instalación)
Set-VMFirmware -VMName "starship" -EnableSecureBoot Off

# Adjuntar ISO de Debian
Add-VMDvdDrive -VMName "starship" `
    -Path "D:\iso\debian13-auto.iso"

# Configurar boot desde DVD primero
$dvd = Get-VMDvdDrive -VMName "starship"
Set-VMFirmware -VMName "starship" -FirstBootDevice $dvd



# Configuracion de red
# Crear switch interno (Host-Only)
New-VMSwitch -Name "Kubernetes-Internal" -SwitchType Internal

# Ver el adaptador creado
Get-NetAdapter | Where-Object {$_.Name -like "*Kubernetes*"}

# Configurar IP en el adaptador del host
New-NetIPAddress -IPAddress 192.168.0.112 `
    -PrefixLength 24 `
    -InterfaceAlias "vEthernet (Kubernetes-Internal)"

# Conectar VM al switch
Connect-VMNetworkAdapter -VMName "starship" `
    -SwitchName "Kubernetes-Internal"

# Agregar segundo adaptador para internet (NAT)
Add-VMNetworkAdapter -VMName "starship" `
    -SwitchName "Default Switch"


