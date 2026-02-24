#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# VRT MAX launcher installer
# Installs:
# - VRT MAX desktop entry for the target user
# - VRT MAX icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   vrt-max.bash <default_user>
# Example:
#   vrt-max.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "vrt-max" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/vrt-max-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vrt-max-kiosk.desktop"

log_component_step "vrt-max" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/vrt-max.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/vrt-max.png"

log_component_step "vrt-max" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "vrt-max-kiosk.desktop" "$DEFAULT_USER"
log_component_step "vrt-max" "Done."
