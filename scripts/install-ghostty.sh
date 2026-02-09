#!/bin/bash

set -e

# If installation steps have changed, see:
# https://github.com/mkasberg/ghostty-ubuntu

if command -v ghostty &>/dev/null; then
    echo "Ghostty is already installed."
    exit 0
fi

echo "Installing Ghostty..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

echo "Ghostty installed."
