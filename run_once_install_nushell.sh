#!/bin/bash

# Add Nushell GPG key to trusted sources
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg

# Add Nushell repository to sources list
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list

# Update the package list
sudo apt update

# Install Nushell
sudo apt install nushell -y
