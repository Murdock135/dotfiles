#!/usr/bin/env bash
set -euo pipefail

# check if cargo exists already. If so, exit.
if command -v cargo >/dev/null 2>&1; then
  echo "cargo is already installed and available on PATH. Exiting."
  exit 0
fi

CARGO_ENV="${HOME}/.cargo/env"
if [ -f "$CARGO_ENV" ]; then
  echo "cargo already installed (found ${CARGO_ENV}). Skipping install."
else
  echo "Installing Rust (cargo) via rustup..."
  # -y: non-interactive. --no-modify-path: don't let rustup also append its
  # own activation line to a shell profile -- env.sh is this repo's single
  # source of truth for activation (it sources ~/.cargo/env, which rustup
  # always creates regardless of --no-modify-path).
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

echo "cargo installed. It will be activated automatically by shell/.config/shell/env.sh."
