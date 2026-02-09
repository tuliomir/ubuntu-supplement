#!/bin/bash

set -e

AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

echo "Configuring autostart apps..."

# 1Password — start silently to system tray
cat > "$AUTOSTART_DIR/1password.desktop" << 'EOF'
[Desktop Entry]
Name=1Password
Exec=/opt/1Password/1password --silent
Terminal=false
Type=Application
Icon=1password
X-GNOME-Autostart-enabled=true
Comment=Password manager (starts minimized to tray)
EOF

# Slack — start minimized
cat > "$AUTOSTART_DIR/slack.desktop" << 'EOF'
[Desktop Entry]
Name=Slack
Exec=/snap/bin/slack --startup
Terminal=false
Type=Application
Icon=/snap/slack/current/usr/share/pixmaps/slack.png
X-GNOME-Autostart-enabled=true
Comment=Slack (starts minimized)
EOF

# Gitify — menubar app, starts in tray by default
cat > "$AUTOSTART_DIR/gitify.desktop" << 'EOF'
[Desktop Entry]
Name=Gitify
Exec=/opt/Gitify/gitify
Terminal=false
Type=Application
Icon=gitify
X-GNOME-Autostart-enabled=true
Comment=GitHub notifications (menubar)
EOF

echo "Autostart configured for: 1Password, Slack, Gitify."
echo "They will launch minimized on your next login."
