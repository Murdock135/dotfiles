#!/bin/bash

set -euo pipefail

# CLT is required for brew
if ! xcode-select -p >/dev/null 2>&1; then
  echo "❌ Command Line Tools missing. Run ./setup.sh first."
  exit 1
fi

echo "🍺 Installing Homebrew if needed..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi
