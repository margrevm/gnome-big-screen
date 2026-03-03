#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "spotify" "Installing Flatpak app..."
sudo flatpak install --system -y com.spotify.Client

log_component_step "spotify" "Installing custom desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/spotify-custom.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/spotify-custom.desktop"

log_component_step "spotify" "Pinning app to GNOME dock (if missing)..."
pin_favorite_app "spotify-custom.desktop" "$DEFAULT_USER"
log_component_step "spotify" "Done."
