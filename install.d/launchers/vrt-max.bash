#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# VRT MAX launcher installer
# Installs:
# - VRT MAX desktop entry for the target user
# - VRT MAX icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   vrt-max.bash <default_user>
# Example:
#   vrt-max.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)"

echo "[vrt-max] Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/vrt-max-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vrt-max-kiosk.desktop"

echo "[vrt-max] Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/vrt-max.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/vrt-max.png"

# Add launcher to GNOME dock favorites if not already present.
DESKTOP_ENTRY="vrt-max-kiosk.desktop"
echo "[vrt-max] Pinning launcher to GNOME dock (if missing)..."
cur=$(sudo -u "$DEFAULT_USER" dbus-run-session gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
if ! echo "$cur" | grep -F "'$DESKTOP_ENTRY'" >/dev/null; then
  if [[ "$cur" == "[]" ]]; then
    new="['$DESKTOP_ENTRY']"
  else
    new=$(echo "$cur" | sed -e "s/]$/, '$DESKTOP_ENTRY']/")
  fi
  sudo -u "$DEFAULT_USER" dbus-run-session gsettings set org.gnome.shell favorite-apps "$new" || true
fi
echo "[vrt-max] Done."
