#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "arte" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "arte.desktop" "$DEFAULT_USER"

log_component_step "arte" "Removing desktop launcher and icon..."
sudo rm -f \
  "/home/$DEFAULT_USER/.local/share/applications/arte.desktop" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/arte.png"

log_component_step "arte" "Done."
