#!/bin/bash

set -e

# If installation steps have changed, see:
# https://code.claude.com/docs/en/setup

if command -v claude &>/dev/null; then
    echo "Claude Code is already installed: $(claude --version 2>/dev/null || echo 'unknown version')"
    exit 0
fi

echo "Installing Claude Code (native installer)..."
curl -fsSL https://claude.ai/install.sh | bash

echo "Claude Code installed."
echo "Run 'claude' in a project directory to get started."
