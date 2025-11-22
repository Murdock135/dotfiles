#!/usr/bin/env bash
set -euo pipefail

# Determine DOTFILES_DIR if not already set
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)}"

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

echo "Package installation complete!"