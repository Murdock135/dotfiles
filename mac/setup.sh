#!/bin/zsh

set -euo pipefail

# -----------------------------
# setup.sh (run under zsh)
# Installs Xcode CLT + switches default shell to bash
# -----------------------------

echo "🚀 Starting macOS setup (setup.sh)"

# Ask for sudo upfront
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# 1. Ensure Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "🛠 Installing Xcode Command Line Tools..."
  xcode-select --install || true
  echo "⚠️ A GUI popup appeared. Finish installing, then re-run this script."
  exit 1
else
  echo "✅ Xcode Command Line Tools already installed."
fi

# 2. Switch default shell to /bin/bash
if [[ "$SHELL" != "/bin/bash" ]]; then
  echo "🐚 Changing default shell to /bin/bash..."
  if ! grep -q "/bin/bash" /etc/shells; then
    echo "/bin/bash" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s /bin/bash
  echo "ℹ️ Default shell changed to /bin/bash. Log out and log back in for it to take effect."
else
  echo "✅ Default shell already /bin/bash."
fi

echo "✅ setup.sh complete."
