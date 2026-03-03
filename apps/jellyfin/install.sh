#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "jellyfin" "Installing Flatpak app..."
sudo flatpak install --system -y com.github.iwalton3.jellyfin-media-player

log_component_step "jellyfin" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/jellyfin.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/jellyfin.desktop"

log_component_step "jellyfin" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "jellyfin.desktop" "$DEFAULT_USER"
log_component_step "jellyfin" "Done."
