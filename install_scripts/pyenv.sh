if ! command -v pyenv &> /dev/null; then
    echo "pyenv is not installed. Installing..."
    brew install pyenv
else
    echo "pyenv is already installed."
fi

if ! grep -q 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zshrc; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
fi

if ! grep -q '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.zshrc; then
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
fi

if ! grep -q 'eval "$(pyenv init - zsh)"' ~/.zshrc; then
    echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc
fi
