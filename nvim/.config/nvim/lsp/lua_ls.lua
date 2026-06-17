return {
	cmd = {
		"lua-language-server",
	},
	filetypes = {
		"lua",
	},
	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
	},

  -- Server-specific configurations parsed by lua_ls
  settings = {
    Lua = {
      diagnostics = {
        -- Explicitly inform the linter that 'vim' is an authorized global variable
        globals = { "vim" },
      },
      workspace = {
        -- Pull in Neovim's internal runtime paths to enable API autocompletion
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
