#!/bin/bash

set -e

# If installation steps have changed, see:
# https://tailscale.com/download/linux

if command -v tailscale &>/dev/null; then
    echo "Tailscale is already installed: $(tailscale version | head -1)"
    exit 0
fi

echo "Installing Tailscale (apt repo)..."

# Add the GPG key
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg \
    | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null

# Add the apt repository
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list \
    | sudo tee /etc/apt/sources.list.d/tailscale.list > /dev/null

# Install
sudo apt update && sudo apt install -y tailscale

echo "Tailscale installed."
echo ""
echo "Run 'sudo tailscale up' to authenticate and connect to your network."
