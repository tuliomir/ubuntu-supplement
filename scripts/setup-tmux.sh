#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Install TPM (Tmux Plugin Manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
    echo "TPM already installed."
else
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Copy tmux config
echo "Installing tmux config..."
cp "$REPO_DIR/configs/tmux.conf" ~/.tmux.conf

echo "tmux configured. Start tmux and press prefix + I to install plugins."
