# AGENTS.md

## Overview

This repository is designed for automating and standardizing development environment setups across macOS, Linux (Arch, Ubuntu), and related tools. The following agent customizations and instructions help AI agents (like GitHub Copilot) work productively in this workspace.

---

## Agent Customization Principles

- **Link, Don’t Embed:** Reference existing documentation (README.md, .github/copilot-instructions.md) instead of duplicating content.
- **Platform Awareness:** Use platform-specific scripts and instructions (see `mac/`, `install/arch/`, `install/ubuntu/`).
- **Stow Workflow:** Prefer Stow for symlinking configs. Always check for existing files and warn about conflicts.
- **Script Robustness:** Scripts use `set -euo pipefail` for error handling. Agents should expect early exits on error.
- **Environment Variable:** Use `DOTFILES_DIR` for script portability.

---

## Agent Instructions by Area

### 1. mac/
- Use `mac/init.sh` to bootstrap macOS (Xcode CLT, shell setup).
- Use `mac/brew.sh` and `mac/install_packages.sh` for Homebrew and package installs.
- Use `mac/setup.sh` and Stow for symlinking configs.
- Reference [mac/README.md](mac/README.md) for step-by-step instructions.

### 2. install/arch/ and install/ubuntu/
- Use `install_packages.sh` for package installation.
- On Ubuntu, prefer Homebrew for up-to-date packages (see [install/ubuntu/README.md](install/ubuntu/README.md)).
- Reference [install/arch/README.md](install/arch/README.md) and [install/ubuntu/README.md](install/ubuntu/README.md) for details.

### 3. install/optional/
- Enable/disable optional features with `<package>/enable.sh` or `disable.sh`.
- Some packages require manual installation (see `manual_install_list.txt`).

### 4. General
- Always check for and link to relevant documentation before providing instructions.
- For new configs, recommend using Stow and updating symlinks as needed.

---

## Example Prompts

- "How do I bootstrap a new macOS machine with these dotfiles?"
- "How do I enable the starship prompt?"
- "What should I do if Stow reports a conflict?"
- "How do I install all required packages on Ubuntu?"
- "How do I update my Neovim config after making changes?"

---

## Suggestions for Further Customization

- Create applyTo-based instructions for platform-specific scripts (e.g., only apply macOS instructions to `mac/` scripts).
- Add agent hooks for common troubleshooting (e.g., Stow conflicts, missing dependencies).
- Expand documentation links as new features or scripts are added.

---

For more details, see [.github/copilot-instructions.md](.github/copilot-instructions.md) and the main [README.md](README.md).
