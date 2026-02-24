#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Auvio launcher installer
# Installs:
# - Auvio desktop entry for the target user
# - Auvio icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   auvio.bash <default_user>
# Example:
#   auvio.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "auvio" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/auvio-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/auvio-kiosk.desktop"

log_component_step "auvio" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/auvio.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/auvio.png"

log_component_step "auvio" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "auvio-kiosk.desktop" "$DEFAULT_USER"
log_component_step "auvio" "Done."
