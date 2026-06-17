return {
  {
    "sainnhe/gruvbox-material",
    -- enabled = true,
    -- priority = 1000,
    config = function()
        vim.g.gruvbox_material_transparent_background = 1
        vim.g.gruvbox_material_foreground = "mix"
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_ui_contrast = "high"
        vim.g.gruvbox_material_float_style = "bright"
        vim.g.gruvbox_material_statusline_style = "material"
        vim.g.gruvbox_material_cursor = "auto"
        -- vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "diegoulloao/neofusion.nvim",
    opts = {
      transparent_mode = true,
    },
  },
  {
    "projekt0n/github-nvim-theme",
    name = 'github-theme',
    lazy = false,
    priority = 1000,
  },
  {
    "ShiraiEd/Wolf359_nvim_rust_theme",
    lazy = false,
    priority = 1000,
  },
}
