return {
  "forest-nvim/sequoia.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme sequoia") -- or 'sequoia-night' / 'sequoia-rise'
  end
}

-- return {
--   {
--     "ntk148v/habamax.nvim",
--     dependencies = { "rktjmp/lush.nvim" },
--     config = function()
--       vim.cmd("colorscheme habamax")
--       vim.o.background = "dark" -- Or "light" if you prefer
--     end,
--   }
-- }
-- return {
--  { "ficcdaf/ashen.nvim" },
--   {
--     "LazyVim/LazyVim",
--    opts = {
--      colorscheme = "ashen",
--    },
--  }
-- }
