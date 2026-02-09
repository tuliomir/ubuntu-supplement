#!/bin/bash

set -e

# If installation steps have changed, see:
# https://support.google.com/chrome/answer/95346?hl=en&co=GENIE.Platform%3DDesktop#zippy=%2Clinux

if command -v google-chrome &>/dev/null; then
    echo "Google Chrome is already installed: $(google-chrome --version)"
    exit 0
fi

echo "Installing Google Chrome..."
wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome.deb || sudo apt-get install -f -y
rm -f /tmp/google-chrome.deb

echo "Google Chrome installed: $(google-chrome --version)"
