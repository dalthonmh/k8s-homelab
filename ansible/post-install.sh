#!/bin/bash

# Path to the Ansible inventory file
INVENTORY_FILE="./hosts.ini"

# Function to retrieve hostnames from the workers group in the Ansible inventory
get_workers() {
  awk '/\[debian\]/{flag=1; next} /\[/{flag=0} flag && NF' $INVENTORY_FILE | awk '{print $1}'
}

# Function to join the worker node to the Kubernetes cluster
join_worker_node() {
  local NODE_NAME=$1
  local JOIN_COMMAND=$2

  # SSH into the node using the superadmin user and execute the join command
  ssh -o StrictHostKeyChecking=no -T superadmin@$NODE_NAME << EOF
  echo "Joining $NODE_NAME to the Kubernetes cluster..."
  sudo $JOIN_COMMAND
EOF
}

# Main script execution
main() {
  echo "Setting up kubectl for the local user..."
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  export KUBECONFIG=$HOME/.kube/config

  echo "Installing network add-on (Calico)..."
  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml --validate=false

  echo "Retrieving join command..."
  JOIN_COMMAND=$(kubeadm token create --print-join-command)
  echo "Join command: $JOIN_COMMAND"

  echo "Retrieving worker nodes from Ansible inventory..."
  NODE_NAMES=$(get_workers)
  echo "Worker nodes: $NODE_NAMES"

  for NODE_NAME in $NODE_NAMES; do
    join_worker_node $NODE_NAME "$JOIN_COMMAND"
  done

  echo "Verifying cluster status..."
  kubectl get nodes
  kubectl get pods -A
}

main