#!/bin/bash
set -euo pipefail

# -----------------------------
# install_packages.sh
# Installs packages from Brewfile
# -----------------------------

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BREWFILE_PATH="$DOTFILES_DIR/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Run ./brew.sh first."
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

echo "✅ Package installation complete."
