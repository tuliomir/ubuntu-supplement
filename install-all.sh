#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/scripts"

./setup-ssh.sh
./install-gh.sh
./setup-git.sh
./setup-keyboard.sh
./setup-starship.sh
./install-nvm.sh
./install-bun.sh

echo ""
echo "All done! Remaining manual steps:"
echo "  1. Run 'gh auth login -p ssh' to authenticate with GitHub"
echo "  2. Log out and back in for keyboard/XCompose changes"
