#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# ARTE launcher installer
# Installs:
# - ARTE desktop entry for the target user
# - ARTE icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   arte.bash <default_user>
# Example:
#   arte.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)"

echo "[arte] Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/arte-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/arte-kiosk.desktop"

echo "[arte] Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/arte.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/arte.png"

# Add launcher to GNOME dock favorites if not already present.
DESKTOP_ENTRY="arte-kiosk.desktop"
echo "[arte] Pinning launcher to GNOME dock (if missing)..."
cur=$(sudo -u "$DEFAULT_USER" dbus-run-session gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
if ! echo "$cur" | grep -F "'$DESKTOP_ENTRY'" >/dev/null; then
  if [[ "$cur" == "[]" ]]; then
    new="['$DESKTOP_ENTRY']"
  else
    new=$(echo "$cur" | sed -e "s/]$/, '$DESKTOP_ENTRY']/")
  fi
  sudo -u "$DEFAULT_USER" dbus-run-session gsettings set org.gnome.shell favorite-apps "$new" || true
fi
echo "[arte] Done."
