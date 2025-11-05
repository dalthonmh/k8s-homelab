# Installing Virtual Machines on Hyper-V

## 1. Prerequisites

1. **Enable Hyper-V on Windows**:

   - Go to: Control Panel → Programs → Programs and Features → Turn Windows features on or off.
   - Check the Hyper-V box and restart your computer.

2. **Download the OS ISO**:
   - [Debian Netinst ISO](https://www.debian.org/distrib/netinst)

> **Note:** Save the ISO file in an accessible location, such as:  
> `D:\iso\debian-13-amd64-netinst.iso`.

## 2. Virtual Machine Configuration

- **Name**: `falcon9`
- **Generation**: 2
- **Memory**: 2 GB RAM
- **Processors**: 2 cores
- **Hard Disk**: 20 GB (VHDX)
- **Firmware**: Secure Boot disabled
- **Attached ISO**: Debian 13 (Netinst)
- **Boot Order**: DVD first
- **Network**: Connected to an external switch in bridge mode (`WiFi-Bridge`)

## 3. Steps to Create the Virtual Machine

1. Open PowerShell as Administrator.
2. Run the [powershell.ps1](/hyperv/powershell.ps1) script to automate the creation of the virtual machine.

## 4. Network Configuration

### 4.1. Create an External Switch

To connect the virtual machine to the network, create an external switch in bridge mode:

```powershell
New-VMSwitch -Name "WiFi-Bridge" -NetAdapterName "Wi-Fi" -AllowManagementOS $true
```

### 4.2. Graphical Configuration (Optional)

1. Open the Hyper-V Manager.
2. Go to the Virtual Switch Manager.
3. Create a new switch of type External.
4. Assign the name WiFi-Bridge.
5. Select the network adapter labeled "Wi-Fi Adapter."

### 4.3. Connect the Virtual Machine to the Switch

After creating the switch, connect the virtual machine:

```powershell
Connect-VMNetworkAdapter -VMName "falcon9" -SwitchName "WiFi-Bridge"
```
