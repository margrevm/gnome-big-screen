#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "stremio" "Installing Flatpak app..."
sudo flatpak install --system -y com.stremio.Stremio

log_component_step "stremio" "Installing custom desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/stremio-custom.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/stremio-custom.desktop"

log_component_step "stremio" "Pinning app to GNOME dock (if missing)..."
pin_favorite_app "stremio-custom.desktop" "$DEFAULT_USER"
log_component_step "stremio" "Done."
