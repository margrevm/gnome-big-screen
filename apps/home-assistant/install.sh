#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "home-assistant" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/home-assistant.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/home-assistant.desktop"

log_component_step "home-assistant" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/ha.svg" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/scalable/apps/ha.svg"

log_component_step "home-assistant" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "home-assistant.desktop" "$DEFAULT_USER"
log_component_step "home-assistant" "Done."
