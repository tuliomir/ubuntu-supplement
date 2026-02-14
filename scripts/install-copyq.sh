#!/bin/bash

set -e

# If installation steps have changed, see:
# https://copyq.readthedocs.io/en/latest/installation.html

if command -v copyq &>/dev/null; then
    echo "CopyQ is already installed."
    exit 0
fi

echo "Installing CopyQ (PPA)..."

# Add the PPA for the latest release
sudo add-apt-repository -y ppa:hluk/copyq

# Install
sudo apt update && sudo apt install -y copyq

echo "CopyQ installed."
