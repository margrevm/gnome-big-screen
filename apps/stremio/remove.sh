#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "stremio" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "stremio-custom.desktop" "$DEFAULT_USER"

log_component_step "stremio" "Removing desktop launcher and icon..."
sudo rm -f \
  "/home/$DEFAULT_USER/.local/share/applications/stremio-custom.desktop" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/scalable/apps/stremio.svg"

log_component_step "stremio" "Removing Flatpak app..."
sudo flatpak uninstall --system -y com.stremio.Stremio || true

log_component_step "stremio" "Done."
