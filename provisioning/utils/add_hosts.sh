#!/bin/bash

IP="10.0.2.15"
DOMAINS=("jenkins.local" "grafana.local" "prometheus.local")
HOSTS_FILE="/etc/hosts"

for DOMAIN in "${DOMAINS[@]}"; do
    if ! grep -q "$DOMAIN" "$HOSTS_FILE"; then
        echo "Add $DOMAIN to $HOSTS_FILE"
        echo "$IP $DOMAIN" | sudo tee -a "$HOSTS_FILE" > /dev/null
    else
        echo "$DOMAIN already exist in $HOSTS_FILE"
    fi
done
