#!/usr/bin/env sh
set -eu

RELEASE_URL="${STATION_RELEASE_URL:-https://github.com/NokMyo/Soojong-Station/releases/latest/download/soojong-station-arm64.tar.gz}"
INSTALL_DIR="${STATION_INSTALL_DIR:-$HOME/soojong-station}"
TMP_DIR="$(mktemp -d)"
ARCHIVE="$TMP_DIR/soojong-station-arm64.tar.gz"
EXTRACT_DIR="$TMP_DIR/extracted"

if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
  RESET="$(tput sgr0 2>/dev/null || true)"
  BLUE="$(tput setaf 4 2>/dev/null || true)"
  GREEN="$(tput setaf 2 2>/dev/null || true)"
  YELLOW="$(tput setaf 3 2>/dev/null || true)"
  RED="$(tput setaf 1 2>/dev/null || true)"
else
  RESET=""
  BLUE=""
  GREEN=""
  YELLOW=""
  RED=""
fi

line() { printf '%s\n' '────────────────────────────────────────────────────────────'; }
ok() { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$1"; }
warn() { printf '%s!%s %s\n' "$YELLOW" "$RESET" "$1"; }
fail() { printf '%s✗%s %s\n' "$RED" "$RESET" "$1"; }

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

printf '\n%sSoojong Station Installer%s\n' "$BLUE" "$RESET"
line
printf '  %-16s %s\n' "Target" "$INSTALL_DIR"
printf '  %-16s %s\n' "Release" "$RELEASE_URL"

if ! command -v curl >/dev/null 2>&1; then
  fail "curl not found"
  printf '%s\n' 'Install curl first:'
  printf '%s\n' '  sudo apt update && sudo apt install -y curl'
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  fail "tar not found"
  printf '%s\n' 'Install tar first:'
  printf '%s\n' '  sudo apt update && sudo apt install -y tar'
  exit 1
fi

mkdir -p "$EXTRACT_DIR"

printf '\n%sDownloading latest release%s\n' "$BLUE" "$RESET"
line
curl -L --fail --show-error --output "$ARCHIVE" "$RELEASE_URL"
ok "downloaded"

printf '\n%sExtracting package%s\n' "$BLUE" "$RESET"
line
tar -xzf "$ARCHIVE" -C "$EXTRACT_DIR"
PACKAGE_ROOT="$(find "$EXTRACT_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"

if [ -z "$PACKAGE_ROOT" ] || [ ! -d "$PACKAGE_ROOT" ]; then
  fail "invalid release package"
  exit 1
fi

if [ ! -x "$PACKAGE_ROOT/shell/build/soojong-station" ]; then
  fail "release binary missing"
  exit 1
fi
ok "package verified"

printf '\n%sInstalling files%s\n' "$BLUE" "$RESET"
line
if [ -e "$INSTALL_DIR" ]; then
  BACKUP_DIR="$INSTALL_DIR.previous"
  rm -rf "$BACKUP_DIR"
  mv "$INSTALL_DIR" "$BACKUP_DIR"
  warn "existing install moved to $BACKUP_DIR"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
mv "$PACKAGE_ROOT" "$INSTALL_DIR"
ok "installed to $INSTALL_DIR"

printf '\n%sInstalling required packages%s\n' "$BLUE" "$RESET"
line
if command -v sudo >/dev/null 2>&1; then
  sudo STATION_DEPS_MODE=device sh "$INSTALL_DIR/scripts/install-pak.sh"
else
  warn "sudo not found; skipping package install"
  warn "run later as root: STATION_DEPS_MODE=device sh $INSTALL_DIR/scripts/install-pak.sh"
fi

printf '\n%sDone%s\n' "$GREEN" "$RESET"
line
printf '  %-16s %s\n' "Run" "cd $INSTALL_DIR && sh scripts/run.sh"
printf '  %-16s %s\n' "Autostart" "cd $INSTALL_DIR && sudo sh scripts/station-autostart.sh enable"
printf '  %-16s %s\n' "Update" "cd $INSTALL_DIR && sh scripts/update.sh"
printf '\n'
