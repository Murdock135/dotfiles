if ! command -v "nvim" &> /dev/null; then
    echo "Neovim is not installed. Installing..."
    brew install neovim
else
    echo "Neovim is already installed."
fi

if ! grep -q "alias vi='nvim'" "$HOME/.zshrc"; then
    echo "alias vi='nvim'" >> "$HOME/.zshrc"
fi

if ! grep -q "alias vi='nvim'" "$HOME/.bashrc"; then
    echo "alias vi='nvim'" >> "$HOME/.bashrc"
fi
