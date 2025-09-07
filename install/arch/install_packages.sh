#!/usr/bin/env bash
set -euo pipefail

PKGLIST="packages-arch.txt"

# 1. Check if yay is installed
if ! command -v yay >/dev/null 2>&1; then
    echo "[INFO] yay not found. Installing..."

    # Install prerequisites
    sudo pacman -Sy --needed --noconfirm git base-devel

    # Clone and build yay
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    pushd "$tmpdir/yay"
    makepkg -si --noconfirm
    popd
    rm -rf "$tmpdir"

    echo "[INFO] yay installed successfully."
fi

# 2. Install packages from list
if [[ -f "$PKGLIST" ]]; then
    echo "[INFO] Installing packages from $PKGLIST..."
    yay -S --needed --noconfirm - < "$PKGLIST"
    echo "[INFO] All packages installed."
else
    echo "[ERROR] Package list $PKGLIST not found."
    exit 1
fi

yay -S --noconfirm --needed - < packages-arch.txt