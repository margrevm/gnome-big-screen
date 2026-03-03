#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "youtube" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "vacuumtube.desktop" "$DEFAULT_USER"

log_component_step "youtube" "Removing desktop launcher and icon..."
sudo rm -f \
  "/home/$DEFAULT_USER/.local/share/applications/vacuumtube.desktop" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/yt.png"

log_component_step "youtube" "Removing Flatpak app (VacuumTube)..."
sudo flatpak uninstall --system -y rocks.shy.VacuumTube || true

log_component_step "youtube" "Done."
