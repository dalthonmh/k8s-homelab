#!/bin/bash
# post-install.sh
# created: 2025-11-03, dalthonmh
# Automate the kubernetes setup after installation with Ansible.
# This file must be executed on the master node.

# Rollback when any command fails
set -euo pipefail

INVENTORY_FILE="./hosts.ini"
USER="superadmin"

# Función para obtener las IPs de los nodos trabajadores desde hosts.ini
get_workers() {
  awk '/\[workers\]/{flag=1; next} /\[/{flag=0} flag && NF' "$INVENTORY_FILE" | awk -F'=' '{print $2}'
}

init_master() {
  if [ ! -f /etc/kubernetes/admin.conf ]; then
    echo "Ejecutando kubeadm init en el nodo master..."
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16
  else
    echo "kubeadm ya está inicializado."
  fi
}

setup_kubectl() {
  echo "Configurando kubectl para el usuario $USER..."
  mkdir -p /home/$USER/.kube
  sudo cp -i /etc/kubernetes/admin.conf /home/$USER/.kube/config
  sudo chown $USER:$USER /home/$USER/.kube/config
  export KUBECONFIG=/home/$USER/.kube/config
}

install_calico() {
  echo "Instalando Calico..."
  sudo -u $USER kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml --validate=false
}

get_join_command() {
  echo "🔑 Generando comando de unión..."
  sudo kubeadm token create --print-join-command
}

join_workers() {
  local JOIN_CMD="$1"
  local WORKERS=$(get_workers)

  for NODE in $WORKERS; do
    echo "Conectando $NODE al clúster..."
    ssh -o StrictHostKeyChecking=no $USER@$NODE "sudo $JOIN_CMD"
  done
}

check_cluster() {
  echo "Verificando el estado del clúster..."
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
  echo "Comando de unión: $JOIN_CMD"

  join_workers "$JOIN_CMD"
  check_cluster

  echo "Clúster configurado exitosamente."
}

main
