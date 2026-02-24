#!/usr/bin/env bash
set -euo pipefail

prompt_continue() {
  local prompt="${1:-Continue?}"
  printf "%s [y/N]: " "$prompt"
  read -r ans
  case "${ans:-}" in
    y|Y|yes|YES) return 0 ;;
    *) echo "Aborted by user."; exit 1 ;;
  esac
}

prompt_yes_no() {
  local prompt="${1:-Proceed?}"
  printf "%s [Y/n]: " "$prompt"
  read -r ans
  case "${ans:-}" in
    n|N|no|NO) return 1 ;;
    *) return 0 ;;
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

log_component_step() {
  local component="$1"
  local message="$2"
  log_step "[$component] $message"
}

gset() {
  sudo -u "$DEFAULT_USER" dbus-run-session gsettings "$@"
}

pin_favorite_app() {
  local desktop_entry="$1"
  local user="${2:-$DEFAULT_USER}"
  local cur new

  cur=$(sudo -u "$user" dbus-run-session gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "[]")
  if ! echo "$cur" | grep -F "'$desktop_entry'" >/dev/null; then
    if [[ "$cur" == "[]" ]]; then
      new="['$desktop_entry']"
    else
      new=$(echo "$cur" | sed -e "s/]$/, '$desktop_entry']/")
    fi
    sudo -u "$user" dbus-run-session gsettings set org.gnome.shell favorite-apps "$new" || true
  fi
}
