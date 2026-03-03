#!/bin/bash

set -e

# If installation steps have changed, see:
# https://discord.com/download

if command -v discord &>/dev/null; then
    echo "Discord is already installed."
    exit 0
fi

echo "Installing Discord..."

wget -q -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y /tmp/discord.deb
rm -f /tmp/discord.deb

echo "Discord installed."
