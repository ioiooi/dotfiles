#!/bin/bash
set -euo pipefail

# GNOME desktop settings. Part of setup.sh and run once, rather than from
# .linux_config on every shell start.

if ! command -v gsettings > /dev/null 2>&1; then
  echo "gsettings not available, skipping desktop configuration."
  exit 0
fi

configure_keyboard_layout() {
  local current_layout
  current_layout=$(gsettings get org.gnome.desktop.input-sources sources)
  if [[ "$current_layout" != "[('xkb', 'us+de_se_fi')]" ]]; then
    echo "Configuring keyboard layout to us+de_se_fi..."
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+de_se_fi')]"
    gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:lalt_switch']"
    echo "Keyboard layout configured"
  fi
}

configure_workspace_shortcuts() {
  local current_ws_up
  current_ws_up=$(gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-up)
  if [[ "$current_ws_up" != "@as []" ]]; then
    echo "Disabling workspace shortcuts..."
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up '[]'
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down '[]'
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up '[]'
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down '[]'
    echo "Workspace shortcuts disabled"
  fi
}

configure_keyboard_layout
configure_workspace_shortcuts
