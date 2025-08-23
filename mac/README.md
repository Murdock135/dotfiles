# Dotfiles (macOS)

This repo contains my personal dotfiles and setup scripts for macOS.  
It uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink configuration files into `~/.config`.

---

## 📦 Prerequisites

- macOS (fresh install works fine)
- Internet connection

---

## 🚀 Setup Steps

All scripts live in [`mac/`](./mac). Run them in order:

1. **Bootstrap system (Xcode Command Line Tools + default shell = bash)**
   ```sh
   ./mac/init.sh

- Runs under zsh (default macOS shell).

- Installs Xcode Command Line Tools if not already installed.

- Sets /bin/bash as your login shell (log out / back in to take effect)

2. Install Homebrew

```
./mac/brew.sh
```

3. Install packages from Brewfile

```
./mac/install_packages.sh
```
```
```

4. Stow dotfiles into `~/.config`

```
./mac/setup.sh
```

# To apply changes in the Brewfile

```
brew bundle --file=~/mydotfiles/mac/Brewfile
```

# To reapply dotfiles symlinks with stow

`./mac/setup.sh`
