#!/usr/bin/env bash
set -euo pipefail

DEFAULT_USER="${1:-tv}"
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
# shellcheck source=common.bash
source "$SCRIPT_DIR/common.bash"

log_component_step "spotify" "Unpinning launcher from GNOME dock..."
unpin_favorite_app "com.spotify.Client.desktop" "$DEFAULT_USER"

log_component_step "spotify" "Removing Flatpak app..."
sudo flatpak uninstall --system -y com.spotify.Client || true

log_component_step "spotify" "Done."
