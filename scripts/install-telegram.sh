#!/bin/bash

set -e

# If installation steps have changed, see:
# https://desktop.telegram.org/

INSTALL_DIR="$HOME/.local/lib/telegram"
TELEGRAM_BIN="$INSTALL_DIR/Telegram"

if [ -f "$TELEGRAM_BIN" ]; then
    echo "Telegram Desktop is already installed."
    exit 0
fi

echo "Installing Telegram Desktop..."

ARCHIVE="/tmp/telegram.tar.xz"
wget -q --show-progress -O "$ARCHIVE" "https://telegram.org/dl/desktop/linux"

mkdir -p "$INSTALL_DIR"
tar -xJf "$ARCHIVE" -C "$INSTALL_DIR" --strip-components=1
rm -f "$ARCHIVE"

echo "Telegram Desktop installed to $INSTALL_DIR"
echo "Run it once to create the desktop entry automatically."
