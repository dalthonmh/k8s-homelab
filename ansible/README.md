# Kubernetes Cluster Configuration

This document describes the steps required to configure a Kubernetes cluster using Ansible and Debian virtual machines.

## 1. Installing Ansible

We will install Ansible on our machine to manage the virtual machines.

- On macOS:

```bash
brew install ansible
ansible --version
```

> Note: Ensure that the Debian servers have Python installed and the SSH service enabled.

## 2. Configuring the /etc/hosts File

To allow the cluster nodes to communicate with each other, add the following entries to the `/etc/hosts` file on each Debian machine:

```bash
cat <<EOF | sudo tee -a /etc/hosts
192.168.0.200 spacex k8s-master
192.168.0.201 crewdragon k8s-worker1
192.168.0.202 falcon9 k8s-worker2
EOF
```

This will assign names to the IP addresses of the nodes, making them easier to identify.

## 3. Configure SSH Access

To allow Ansible to manage the nodes, we will configure passwordless SSH access from the control node (MacBook).

### 3.1. Generate an SSH Key:

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "ansible@mac"
```

> Note: When prompted for a name for the key, you can use something like `id_ansible_mac_debian`.

### 3.2. Copy the Public Key to the Debian Nodes

```bash
ssh-copy-id -i ~/.ssh/id_ansible_mac_debian.pub superadmin@192.168.0.200
ssh-copy-id -i ~/.ssh/id_ansible_mac_debian.pub superadmin@192.168.0.201
ssh-copy-id -i ~/.ssh/id_ansible_mac_debian.pub superadmin@192.168.0.202
```

This will allow the host (MacBook) to connect to the nodes without needing to enter a password.

## 4. Configuring the ~/.ssh/config File

If you have multiple SSH keys on the MacBook, you can configure the `~/.ssh/config` file so that Ansible automatically uses the correct key when connecting to each node.

### 4.1. Open the SSH Configuration File:

```bash
vim ~/.ssh/config
```

### 4.2. Add the Following Configurations for Each Node:

```bash
# k8s-master node (spacex)

Host 192.168.0.200
User superadmin
IdentityFile ~/.ssh/id_ansible_mac_debian
IdentitiesOnly yes

# k8s-worker1 node (crewdragon)

Host 192.168.0.201
User superadmin
IdentityFile ~/.ssh/id_ansible_mac_debian
IdentitiesOnly yes

# k8s-worker2 node (falcon9)

Host 192.168.0.202
User superadmin
IdentityFile ~/.ssh/id_ansible_mac_debian
IdentitiesOnly yes
```

## 5. Basic Ansible Commands

Test the connection with the VMs:

```bash
ansible -i hosts.ini all -m ping
```

Run the playbook:

```bash
ansible-playbook -i hosts.ini kube-play.yml
```
