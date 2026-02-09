#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Set keyboard to US International with dead keys
echo "Setting keyboard to US International with dead keys..."
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"

# Install custom XCompose for ' + c = ç
echo "Installing custom .XCompose..."
cp "$REPO_DIR/configs/XCompose" ~/.XCompose

echo "Keyboard configured."
echo "Log out and back in for .XCompose changes to take effect."
