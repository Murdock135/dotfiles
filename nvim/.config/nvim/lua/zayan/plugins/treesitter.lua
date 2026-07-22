local parsers = {
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"bash",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = 'main',
	lazy = false,
	build = ":TSUpdate",
	config = function(_)
		-- Install parsers
		require("nvim-treesitter").install(parsers)

		-- Enable treesitter highlighting
		vim.api.nvim_create_autocmd('FileType', {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if lang and vim.treesitter.language.add(lang) then
					vim.treesitter.start(args.buf, lang)
				end
			end,
		})
	end,
}
