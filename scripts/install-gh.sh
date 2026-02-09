#!/bin/bash

set -e

if command -v gh &>/dev/null; then
    echo "GitHub CLI is already installed: $(gh --version | head -1)"
    exit 0
fi

echo "Installing GitHub CLI..."

GH_VERSION=$(wget -qO- https://api.github.com/repos/cli/cli/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
echo "Latest gh version: $GH_VERSION"

mkdir -p ~/.local/bin
wget -qO /tmp/gh.tar.gz "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz"
tar -xzf /tmp/gh.tar.gz -C /tmp
cp "/tmp/gh_${GH_VERSION}_linux_amd64/bin/gh" ~/.local/bin/gh
rm -rf /tmp/gh*

# Add ~/.local/bin to PATH if not already there
if ! echo "$PATH" | tr ':' '\n' | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "GitHub CLI installed: $(~/.local/bin/gh --version | head -1)"
echo ""
echo "Run 'gh auth login -p ssh' to authenticate and upload your SSH key."
