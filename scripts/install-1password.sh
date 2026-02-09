#!/bin/bash

set -e

# If installation steps have changed, see:
# https://support.1password.com/install-linux/#get-1password-for-linux

if command -v 1password &>/dev/null; then
    echo "1Password is already installed."
    exit 0
fi

echo "Installing 1Password (apt repo, non-sandboxed)..."

# Add the GPG key
curl -sS https://downloads.1password.com/linux/keys/1password.asc \
    | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

# Add the apt repository
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' \
    | sudo tee /etc/apt/sources.list.d/1password.list

# Set up debsig verification
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol \
    | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc \
    | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# Install
sudo apt update && sudo apt install -y 1password

echo "1Password installed."
