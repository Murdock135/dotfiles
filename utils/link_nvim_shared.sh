#!/usr/bin/env bash
# link_nvim_shared.sh
# Symlink nvim_omarchy/config/* → nvim/user/* inside the dotfiles repo
# Note: Currently only keymaps.lua and options.lua are linked. If you want to add more
# files, modify line 15.

set -euo pipefail

# Find repo root (directory where this script lives)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SRC_DIR="$REPO_ROOT/nvim/.config/nvim/lua/zayan"
DEST_DIR="$REPO_ROOT/nvim_omarchy/.config/nvim/lua/config"

FILES=("options.lua" "keymaps.lua" "plugins") # add more if needed

mkdir -p "$DEST_DIR"

for file in "${FILES[@]}"; do
  src="$SRC_DIR/$file"
  dest="$DEST_DIR/$file"

  if [[ ! -e "$src" ]]; then
    echo "⚠️  Skipping $file (not found in $SRC_DIR)"
    continue
  fi

  # Remove existing file/symlink
  [ -e "$dest" ] && rm -f "$dest"

  # Create relative symlink (portable!)
  ln -s "../../../../../nvim/.config/nvim/lua/zayan/$file" "$dest"

  echo "Linked $dest → $src"
done

echo "✅ Symlinks created successfully."
