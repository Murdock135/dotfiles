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

# 3) Symlink .bashrc and .bash_profile into ~
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "REPO_ROOT: $REPO_ROOT"
read -p "Is this the correct dotfiles directory? (y/n): " answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Please manually change REPO_ROOT in mac/init.sh and try again."
  exit 1
fi

ln -sf "$REPO_ROOT/bash/.bashrc" "$HOME/.bashrc"
ln -sf "$REPO_ROOT/bash/.bash_profile" "$HOME/.bash_profile"
echo "✅ Symlinked .bashrc and .bash_profile to mac/home shims"

# silence Apple's zsh MOTD
[ -f "$HOME/.hushlogin" ] || touch "$HOME/.hushlogin"

echo "✅ init.sh complete."

