#!/bin/bash

set -e

# Fixes dead keys (", ', ~, ^, `) not working in JetBrains IDEs on Ubuntu.
#
# Root cause: JetBrains Runtime (JBR) has a bug in its XIM client that fails
# to handle IBus dead key composition. Setting XMODIFIERS='' bypasses IBus
# for the JVM and lets XKB handle dead keys directly. The Toolbox also strips
# parent env vars by default — JETBRAINS_TOOLBOX_INHERIT_ENV=1 fixes that.
#
# XMODIFIERS can't go in environment.d because GNOME's IBus integration
# overrides it at session start. Instead, we set it via a wrapper script
# that Toolbox's .desktop entries call. Since Toolbox inherits the wrapper's
# env (JETBRAINS_TOOLBOX_INHERIT_ENV=1), all child IDEs also get XMODIFIERS=.
#
# See: knowledge/jetbrains-installation.md for full rationale.

TOOLBOX_BIN="$HOME/.local/lib/jetbrains-toolbox/bin/jetbrains-toolbox"
ENV_DIR="$HOME/.config/environment.d"
ENV_FILE="$ENV_DIR/jetbrains-ibus-fix.conf"
WRAPPER="$HOME/.local/bin/jetbrains-toolbox-wrapper.sh"
APP_DESKTOP="$HOME/.local/share/applications/jetbrains-toolbox.desktop"
AUTOSTART_DESKTOP="$HOME/.config/autostart/jetbrains-toolbox.desktop"

# --- environment.d: vars that survive session startup ---

if [ -f "$ENV_FILE" ]; then
    echo "JetBrains environment.d fix already configured."
else
    echo "Configuring JetBrains environment.d vars..."
    mkdir -p "$ENV_DIR"
    cat > "$ENV_FILE" << 'EOF'
# Fix dead keys in JetBrains IDEs (us+intl layout + IBus)
# XMODIFIERS is NOT set here — GNOME/IBus overrides it at session start.
# It's set in the Toolbox wrapper script instead.
IBUS_ENABLE_SYNC_MODE=1
JETBRAINS_TOOLBOX_INHERIT_ENV=1
EOF
    echo "  Written: $ENV_FILE"
fi

# --- Wrapper script: sets XMODIFIERS before launching Toolbox ---

if [ -f "$WRAPPER" ]; then
    echo "JetBrains Toolbox wrapper already exists."
else
    echo "Creating Toolbox wrapper script..."
    mkdir -p "$(dirname "$WRAPPER")"
    cat > "$WRAPPER" << SCRIPT
#!/bin/bash
export XMODIFIERS=
exec "$TOOLBOX_BIN" "\$@"
SCRIPT
    chmod +x "$WRAPPER"
    echo "  Written: $WRAPPER"
fi

# --- Patch .desktop entries to use the wrapper ---
# Toolbox creates these on first launch. If they already exist (e.g. re-running
# this script after Toolbox is installed), patch them now.

patch_desktop() {
    local file="$1"
    if [ -f "$file" ] && grep -q "Exec=$TOOLBOX_BIN" "$file"; then
        sed -i "s|Exec=$TOOLBOX_BIN|Exec=$WRAPPER|g" "$file"
        echo "  Patched: $file"
    fi
}

patch_desktop "$APP_DESKTOP"
patch_desktop "$AUTOSTART_DESKTOP"

echo ""
echo "JetBrains dead keys fix configured."
echo "Log out and back in for environment.d changes to take effect."
