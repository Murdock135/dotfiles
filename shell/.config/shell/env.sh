# NVM related
# Set where NVM will store installed Node versions
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/nvm"

# workaround for known issue: 'nvm disables hashing' for some distros (see https://github.com/nvm-sh/nvm/issues/2065)
prev_hashall=0
[[ :$BASHOPTS: == *:hashall:* ]] && prev_hashall=1
set -h # enable hashing for nvm.sh (guards its \hash -r)

# Arch AUR package path
if [ -s /usr/share/nvm/init-nvm.sh ]; then
  . /usr/share/nvm/init-nvm.sh

# GitHub install script path
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

((prev_hashall == 0)) && set +h
