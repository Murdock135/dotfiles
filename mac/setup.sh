#!/bin/bash
# =============================================================================
# setup.sh
# -----------------------------------------------------------------------------
# Purpose:
#   Stow dotfiles into ~/.config
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/../lib/common.sh"
PACKAGES=(git nvim shell alacritty) # extend as needed

if ! command -v stow >/dev/null 2>&1; then
  echo "❌ stow not installed. Run ./mac/install_packages.sh first or install stow manually."
  exit 1
fi

mkdir -p "$HOME/.config"

cd "$DOTFILES_DIR"
echo "📂 Stowing packages into ~ ..."
for pkg in "${PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    echo "• stow $pkg"
    stow -t "$HOME" -R "$pkg"
  else
    echo "⚠️ Skipping $pkg (directory not found)."
  fi
done

echo "✅ setup.sh complete."
