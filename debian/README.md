# Automatización de instalación de Debian

## Definición

Instalación del pressed de debian13 mediante un servidor local.

Este archivo preseed automatiza la instalación de Debian 13 (Trixie) para entornos como Hyper-V, VMware o hardware bare-metal. Configura lo siguiente:

- **Localización y red**: Idioma inglés, teclado US, red DHCP con hostname predeterminado.
- **Cuentas**: Desactiva el acceso root directo, crea un usuario administrador con sudo.
- **Particionado**: Borra el disco, usa ext4 sin swap, y configura partición automática.
- **Sistema base**: Instala el kernel genérico AMD64 y habilita firmware adicional.
- **Repositorios y paquetes**: Activa secciones non-free/contrib, instala herramientas básicas y SSH, y habilita actualizaciones automáticas.
- **Cargador de arranque**: Instala GRUB en el disco principal con inicio rápido.
- **Comandos finales**: Ajusta SSH, habilita servicios esenciales, y realiza limpieza y actualizaciones post-instalación.

## Pasos de instalación

### 1. Tener python instalado.

```bash
$ python --version
Python 3.12.6
```

### 2. Levantar el servidor local

```bash
cd /k8s-homelab/debian
python -m http.server 8080
```

### 3. Entrar al menu grub en la instalación

En la siguiente imagen:
![Debian installation menu](/docs/debian-installation-menu.png)

Esribimos `c` para que nos muestre el menu del grub
![Debian installation grub](/docs/debian-installation-grub.png)

### 4. Escribir configuración

> Nota: Cambiar a la ip al de la máquina host.

```bash
linux /install.amd/vmlinuz auto=true preseed/url=http://192.168.0.116:8080/preseed.cfg priority=critical ---
initrd /install.amd/initrd.gz
boot
```

Listo!
