#!/usr/bin/env bash
set -euo pipefail

# check if nvm exists already. If so, exit.
if command -v nvm >/dev/null 2>&1; then
  echo "nvm is already installed and available on PATH. Exiting."
  exit 0
fi

# install nvm if not present
NVM_INSTALL_DIR="${HOME}/.nvm"
if [ ! -f "${NVM_INSTALL_DIR}/nvm.sh" ]; then
  echo "Installing nvm..."
  unset NVM_DIR
  # PROFILE=/dev/null tells nvm's installer to skip auto-appending its own
  # activation snippet to a shell profile. env.sh is this repo's single
  # source of truth for nvm activation (shell/.config/shell/env.sh) --
  # without this, the installer would write a second, unmanaged copy of
  # the same activation logic straight into ~/.bashrc.
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | PROFILE=/dev/null bash
else
  echo "nvm already installed at ${NVM_INSTALL_DIR}. Skipping install."
fi

echo "nvm installed. It will be activated automatically by shell/.config/shell/env.sh."
