#!/bin/bash

set -e

if grep -q 'alias claude-yolo' ~/.bashrc 2>/dev/null; then
    echo "claude-yolo alias is already configured."
    exit 0
fi

echo "Adding claude-yolo alias to .bashrc..."

echo "" >> ~/.bashrc
echo '# Claude Code with no permission prompts (use in trusted environments only)' >> ~/.bashrc
echo "alias claude-yolo='claude --dangerously-skip-permissions'" >> ~/.bashrc

echo "claude-yolo alias added. Run 'source ~/.bashrc' or open a new terminal to use it."
