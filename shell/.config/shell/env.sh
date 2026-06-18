# Resolve DOTFILES_DIR for use by aliases/functions (e.g. the `dots` alias
# in aliases.sh), regardless of what the user named the cloned directory.
# env.sh is itself a stowed symlink, so it's resolved back to the real file
# before asking git for the repo root -- same technique as lib/common.sh,
# duplicated here since that file isn't reachable until this resolution is done.
if [ -z "${DOTFILES_DIR:-}" ]; then
  _env_self="${BASH_SOURCE[0]}"
  while [ -L "$_env_self" ]; do
    _env_link_dir="$(cd -P "$(dirname "$_env_self")" && pwd)"
    _env_self="$(readlink "$_env_self")"
    case "$_env_self" in
      /*) ;;
      *) _env_self="$_env_link_dir/$_env_self" ;;
    esac
  done
  _env_self_dir="$(cd -P "$(dirname "$_env_self")" >/dev/null 2>&1 && pwd)"
  DOTFILES_DIR="$(git -C "$_env_self_dir" rev-parse --show-toplevel 2>/dev/null || true)"
  unset _env_self _env_link_dir _env_self_dir
fi
export DOTFILES_DIR

# NVM related
# Set where NVM will store installed Node versions
export NVM_DIR="$HOME/.nvm"

# workaround for known issue: 'nvm disables hashing' for some distros (see https://github.com/nvm-sh/nvm/issues/2065)
prev_hashall=0
[[ :$BASHOPTS: == *:hashall:* ]] && prev_hashall=1
set -h # enable hashing for nvm.sh (guards its \hash -r)

# Single source of truth for nvm activation (installed via curl, see
# install/optional/nvm/enable.sh, which runs the installer with
# PROFILE=/dev/null so it doesn't also write its own activation snippet
# into a shell profile).
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

((prev_hashall == 0)) && set +h

# Starship prompt (installed via package manager on all platforms — see
# mac/Brewfile, packages-arch.txt, packages-ubuntu.txt). No separate
# enable/disable script: this is the single source of truth for activation,
# guarded so it's a no-op on any machine where starship isn't installed.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# mise (dev tool version manager, mac Brewfile only today). Same pattern as
# starship above: guarded activation here instead of a separate enable script.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# Cargo/Rust (optional, see install/optional/cargo/enable.sh, which installs
# via rustup with --no-modify-path so it doesn't also self-append an
# activation line to a shell profile). Single source of truth for activation,
# guarded so it's a no-op if not installed.
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
