#!/usr/bin/env bash
set -euo pipefail

BASHRC="${HOME}/.bashrc"
BLOCK_BEGIN="# >>> starship (managed by mydotfiles) >>>"
BLOCK_END="# <<< starship (managed by mydotfiles) <<<"

# 0) Require .bashrc
if [ ! -f "$BASHRC" ]; then
  echo "Error: ~/.bashrc not found. Please create one before enabling Starship." >&2
  exit 1
fi

# 1) Require starship binary
if ! command -v starship >/dev/null 2>&1; then
  echo "Error: 'starship' not found on PATH. Install it first." >&2
  exit 1
fi

# 2) Re-write ~/.bashrc atomically
tmpfile="$(mktemp "${BASHRC}.XXXX")"
trap 'rm -f "$tmpfile"' EXIT

# Remove old block if present
awk -v start="$BLOCK_BEGIN" -v end="$BLOCK_END" '
  $0==start {skip=1; next}
  $0==end {skip=0; next}
  !skip {print}
' "$BASHRC" > "$tmpfile"

# Append fresh block
cat >> "$tmpfile" <<'EOF'

# >>> starship (managed by mydotfiles) >>>
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
# <<< starship (managed by mydotfiles) <<<
EOF

mv "$tmpfile" "$BASHRC"
trap - EXIT

echo "Starship enabled for bash. Run: source ~/.bashrc"
