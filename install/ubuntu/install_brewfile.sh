#!/bin/bash
# =============================================================================
# install_brewfile.sh
# -----------------------------------------------------------------------------
# Purpose:
#   Install packages listed in Brewfile via `brew bundle`.
# =============================================================================
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/mydotfiles}"

# Print the dotfile directory and ask for confirmation
echo "Your dotfile directory is: $DOTFILES_DIR"
read -p "Is this the correct directory? (y/n): " answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Please manually change DOTFILES_DIR in <dotfiledir>/mac/install_packages.sh and try again."
  exit 1
fi

BREWFILE_PATH="$DOTFILES_DIR/install/ubuntu/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Install it first."
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
