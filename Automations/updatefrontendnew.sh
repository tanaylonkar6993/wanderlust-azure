#!/bin/bash

# Set the resource group and VM name
RESOURCE_GROUP="wanderlust-rg"
VM_NAME="Automate"

# Retrieve the public IP address of the specified Azure VM
ipv4_address=$(az vm show -d -g "$RESOURCE_GROUP" -n "$VM_NAME" --query publicIps -o tsv)

# Path to the .env file
file_to_find="../frontend/.env.docker"

# Check the current VITE_API_PATH in the .env file
current_url=$(cat $file_to_find)

# Update the .env file if the IP address has changed
if [[ "$current_url" != "VITE_API_PATH=\"http://${ipv4_address}:31100\"" ]]; then
    if [ -f $file_to_find ]; then
        sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" $file_to_find
    else
        echo "ERROR: File not found."
    fi
fi
