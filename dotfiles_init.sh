# Note: Run the following before executing this script:
# 1. Install git if not already installed.
# 2. (Optional) install github CLI and set up SSH keys for GitHub access.

# Clone the dotfiles repository as a bare repo if it doesn't exist
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Cloning the dotfiles repository as a bare repository..."
    git clone --bare git@github.com:Murdock135/dotfiles.git "$HOME/.dotfiles"

    # Check if the repository was successfully cloned
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone the repository."
        exit 1
    else
        echo "Successfully cloned the dotfiles repository."
    fi
else
    echo "Dotfiles repository already exists. Skipping clone."
fi

# Define the dotfiles function directly in the script
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

echo "Setting up the 'dotfiles' alias in .zshrc..."
echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'" >> "$HOME/.zshrc"
echo "'dotfiles' alias added to .zshrc"

# Set local config
dotfiles config --local status.showUntrackedFiles no

# Backup any existing files that would be overwritten
echo "Checking for conflicting files..."
conflicting_files=$(dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}')
if [ -n "$conflicting_files" ]; then
    echo "Conflicting files found. Backing up existing files..."
    mkdir -p "$HOME/.dotfiles-backup"
    for file in $conflicting_files; do
        echo "Backing up $file..."
        backup_dir="$HOME/.dotfiles-backup/$(dirname "$file")"
        mkdir -p "$backup_dir"
        mv "$HOME/$file" "$backup_dir/"
    done
    echo "Backup completed."
else
    echo "No conflicting files found."
fi

# Attempt to check out the dotfiles again
echo "Attempting to check out the dotfiles..."
dotfiles checkout
if [ $? -eq 0 ]; then
    echo "Dotfiles checked out successfully."
    echo "Remember to source your .zshrc to use the 'dotfiles' alias: source ~/.zshrc"
else
    echo "Error: Failed to check out the dotfiles."
    exit 1
fi
