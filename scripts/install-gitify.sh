#!/bin/bash

set -e

# If installation steps have changed, see:
# https://gitify.io/
# https://github.com/gitify-app/gitify/releases

if command -v gitify &>/dev/null; then
    echo "Gitify is already installed."
    exit 0
fi

echo "Installing Gitify..."

GITIFY_VERSION=$(wget -qO- https://api.github.com/repos/gitify-app/gitify/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
echo "Latest version: $GITIFY_VERSION"

wget -q -O /tmp/gitify.deb "https://github.com/gitify-app/gitify/releases/download/v${GITIFY_VERSION}/gitify_${GITIFY_VERSION}_amd64.deb"
sudo apt install -y /tmp/gitify.deb
rm -f /tmp/gitify.deb

echo "Gitify installed."
