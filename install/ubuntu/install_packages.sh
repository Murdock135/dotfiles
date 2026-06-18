#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../../lib/common.sh"

# Path to the Ubuntu packages list
PACKAGES_UBUNTU_PATH="$DOTFILES_DIR/install/ubuntu/packages-ubuntu.txt"

# Warn if the file doesn't exist
if [[ ! -f "$PACKAGES_UBUNTU_PATH" ]]; then
    echo "Warning: packages file not found at $PACKAGES_UBUNTU_PATH" >&2
    exit 1
fi

# Update package list
echo "Updating package list..."
sudo apt-get update

# Read packages from file and install
echo "Installing packages..."
while IFS= read -r package; do
    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^# ]] && continue
    
    echo "Installing: $package"
    
    # Try apt first
    if sudo apt-get install -y "$package" 2>/dev/null; then
        echo "✓ Installed via apt: $package"
    else
        echo "⚠ Package not found in apt, attempting snap: $package"
        
        # Fallback to snap
        if sudo snap install "$package" 2>/dev/null; then
            echo "✓ Installed via snap: $package"
        else
            echo "✗ Failed to install: $package (not found in apt or snap)" >&2
        fi
    fi
done < "$PACKAGES_UBUNTU_PATH"

# Debian/Ubuntu packages `fd` as `fd-find`, installing a binary named
# `fdfind` instead of `fd` (name conflict with an existing package). Tools
# that exec `fd` directly as a subprocess (e.g. Neovim's Telescope) don't
# go through interactive shell aliases, so a real symlink in PATH is needed,
# not just an alias. ~/.local/bin is on PATH by default via Ubuntu's stock
# ~/.profile.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    echo "Symlinking fdfind -> fd in ~/.local/bin"
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

echo "Package installation complete!"