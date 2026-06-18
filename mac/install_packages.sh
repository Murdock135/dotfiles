#!/bin/bash
# =============================================================================
# install_packages.sh
# -----------------------------------------------------------------------------
# Purpose:
#   Install packages listed in Brewfile via `brew bundle`.
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/../lib/common.sh"
echo "Dotfiles directory: $DOTFILES_DIR"

BREWFILE_PATH="$DOTFILES_DIR/mac/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Run ./mac/brew.sh first."
  exit 1
fi

eval "$("$(brew --prefix)"/bin/brew shellenv)"

if [[ ! -f "$BREWFILE_PATH" ]]; then
  echo "❌ No Brewfile found at $BREWFILE_PATH"
  exit 1
fi

echo "📦 Installing packages from $BREWFILE_PATH..."
brew update
brew bundle --file="$BREWFILE_PATH"
brew cleanup || true

echo "✅ install_packages.sh complete."
