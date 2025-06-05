#!/bin/bash

# Domains to remove from /etc/hosts
DOMAINS=("jenkins.local" "grafana.local" "prometheus.local")
HOSTS_FILE="/etc/hosts"

# Backup the original hosts file
sudo cp "$HOSTS_FILE" "$HOSTS_FILE.bak"

# Remove lines containing the specified domains
for DOMAIN in "${DOMAINS[@]}"; do
    echo "Removing $DOMAIN from $HOSTS_FILE"
    sudo sed -i.bak "/$DOMAIN/d" "$HOSTS_FILE"
done

echo "Done. Backup saved as $HOSTS_FILE.bak"
