#!/usr/bin/env bash
set -euo pipefail

# check if nvm exists already. If so, exit.
if command -v nvm >/dev/null 2>&1; then
  echo "nvm is already installed and available on PATH. Exiting."
  exit 0
fi

# configuration
BLOCK_BEGIN="# >>> NVM configuration (managed by dotfiles) >>>"
BLOCK_END="# <<< NVM configuration (managed by dotfiles) <<<"

read -r -d '' NVM_BLOCK <<'EOF'
# >>> NVM configuration (managed by dotfiles) >>>"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# <<< NVM configuration (managed by dotfiles) <<<"
EOF

# Ask user preference for profile file
read -rp "Which profile do you use? \n 1) .bash_profile \n 2) .profile 





