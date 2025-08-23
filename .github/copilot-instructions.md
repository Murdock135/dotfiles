# Copilot Instructions

## Overview

This dotfiles repository bootstraps and configures various aspects of the development environment and OS settings. It is organized into directories by purpose:

- **mac/**: Scripts for macOS-specific setup (e.g., installing Homebrew packages, Xcode CLT, default shell configuration).
- **nvim/** and **nvim_omarchy/**: Neovim configurations.
- **git/**, **shell/**, **starship/**, **utils/**: Additional system configurations and custom scripts.

## Architecture & Workflows

- **Dotfiles Directory**: The environment variable `DOTFILES_DIR` defines the repository root, enabling scripts to easily locate their configuration files (e.g., `$DOTFILES_DIR/mac/Brewfile`).
- **Bootstrap Scripts**: 
  - `mac/init.sh` bootstraps the system by installing Xcode Command Line Tools and setting the default shell to `/bin/bash`.
  - `mac/install_packages.sh` installs Homebrew packages via `brew bundle` using the Brewfile.
- **Stow Integration**: As documented in the `README.md`, GNU Stow is used to create symbolic links for configurations (e.g., `stow shell`, `stow hypr`, `stow git`).
- **Error Handling & Robustness**: Scripts include `set -euo pipefail` for early error detection and reliable execution.

## Developer Conventions & Patterns

- **Shell Scripting Practices**: Scripts explicitly set environment variables and prompt user confirmation (e.g., validating DOTFILES_DIR in `install_packages.sh`). Note the differences in shell usage between Bash (in `install_packages.sh`) and Zsh (in `init.sh`).
- **External Dependencies**: Key tools include Homebrew and Xcode Command Line Tools; ensure these are properly installed as per instructions in the `mac/` scripts.
- **Configuration Updates**: When changes are made to configuration directories (e.g., `nvim/`), re-run Stow commands to update symbolic links.

## Additional Guidance

- **Big Picture**: Understand that the repository is meant to standardize and automate development environment setups across various tools and platforms. Reading multiple files (like those in `mac/` and `README.md`) is essential to grasp service boundaries and data flows.
- **Developer Workflows**: Common tasks include bootstrapping a machine (running `./mac/init.sh`), installing packages (`./mac/install_packages.sh`), and linking configuration files using Stow. These workflows help maintain consistency across different setups.
- **Feedback**: If any section is unclear or seems incomplete, please provide your feedback for iterative improvements.

*These instructions capture the essential, discoverable patterns of the dotfiles repository as of August 2025.*
