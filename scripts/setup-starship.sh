#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Install starship if not present
if ! command -v starship &>/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Copy starship config
echo "Installing Starship config..."
mkdir -p ~/.config
cp "$REPO_DIR/configs/starship.toml" ~/.config/starship.toml

echo "Starship configured."
