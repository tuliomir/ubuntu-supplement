#!/bin/bash
set -e

if command -v pipx &>/dev/null; then
    echo "pipx is already installed."
else
    echo "Installing pipx and python3-venv..."
    sudo apt update && sudo apt install -y pipx python3-venv
    pipx ensurepath  # adds ~/.local/bin to PATH in .bashrc (idempotent)
    echo "pipx installed."
fi

# Make pipx available to subsequent scripts in the same session
export PATH="$HOME/.local/bin:$PATH"

echo "Python environment ready."
