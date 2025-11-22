# Open PowerShell as Administrator
# Created: 2025-10-28
# Author: dalthonmh


# -----------------------------------------------
# 1. Create Generation 2 VM
# Note: "newglenn" is the name of the VM we are going to create
New-VM -Name "newglenn" `
    -MemoryStartupBytes 2GB `
    -Generation 2 `
    -NewVHDPath "C:\Hyper-V\newglenn.vhdx" `
    -NewVHDSizeBytes 20GB `
    -SwitchName "Default Switch"

# Disable dynamic memory
Set-VMMemory -VMName "newglenn" `
    -DynamicMemoryEnabled $false

# Configure processors
Set-VMProcessor -VMName "newglenn" -Count 2

# Disable Secure Boot (important for installation)
Set-VMFirmware -VMName "newglenn" -EnableSecureBoot Off

# Attach Debian ISO
Add-VMDvdDrive -VMName "newglenn" `
    -Path "D:\iso\debian-13-amd64-netinst.iso"

# Configure boot from DVD first
$dvd = Get-VMDvdDrive -VMName "newglenn"
Set-VMFirmware -VMName "newglenn" -FirstBootDevice $dvd
# -----------------------------------------------



# -----------------------------------------------
# 2. Network Configuration
# List available switches
Get-VMSwitch
# Create an external switch in bridge mode using Wi-Fi
New-VMSwitch -Name "WiFi-Bridge" -NetAdapterName "Wi-Fi" -AllowManagementOS $true
# -----------------------------------------------



# -----------------------------------------------
# 3. Set up the network after installing the operating system
Connect-VMNetworkAdapter -VMName "newglenn" -SwitchName "WiFi-Bridge"
# -----------------------------------------------



# -----------------------------------------------
# 4. Delete the virtual machine
Remove-VM -Name "newglenn" -Force
# -----------------------------------------------