#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "spotify" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "spotify-custom.desktop" "$DEFAULT_USER"

log_component_step "spotify" "Removing desktop launcher and icon..."
sudo rm -f \
  "/home/$DEFAULT_USER/.local/share/applications/spotify-custom.desktop" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/scalable/apps/spotify.svg"

log_component_step "spotify" "Removing Flatpak app..."
sudo flatpak uninstall --system -y com.spotify.Client || true

log_component_step "spotify" "Done."
