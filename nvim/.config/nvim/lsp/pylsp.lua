---@type vim.lsp.Config
return {
  -- As defined in |vim.lsp.Config|, 'cmd' points to the server executable
  cmd = { "pylsp" },
  
  -- 'filetypes' defines which buffers automatically attach to this server
  filetypes = { "python" },
  
  -- 'root_markers' sets the workspace root to the first directory containing these files
  root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
  
  -- 'settings' passes a table directly to the language server to adjust its internal behavior
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { maxLineLength = 88 }, -- Custom linting rules
      },
    },
  },
}
