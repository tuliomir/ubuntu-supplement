#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/scripts"

# User-space tools (no sudo)
./setup-ssh.sh
./install-gh.sh
./setup-git.sh
./setup-keyboard.sh
./setup-hotkeys.sh
./setup-starship.sh
./install-nvm.sh
./install-bun.sh
./install-claude-code.sh
./setup-claude-yolo.sh
./install-opencode.sh
./setup-python.sh
./install-gallery-dl.sh
./setup-jetbrains-env.sh
./install-jetbrains-toolbox.sh
./install-telegram.sh

# Desktop apps (sudo required)
./install-chrome.sh
./install-1password.sh
./install-ghostty.sh
./install-slack.sh
./install-discord.sh
./install-gitify.sh
./install-obsidian.sh
./install-dropbox.sh
./install-sublime-text.sh
./install-copyq.sh
./install-filezilla.sh
./install-docker.sh
./install-openjdk.sh
./install-gradle.sh
./install-tailscale.sh
./install-tmux.sh
./setup-tmux.sh

# Autostart configuration (after apps are installed)
./setup-autostart.sh

echo ""
echo "All done! Remaining manual steps:"
echo "  1. Run 'gh auth login -p ssh' to authenticate with GitHub"
echo "  2. Log out and back in for keyboard/XCompose changes"
