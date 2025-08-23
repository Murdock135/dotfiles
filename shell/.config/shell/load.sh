#!/usr/bin/env bash
# ~/.config/shell/load.sh

BASHRC="$HOME/.bashrc"
LOAD_FILE='$HOME/.config/shell/load.sh'   # keep $HOME literal
SOURCE_LINE=". $LOAD_FILE"

install_into_bashrc() {
  # Create ~/.bashrc if missing
  [ -f "$BASHRC" ] || : >"$BASHRC"

  # Look for any line that sources ~/.config/shell/load.sh (plain or guarded)
  if ! grep -Eq '\. *(\$HOME|'"$HOME"')/\.config/shell/load\.sh' "$BASHRC"; then
    {
      echo ""
      echo "# Layer custom shell config"
      echo "[ -f \"$LOAD_FILE\" ] && . \"$LOAD_FILE\""
    } >>"$BASHRC"
    echo "Added sourcing of custom shell config to $BASHRC"
  fi
}

# If executed directly, run the installer step and exit
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_into_bashrc
  exit 0
fi

# -------- Runtime loading (when sourced by .bashrc) --------

# Env vars (load always)
[ -f "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"

# Only continue if interactive
case $- in
  *i*) : ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

# Aliases
[ -f "$HOME/.config/shell/aliases.sh" ] && . "$HOME/.config/shell/aliases.sh"

# All function scripts
func_dir="$HOME/.config/shell/functions"
if [ -d "$func_dir" ]; then
  for f in "$func_dir"/*.sh; do
    [ -f "$f" ] && . "$f"
  done
fi
