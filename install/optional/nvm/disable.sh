
#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Usage: disable.sh
#
# Removes the NVM configuration block from common shell profiles.
# Edit the PROFILES array below to customize which files are checked.
# ------------------------------------------------------------------------------

# List of shell profiles to check (edit as needed)
PROFILES=("$HOME/.bash_profile" "$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc")

BLOCK_BEGIN="# >>> NVM configuration (managed by dotfiles) >>>"
BLOCK_END="# <<< NVM configuration (managed by dotfiles) <<<"

remove_nvm_block() {
  local target_file="$1"
  # Skip if file doesn't exist
  if [ ! -f "$target_file" ]; then
    echo "Skipping $target_file (does not exist)"
    return 0
  fi
  # Check if block exists
  if ! grep -Fq "$BLOCK_BEGIN" "$target_file"; then
    echo "No NVM block found in $target_file"
    return 0
  fi
  # Remove managed block using awk
  local tmpfile
  tmpfile="$(mktemp "${target_file}.XXXX")"
  trap 'rm -f "$tmpfile"' EXIT
  awk -v start="$BLOCK_BEGIN" -v end="$BLOCK_END" '
    $0 == start { skip=1; next }
    $0 == end { skip=0; next }
    !skip { print }
  ' "$target_file" > "$tmpfile"
  mv "$tmpfile" "$target_file"
  trap - EXIT
  echo "Removed NVM block from $target_file"
}


for profile in "${PROFILES[@]}"; do
  remove_nvm_block "$profile"
done

echo "NVM configuration block removal complete."
