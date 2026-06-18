# Usage

1. Clone the repo with `git clone https://github.com/Murdock135/mydotfiles.git`
2. Move into the directory (e.g. `cd dotfiles` if you didn't rename it — every script in this repo auto-detects the repo root via `git`, so the directory name itself doesn't actually matter, see `lib/common.sh`)
3. Stow the packages. (Look into each package to know what you are importing!)

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

4. Load aliases and functions
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

# TODOS

1. Neovim set up prerequisites
    - [x] ~~Python language server (handled by a script that uses uv)~~ — deliberately out of scope: `pylsp` needs to see each project's own venv to give accurate diagnostics/completions, so it can't be handled with one global install like the other prerequisites here. Already documented as a manual prerequisite in [nvim/.config/nvim/README.md](nvim/.config/nvim/README.md); not pursuing automation for it.
    - [x] Cargo (`install/optional/`) — added `install/optional/cargo/{enable,disable}.sh`, same pattern as `nvm`: installs via rustup with `-y --no-modify-path` so it doesn't self-append an activation line to a shell profile; `env.sh` is the single source of truth for activation, guarded on `~/.cargo/env` existing. `disable.sh --purge` runs `rustup self uninstall`. Verified the `env.sh` guard with a fake `~/.cargo/env`; did not run a real install (large download, deliberately out of scope for this verification pass).
    - [x] Lua language server was only in `mac/Brewfile` — added `lua-language-server` to `packages-arch.txt` (available directly via Arch's official repos) and to `install/ubuntu/Brewfile` (no reliable apt/snap package; verified working via Homebrew-on-Linux — `brew info lua-language-server` shows a bottled Linux build, and it installs/runs cleanly)
    - [x] `ripgrep` was missing from `packages-arch.txt` and `packages-ubuntu.txt` — added to both
    - [x] `fd` was missing from Arch/Ubuntu — added (`fd` on Arch, `fd-find` on Ubuntu, since Debian/Ubuntu ships the binary as `fdfind` due to a name conflict). `install/ubuntu/install_packages.sh` now symlinks `fdfind` → `~/.local/bin/fd` after install so subprocess-exec'd tools like Telescope find it (a shell alias alone wouldn't, since aliases aren't inherited by non-interactive child processes); `aliases.sh` carries the same alias as a defensive fallback only.
    - [x] No clipboard provider was installed on Arch or Ubuntu — added `wl-clipboard` to Arch (this repo's Arch setup is Wayland via Hyprland/Mango, see `hypr/`, `mango/`) and `xclip` to Ubuntu (safe default; works under X11 and XWayland)

    Coverage of [nvim's documented prerequisites](nvim/.config/nvim/README.md) per OS package list:

    | Prerequisite | Arch | Ubuntu | macOS |
    |---|---|---|---|
    | git, curl | ✓ | ✓ | ✓ (built-in) |
    | nerd font | ✓ | ✓ (via Brewfile) | ✓ |
    | clipboard provider | ✓ (`wl-clipboard`) | ✓ (`xclip`) | ✓ (`pbcopy` built-in) |
    | ripgrep | ✓ | ✓ | ✓ |
    | fd | ✓ | ✓ (`fd-find`, symlinked to `fd`) | ✓ |
    | python | ✓ (explicit) | ✓ (preinstalled by OS) | ✗ (relies on `uv` to fetch one) |
    | uv/pip | ✓ | ✓ | ✓ |
    | pylsp | n/a (per-venv, not centrally installable — see item 1 above) | n/a (same) | ✓ (`python-lsp-server`, but same per-venv caveat applies in practice) |
    | lua-language-server | ✓ | ✓ (via Homebrew-on-Linux) | ✓ |
    | C compiler (for `:TSUpdate`) | implicit via `base-devel` | ✓ explicit | ✓ via Xcode CLT |
    | Cargo/rust (blink.cmp build fallback) | ✓ (`install/optional/cargo`) | ✓ (same) | ✓ (same) |
2. Improve docs
    - [x] Specify which package manager installs what for each OS — added the "[Which package manager installs what](#which-package-manager-installs-what)" section above, including the cross-platform mechanism differences (e.g. neovim: `yay` on Arch, Homebrew-on-Linux on Ubuntu, `brew` on mac) plus a note on the nerd-font-family mismatch discovered while building the table
3. Fix script/package install inconsistencies
    - [x] Unify the default `DOTFILES_DIR` across scripts — done via `lib/common.sh`, sourced by every install/bootstrap script; resolves the repo root via `git rev-parse --show-toplevel` instead of guessing `$HOME/dotfiles` vs `$HOME/mydotfiles`
    - [x] Fix copy-pasted error message in `install/ubuntu/install_brewfile.sh` — resolved as a side effect of removing the manual confirm-prompt logic in favor of `lib/common.sh`
    - [x] Reconciled the two disconnected Homebrew-on-Ubuntu enable paths — `homebrew/enable.sh` now installs Homebrew itself (via `NONINTERACTIVE=1` + the official installer) instead of just erroring and telling the user to run the curl command manually first, matching `nvm/enable.sh`'s self-install pattern; `install/ubuntu/README.md` now points at `bash install/optional/homebrew/enable.sh` instead of a bare curl command
    - [x] `starship` was installed unconditionally but stayed inert until the now-removed `install/optional/starship/enable.sh` ran — fixed: activation moved into `env.sh` as a guarded `command -v starship` check (no-op if not installed), and the optional package was deleted since there's no longer anything to enable/disable
    - [x] `mise` had no shell activation anywhere — fixed: same pattern as `starship`, a guarded `eval "$(mise activate bash)"` added to `env.sh`
    - [x] `ollama` (mac Brewfile) installs the CLI only; documented the manual `brew services start ollama` step in `mac/README.md` rather than auto-starting a background service from every shell (deliberately not following the `starship`/`mise` pattern, since this is a long-running service, not a per-shell hook)
4. Fix `shell/` self-wiring bugs
    - [x] `load.sh`'s idempotency check now does an exact literal match (`grep -Fq`) against its own managed block instead of a regex that never matched the quoted line it writes — re-running `load.sh` no longer duplicates the block
    - [x] Fixed as a consequence of the above: `mac/init.sh`-symlinked `~/.bashrc` no longer gets duplicate appends through the repo's `mac/home/.bashrc`
    - [x] `load.sh`'s self-install now uses `# >>> shell-load (managed by dotfiles) >>>` markers, consistent with `install/optional/*`
    - [x] nvm was wired up twice independently (`env.sh` always, plus `install/optional/nvm/enable.sh`'s own profile block) — fixed: `env.sh` is now the single source of truth for activation, and `enable.sh` only installs nvm, running its curl installer with `PROFILE=/dev/null` so the upstream script doesn't also self-append an activation snippet to `.bashrc`/`.profile`. `disable.sh` now just offers `--purge` to remove `~/.nvm` (there's no profile block left to clean up). Verified end-to-end: no new lines added to any profile file, and `env.sh` activates `nvm` correctly in a fresh shell.
    - [x] `env.sh`'s Arch-AUR nvm path (`/usr/share/nvm/init-nvm.sh`) was dead code since `packages-arch.txt` never installs an `nvm` package — removed
    - [x] `aliases.sh` hardcoded `alias dots="cd ~/dotfiles/"` — fixed: `env.sh` now self-resolves `DOTFILES_DIR` (following its own stow symlink back to the real file, then `git rev-parse --show-toplevel`) and exports it for the shell session; `dots` now does `cd "${DOTFILES_DIR:-$HOME/dotfiles}"`. Verified through a real symlink chain mimicking `stow`.
5. `lib/common.sh` (added) — shared `DOTFILES_DIR` resolution plus `add_managed_block`/`remove_managed_block` helpers, now used by `mac/{init,setup,install_packages}.sh`, `install/ubuntu/{install_packages,install_brewfile}.sh`, and `install/optional/homebrew/{enable,disable}.sh`. `mac/init.sh`'s shebang also changed from `#!/bin/zsh` to bash, since `common.sh` relies on bash-only syntax (`${BASH_SOURCE[1]}`) that isn't safe to source under zsh.
    - [x] Evaluated, not pursued: shared `confirm()`/logging helpers for `common.sh`. `confirm()` is moot — every `read -p`/`read -rp` call site was already removed once `DOTFILES_DIR` became auto-detected, so there's nothing left to consolidate. Logging helpers (`info`/`warn`/`error`/`success`) would only fix cosmetic inconsistency (emoji vs. `[INFO]` tags vs. plain `echo` across ~10 scripts) with no behavior change and no downstream log-parsing to benefit from it — not worth the migration churn for this repo's size.
    - [x] Final repo-wide check caught a leftover instance of the exact problem item 3 fixed: the root README's own Usage steps, `install/optional/README.md`, and `mac/README.md` (two spots) still hardcoded `cd ~/mydotfiles` as a required step, contradicting the `DOTFILES_DIR` auto-detection built earlier. Fixed: early-bootstrap instructions (before any shell would have `env.sh` loaded) now say "cd into wherever you cloned this repo"; later/convenience instructions (after setup, when `env.sh` has already exported `DOTFILES_DIR`) now reference `"$DOTFILES_DIR"` directly.
