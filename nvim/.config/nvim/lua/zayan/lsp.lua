-- vim.lsp.enable('pylsp')
-- vim.lsp.enable('lua_ls')

-- 1. Globally enable your desired language servers
local servers = { "lua_ls" }

-- basedpyright is a per-project uv dev-dependency (see lsp/basedpyright.lua), not a global
-- install, so fall back to pylsp when neither a local .venv nor a global install is found
local function has_basedpyright()
  local venv_langserver = vim.fn.getcwd() .. "/.venv/bin/basedpyright-langserver"
  return vim.uv.fs_stat(venv_langserver) ~= nil or vim.fn.executable("basedpyright-langserver") == 1
end

table.insert(servers, has_basedpyright() and "basedpyright" or "pylsp")

for _, server in ipairs(servers) do
  -- As documented under |vim.lsp.enable()|, this activates the config for current and future buffers
  vim.lsp.enable(server)
end

-- 2. Configure Global Native Diagnostics
-- As documented under |lsp-diagnostic|, use vim.diagnostic.config() to customize rendering
vim.diagnostic.config({
  virtual_line = true,
  virtual_text = true, -- Re-enabling (native default became false in v0.11+)
  underline = true,
  severity_sort = true,
  signs = {
    -- As documented in v0.10+, customize text symbols directly inside the config table
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  float = {
    border = "rounded",
    source = "always",
  },
})
