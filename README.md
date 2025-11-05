[![Kubernetes](https://img.shields.io/badge/kubernetes-v1.34-blue.svg)](https://kubernetes.io)
[![Debian](https://img.shields.io/badge/debian-13-red.svg)](https://www.debian.org)
[![License](https://img.shields.io/badge/license-Apache%202.0-green.svg)](https://www.apache.org/licenses/LICENSE-2.0)

# Kubernetes Homelab Setup

This repository contains scripts, configurations, and documentation to set up a 3-node Kubernetes cluster distributed across multiple hypervisors.

- **Hypervisor**: Hyper-V or VirtualBox
- **OS**: Debian 13 (Trixie)
- **Kubernetes**: kubeadm, kubelet, kubectl
- **Container Runtime**: containerd
- **CNI**: Calico

## Architecture

```
                         🌐 Internet
                              │
                              │
                         ┌────▼────┐
                         │  Router │
                         │ Gateway │
                         └────┬────┘
                              │
                 ┌────────────┴────────────┐
                 │   LAN 192.168.0.0/24    │
                 └─┬────────────┬─────────┬┘
                   │            │         │
              ┌────▼─────┐ ┌────▼─────┐ ┌─▼───────┐
              │  spacex  │ │crewdragon│ │ falcon9 │
              │ (master) │ │ (worker) │ │(worker) │
              │   .200   │ │   .201   │ │  .202   │
              └──────────┘ └──────────┘ └─────────┘
```

## Cluster Resources

### Total Capacity

- **Total CPU**: 6 vCPUs (2 per node)
- **Total RAM**: 6 GB (2GB per node)
- **Worker Nodes**: 2 (crewdragon, falcon9)
- **Pod Capacity**: ~110 pods per node (approximately 220 pods across workers)

### Node Details

| Hostname       | Role                   | IP            | RAM | vCPU | Hypervisor   | Host    |
| -------------- | ---------------------- | ------------- | --- | ---- | ------------ | ------- |
| **spacex**     | Control Plane (Master) | 192.168.0.200 | 2GB | 2    | VirtualBox   | macOS   |
| **crewdragon** | Worker Node            | 192.168.0.201 | 2GB | 2    | Hyper-V Gen2 | Windows |
| **falcon9**    | Worker Node            | 192.168.0.202 | 2GB | 2    | Hyper-V Gen2 | Windows |

## Installation

Follow the steps described in the [easy_steps.txt](/easy_steps.txt) file.

## Credit

This role was created by dalthonmh@gmail.com.

Based on:

- Elias Igwegbu - https://galaxy.ansible.com/ui/namespaces/ecigwegbu/
- Copyright (c) 2025 Marouane - https://github.com/mlouguid/k8s-Ansible.git
