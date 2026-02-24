#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Stremio launcher installer
# Installs:
# - Stremio Flatpak app
# - Dock favorite entry (if missing)
#
# Usage:
#   stremio.bash <default_user>
# Example:
#   stremio.bash tv
# -----------------------------------------------------------------------------
DEFAULT_USER="${1:-tv}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "stremio" "Installing Flatpak app..."
sudo flatpak install --system -y com.stremio.Stremio

log_component_step "stremio" "Pinning app to GNOME dock (if missing)..."
pin_favorite_app "com.stremio.Stremio.desktop" "$DEFAULT_USER"

log_component_step "stremio" "Done."
