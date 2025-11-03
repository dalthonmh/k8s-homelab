#!/bin/bash

# Variables
SSH_KEY_NAME="id_ansible_master_debian"
SSH_DIR="$HOME/.ssh"
INVENTORY_FILE="./hosts.ini"
USER="superadmin"

# Función para obtener las IPs de los nodos trabajadores desde hosts.ini
get_workers() {
  awk '/\[workers\]/{flag=1; next} /\[/{flag=0} flag && NF' "$INVENTORY_FILE" | awk -F'=' '{print $2}'
}

# Create SSH key if it does not exist
if [ ! -f "$SSH_DIR/$SSH_KEY_NAME" ]; then
  echo "Generating SSH key..."
  ssh-keygen -t ed25519 -C "ansible@master" -f "$SSH_DIR/$SSH_KEY_NAME" -N ""
else
  echo "SSH key already exists: $SSH_DIR/$SSH_KEY_NAME"
fi

# Copy SSH public key to worker nodes
WORKERS=$(get_workers)
for WORKER in $WORKERS; do
  echo "Copying SSH key to $WORKER..."
  ssh-copy-id -i "$SSH_DIR/$SSH_KEY_NAME.pub" "$USER@$WORKER"
done

# Configure the ~/.ssh/config file
SSH_CONFIG="$SSH_DIR/config"
if ! grep -q "Host 192.168.0." "$SSH_CONFIG"; then
  echo "Configuring SSH config file..."
  for WORKER in $WORKERS; do
    cat <<EOF >> "$SSH_CONFIG"
Host $WORKER
    User $USER
    IdentityFile $SSH_DIR/$SSH_KEY_NAME
    IdentitiesOnly yes
EOF
  done
else
  echo "SSH config already contains worker nodes."
fi

echo "SSH configuration completed!"