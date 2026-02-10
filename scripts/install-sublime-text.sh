#!/bin/bash

set -e

# If installation steps have changed, see:
# https://www.sublimetext.com/docs/linux_repositories.html#apt

if command -v subl &>/dev/null; then
    echo "Sublime Text is already installed."
    exit 0
fi

echo "Installing Sublime Text (apt repo)..."

# Add the GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg \
    | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null

# Add the apt repository (stable channel)
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' \
    | sudo tee /etc/apt/sources.list.d/sublime-text.sources > /dev/null

# Install
sudo apt update && sudo apt install -y sublime-text

echo "Sublime Text installed."
