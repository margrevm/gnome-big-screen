#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Spotify launcher installer
# Installs:
# - Spotify Flatpak app
# - Dock favorite entry (if missing)
#
# Usage:
#   spotify.bash <default_user>
# Example:
#   spotify.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"

echo "[spotify] Installing Flatpak app..."
sudo flatpak install --system -y com.spotify.Client

# Add app to GNOME dock favorites if not already present.
DESKTOP_ENTRY="com.spotify.Client.desktop"
echo "[spotify] Pinning app to GNOME dock (if missing)..."
cur=$(sudo -u "$DEFAULT_USER" dbus-run-session gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
if ! echo "$cur" | grep -F "'$DESKTOP_ENTRY'" >/dev/null; then
  if [[ "$cur" == "[]" ]]; then
    new="['$DESKTOP_ENTRY']"
  else
    new=$(echo "$cur" | sed -e "s/]$/, '$DESKTOP_ENTRY']/")
  fi
  sudo -u "$DEFAULT_USER" dbus-run-session gsettings set org.gnome.shell favorite-apps "$new" || true
fi

echo "[spotify] Done."
