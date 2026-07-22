This neovim config is a minimal configuration that only uses ONE 'manager' or 'orchestrator' plugin- lazy vim, to install plugins easily.

# Prerequisites

To make this work fully and out of the box, you need -

1. git
2. curl
3. tar
4. tree-sitter-cli
5. A clipboard provider (e.g., xclip, xsel)
6. A nerd font (e.g., FiraCode Nerd Font)
7. ripgrep
8. fd
9. Python
10. A package manager for python Pypi packages (e.g., pip, uv (recommended))
11. Python language servers (install into your project's virtual environment): 
    - pyright
    - pylsp 
12. The Lua language server

# Set up

Using your preferred method, copy this directory and subdirectories to your `~/.config/nvim` directory. 

> [!TIP]
> I recommend using GNU stow to symbolically link this configuration to your `~/.config/nvim` directory. 
> To do this
> 1. Install GNU stow if you don't have it already.
> 2. Navigate to the directory containing this configuration.
> 3. Run `stow nvim` to create symbolic links in your `~/.config/nvim` directory.

And you're set!

# Features

1. Uses Lazy.nvim as the plugin manager
2. File explorer pane with file icons (requires a nerd font)
3. LSP support for Python and Lua with the following capabilities:
  - Autocompletion
  - Diagnostics (Formatting errors are suppressed)
  - Formatting
  - Code actions
  - Hover documentation
4. 'Find' features:
  - Find files
  - Find text within files
  - Find buffers
  - Find help tags
5. Automatic bracket completion
6. Git signs (shows changes in the gutter)
7. Indentation guides
8. Whichkey (displays available keybindings)

# Notes

- Loading order:
  1. Plugin manager (Lazy.nvim) is loaded first.
  2. Keymaps
  3. Options
  4. LSP
  5. Colorscheme