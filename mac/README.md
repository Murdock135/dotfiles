# Dotfiles (macOS)

This folder contains setup scripts for macOS. The parent directory contains my dotfiles, which are meant to be symlinked with GNU stow into `~/.config/`. 

---

## 📦 Prerequisites

- macOS (fresh install works fine)
- Internet connection

---

## 🚀 Setup Steps

All scripts live in [`mac/`](./mac). Run them in order (Note: Make sure they are executable. You can use the `chmod +x` command.):

1. Make the scripts executable
```
chmod +x ./mac/*.sh
```

2. **Bootstrap system (Xcode Command Line Tools + default shell = bash)**
   ```sh
   ./mac/init.sh

- Installs Xcode Command Line Tools if not already installed.

- Sets /bin/bash as your login shell (log out / back in to take effect)

- Symlinks home/.bashrc and home/.bash_profile into ~

1. Install Homebrew

```
./mac/brew.sh
```

3. Install packages from Brewfile

```
./mac/install_packages.sh
```


4. Stow shell shims

```
cd ~/mydotfiles
stow -t "$HOME" mac/home 
```

Optional quick check

```
ls -l ~/.bash_profile ~/.bashrc
```

5. Stow rest of the dotfiles into `~/.config` by running setup.sh

```
./mac/setup.sh
```

# To apply changes in the Brewfile

```
brew bundle --file=~/mydotfiles/mac/Brewfile
```

# To reapply dotfiles symlinks with stow

`./mac/setup.sh`

# Post-install: starting the Ollama service

`ollama` is installed via the Brewfile, but unlike `starship`/`mise` (which only need
per-shell activation, handled automatically by `shell/.config/shell/env.sh`), it's a
background service and deliberately isn't auto-started on every shell. Start it manually:

```
brew services start ollama
```

# Quick verification

```
echo "$SHELL"
echo "$0"
type brew
type stow
```
