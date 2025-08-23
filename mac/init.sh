#!/bin/zsh
# =============================================================================
# init.sh
# -----------------------------------------------------------------------------
# Purpose:
#   Bootstrap macOS:
#     1) Install Xcode Command Line Tools
#     2) Set /bin/bash as the default login shell
# =============================================================================
set -euo pipefail

echo "🚀 Starting macOS init"

# Ask for sudo upfront and keep alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 1) Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "🛠 Installing Xcode Command Line Tools..."
  xcode-select --install || true
  echo "⚠️ CLT installer launched. Finish it, then re-run ./mac/init.sh."
  exit 1
else
  echo "✅ Xcode Command Line Tools already installed."
fi

# 2) Default shell -> /bin/bash
if [[ "$SHELL" != "/bin/bash" ]]; then
  echo "🐚 Changing default shell to /bin/bash..."
  grep -q "/bin/bash" /etc/shells || echo "/bin/bash" | sudo tee -a /etc/shells >/dev/null
  chsh -s /bin/bash
  echo "ℹ️ Log out and back in (or open a new terminal) to use bash."
else
  echo "✅ Default shell already /bin/bash."
fi

# 3) create .bashrc and .bash_profile
if [ ! -f "$HOME/.bash_profile" ]; then
  touch "$HOME/.bash_profile"
fi

if [ ! -f "$HOME/.bashrc" ]; then
  touch "$HOME/.bashrc"
fi

echo "✅ init.sh complete."

