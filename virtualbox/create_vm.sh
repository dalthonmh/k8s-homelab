# Creacion de maquina virtual en VirtualBox usando VBoxManage
# Creation: 30/10/2025
# Author: dalthonmh

# Nota: "spacex" es el nombre de la VM que vamos a crear

# -----------------------------------------------
# 1. Verificación del nombre del adaptador de red Wifi
VBoxManage list bridgedifs | grep -i name
# En el comando VBoxManage modifyvm "spacex", reemplazar en bridgeadapter1 el nombre del adaptador al de Wifi
# Ejemplo: "--bridgeadapter1 "en0: Wi-Fi""
# -----------------------------------------------



# -----------------------------------------------
# 2. Crear la VM en VirtualBox
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
  --nic1 bridged \
  --bridgeadapter1 "en0: Wi-Fi" \
  --nictype1 82540EM \
  --cableconnected1 on

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
# 3. Eliminar la maquina virtual
VBoxManage controlvm "spacex" poweroff
VBoxManage unregistervm "spacex" --delete
# -----------------------------------------------