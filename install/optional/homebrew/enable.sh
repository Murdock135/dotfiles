#!/usr/bin/env bash
set -euo pipefail

# Configuration
BASHRC="${HOME}/.bashrc"
BLOCK_BEGIN="# >>> Homebrew (managed by dotfiles) >>>"
BLOCK_END="# <<< Homebrew (managed by dotfiles) <<<"

HOMEBREW_BLOCK=$(cat <<'EOF'
# >>> Homebrew (managed by dotfiles) >>>
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# <<< Homebrew (managed by dotfiles) <<<
EOF
)

# Function to add block to a file if it doesn't exist
add_homebrew_block() {
  local target_file="$1"
  
  # Create file if it doesn't exist
  [ -f "$target_file" ] || touch "$target_file"
  
  # Check if block already exists
  if grep -Fq "$BLOCK_BEGIN" "$target_file"; then
    echo "Homebrew block already exists in $target_file"
    return 0
  fi
  
  # Create temporary file
  local tmpfile
  tmpfile="$(mktemp "${target_file}.XXXX")"
  trap 'rm -f "$tmpfile"' EXIT
  
  # Copy existing content
  cat "$target_file" > "$tmpfile"
  
  # Append Homebrew block
  echo "" >> "$tmpfile"
  echo "$HOMEBREW_BLOCK" >> "$tmpfile"
  
  # Replace original file atomically
  mv "$tmpfile" "$target_file"
  trap - EXIT
  
  echo "Added Homebrew block to $target_file"
}

# Main execution
echo "Enabling Homebrew configuration..."

# Check if Homebrew is installed
if [ ! -d "/home/linuxbrew/.linuxbrew" ]; then
  echo "Warning: Homebrew not found at /home/linuxbrew/.linuxbrew"
  echo "Install it first with:"
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
fi

# Add to .bashrc only
# Since your .bash_profile sources .bashrc, this covers both login and interactive shells
add_homebrew_block "$BASHRC"

echo ""
echo "✅ Homebrew enabled successfully!"
echo ""
echo "To apply changes immediately, run:"
echo "  source ~/.bashrc"
echo ""
echo "Dependencies note:"
echo "  If you have sudo access, install build tools:"
echo "    sudo apt-get install build-essential"