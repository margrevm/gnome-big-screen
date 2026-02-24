#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Spotify launcher installer
# Installs:
# - Spotify Flatpak app
# - Dock favorite entry (if missing)
#
# Usage:
#   spotify.bash <default_user>
# Example:
#   spotify.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "spotify" "Installing Flatpak app..."
sudo flatpak install --system -y com.spotify.Client

log_component_step "spotify" "Pinning app to GNOME dock (if missing)..."
pin_favorite_app "com.spotify.Client.desktop" "$DEFAULT_USER"

log_component_step "spotify" "Done."
