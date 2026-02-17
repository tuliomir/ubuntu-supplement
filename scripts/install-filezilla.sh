#!/bin/bash

set -e

if command -v filezilla &>/dev/null; then
    echo "FileZilla is already installed."
    exit 0
fi

echo "Installing FileZilla..."

sudo apt install -y filezilla

echo "FileZilla installed."
