# Automatización de Instalación de Debian 13

Este archivo preseed automatiza la instalación de Debian 13 (Trixie) para entornos como Hyper-V, VirtualBox o hardware bare-metal. Configura aspectos clave como localización, red, cuentas, particionado, sistema base, repositorios, y comandos finales para optimizar la instalación.

## 1. Resumen de Configuración

- **Localización y Red**: Idioma inglés, teclado US, red DHCP con hostname predeterminado.
- **Cuentas**: Desactiva el acceso root directo, crea un usuario administrador con sudo.
- **Particionado**: Borra el disco, usa ext4 sin swap, y configura partición automática.
- **Sistema Base**: Instala el kernel genérico AMD64 y habilita firmware adicional.
- **Repositorios y Paquetes**: Activa secciones non-free/contrib, instala herramientas básicas y SSH, y habilita actualizaciones automáticas.
- **Cargador de Arranque**: Instala GRUB en el disco principal con inicio rápido.
- **Comandos Finales**: Ajusta SSH, habilita servicios esenciales, y realiza limpieza y actualizaciones post-instalación.

## 2. Pasos para la Instalación

### 2.1. Verificar Python Instalado

Asegúrate de tener Python instalado:

```bash
python --version
# Python 3.12.6
```

### 2.2. Levantar un Servidor Local para el Preseed

1. Navega al directorio donde se encuentra el archivo `preseed.cfg`:

   ```bash
   cd /k8s-homelab/debian
   python3 -m http.server 8090
   ```

2. Durante la instalación de Debian:
   - Selecciona: **Advanced options → Automated install**.
   - Cuando se solicite el archivo preseed, ingresa la URL:
     ```
     http://<IP-del-servidor>:8090/preseed.cfg
     ```

### 2.3. Configurar una IP Estática

Después de instalar el sistema operativo, configura una dirección IP estática:

1. Edita el archivo de configuración de interfaces de red:

   ```bash
   sudo vim /etc/network/interfaces
   ```

2. Actualiza el archivo con la configuración deseada:

   ```bash
   # This file describes the network interfaces available on your system
   # and how to activate them. For more information, see interfaces(5).

   source /etc/network/interfaces.d/*

   # The loopback network interface
   auto lo
   iface lo inet loopback

   # The primary network interface
   auto eth0
   iface eth0 inet static
       address 192.168.0.202
       netmask 255.255.255.0
       gateway 192.168.0.1
       dns-nameservers 8.8.8.8 1.1.1.1
   ```

3. Guarda los cambios y reinicia el servicio de red:

   ```bash
   sudo systemctl restart networking
   ```

### 2.4. Cambiar el Nombre del Nodo

Para cambiar el nombre del nodo (hostname):

```bash
sudo hostnamectl set-hostname <nuevo-nombre>
hostname
```
