#!/bin/bash

set -e

# If installation steps have changed, see:
# https://gradle.org/install/

if command -v gradle &>/dev/null; then
    echo "Gradle is already installed: $(gradle --version | head -2 | tail -1)"
    exit 0
fi

echo "Installing Gradle..."

VERSION=$(wget -qO- https://api.github.com/repos/gradle/gradle/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
echo "Latest Gradle version: $VERSION"

INSTALL_DIR="$HOME/.local/lib/gradle-$VERSION"
ARCHIVE="/tmp/gradle-${VERSION}-bin.zip"

wget -q --show-progress -O "$ARCHIVE" "https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip"

mkdir -p "$HOME/.local/lib"
unzip -qo "$ARCHIVE" -d "$HOME/.local/lib"
rm -f "$ARCHIVE"

# Symlink the binary so it's on PATH via ~/.local/bin
mkdir -p "$HOME/.local/bin"
ln -sf "$INSTALL_DIR/bin/gradle" "$HOME/.local/bin/gradle"

echo "Gradle $VERSION installed to $INSTALL_DIR"
