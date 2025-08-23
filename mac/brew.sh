#!/bin/bash
# =============================================================================
# brew.sh
# -----------------------------------------------------------------------------
# Purpose:
#   Install Homebrew (requires Xcode CLT).
# =============================================================================
set -euo pipefail

if ! xcode-select -p >/dev/null 2>&1; then
  echo "❌ Command Line Tools missing. Run ./mac/init.sh first."
  exit 1
fi

echo "🍺 Installing Homebrew if needed..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

# Put brew in this session
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "✅ brew.sh complete."
