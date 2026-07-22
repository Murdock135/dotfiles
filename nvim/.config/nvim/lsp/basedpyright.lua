---@type vim.lsp.Config
return {
  -- basedpyright is a project dev-dependency installed via `uv add --dev basedpyright`,
  -- not a global install, so it lives at <root>/.venv/bin rather than on PATH.
  -- `config.root_dir` is already resolved by the time this runs (see vim/lsp/client.lua).
  cmd = function(dispatchers, config)
    local venv_langserver = config.root_dir and (config.root_dir .. "/.venv/bin/basedpyright-langserver")
    local bin = (venv_langserver and vim.uv.fs_stat(venv_langserver)) and venv_langserver or "basedpyright-langserver"
    return vim.lsp.rpc.start({ bin, "--stdio" }, dispatchers)
  end,

  filetypes = { "python" },

  root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },

  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        -- useLibraryCodeForTypes intentionally left unset: basedpyright defaults it to
        -- true, and setting it explicitly here would override per-project pyproject.toml config.
      },
    },
  },
}
