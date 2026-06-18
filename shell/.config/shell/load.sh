#!/usr/bin/env bash
# ~/.config/shell/load.sh

BASHRC="$HOME/.bashrc"
LOAD_FILE='$HOME/.config/shell/load.sh'   # keep $HOME literal
BLOCK_BEGIN="# >>> shell-load (managed by dotfiles) >>>"
BLOCK_END="# <<< shell-load (managed by dotfiles) <<<"

install_into_bashrc() {
  # Create ~/.bashrc if missing
  [ -f "$BASHRC" ] || : >"$BASHRC"

  # Exact, literal match — avoids false negatives from quoting variations
  # that previously made re-running this appendable indefinitely.
  if grep -Fq "$BLOCK_BEGIN" "$BASHRC"; then
    echo "Sourcing of custom shell config already present in $BASHRC"
    return 0
  fi

  {
    printf '\n%s\n' "$BLOCK_BEGIN"
    printf '%s\n' "[ -f \"$LOAD_FILE\" ] && . \"$LOAD_FILE\""
    printf '%s\n' "$BLOCK_END"
  } >>"$BASHRC"
  echo "Added sourcing of custom shell config to $BASHRC"
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
