#!/bin/bash

set -e

KEY_PATH="$HOME/.ssh/id_ed25519"

if [ -f "$KEY_PATH" ]; then
    echo "SSH key already exists at $KEY_PATH, skipping."
    exit 0
fi

echo "Generating Ed25519 SSH key..."
ssh-keygen -t ed25519 -C "$USER@github" -f "$KEY_PATH" -N ""

echo "SSH key generated:"
cat "${KEY_PATH}.pub"
