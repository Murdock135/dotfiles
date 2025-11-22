#!/usr/bin/env bash
set -euo pipefail

# Configuration
BASHRC="${HOME}/.bashrc"
BLOCK_BEGIN="# >>> Homebrew (managed by dotfiles) >>>"
BLOCK_END="# <<< Homebrew (managed by dotfiles) <<<"

# Function to remove Homebrew block from a file
remove_homebrew_block() {
  local target_file="$1"
  
  # Skip if file doesn't exist
  if [ ! -f "$target_file" ]; then
    echo "Skipping $target_file (does not exist)"
    return 0
  fi
  
  # Check if block exists
  if ! grep -Fq "$BLOCK_BEGIN" "$target_file"; then
    echo "No Homebrew block found in $target_file"
    return 0
  fi
  
  # Create temporary file
  local tmpfile
  tmpfile="$(mktemp "${target_file}.XXXX")"
  trap 'rm -f "$tmpfile"' EXIT
  
  # Remove managed block using awk
  awk -v start="$BLOCK_BEGIN" -v end="$BLOCK_END" '
    $0 == start { skip=1; next }
    $0 == end { skip=0; next }
    !skip { print }
  ' "$target_file" > "$tmpfile"
  
  # Replace original file atomically
  mv "$tmpfile" "$target_file"
  trap - EXIT
  
  echo "Removed Homebrew block from $target_file"
}

# Main execution
echo "Disabling Homebrew configuration..."

# Remove from .bashrc only (since that's where we added it)
remove_homebrew_block "$BASHRC"

echo ""
echo "✅ Homebrew disabled successfully!"
echo ""
echo "Note: This only removes shell configuration."
echo "To completely uninstall Homebrew, run:"
echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"'
echo ""
echo "To apply changes immediately, run:"
echo "  source ~/.bashrc"