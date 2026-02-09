#!/bin/bash

set -e

# If installation steps have changed, see:
# https://github.com/opencode-ai/opencode

if command -v opencode &>/dev/null; then
    echo "OpenCode is already installed: $(opencode --version 2>/dev/null || echo 'unknown version')"
    exit 0
fi

echo "Installing OpenCode..."
curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/refs/heads/main/install | bash

echo "OpenCode installed."
echo "Run 'opencode' in a project directory to get started."
