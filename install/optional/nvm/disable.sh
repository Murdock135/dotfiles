#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Usage: disable.sh [--purge]
#
# nvm's activation lives in shell/.config/shell/env.sh (this repo's single
# source of truth for shell activation), guarded by a check for
# ~/.nvm/nvm.sh. There is no shell-profile block for this script to remove --
# nvm is "disabled" simply by not being installed.
#
# --purge actually removes the installed nvm directory.
# ------------------------------------------------------------------------------

PURGE=false
case "${1:-}" in
  --purge) PURGE=true ;;
  "") ;;
  *) echo "Usage: disable.sh [--purge]" >&2; exit 2 ;;
esac

TARGET_NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if $PURGE; then
  if [ -d "$TARGET_NVM_DIR" ]; then
    echo "Purging $TARGET_NVM_DIR ..."
    rm -rf "$TARGET_NVM_DIR"
  else
    echo "$TARGET_NVM_DIR not found; nothing to purge."
  fi
else
  echo "nvm has no shell-profile block to remove -- activation in env.sh is already a no-op once $TARGET_NVM_DIR is gone."
  echo "Run 'disable.sh --purge' to remove $TARGET_NVM_DIR and fully uninstall nvm."
fi
