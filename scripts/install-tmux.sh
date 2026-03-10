#!/bin/bash

set -e

if command -v tmux &>/dev/null; then
    echo "tmux is already installed."
    exit 0
fi

echo "Installing tmux..."
sudo apt-get update -qq
sudo apt-get install -y tmux

echo "tmux installed: $(tmux -V)"
