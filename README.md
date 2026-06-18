# Usage

1. Clone the repo with `git clone https://github.com/Murdock135/mydotfiles.git`
2. Move into the directory (e.g. `cd dotfiles` if you didn't rename it — every script in this repo auto-detects the repo root via `git`, so the directory name itself doesn't actually matter, see `lib/common.sh`)
3. Install packages for your OS:
   - **Arch**: follow [install/arch/README.md](install/arch/README.md)
   - **Ubuntu**: follow [install/ubuntu/README.md](install/ubuntu/README.md)
   - **macOS**: follow [mac/README.md](mac/README.md) — note that walkthrough already covers stowing your shell config and the rest of your dotfiles, so once you've finished it you can skip directly to step 5 below

4. Stow the packages (Arch/Ubuntu — if you followed the macOS guide above, this is already done). Look into each package to know what you are importing!

```
stow -v shell
stow -v hypr
stow -v git
.
.
.
```

> > [!NOTE]
> If stow warns you that the same files already exist in your machine (predesigned configs), you have to make a choice between (1) using these configs (2) using the pre-existing configs (3) make a 'balancing act' and using some from each. (1) is easiest. Simply delete the predesigned configs and use the stow command again. I personally had to do this because I am using [Omarchy](https://omarchy.org/), which ships with its own `keymaps.lua` and `options.lua`. 

5. Load aliases and functions (Arch/Ubuntu — macOS already gets this wired up automatically by `mac/init.sh`)
```
~/.config/shell/load.sh
```

# Enabling more packages from `install/optional/`
To enable any package, simply run 

```
cd "$DOTFILES_DIR"   # exported by env.sh once shell/ is stowed and loaded; otherwise cd into wherever you cloned this repo
bash install/optional/<package>/enable.sh
```

To disable the package (to not use them), run

```
bash install/optional/<package>/disable.sh
```

Optionally, if you also want to unstow them you can use the `--unstow` flag, like so

```
bash install/optional/<package>/disable.sh --unstow
```

Optionally, if you want to fully purge the config (deletes the config files from ~/.config/<package>/)

```
bash install/optional/<package>/disable.sh --unstow --purge
```

# Which package manager installs what

Master list of every package/app meant to be used across all three OSes, and which
mechanism installs it on each. Empty cell = not installed on that OS. Where the
underlying package/formula name differs from the row label, it's noted in parens.

| Package/App | Arch | Ubuntu | macOS |
|---|---|---|---|
| git | yay | apt | homebrew |
| GitHub CLI | yay (`github-cli`) | apt (`github-cli`) | homebrew (`gh`) |
| stow | yay | apt | homebrew |
| eza | yay | apt | homebrew |
| tmux | yay | apt | homebrew |
| curl | yay | apt | |
| wget | yay | apt | |
| gzip | yay | apt | |
| htop | yay | apt | |
| uv | yay | apt (`astral-uv`) | homebrew |
| ripgrep | yay | apt | homebrew |
| fd | yay | apt (`fd-find`) | homebrew |
| starship | yay | apt | homebrew |
| neovim | yay | linuxbrew | homebrew |
| lua-language-server | yay | linuxbrew | homebrew |
| python | yay | | |
| gcc | | apt | |
| luarocks | | apt | |
| build-essential | | apt | |
| neofetch | | apt | |
| fastfetch | yay | | |
| xclip | | apt | |
| wl-clipboard | yay | | |
| docker | yay | | |
| docker-compose | yay | apt | |
| docker-buildx | yay | | |
| lazydocker | yay | | |
| appimagelauncher | yay | | |
| tree-sitter | | | homebrew |
| tree-sitter-cli | | | homebrew |
| python-lsp-server | | | homebrew |
| ollama | | | homebrew |
| mise | | | homebrew |
| obsidian | yay | | homebrew (cask) |
| zoom | yay | | homebrew (cask) |
| Visual Studio Code | yay (`visual-studio-code-bin`) | | homebrew (cask, `visual-studio-code`) |
| discord | yay | | homebrew (cask) |
| zen browser | yay (`zen-browser-bin`) | | |
| zotero | yay | | homebrew (cask) |
| spotify | yay | | homebrew (cask) |
| alacritty | yay | | homebrew (cask) |
| raycast | | | homebrew (cask) |
| microsoft teams | | | homebrew (cask) |
| microsoft office | | | homebrew (cask) |
| fontbase | | | homebrew (cask) |
| logitech options | | | homebrew (cask, `logitech-options`) |
| logi options+ | | | homebrew (cask, `logi-options++`) |
| onedrive | | | homebrew (cask) |
| google drive | | | homebrew (cask) |
| chatgpt | | | homebrew (cask) |
| rectangle | | | homebrew (cask) |
| aerospace | | | homebrew (cask, via `nikitabobko/tap`) |
| Nerd Font: Source Code Pro | yay (`ttf-sourcecodepro-nerd`) | | |
| Nerd Font: Droid Sans Mono | yay (`otf-droid-nerd`) | linuxbrew (cask) | homebrew (cask) |
| Nerd Font: Fira Code | | linuxbrew (cask) | homebrew (cask) |

> [!NOTE]
> The nerd font *families* differ by OS: Arch additionally installs Source Code Pro, which Ubuntu/mac don't. Not fixed as part of this table — just worth knowing if a glyph looks different across machines.
>
> Docker Desktop is manual-only on macOS (see `mac/other_packages.txt`) — not a gap in the table, just not scriptable.

### Self-installed tools (no package manager — same official installer script on every OS)

- **nvm** — `install/optional/nvm/enable.sh` runs nvm's official curl installer. Activated via `env.sh`, guarded on `~/.nvm/nvm.sh` existing.
- **cargo/rust** — `install/optional/cargo/enable.sh` runs rustup. Activated via `env.sh`, guarded on `~/.cargo/env` existing.
- **Homebrew itself** — on Linux, `install/optional/homebrew/enable.sh` runs Homebrew's official curl installer and wires the `linuxbrew` shellenv into `.bashrc`. On macOS it isn't optional: `mac/brew.sh` installs it directly via the same curl installer and wires it into `.bash_profile`.

# Neovim prerequisites

Coverage of [nvim's documented prerequisites](nvim/.config/nvim/README.md) per OS
package list. Check this table when changing a package list or verifying neovim
will actually build/run correctly on a given OS.

| Prerequisite | Arch | Ubuntu | macOS |
|---|---|---|---|
| git, curl | ✓ | ✓ | ✓ (built-in) |
| nerd font | ✓ | ✓ (via Brewfile) | ✓ |
| clipboard provider | ✓ (`wl-clipboard`) | ✓ (`xclip`) | ✓ (`pbcopy` built-in) |
| ripgrep | ✓ | ✓ | ✓ |
| fd | ✓ | ✓ (`fd-find`, symlinked to `fd`) | ✓ |
| python | ✓ (explicit) | ✓ (preinstalled by OS) | ✗ (relies on `uv` to fetch one) |
| uv/pip | ✓ | ✓ | ✓ |
| pylsp | n/a (per-venv — see note below) | n/a (same) | ✓ (`python-lsp-server`, but same per-venv caveat applies in practice) |
| lua-language-server | ✓ | ✓ (via Homebrew-on-Linux) | ✓ |
| C compiler (for `:TSUpdate`) | implicit via `base-devel` | ✓ explicit | ✓ via Xcode CLT |
| Cargo/rust (blink.cmp build fallback) | ✓ (`install/optional/cargo`) | ✓ (same) | ✓ (same) |

> [!NOTE]
> `pylsp` needs to see each project's own venv to give accurate diagnostics/completions, so it can't be handled with one global install like the rest of this table. It's a manual, per-project prerequisite — see [nvim/.config/nvim/README.md](nvim/.config/nvim/README.md).
