#!/bin/bash
set -e

# https://github.com/mikf/gallery-dl
# Requires: pipx (see setup-python.sh)

if command -v gallery-dl &>/dev/null; then
    echo "gallery-dl is already installed."
    exit 0
fi

echo "Installing gallery-dl via pipx..."
pipx install gallery-dl

echo "gallery-dl installed."
