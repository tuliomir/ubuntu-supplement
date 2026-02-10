#!/bin/bash

set -e

SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
CUSTOM_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

CURRENT=$(gsettings get "$SCHEMA" custom-keybindings)

add_to_list() {
    local path="$1"
    if echo "$CURRENT" | grep -q "$path"; then
        return
    fi
    if [ "$CURRENT" = "@as []" ]; then
        CURRENT="['$path']"
    else
        CURRENT="${CURRENT%]*}, '$path']"
    fi
}

set_hotkey() {
    local path="$BASE_PATH/$1/"
    local name="$2"
    local command="$3"
    local binding="$4"

    echo "Setting $binding → $name..."
    gsettings set "$CUSTOM_SCHEMA:$path" name "$name"
    gsettings set "$CUSTOM_SCHEMA:$path" command "$command"
    gsettings set "$CUSTOM_SCHEMA:$path" binding "$binding"
    add_to_list "$path"
}

set_hotkey "file-browser" "Open Downloads folder" "nautilus $HOME/Downloads" "<Super>e"
set_hotkey "text-editor"  "Open text editor"       "gnome-text-editor"        "<Super>r"
set_hotkey "sublime-text" "Open Sublime Text"      "subl"                     "<Super><Shift>r"

gsettings set "$SCHEMA" custom-keybindings "$CURRENT"

echo "Hotkeys configured."
