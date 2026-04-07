#!/usr/bin/env bash
set -euo pipefail

# check if nvm exists already. If so, exit.
if command -v nvm >/dev/null 2>&1; then
  echo "nvm is already installed and available on PATH. Exiting."
  exit 0
fi

# install nvm if not present
if [ ! -d "${NVM_DIR:-$HOME/.nvm}" ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
else
  echo "nvm directory found but nvm is not on PATH. Skipping install."
fi

# configuration
BLOCK_BEGIN="# >>> NVM configuration (managed by dotfiles) >>>"
BLOCK_END="# <<< NVM configuration (managed by dotfiles) <<<"

read -r -d '' NVM_BLOCK <<'EOF'
# >>> NVM configuration (managed by dotfiles) >>>"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# <<< NVM configuration (managed by dotfiles) <<<"
EOF

# Ask user preference for profile file
echo "Which profile do you use?"
echo "  1) .bash_profile"
echo "  2) .profile"
read -rp "Enter choice [1-2]: " choice

case "$choice" in
  1) PROFILE="$HOME/.bash_profile" ;;
  2) PROFILE="$HOME/.profile" ;;
  *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

# Add NVM block to profile if not already present
if grep -qF "$BLOCK_BEGIN" "$PROFILE" 2>/dev/null; then
  echo "NVM configuration block already exists in $PROFILE. Skipping."
else
  printf '\n%s\n' "$NVM_BLOCK" >> "$PROFILE"
  echo "NVM configuration added to $PROFILE."
fi
