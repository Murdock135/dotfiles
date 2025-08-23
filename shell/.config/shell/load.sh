#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
LOAD_FILE="$HOME/.config/shell/load.sh"
SOURCE_CMD=". $LOAD_FILE"

# Ensure .bashrc sources *this* load.sh
if ! grep -Fxq "$SOURCE_CMD" "$BASHRC"; then
  {
    echo ""
    echo "# Layer custom shell config"
    echo "$SOURCE_CMD"
  } >>"$BASHRC"
  echo "Added sourcing of custom shell config to .bashrc"
fi

# --- Modular sourcing starts here ---

# Aliases
[ -f "$HOME/.config/shell/aliases.sh" ] && source "$HOME/.config/shell/aliases.sh"

# Env vars
[ -f "$HOME/.config/shell/env.sh" ] && source "$HOME/.config/shell/env.sh"

# All function scripts
if [ -d "$HOME/.config/shell/functions" ]; then
  for f in "$HOME/.config/shell/functions/"*.sh; do
    [ -f "$f" ] && source "$f"
  done
fi
