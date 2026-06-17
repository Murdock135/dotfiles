-- vim.lsp.enable('pylsp')
-- vim.lsp.enable('lua_ls')

-- 1. Globally enable your desired language servers
local servers = { "pylsp", "lua_ls" }
for _, server in ipairs(servers) do
  -- As documented under |vim.lsp.enable()|, this activates the config for current and future buffers
  vim.lsp.enable(server)
end

-- 2. Configure Global Native Diagnostics
-- As documented under |lsp-diagnostic|, use vim.diagnostic.config() to customize rendering
vim.diagnostic.config({
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
