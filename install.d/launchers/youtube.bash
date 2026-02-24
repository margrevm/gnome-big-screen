#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# YouTube launcher installer (VacuumTube)
# Installs:
# - VacuumTube Flatpak app
# - VacuumTube desktop entry for the target user
# - YouTube icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   youtube.bash <default_user>
# Example:
#   youtube.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)"

echo "[youtube] Installing Flatpak app (VacuumTube)..."
sudo flatpak install --system -y rocks.shy.VacuumTube

echo "[youtube] Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/vacuumtube.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vacuumtube.desktop"

echo "[youtube] Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/yt.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/yt.png"

# Add launcher to GNOME dock favorites if not already present.
DESKTOP_ENTRY="vacuumtube.desktop"
echo "[youtube] Pinning launcher to GNOME dock (if missing)..."
cur=$(sudo -u "$DEFAULT_USER" dbus-run-session gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
if ! echo "$cur" | grep -F "'$DESKTOP_ENTRY'" >/dev/null; then
  if [[ "$cur" == "[]" ]]; then
    new="['$DESKTOP_ENTRY']"
  else
    new=$(echo "$cur" | sed -e "s/]$/, '$DESKTOP_ENTRY']/")
  fi
  sudo -u "$DEFAULT_USER" dbus-run-session gsettings set org.gnome.shell favorite-apps "$new" || true
fi
echo "[youtube] Done."
