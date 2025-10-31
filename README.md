[![Kubernetes](https://img.shields.io/badge/kubernetes-v1.34-blue.svg)](https://kubernetes.io)
[![Debian](https://img.shields.io/badge/debian-13-red.svg)](https://www.debian.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

# Kubernetes Homelab Setup

Este repositorio contiene scripts, configuraciones y documentación para configurar un cluster Kubernetes de 3 nodos distribuidos entre múltiples hypervisors.

- **Hypervisor**: Hyper-V o VirtualBox
- **OS**: Debian 13 (Trixie)
- **Kubernetes**: kubeadm, kubelet, kubectl
- **Container Runtime**: containerd
- **CNI**: Calico / Flannel

## Arquitectura

```
                    🌐 Internet
                         │
                         │
                    ┌────▼────┐
                    │ Router  │
                    │ Gateway │
                    └────┬────┘
                         │
            ┌────────────┴────────────┐
            │    LAN 192.168.0.0/24   │
            └─┬──────────┬──────────┬─┘
              │          │          │
         ┌────▼───┐ ┌────▼───┐ ┌───▼────┐
         │spacex  │ │starship│ │falcon9 │
         │(master)│ │(worker)│ │(worker)│
         │  .200  │ │  .201  │ │  .202  │
         └────────┘ └────────┘ └────────┘
```

## Recursos del Cluster

### Capacidad Total

- **CPU Total**: 6 vCPUs (2 por nodo)
- **RAM Total**: 6 GB (2GB por nodo)
- **Nodos Worker**: 2 (starship, falcon9)
- **Capacidad Pods**: ~110 pods por nodo (aprox. 220 pods workers)

### Detalles de los Nodos

| Hostname     | Rol                    | IP            | RAM | vCPU | Hypervisor   | Host    |
| ------------ | ---------------------- | ------------- | --- | ---- | ------------ | ------- |
| **spacex**   | Control Plane (Master) | 192.168.0.200 | 2GB | 2    | VirtualBox   | macOS   |
| **starship** | Worker Node            | 192.168.0.201 | 2GB | 2    | Hyper-V Gen2 | Windows |
| **falcon9**  | Worker Node            | 192.168.0.202 | 2GB | 2    | Hyper-V Gen2 | Windows |

### /etc/hosts en todos los nodos

```bash
# Agregar en /etc/hosts de cada nodo
192.168.0.200   spacex      k8s-master
192.168.0.201   starship    k8s-worker1
192.168.0.202   falcon9     k8s-worker2
```
