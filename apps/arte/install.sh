#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "arte" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/arte-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/arte-kiosk.desktop"

log_component_step "arte" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/icon.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/arte.png"

log_component_step "arte" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "arte-kiosk.desktop" "$DEFAULT_USER"
log_component_step "arte" "Done."
