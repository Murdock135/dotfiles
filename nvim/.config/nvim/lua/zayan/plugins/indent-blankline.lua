return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = { "Function", "Label" }
      },
      indent = {
        highlight = { "IblIndent" }
      },
    },
}
