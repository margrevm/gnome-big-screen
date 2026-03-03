#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "jellyfin" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "jellyfin.desktop" "$DEFAULT_USER"

log_component_step "jellyfin" "Removing desktop launcher..."
sudo rm -f "/home/$DEFAULT_USER/.local/share/applications/jellyfin.desktop"

log_component_step "jellyfin" "Removing Flatpak app..."
sudo flatpak uninstall --system -y com.github.iwalton3.jellyfin-media-player || true

log_component_step "jellyfin" "Done."
