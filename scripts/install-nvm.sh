#!/bin/bash

set -e

export NVM_DIR="$HOME/.nvm"

# Install NVM if not present
if [ ! -d "$NVM_DIR" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
else
    echo "NVM is already installed."
fi

# Load NVM for this script
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Install Node LTS and set as default
if ! nvm ls --no-colors 2>/dev/null | grep -q "lts"; then
    echo "Installing Node.js LTS..."
    nvm install --lts
fi

nvm alias default lts/*

# Add npm tab-completion to .bashrc (includes "npm run <script>" completion)
if ! grep -q 'npm completion' ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo '# npm completions (includes "npm run <script>" from package.json)' >> ~/.bashrc
    echo 'eval "$(npm completion 2>/dev/null)"' >> ~/.bashrc
    echo "npm tab-completion added to .bashrc."
else
    echo "npm tab-completion already configured."
fi

echo "Node.js $(node --version) installed and set as default."
