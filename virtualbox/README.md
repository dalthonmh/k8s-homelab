# Instalación de una máquina virtual en MacOS

## Descarga de la imagen ISO

Descargar el ISO del sistema operativo a instalar. En este caso será debian 13.

- [debian](https://www.debian.org/distrib/netinst)

> Nota: Colocarlo en una ruta de facil acceso porque será apuntado por el Vagrantfile,
> Ejemplo: /Users/dalthon/Documents/iso/debian-13-amd64-netinst.iso

## Instalación de virtualbox y vagrant

```bash
brew update
brew install --cask virtualbox
```

```bash
# Verificaciones de instalación
VBoxManage --version
```

## Levantar la maquina virtual

Ejecutamos los comandos de "1. Crear la VM en VirtualBox" del archivo create_vm.sh para crear la maquina virtual

**1. Iniciar la máquina virtual**

```bash
VBoxManage startvm "spacex" --type gui
```

**2. Eliminar la maquina virtual**

```bash
VBoxManage controlvm "spacex" poweroff
VBoxManage unregistervm "spacex" --delete
```

## Pasar comandos preset

Levantamos el servidor local con python como indica el [README](/debian/README.md).

1. En el menú principal, selecciona: "Advanced options" →

2. Luego selecciona: "Automated install"

3. Se nos mostrará una ventana con la siguiente imagen:

![Request preseed file](/docs/debian-installation-request-preseed.png)

Escribimos la dirección del preseed: http://192.168.0.118:8090/preseed.cfg
