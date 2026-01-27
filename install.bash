#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Post-installation configuration script for Fedora Workstation
#
# Copyright (c) 2026 Mike Margreve (mike.margreve@outlook.com)
# Licensed under the MIT License. You may copy, modify, and distribute this
# script under the terms of that license.
#
# Purpose
#   Automates common post-install steps on a freshly installed workstation to
#   establish a consistent baseline for development and daily use, like a
#   lightweight launch checklist.
#
# Usage
#   1) Review the script before running and adjust variables to your needs.
#   2) Execute:
#        chmod +x fedora-post-install.bash
#        ./fedora-post-install.bash /path/to/config.cfg
#
# Notes
#   - This script is intentionally interactive and will prompt before major
#     phases and on non-fatal errors (think "go/no-go").
#   - Administrative privileges (sudo) are required for system changes.
# -----------------------------------------------------------------------------

prompt_continue() {
  local prompt="${1:-Continue?}"
  printf "%s [y/N]: " "$prompt"
  read -r ans
  case "${ans:-}" in
    y|Y|yes|YES) return 0 ;;
    *) echo "Aborted by user."; exit 1 ;;
  esac
}

log_section() {
  printf "\n\033[1;34m[%s]\033[0m\n" "$1"
  prompt_continue "Continue"
}

log_step() {
  printf "\033[0;34m➜ %s\033[0m\n" "$1"
}

log_warn() {
  printf "\033[1;33mWARN: %s\033[0m\n" "$1"
  prompt_continue "Continue anyway"
}


FEDORA_VERSION=""
if command -v rpm >/dev/null 2>&1; then
  FEDORA_VERSION="$(rpm -E %fedora 2>/dev/null || true)"
fi

warning_message=""
if [[ -z "$FEDORA_VERSION" ]]; then
  warning_message="WARNING: Unable to detect Fedora version. Continue at your own risk."
elif [[ "$FEDORA_VERSION" != "44" ]]; then
  warning_message="WARNING: This script targets Fedora 44. Continue at your own risk."
fi

if [[ -n "$warning_message" ]]; then
  printf "\033[1;31m%s\033[0m\n" "$warning_message"
  prompt_continue "Continue at your own risk"
fi

# ---------------------------------------------------
# Select hostname
# ---------------------------------------------------
log_section "Setting hostname"

NEW_HOSTNAME="gnome-tv"

log_step "Set hostname to $NEW_HOSTNAME..."

prompt_continue "Run: sudo hostnamectl set-hostname $NEW_HOSTNAME"
sudo hostnamectl set-hostname "$NEW_HOSTNAME"

# ---------------------------------------------------
# Create default user
# ---------------------------------------------------
DEFAULT_USER="tv"
GDM_CUSTOM_CONF="/etc/gdm/custom.conf"

log_section "User and auto-login setup"

log_step "Creating user $DEFAULT_USER..."
# Add user 
sudo useradd -m "$DEFAULT_USER"
# Remove password to allow automatic login
sudo passwd -d $DEFAULT_USER

log_step "Configuring automatic login for user $DEFAULT_USER..."
sudo bash -c "cat >> $GDM_CUSTOM_CONF <<EOL
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=$DEFAULT_USER
EOL
"

# ---------------------------------------------------
# DNF repositories and packages
# ---------------------------------------------------
DNF_INSTALL_PACKAGES=(
  dnf-automatic # Automatic updates
  gnome-shell-extension-dash-to-dock
  gnome-tweaks
  heif-pixbuf-loader
  chromium
  steam
  snapper
)

DNF_REMOVE_PACKAGES=(
  gnome-tour
  yelp
  gnome-maps
  gnome-calendar
  gnome-boxes
  snapshot
  gnome-contacts
  simple-scan
  mediawriter
  gnome-weather
)

log_section "Installing DNF packages"

log_step "Installing DNF plugin helpers (dnf-plugins-core)..."
sudo dnf install dnf-plugins-core

log_step "Enabling RPM Fusion (free + nonfree)..."
sudo dnf install \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

log_step "Refreshing and upgrading system packages..."
sudo dnf upgrade --refresh

log_step "Installing packages..."
sudo dnf install "${DNF_INSTALL_PACKAGES[@]}"

log_step "Installing multimedia codecs (RPM Fusion)..."
sudo dnf group install --with-optional multimedia --allowerasing

log_step "Removing unwanted packages (if present)..."
for pkg in "${DNF_REMOVE_PACKAGES[@]}"; do
  rpm -q "$pkg" && sudo dnf remove "$pkg" || printf "➜ Skipping %s (not installed)\n" "$pkg"
done

log_step "Removing unused dependencies..."
sudo dnf autoremove

# ---------------------------------------------------
# Installing flatpak packages
# ---------------------------------------------------
FLATPAK_INSTALL_PACKAGES=(
  com.stremio.Stremio
  com.spotify.Client
  com.mattjakeman.ExtensionManager
  rocks.shy.VacuumTube
)

log_section "Installing flatpak packages"

FLATHUB_REMOTE_URL="https://flathub.org/repo/flathub.flatpakrepo"

log_step "Add flatpak repositories..."
sudo flatpak remote-add --if-not-exists flathub "$FLATHUB_REMOTE_URL"

log_step "Install flatpak packages..."
sudo flatpak install --system "${FLATPAK_INSTALL_PACKAGES[@]}"

log_step "Update flatpak packages..."
sudo flatpak update

# ---------------------------------------------------
# Mission-specific payloadsThis repo is standalone and includes its own post-install script. Adapt `gnome-big-screen.cfg` to your needs, then pass it as an argument...
# ---------------------------------------------------
log_section "Custom installs"
CUSTOM_INSTALL

# ---------------------------------------------------
# GNOME settings
# ---------------------------------------------------
log_section "GNOME settings"

log_step "Apply gsettings..."
log_step "Hot corner: off"
gsettings set org.gnome.desktop.interface enable-hot-corners false

log_step "Alert sounds: off"
gsettings set org.gnome.desktop.sound event-sounds false

log_step "Lock screen notifications: off"
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

log_step "Power saving idle delay: 15 minutes"
gsettings set org.gnome.desktop.session idle-delay 900

log_step "Screen lock delay: 5 minutes"
gsettings set org.gnome.desktop.screensaver lock-delay 300

log_step "Power profile: performance"
gsettings set org.gnome.desktop.interface power-profile performance

log_step "Window buttons: minimize/maximize/close"
gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"

# ---------------------------------------------------
# Custom steps
# ---------------------------------------------------
log_section "Custom steps"

log_step "Enabling unattended Fedora updates (dnf-automatic)..."

sudo install -D -m 0644 "$(dirname "$CONFIG_FILE")/etc/dnf/automatic.conf" /etc/dnf/automatic.conf \
  || log_warn "Failed to install /etc/dnf/automatic.conf"

sudo systemctl enable --now dnf-automatic.timer || log_warn "Failed to enable dnf-automatic.timer"

# ---------------------------------------------------
# Launchers
# ---------------------------------------------------
log_section "Installing custom launchers"

log_step "Install Auvio..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/desktop/auvio-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/auvio-kiosk.desktop"

sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/assets/auvio.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/auvio.png"

log_step "Install VRT MAX..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/desktop/vrt-max-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vrt-max-kiosk.desktop"

sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/assets/vrt-max.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/vrt-max.png"

log_step "Install ARTE..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/desktop/arte-kiosk.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/arte-kiosk.desktop"

sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/assets/arte.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/arte.png"

log_step "Install Youtube..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/desktop/vacuumtube.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/vacuumtube.desktop"

sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/assets/yt.png" \
  "/home/$DEFAULT_USER/.local/share/icons/hicolor/256x256/apps/yt.png"

log_step "Install Chromium launcher..."
sudo install -D -m 0644 -o "$DEFAULT_USER" -g "$DEFAULT_USER" \
  "$(dirname "$0")/desktop/chromium-custom.desktop" \
  "/home/$DEFAULT_USER/.local/share/applications/chromium-custom.desktop"

log_step "Pin kiosk launchers to dash..."
gset set org.gnome.shell favorite-apps "['auvio-kiosk.desktop','vrt-max-kiosk.desktop','arte-kiosk.desktop','vacuumtube.desktop','chromium-custom.desktop','com.spotify.Client.desktop']"

# ---------------------------------------------------
# Summary
# ---------------------------------------------------
log_section "Summary"

log_step "System info..."
fastfetch

printf "\n[Installation completed!]\n"
log_step "Now reboot..."
cd "$HOME"
