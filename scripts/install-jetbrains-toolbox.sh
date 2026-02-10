#!/bin/bash

set -e

# If installation steps have changed, see:
# https://www.jetbrains.com/toolbox-app/
#
# Toolbox 3.2+ runs from its install directory (no self-copy).
# We extract to ~/.local/lib/jetbrains-toolbox/ as a permanent location.

INSTALL_DIR="$HOME/.local/lib/jetbrains-toolbox"
TOOLBOX_BIN="$INSTALL_DIR/bin/jetbrains-toolbox"

if [ -f "$TOOLBOX_BIN" ]; then
    echo "JetBrains Toolbox is already installed."
    exit 0
fi

echo "Installing JetBrains Toolbox..."

DOWNLOAD_URL=$(wget -qO- "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" \
    | grep -oP '"linux":\{"link":"\K[^"]+')

ARCHIVE="/tmp/jetbrains-toolbox.tar.gz"
wget -q --show-progress -O "$ARCHIVE" "$DOWNLOAD_URL"

mkdir -p "$INSTALL_DIR"
tar -xzf "$ARCHIVE" -C "$INSTALL_DIR" --strip-components=1
rm -f "$ARCHIVE"

"$TOOLBOX_BIN" &
disown

echo "JetBrains Toolbox installed to $INSTALL_DIR and running."
echo "Use it to install WebStorm, IntelliJ, or any other JetBrains IDE."
