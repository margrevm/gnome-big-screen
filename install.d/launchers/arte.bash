#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# ARTE launcher installer
# Installs:
# - ARTE desktop entry for the target user
# - ARTE icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   arte.bash <default_user>
# Example:
#   arte.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "arte" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/arte-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/arte-kiosk.desktop"

log_component_step "arte" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/arte.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/arte.png"

log_component_step "arte" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "arte-kiosk.desktop" "$DEFAULT_USER"
log_component_step "arte" "Done."
