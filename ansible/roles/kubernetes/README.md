# Kubernetes Role

This Ansible role automates the installation and configuration of a Kubernetes cluster using `kubeadm`. It sets up the necessary system prerequisites, installs Kubernetes core components (`kubeadm`, `kubelet`, `kubectl`), configures the container runtime (`containerd`), and performs post-installation tasks to ensure the cluster is ready for use.

The control plane and worker nodes have full password-less key-based authentication connectivity for the user 'superadmin' (with initial password: 'secret').

## Requirements

- Supported Operating Systems: Debian-based distributions: Debian 13 (Trixie).
- SSH access to all nodes with a user that has `sudo` privileges.
- The `hosts.ini` inventory file must define `master` and `workers` groups with their respective IPs and SSH users.

## Role Variables

The following variables can be customized to modify the versions and configurations used by this role. You can define these variables in a `variables` folder within the role or in your playbook, `group_vars`, or `host_vars`.

| Variable              | Default Value                                          | Description                                                           |
| --------------------- | ------------------------------------------------------ | --------------------------------------------------------------------- |
| `k8s_version`         | `1.34.1`                                               | Version of Kubernetes to install.                                     |
| `containerd_version`  | `2.1.`                                                 | Version of `containerd` to install.                                   |
| `pod_network_cidr`    | `192.168.0.0/16`                                       | CIDR range for the pod network (used by Calico or other CNI plugins). |
| `kubernetes_user`     | `superadmin`                                           | User on the master node for configuring `kubectl`.                    |
| `calico_manifest_url` | `https://docs.projectcalico.org/manifests/calico.yaml` | URL to the Calico manifest for pod networking.                        |

You can define these variables in your playbook or in `group_vars`/`host_vars`.

## Tasks Overview

The role is divided into the following steps:

1. **System Prerequisites**:

   - Installs required packages (e.g., `apt-transport-https`, `curl`).
   - Configures kernel modules and sysctl parameters for Kubernetes.

2. **Container Runtime Setup**:

   - Installs and configures `containerd` as the container runtime.

3. **Kubernetes Core Installation**:

   - Installs `kubeadm`, `kubelet`, and `kubectl`.
   - Ensures the services are enabled and running.

4. **Post-Installation Configuration**:

   - Applies sysctl tweaks and restarts necessary services.

5. **Master Node Setup**:

   - Copies helper scripts to the master node.
   - Initializes the Kubernetes control plane using `kubeadm init`.
   - Configures `kubectl` for the master node user.
   - Installs the Calico network plugin.

6. **Worker Node Setup**:
   - Generates the `kubeadm join` command for worker nodes.
   - Connects worker nodes to the cluster via SSH.

## Inventory File Example

Your hosts.ini file should look like this:

```
[master]
debian0 ansible_host=192.168.0.200 ansible_user=superadmin

[workers]
debian1 ansible_host=192.168.0.201 ansible_user=superadmin
debian2 ansible_host=192.168.0.202 ansible_user=superadmin

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

## Tags

The following tags are available to run specific parts of the role:

- prereqs: Installs system prerequisites.
- containerd: Installs and configures the container runtime.
- k8s: Installs Kubernetes core components.
- post: Runs post-installation tasks.
- copy-master: Copies scripts to the master node.

## Credit

This role was created by dalthonmh@gmail.com.

Based on:

- Copyright (c) 2025 Marouane - https://github.com/mlouguid/k8s-Ansible.git
- [Elias Igwegbu](https://www.linkedIn.com/in/elias-igwegbu) - https://galaxy.ansible.com/ui/namespaces/ecigwegbu/
