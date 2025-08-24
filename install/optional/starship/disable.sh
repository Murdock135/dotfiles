#!/usr/bin/env bash
set -euo pipefail

# --- config/paths ------------------------------------------------------------
BASHRC="${HOME}/.bashrc"
BLOCK_BEGIN="# >>> starship (managed by mydotfiles) >>>"
BLOCK_END="# <<< starship (managed by mydotfiles) <<<"

REPO_DIR="${REPO_DIR:-}"
if [ -z "$REPO_DIR" ]; then
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_DIR="$(git rev-parse --show-toplevel)"
  else
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
  fi
fi

TARGET_CONFIG_DIR="${HOME}/.config/starship"

# --- flags -------------------------------------------------------------------
UNSTOW=false
PURGE=false

usage() {
  cat <<'USAGE'
Usage: disable.sh [--unstow] [--purge]

Removes the Starship managed block from ~/.bashrc.

Options:
  --unstow   Run 'stow -D starship' from repo root after removing the block.
  --purge    Remove ~/.config/starship after unstow (use with care).

Notes:
  --purge implies you really want to remove local Starship config files.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --unstow)
    UNSTOW=true
    shift
    ;;
  --purge)
    PURGE=true
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    exit 2
    ;;
  esac
done

# --- preflight checks --------------------------------------------------------
# 0) Require .bashrc to exist (do NOT auto-create)
if [ ! -f "$BASHRC" ]; then
  echo "Error: ~/.bashrc not found. Nothing to disable." >&2
  exit 1
fi

# --- update ~/.bashrc atomically --------------------------------------------
tmpfile="$(mktemp "${BASHRC}.XXXX")"
trap 'rm -f "$tmpfile"' EXIT

# Copy .bashrc without the managed block
awk -v start="$BLOCK_BEGIN" -v end="$BLOCK_END" '
  $0==start {skip=1; next}
  $0==end {skip=0; next}
  !skip {print}
' "$BASHRC" >"$tmpfile"

# If nothing changed, awk output will be identical; mv still safe & atomic
mv "$tmpfile" "$BASHRC"
trap - EXIT

echo "Removed Starship block from ~/.bashrc (if present)."

# --- optional cleanup steps --------------------------------------------------
if $UNSTOW; then
  if ! command -v stow >/dev/null 2>&1; then
    echo "Warning: stow not found; skipping unstow." >&2
  else
    echo "Unstowing 'starship' package..."
    (cd "$REPO_DIR" && stow -D --target="$HOME" starship) || {
      echo "Warning: 'stow -D starship' failed; continuing." >&2
    }
  fi
fi

if $PURGE; then
  # Only remove if it's now empty or if you truly want it gone.
  if [ -d "$TARGET_CONFIG_DIR" ]; then
    echo "Purging ${TARGET_CONFIG_DIR} ..."
    rm -rf "$TARGET_CONFIG_DIR"
  fi
fi

echo "Starship disabled."
