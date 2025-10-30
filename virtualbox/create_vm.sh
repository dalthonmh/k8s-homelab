# Creacion de maquina virtual en VirtualBox usando VBoxManage
# Creation: 30/10/2025
# Author: dalthonmh


# -----------------------------------------------
# 1. Crear la VM en VirtualBox
# Nota: "spacex" es el nombre de la VM que vamos a crear
VBoxManage createvm --name "spacex" --ostype "Debian_64" --register

# Configuración general
VBoxManage modifyvm "spacex" \
  --memory 2048 \
  --cpus 2 \
  --vram 128 \
  --ioapic on \
  --audio-driver none \
  --usb off \
  --firmware bios \
  --nic1 nat \
  --cableconnected1 on \
  --nictype1 82540EM

# Crear y adjuntar disco duro virtual
VBoxManage createhd --filename "$HOME/VirtualBox VMs/spacex/spacex.vdi" --size 20000 --format VDI
VBoxManage storagectl "spacex" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "spacex" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/spacex/spacex.vdi"

# Adjuntar la ISO de instalación
VBoxManage storagectl "spacex" --name "IDE Controller" --add ide
VBoxManage storageattach "spacex" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/Users/dalthon/Documents/iso/debian-13-amd64-netinst.iso"

# Configurar orden de arranque
VBoxManage modifyvm "spacex" --boot1 dvd --boot2 disk

# Iniciar la máquina virtual
VBoxManage startvm "spacex" --type gui
# -----------------------------------------------



# -----------------------------------------------
# 2. Eliminar la maquina virtual
VBoxManage controlvm "spacex" poweroff
VBoxManage unregistervm "spacex" --delete
# -----------------------------------------------