#!/bin/bash

set -e

# If installation steps have changed, see:
# https://docs.docker.com/engine/install/ubuntu/

if command -v docker &>/dev/null && docker compose version &>/dev/null; then
    echo "Docker and Docker Compose are already installed."

    if ! groups | grep -q '\bdocker\b'; then
        echo "⚠ Your user is not in the 'docker' group. Adding now..."
        sudo usermod -aG docker "$USER"
        echo "Log out and back in for the group change to take effect."
    fi

    exit 0
fi

echo "Installing Docker and Docker Compose..."

sudo apt update && sudo apt install -y docker.io docker-compose-v2

# Let the current user run docker without sudo
if ! groups | grep -q '\bdocker\b'; then
    sudo usermod -aG docker "$USER"
fi

echo "Docker installed."
echo "⚠ Log out and back in for the 'docker' group to take effect."
