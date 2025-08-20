ALIASES_FILE="$HOME/.config/shell/aliases.sh"
BASHRC="$HOME/.bashrc"
SOURCE_CMD="source $ALIASES_FILE"

if ! grep -Fxq "$SOURCE_CMD" "$BASHRC"; then
  echo "" >>"$BASHRC"
  echo "# Load custom aliases" >>"$BASHRC"
  echo "$SOURCE_CMD" >>"$BASHRC"
  echo "Added sourcing of aliases to .bashrc"
else
  echo "Aliases already sourced in"
fi
