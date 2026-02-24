#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Auvio launcher installer
# Installs:
# - Auvio desktop entry for the target user
# - Auvio icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   auvio.bash <default_user>
# Example:
#   auvio.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)"

echo "[auvio] Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/auvio-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/auvio-kiosk.desktop"

echo "[auvio] Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/auvio.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/auvio.png"

# Add launcher to GNOME dock favorites if not already present.
DESKTOP_ENTRY="auvio-kiosk.desktop"
echo "[auvio] Pinning launcher to GNOME dock (if missing)..."
cur=$(sudo -u "$DEFAULT_USER" dbus-run-session gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
if ! echo "$cur" | grep -F "'$DESKTOP_ENTRY'" >/dev/null; then
  if [[ "$cur" == "[]" ]]; then
    new="['$DESKTOP_ENTRY']"
  else
    new=$(echo "$cur" | sed -e "s/]$/, '$DESKTOP_ENTRY']/")
  fi
  sudo -u "$DEFAULT_USER" dbus-run-session gsettings set org.gnome.shell favorite-apps "$new" || true
fi
echo "[auvio] Done."
