#!/usr/bin/env bash
set -euo pipefail

# Location assumptions:
#   This script lives at: mydotfiles/install/optional/starship/enable.sh
#   Repo root is three levels up from here.
#   Starship config lives at: mydotfiles/starship/.config/starship/starship.toml

# --- config/paths ------------------------------------------------------------
# Allow override via env; otherwise try git, then path math.
if [ -z "${REPO_DIR:-}" ]; then
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_DIR="$(git rev-parse --show-toplevel)"
  else
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
  fi
fi

BASHRC="${HOME}/.bashrc"
BLOCK_BEGIN="# >>> starship (managed by mydotfiles) >>>"
BLOCK_END="# <<< starship (managed by mydotfiles) <<<"

# --- preflight checks --------------------------------------------------------
# 0) Require .bashrc to exist (do NOT auto-create)
if [ ! -f "$BASHRC" ]; then
  echo "Error: ~/.bashrc not found. Please create one before enabling Starship." >&2
  exit 1
fi

# 1) Require stow (we'll try to stow the starship package if needed)
if ! command -v stow >/dev/null 2>&1; then
  echo "Error: 'stow' is not installed or not on PATH." >&2
  exit 1
fi

# 2) Require starship binary (we only wire it up here; installation is out of scope)
if ! command -v starship >/dev/null 2>&1; then
  echo "Error: 'starship' is not installed or not on PATH." >&2
  echo "Install Starship first, then re-run this script." >&2
  exit 1
fi

# --- ensure config is stowed -------------------------------------------------
TARGET_TOML="${HOME}/.config/starship/starship.toml"
if [ ! -e "$TARGET_TOML" ]; then
  echo "Stowing 'starship' package..."
  (cd "$REPO_DIR" && stow --target="$HOME" starship)
fi

# --- update ~/.bashrc atomically --------------------------------------------
tmpfile="$(mktemp "${BASHRC}.XXXX")"
trap 'rm -f "$tmpfile"' EXIT

# Remove any existing managed block (idempotent)
awk -v start="$BLOCK_BEGIN" -v end="$BLOCK_END" '
  $0==start {skip=1; next}
  $0==end {skip=0; next}
  !skip {print}
' "$BASHRC" >"$tmpfile"

# Append a fresh managed block
cat >>"$tmpfile" <<'EOF'

# >>> starship (managed by mydotfiles) >>>
# Initialize Starship for bash if available.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
# <<< starship (managed by mydotfiles) <<<
EOF

# Replace original
mv "$tmpfile" "$BASHRC"
trap - EXIT

echo "Starship enabled for bash."
echo "Open a new shell or run: source ~/.bashrc"
