#!/bin/bash

set -e

# If installation steps have changed, see:
# https://slack.com/downloads/linux

if command -v slack &>/dev/null; then
    echo "Slack is already installed."
    exit 0
fi

echo "Installing Slack (apt repo)..."

# Add the GPG key
curl -fsSL https://packagecloud.io/slacktechnologies/slack/gpgkey \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/slack-archive-keyring.gpg > /dev/null

# Add the apt repository
echo "deb [signed-by=/usr/share/keyrings/slack-archive-keyring.gpg arch=amd64] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" \
    | sudo tee /etc/apt/sources.list.d/slack.list > /dev/null

# Install
sudo apt update && sudo apt install -y slack-desktop

echo "Slack installed."
