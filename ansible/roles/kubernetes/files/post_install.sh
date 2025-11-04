#!/bin/bash
# post-install.sh
# Created: 2025-11-03, dalthonmh
# Description:
# Automates the post-installation setup of a Kubernetes cluster. Designed to
# be executed on the master node, it performs the following:
# 1. Initializes the Kubernetes control plane (if not already initialized).
# 2. Configures kubectl for the master node user.
# 3. Installs the Calico network plugin for pod networking.
# 4. Connects worker nodes to the cluster using SSH.
# 5. Verifies the cluster status (nodes and pods).
#
# Requirements:
# - Run this script as root or with sudo privileges.
# - Ensure "hosts.ini" is in the same directory.
# - Worker nodes must be accessible via SSH. (previously set up with setup_ssh.sh)
#
# Usage:
#   sudo ./post_install.sh


# Rollback when any command fails
set -euo pipefail

INVENTORY_FILE="./hosts.ini"
USER="superadmin"

# Function to get worker node IPs from hosts.ini
get_workers() {
  awk '/\[workers\]/{flag=1; next} /\[/{flag=0} flag && NF' "$INVENTORY_FILE" | awk '{for (i=1; i<=NF; i++) if ($i ~ /^ansible_host=/) {split($i, a, "="); print a[2]}}'
}

init_master() {
  if [ ! -f /etc/kubernetes/admin.conf ]; then
    echo "Initializing Kubernetes control plane on the master node..."
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16
  else
    echo "Kubernetes control plane is already initialized."
  fi
}

setup_kubectl() {
  echo "Configuring kubectl for user $USER..."
  mkdir -p /home/$USER/.kube
  sudo cp -i /etc/kubernetes/admin.conf /home/$USER/.kube/config
  sudo chown $USER:$USER /home/$USER/.kube/config
  export KUBECONFIG=/home/$USER/.kube/config
}

install_calico() {
  echo "Installing Calico network plugin..."
  sudo -u $USER kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml --validate=false
}

get_join_command() {
  sudo kubeadm token create --print-join-command
}

join_workers() {
  local JOIN_CMD="$1"
  local WORKERS=$(get_workers)

  for NODE in $WORKERS; do
    echo "Connecting worker node $NODE to the cluster..."
    ssh -o StrictHostKeyChecking=no $USER@$NODE "sudo $JOIN_CMD"
  done
}

check_cluster() {
  echo "Checking cluster status..."
  sudo -u $USER kubectl get nodes -o wide
  sudo -u $USER kubectl get pods -A
}

# Main script execution
main() {
  echo "=========================="
  echo "   Kubernetes Post Setup  "
  echo "=========================="

  init_master
  setup_kubectl
  install_calico

  JOIN_CMD=$(get_join_command)
  echo "Join command: $JOIN_CMD"

  join_workers "$JOIN_CMD"
  check_cluster

  echo "Cluster setup completed successfully."
}

main