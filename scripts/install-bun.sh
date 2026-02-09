#!/bin/bash

set -e

if command -v bun &>/dev/null; then
    echo "Bun is already installed: $(bun --version)"
    exit 0
fi

echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

echo "Bun installed."
