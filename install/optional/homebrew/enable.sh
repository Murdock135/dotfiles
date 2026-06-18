#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/common.sh"

BASHRC="${HOME}/.bashrc"
LINUXBREW_DIR="/home/linuxbrew/.linuxbrew"

echo "Enabling Homebrew configuration..."

# Install Homebrew if not present (mirrors install/optional/nvm/enable.sh's
# pattern: check, then self-install via the project's own official script
# rather than just erroring out and telling the user to do it manually).
if [ ! -d "$LINUXBREW_DIR" ]; then
  echo "Homebrew not found at $LINUXBREW_DIR. Installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed at $LINUXBREW_DIR. Skipping install."
fi

if [ ! -d "$LINUXBREW_DIR" ]; then
  echo "Error: Homebrew installation appears to have failed -- $LINUXBREW_DIR still not found." >&2
  exit 1
fi

# Add to .bashrc only
# Since your .bash_profile sources .bashrc, this covers both login and interactive shells
add_managed_block "$BASHRC" "homebrew" 'if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi'

echo ""
echo "✅ Homebrew enabled successfully!"
echo ""
echo "To apply changes immediately, run:"
echo "  source ~/.bashrc"
echo ""
echo "Dependencies note:"
echo "  If you have sudo access, install build tools:"
echo "    sudo apt-get install build-essential"
