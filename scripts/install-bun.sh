#!/bin/bash

set -e

if command -v bun &>/dev/null; then
    echo "Bun is already installed: $(bun --version)"
    exit 0
fi

echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

# Add bun tab-completion to .bashrc (includes "bun run <script>" completion)
if ! grep -q 'bun completions' ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo '# bun completions (includes "bun run <script>" from package.json)' >> ~/.bashrc
    echo 'eval "$(bun completions 2>/dev/null)"' >> ~/.bashrc
    echo "bun tab-completion added to .bashrc."
else
    echo "bun tab-completion already configured."
fi

echo "Bun installed."
