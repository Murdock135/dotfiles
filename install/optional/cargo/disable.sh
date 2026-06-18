#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Usage: disable.sh [--purge]
#
# cargo's activation lives in shell/.config/shell/env.sh (this repo's single
# source of truth for shell activation), guarded by a check for
# ~/.cargo/env. There is no shell-profile block for this script to remove --
# cargo is "disabled" simply by not being installed.
#
# --purge actually uninstalls the Rust toolchain via rustup's own uninstaller.
# ------------------------------------------------------------------------------

PURGE=false
case "${1:-}" in
  --purge) PURGE=true ;;
  "") ;;
  *) echo "Usage: disable.sh [--purge]" >&2; exit 2 ;;
esac

if $PURGE; then
  if command -v rustup >/dev/null 2>&1; then
    echo "Uninstalling Rust toolchain via rustup..."
    rustup self uninstall -y
  else
    echo "rustup not found; nothing to purge."
  fi
else
  echo "cargo has no shell-profile block to remove -- activation in env.sh is already a no-op once ~/.cargo/env is gone."
  echo "Run 'disable.sh --purge' to uninstall the Rust toolchain via rustup."
fi
