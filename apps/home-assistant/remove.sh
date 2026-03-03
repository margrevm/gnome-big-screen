#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "home-assistant" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "home-assistant.desktop" "$DEFAULT_USER"

log_component_step "home-assistant" "Removing desktop launcher and icon..."
sudo rm -f \
  "/home/$DEFAULT_USER/.local/share/applications/home-assistant.desktop" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/scalable/apps/ha.svg"

log_component_step "home-assistant" "Done."
