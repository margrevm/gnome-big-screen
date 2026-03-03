#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "vrt-max" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "vrt-max.desktop" "$DEFAULT_USER"

log_component_step "vrt-max" "Removing desktop launcher and icon..."
sudo rm -f \
  "/home/$DEFAULT_USER/.local/share/applications/vrt-max.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vrt-max-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/vrt-max.png"

log_component_step "vrt-max" "Done."
