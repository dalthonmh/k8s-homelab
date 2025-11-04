# Configuración del cluster de Kubernetes

Este documento describe los pasos necesarios para configurar un clúster de Kubernetes utilizando Ansible y máquinas virtuales Debian.

## 1. Instalación de Ansible

Instalaremos Ansible en nuestro equipo para gestionar las máquinas virtuales.

- En macOS:

```bash
brew install ansible
ansible --version
```

> Nota: Asegúrate de que los servidores Debian tengan Python instalado y el servicio SSH habilitado.

## 2. Configuración del archivo /etc/hosts

Para que los nodos del clúster puedan comunicarse entre sí, agrega las siguientes entradas al archivo /etc/hosts en cada máquina Debian:

```bash
cat <<EOF | sudo tee -a /etc/hosts
192.168.0.200 spacex k8s-master
192.168.0.201 crewdragon k8s-worker1
192.168.0.202 falcon9 k8s-worker2
EOF
```

Esto asignará nombres a las direcciones IP de los nodos, facilitando su identificación.

## 3. Configurar acceso SSH

Para que Ansible pueda gestionar los nodos, configuraremos el acceso SSH sin contraseña desde el nodo de control MacBook.

### 3.1. Generar una clave SSH:

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "ansible@mac"
```

> Nota: Cuando se te pida un nombre para la clave, se puede usar algo como: id_ansible_mac_debian.

### 3.2. Copiar la clave pública a los nodos Debian

```bash
ssh-copy-id -i ~/.ssh/id_ansible_mac_debian.pub superadmin@192.168.0.200
ssh-copy-id -i ~/.ssh/id_ansible_mac_debian.pub superadmin@192.168.0.201
ssh-copy-id -i ~/.ssh/id_ansible_mac_debian.pub superadmin@192.168.0.202
```

Esto permitirá que desde el host (MacBook) se conecte a los nodos sin necesidad de ingresar una contraseña.

## 4. Configuración del Archivo ~/.ssh/config

Si tenemos múltiples claves SSH en la MacBook, puedes configurar el archivo ~/.ssh/config para que Ansible use automáticamente la clave correcta al conectarse a cada nodo.

### 4.1. Abre el archivo de configuración SSH:

```bash
vim ~/.ssh/config
```

### 4.2. Agrega las siguientes configuraciones para cada nodo:

```bash
# Nodo k8s-master (spacex)
Host 192.168.0.200
    User superadmin
    IdentityFile ~/.ssh/id_ansible_mac_debian
    IdentitiesOnly yes

# Nodo k8s-worker1 (crewdragon)
Host 192.168.0.201
    User superadmin
    IdentityFile ~/.ssh/id_ansible_mac_debian
    IdentitiesOnly yes

# Nodo k8s-worker2 (falcon9)
Host 192.168.0.202
    User superadmin
    IdentityFile ~/.ssh/id_ansible_mac_debian
    IdentitiesOnly yes
```

## 5. Comandos básicos de Ansible

Probar conexión con las VMs

```bash
ansible -i hosts.ini all -m ping
```

Ejecución del playbook:

```bash
ansible-playbook -i hosts.ini kube-play.yml
```
