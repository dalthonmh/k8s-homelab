# Virtual Machine creation in VirtualBox using VBoxManage
# Creation: 2025-10-30
# Author: dalthonmh

# Note: "spacex" is the name of the VM we are going to create.

# -----------------------------------------------
# 1. Verify the name of the Wifi network adapter
VBoxManage list bridgedifs | grep -i name
# In the VBoxManage modifyvm "spacex" command, replace the bridgeadapter1 name with the Wifi adapter name.
# Example: "--bridgeadapter1 "en0: Wi-Fi""
# -----------------------------------------------



# -----------------------------------------------
# 2. Create the VM in VirtualBox
VBoxManage createvm --name "spacex" --ostype "Debian_64" --register

# General configuration
VBoxManage modifyvm "spacex" \
  --memory 2048 \
  --cpus 2 \
  --vram 128 \
  --ioapic on \
  --audio-driver none \
  --usb off \
  --firmware bios \
  --nic1 bridged \
  --bridgeadapter1 "en0: Wi-Fi" \
  --nictype1 82540EM \
  --cableconnected1 on

# Create and attach a virtual hard disk
VBoxManage createhd --filename "$HOME/VirtualBox VMs/spacex/spacex.vdi" --size 20000 --format VDI
VBoxManage storagectl "spacex" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "spacex" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/spacex/spacex.vdi"

# Attach the installation ISO
VBoxManage storagectl "spacex" --name "IDE Controller" --add ide
VBoxManage storageattach "spacex" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/dalthon/Documents/iso/debian-13-amd64-netinst.iso"

# Configure boot order
VBoxManage modifyvm "spacex" --boot1 dvd --boot2 disk

# Start the virtual machine
VBoxManage startvm "spacex" --type gui
# -----------------------------------------------



# -----------------------------------------------
# 3. Delete the virtual machine
VBoxManage controlvm "spacex" poweroff
VBoxManage unregistervm "spacex" --delete
# -----------------------------------------------