#!/bin/bash

set -e

# If installation steps have changed, see:
# https://www.dropbox.com/install-linux
# Uses the "Ubuntu 22.10 or higher" .deb (latest version from the package server)

if command -v dropbox &>/dev/null; then
    echo "Dropbox is already installed."
    exit 0
fi

echo "Installing Dropbox..."

DROPBOX_VERSION=$(wget -qO- https://linux.dropbox.com/packages/ubuntu/ | grep -oP 'dropbox_\K[0-9.]+(?=_amd64\.deb)' | sort -V | tail -1)
echo "Latest version: $DROPBOX_VERSION"

wget -q -O /tmp/dropbox.deb "https://linux.dropbox.com/packages/ubuntu/dropbox_${DROPBOX_VERSION}_amd64.deb"
sudo apt install -y /tmp/dropbox.deb
rm -f /tmp/dropbox.deb

echo "Dropbox installed. Run 'dropbox start -i' to launch and sign in."
