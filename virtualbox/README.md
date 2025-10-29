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
brew install --cask vagrant
```

```bash
# Verificaciones de instalación
VBoxManage --version
vagrant --version
```

## Levantar la maquina virtual

Vamos a la ruta donde esta el vagrantfile `cd virtualbox` y ejecutamos los comandos de inicialización:

```bash
vagrant init
vagrant up --no-provision
```

## Pasar comandos preset

Ejecutaremos los "Pasos de instalación" descritos en el [README](/debian/README.md) de debian para pasarle el archivo preseed.

### Comandos basicos vagrant

```bash
# Conectar por ssh
vagrant ssh

# Detener forma segura
vagrant halt

# Reiniciar la VM
vagrant reload

# Eliminar la VM
vagrant destroy
```
