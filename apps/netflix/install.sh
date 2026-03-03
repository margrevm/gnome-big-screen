#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "netflix" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/netflix.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/netflix.desktop"

log_component_step "netflix" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/netflix.svg" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/scalable/apps/netflix.svg"

log_component_step "netflix" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "netflix.desktop" "$DEFAULT_USER"
log_component_step "netflix" "Done."
