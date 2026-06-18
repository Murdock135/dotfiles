#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/common.sh"

BASHRC="${HOME}/.bashrc"

echo "Disabling Homebrew configuration..."

# Remove from .bashrc only (since that's where we added it)
remove_managed_block "$BASHRC" "homebrew"

echo ""
echo "✅ Homebrew disabled successfully!"
echo ""
echo "Note: This only removes shell configuration."
echo "To completely uninstall Homebrew, run:"
echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"'
echo ""
echo "To apply changes immediately, run:"
echo "  source ~/.bashrc"
