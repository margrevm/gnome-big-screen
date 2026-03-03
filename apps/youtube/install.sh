#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$APP_DIR/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "youtube" "Installing Flatpak app (VacuumTube)..."
sudo flatpak install --system -y rocks.shy.VacuumTube

log_component_step "youtube" "Installing desktop launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/vacuumtube.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vacuumtube.desktop"

log_component_step "youtube" "Installing icon..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$APP_DIR/icon.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/yt.png"

log_component_step "youtube" "Pinning launcher to GNOME dock (if missing)..."
pin_favorite_app "vacuumtube.desktop" "$DEFAULT_USER"
log_component_step "youtube" "Done."
