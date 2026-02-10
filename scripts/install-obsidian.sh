#!/bin/bash

set -e

# If installation steps have changed, see:
# https://obsidian.md/download
# https://github.com/obsidianmd/obsidian-releases/releases

if command -v obsidian &>/dev/null; then
    echo "Obsidian is already installed."
    exit 0
fi

echo "Installing Obsidian..."

OBSIDIAN_VERSION=$(wget -qO- https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
echo "Latest version: $OBSIDIAN_VERSION"

wget -q -O /tmp/obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb"
sudo apt install -y /tmp/obsidian.deb
rm -f /tmp/obsidian.deb

echo "Obsidian installed."
