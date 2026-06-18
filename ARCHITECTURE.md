# Architecture of This Dotfiles Repository

## Abstract

This repository provisions a development environment — package installation,
configuration deployment, and shell activation — across three target platforms (Arch
Linux, Ubuntu, and macOS) from a single codebase. We describe the design invariants
that keep these three concerns independent as the system grows to accommodate
additional platforms and tools: location-independent path resolution, a single
activation authority per shell session, a binary classification of installable
packages, an idempotent primitive for editing shell configuration files, and a
uniform idempotence requirement applied throughout. Each section below presents one
mechanism, its motivation, and the failure mode it was introduced to prevent.

## 1. Introduction

A dotfiles repository that targets a single machine can afford to hardcode paths,
assume a particular shell session is the only one that will ever run its scripts, and
treat "install X" as a one-time, idempotence-agnostic action. None of those
assumptions hold once the same repository must also bootstrap a fresh Arch install,
an Ubuntu WSL instance, and a macOS laptop, possibly re-run after the fact, possibly
on a machine missing half the tools the scripts check for. This document describes
the mechanisms this repository uses to make that tractable.

```
Figure 1: end-to-end flow from clone to interactive shell.

  clone repo (any directory name -- nothing hardcodes it, see Section 2)
        |
        v
  install packages      OS package list / Brewfile for anything a package
        |                manager handles well; install/optional/<tool> for
        |                anything that needs its own installer instead
        v
  stow configs           symlink each top-level dir (shell/, nvim/, git/, ...)
        |                into $HOME
        v
  open a shell           ~/.bashrc -> load.sh -> env.sh activates whatever
                          got installed above (guarded, so machine-to-machine
                          differences in what's installed are never a problem)
```

The remainder of this document is organized as follows. Section 2 describes how
scripts locate the repository root without depending on its clone path or directory
name. Section 3 presents the activation model implemented by `env.sh`, the single
authority for what runs in an interactive shell. Section 4 gives the decision
procedure for classifying a new tool as a core package or an optional, self-installed
one. Section 5 introduces the managed-block primitive used whenever a script must
edit a shell configuration file in place. Section 6 covers configuration deployment
via GNU Stow. Section 7 describes precondition-checked bootstrap sequencing on macOS.
Section 8 states the idempotence invariant that Sections 2 through 7 each satisfy.
Section 9 concludes.

## 2. Repo-Root Resolution

No script hardcodes or guesses its own location on disk. Instead, `lib/common.sh`
resolves the environment variable `DOTFILES_DIR` at the moment it is sourced, by
querying `git` for the working tree root relative to the *caller's* location:

```
Figure 2: DOTFILES_DIR resolution.

  script (e.g. mac/setup.sh)
        |
        | source "$(dirname "$0")/../lib/common.sh"
        v
  lib/common.sh
        |
        | if caller path is a symlink (stowed), follow it back to the
        | real file first -- readlink -f isn't portable to BSD/macOS,
        | so this is a plain manual loop
        v
  git -C <real caller dir> rev-parse --show-toplevel
        |
        v
  DOTFILES_DIR exported -> every later path is "$DOTFILES_DIR/..."
```

This eliminates an entire class of bugs that otherwise recur whenever a script needs
to reference another file in the repository: defaulting to a literal path such as
`$HOME/dotfiles` or `$HOME/mydotfiles` breaks the moment a user clones the repository
under a different name. Scripts invoked through a Stow-created symlink (for example
`shell/.config/shell/env.sh`) cannot rely on `$0` or `BASH_SOURCE` pointing at the
real file, so the symlink is resolved manually before the `git` query is issued.
New scripts should source `lib/common.sh` rather than reimplement this resolution.

## 3. The Activation Model

`env.sh` is the sole authority for what gets activated in an interactive shell. On
every shell startup it evaluates, in sequence, a guard for each optionally-installed
tool, and activates that tool only if the guard succeeds:

```
Figure 3: activation fan-out in env.sh.

  new shell opens
        |
        v
  ~/.bashrc --sources--> ~/.config/shell/load.sh --sources--> env.sh
                                                                  |
                  +---------------------+---------------------+-+-------------------+
                  v                     v                     v                     v
           command -v nvm?      command -v starship?   command -v mise?     [ -f ~/.cargo/env ]?
            yes |  no             yes |  no              yes |  no            yes |  no
                v   `--skip          v   `--skip             v   `--skip          v   `--skip
            activate nvm        activate starship      activate mise        activate cargo
```

The motivation for centralizing activation in one file, rather than letting each
tool's own installer wire itself into a shell profile, is that most upstream
installers (nvm's, rustup's) attempt exactly that by default. If both the upstream
snippet and `env.sh`'s guard executed, the tool would be initialized twice per shell.
Consequently, every installer invoked from `install/optional/*/enable.sh` is passed
an explicit flag suppressing its self-wiring behavior (`PROFILE=/dev/null` for nvm,
`--no-modify-path` for rustup), and `env.sh` is left as the only site at which
activation occurs.

This yields a design rule for any new tool under consideration: if it must run on
every shell startup, it receives a guarded block in `env.sh`; if it is instead a
long-running service, it is documented as a manual start step (see `ollama` in
`mac/README.md`) rather than invoked from a shell hook.

## 4. Package Classification: Core vs. Optional

Every tool this repository installs falls into exactly one of two classes, decided
by a single question:

```
Figure 4: classification procedure for a new tool.

  New tool to add
        |
        v
  Does apt/pacman/brew package it adequately? ----------------------- yes --> add to that
        |                                                                     OS's package
        no                                                                    list (core).
        |                                                                     Needs activation?
        v                                                                     -> guarded block
  Tool's own docs say "use our installer,                                       in env.sh.
  not your distro's package manager"
  (nvm, cargo/rustup, Homebrew-on-Linux)
        |
        v
  install/optional/<tool>/enable.sh + disable.sh
    enable.sh:  install if missing, suppress the installer's own
                profile-wiring, let env.sh own activation
    disable.sh: least-destructive by default; --unstow / --purge
                are explicit opt-ins for anything that removes data
```

**Core packages** are declared in the OS-specific package list
(`install/arch/packages-arch.txt`, `install/ubuntu/packages-ubuntu.txt`,
`mac/Brewfile`, `install/ubuntu/Brewfile`) and carry no enable/disable lifecycle: a
core package is simply present or absent. **Optional packages** are those whose
upstream maintainers explicitly recommend against distribution-managed installation,
or which bootstrap a package manager itself (Homebrew on Linux); these are granted a
directory under `install/optional/` with an `enable.sh`/`disable.sh` pair following
the convention established in Section 3.

## 5. Managed Blocks: Idempotent Profile Edits

Any script that must insert or remove a snippet within an existing file such as
`~/.bashrc` does so through `lib/common.sh`'s `add_managed_block` and
`remove_managed_block` functions, rather than through an ad hoc combination of
`grep`, `awk`, and `mktemp`:

```
Figure 5: idempotent block replacement.

  add_managed_block(file, tag, content)

  1st run on ~/.bashrc:                2nd run, same tag (idempotent):
  ------------------------------       ------------------------------
  ...existing lines...                 ...existing lines...
  # >>> tag (managed by dotfiles) >>>   # >>> tag (managed by dotfiles) >>>
  content                              NEW content   <- replaced, not duplicated
  # <<< tag (managed by dotfiles) <<<  # <<< tag (managed by dotfiles) <<<
```

This primitive exists because an earlier, hand-rolled instance of the same pattern,
in `load.sh`, contained a regular expression that failed to match the very line it
had previously written, causing duplicate insertions on every subsequent invocation.
The shared helper is the single point of correctness for this operation; it should
not be reimplemented.

## 6. Configuration Deployment via GNU Stow

Each top-level directory in this repository (`shell/`, `nvim/`, `git/`, `hypr/`, and
so on) constitutes a GNU Stow package whose internal structure mirrors its intended
location beneath `$HOME`:

```
Figure 6: Stow's symlinking convention.

  repo/shell/.config/shell/env.sh  --stow-->  ~/.config/shell/env.sh (symlink)
```

Optional packages that ship an actual configuration directory additionally support
`disable.sh --unstow`, which invokes `stow -D` to remove the corresponding symlinks.

## 7. Bootstrap Sequencing on macOS

macOS provisioning is decomposed into four scripts with a strict ordering
dependency, since each script's preconditions are established by the one before it:

```
Figure 7: macOS bootstrap sequence.

  mac/init.sh --> mac/brew.sh --> mac/install_packages.sh --> mac/setup.sh
  (Xcode CLT,      (installs        (Brewfile packages)        (stow all
   bash login        Homebrew)                                  configs)
   shell, symlink
   .bashrc)
```

Each script checks that its precondition holds and, if not, terminates with an error
naming the specific prior script to run (for example, `"Run ./mac/init.sh first."`)
rather than failing without explanation. Any future multi-step bootstrap sequence
should follow the same convention: fail early, fail loudly, and name the remedy.

## 8. Idempotence as a Design Invariant

A single invariant is satisfied by every mechanism in Sections 2 through 7: a script
must behave identically whether it is being executed for the first time, the tenth
time, or on a machine that lacks the tool it is testing for.

- Activation guards (Section 3) test `command -v <tool>` or file existence before
  invoking `eval`/`source`.
- Installers (Section 4) test whether their target is already installed before
  attempting installation.
- Managed-block edits (Section 5) replace prior content rather than appending to it.

Any new script introduced into this repository should be written under the same
assumption: that it will be invoked more than once, and that it may be invoked on a
machine where its subject is absent.

## 9. Conclusion

The mechanisms above were each introduced in response to a concrete failure
encountered while extending this repository to a third platform: ambiguous repo
location, duplicate tool activation, inconsistent installer conventions, a buggy
idempotency check, and unordered bootstrap failures. None of them is specific to any
one platform; together they are what allow the same repository to remain coherent as
Arch, Ubuntu, and macOS support are developed and maintained side by side. See
[README.md](README.md) for operational usage and [AGENTS.md](AGENTS.md) for
AI-agent-specific conventions.

## Appendix A: How to Add a New Package or App

First decide which path applies, using the procedure in Section 4: does
`apt`/`pacman`/`brew` package this tool adequately? If you're not sure, check whether
the tool's own install docs say "don't install via your distro's package manager."

### Path 1: Core package (a package manager handles it)

1. Figure out the package name on each OS you care about — it's often not identical:

   ```
   # the same tool, three different package names
   Arch  (packages-arch.txt):     uv
   Ubuntu (packages-ubuntu.txt):  astral-uv
   macOS  (mac/Brewfile):         brew "uv"
   ```

   Check each package manager's own search/index (`yay -Ss <name>`,
   `apt-cache search <name>`, `brew search <name>`) before assuming the name matches.

2. Add the package name to the relevant file(s):

   ```diff
   # install/arch/packages-arch.txt
    eza
   +ripgrep
    starship
   ```

   ```diff
   # install/ubuntu/packages-ubuntu.txt  (only if it has a reliable apt/snap package)
    eza
   +ripgrep
    starship
   ```

   ```diff
   # install/ubuntu/Brewfile  (use this instead, if apt/snap doesn't package it well)
    brew "neovim"
   +brew "lua-language-server"
   ```

   ```diff
   # mac/Brewfile
    brew "starship"
   +brew "ripgrep"
   ...
   +cask "rectangle"        # use cask instead of brew for GUI apps
   ```

3. If the tool needs to run on every shell startup (a prompt, a version manager,
   etc.), add a guarded block to `shell/.config/shell/env.sh` following the existing
   pattern — this is the actual `mise` block already in the file:

   ```sh
   # mise (dev tool version manager, mac Brewfile only today). Same pattern as
   # starship above: guarded activation here instead of a separate enable script.
   if command -v mise >/dev/null 2>&1; then
     eval "$(mise activate bash)"
   fi
   ```

   If it's a long-running service instead (like `ollama`), don't add it to `env.sh`
   — document a manual start command in the relevant platform README instead:

   ```md
   # Post-install: starting the Ollama service
   `ollama` ... is a background service and deliberately isn't auto-started on
   every shell. Start it manually:

   \`\`\`
   brew services start ollama
   \`\`\`
   ```

4. If a distro installs the binary under a different name than upstream (the way
   Ubuntu's `fd-find` package installs a binary called `fdfind`), add a symlink step
   to that OS's `install_packages.sh` after the install loop — this is the actual
   code handling `fd`/`fdfind` in `install/ubuntu/install_packages.sh`:

   ```sh
   if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
       echo "Symlinking fdfind -> fd in ~/.local/bin"
       mkdir -p "$HOME/.local/bin"
       ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
   fi
   ```

   and the matching fallback alias in `shell/.config/shell/aliases.sh` (covers
   interactive use only — the symlink above is what fixes subprocess/non-interactive
   use, e.g. Neovim's Telescope calling `fd` directly):

   ```sh
   if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
     alias fd='fdfind'
   fi
   ```

5. Update the master table in `README.md`'s "Which package manager installs what"
   section with the new row:

   ```diff
    | ripgrep | yay | apt | homebrew |
   +| fd | yay | apt (`fd-find`) | homebrew |
   ```

6. Verify:

   ```sh
   ./install/arch/install_packages.sh   # substitute install/ubuntu/install_packages.sh, or `brew bundle` on mac
   command -v <tool>                    # should now resolve

   # Note: command -v only checks that the binary is on PATH. The package
   # manager already put it there, so the line above passes whether or not
   # env.sh's guard ran at all. To actually test the guard, check that env.sh
   # sources without error instead:
   bash -c 'source shell/.config/shell/env.sh && echo "env.sh sourced OK"'
   ```

### Path 2: Optional, self-installed tool (has its own installer script)

1. Create a new directory: `install/optional/<tool>/`.

2. Write `enable.sh`. This is the actual `install/optional/cargo/enable.sh`, usable
   as a template — note the early exit, the official installer invoked
   non-interactively, and the flag suppressing its own profile-wiring:

   ```sh
   #!/usr/bin/env bash
   set -euo pipefail

   if command -v cargo >/dev/null 2>&1; then
     echo "cargo is already installed and available on PATH. Exiting."
     exit 0
   fi

   CARGO_ENV="${HOME}/.cargo/env"
   if [ -f "$CARGO_ENV" ]; then
     echo "cargo already installed (found ${CARGO_ENV}). Skipping install."
   else
     echo "Installing Rust (cargo) via rustup..."
     # -y: non-interactive. --no-modify-path: don't let rustup also append its
     # own activation line to a shell profile -- env.sh is this repo's single
     # source of truth for activation.
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
   fi

   echo "cargo installed. It will be activated automatically by shell/.config/shell/env.sh."
   ```

   (Check the installer's own `--help`/docs for the equivalent flag — nvm's is
   `PROFILE=/dev/null`, rustup's is `--no-modify-path`; not every installer calls it
   the same thing.)

3. Write `disable.sh`. This is the actual `install/optional/cargo/disable.sh` —
   default is a no-op explanation, `--purge` does the real removal, preferring the
   tool's own uninstaller over a raw `rm -rf`:

   ```sh
   #!/usr/bin/env bash
   set -euo pipefail

   PURGE=false
   case "${1:-}" in
     --purge) PURGE=true ;;
     "") ;;
     *) echo "Usage: disable.sh [--purge]" >&2; exit 2 ;;
   esac

   if $PURGE; then
     if command -v rustup >/dev/null 2>&1; then
       echo "Uninstalling Rust toolchain via rustup..."
       rustup self uninstall -y
     else
       echo "rustup not found; nothing to purge."
     fi
   else
     echo "cargo has no shell-profile block to remove -- activation in env.sh is already a no-op once ~/.cargo/env is gone."
     echo "Run 'disable.sh --purge' to uninstall the Rust toolchain via rustup."
   fi
   ```

4. Add a guarded activation block to `shell/.config/shell/env.sh` — same pattern as
   Path 1 step 3, but guarding on the marker file the installer leaves behind rather
   than `command -v`, since the tool isn't on `PATH` until that file is sourced:

   ```sh
   # Cargo/Rust (optional, see install/optional/cargo/enable.sh, which installs
   # via rustup with --no-modify-path so it doesn't also self-append an
   # activation line to a shell profile). Single source of truth for activation,
   # guarded so it's a no-op if not installed.
   if [ -f "$HOME/.cargo/env" ]; then
     . "$HOME/.cargo/env"
   fi
   ```

5. Update `README.md`: add a bullet under "Self-installed tools":

   ```diff
    - **nvm** — `install/optional/nvm/enable.sh` runs nvm's official curl installer. Activated via `env.sh`, guarded on `~/.nvm/nvm.sh` existing.
   +- **<tool>** — `install/optional/<tool>/enable.sh` runs <tool>'s official installer. Activated via `env.sh`, guarded on `<marker file>` existing.
   ```

6. Verify:

   ```sh
   bash install/optional/<tool>/enable.sh
   grep -n "<tool>" ~/.bashrc ~/.bash_profile ~/.profile   # should show NOTHING new --
                                                             # the installer must not have self-wired
   bash -c 'source shell/.config/shell/env.sh; command -v <tool>'   # should now resolve
   bash install/optional/<tool>/disable.sh --purge          # should actually remove it
   ```
