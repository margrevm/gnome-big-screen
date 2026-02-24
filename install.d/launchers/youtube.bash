#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# YouTube launcher installer (VacuumTube)
# Installs:
# - VacuumTube Flatpak app
# - VacuumTube desktop entry for the target user
# - YouTube icon in the hicolor icon theme
# - Dock favorite entry (if missing)
#
# Usage:
#   youtube.bash <default_user>
# Example:
#   youtube.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "youtube" "Installing Flatpak app (VacuumTube)..."
sudo flatpak install --system -y rocks.shy.VacuumTube

log_component_step "youtube" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/desktop/vacuumtube.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vacuumtube.desktop"

log_component_step "youtube" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$SCRIPT_DIR/assets/yt.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/yt.png"

log_component_step "youtube" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "vacuumtube.desktop" "$DEFAULT_USER"
log_component_step "youtube" "Done."
